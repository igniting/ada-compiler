/**************Parser for ADA*************/
%{
# include <stdio.h>
# include <stdlib.h>
# include <string.h>
%}

%token        IDENTIFIER
%token        NUMBER
%token        CHARACTER
%token        STRING
%token        TICK
%token        ARROW
%token        DDOT
%token        EXPONENTIATE
%token        ASSIGNMENT
%token        INEQUALITY
%token        GE
%token        LE
%token        LLB
%token        RLB
%token        BOX
%token        ABORT
%token        ABS
%token        ABSTRACT
%token        ACCEPT
%token        ACCESS
%token        ALIASED
%token        ALL
%token        AND
%token        ARRAY
%token        AT
%token        BegiN
%token        BODY
%token        CASE
%token        CONSTANT
%token        DECLARE
%token        DELAY
%token        DELTA
%token        DIGITS
%token        DO
%token        ELSE
%token        ELSIF
%token        END
%token        ENTRY
%token        EXCEPTION
%token        EXIT
%token        FOR
%token        FUNCTION
%token        GENERIC
%token        GOTO
%token        IF
%token        IN
%token        INTERFACE
%token        IS
%token        LIMITED
%token        LOOP
%token        MOD
%token        NEW
%token        NOT
%token        NuLL
%token        OF
%token        OR
%token        OTHERS
%token        OUT
%token        OVERRIDING
%token        PACKAGE
%token        PRAGMA
%token        PRIVATE
%token        PROCEDURE
%token        PROTECTED
%token        RAISE
%token        RANGE
%token        RECORD
%token        REM
%token        RENAMES
%token        REQUEUE
%token        RETURN
%token        REVERSE
%token        SELECT
%token        SEPARATE
%token        SUBTYPE
%token        SYNCHRONIZED
%token        TAGGED
%token        TASK
%token        TERMINATE
%token        THEN
%token        TYPE
%token        UNTIL
%token        USE
%token        WHEN
%token        WHILE
%token        WITH
%token        XOR

%start        statement_s

%{
#include <stdio.h>
#define YYSTYPE char*
%}

%%
pragma              :   PRAGMA IDENTIFIER ';'
                    |   PRAGMA simple_name '(' pragma_arg_s ')' ';'
                    ;
pragma_arg_s        :   pragma_arg
	                |   pragma_arg_s ',' pragma_arg
	                ;
pragma_right        :   expression
                    |   name
                    ;
pragma_arg          :   pragma_right
	                |   simple_name ARROW pragma_right
	                ;
pragma_s            :   /* Empty */
	                |   pragma_s pragma
	                ;
	                
decl                :   type_decl
                    |   subtype_decl
                    |   object_decl
                    |   number_decl
                    |   subprog_decl
                    |   pkg_decl
                    |   task_decl
                    |   prot_decl
                    |   rename_decl
                    |   exception_decl
                    |   generic_decl
                    |   body_stub
                    ;

def_identifier      :   IDENTIFIER
                    ;
                                                       
type_decl           :   TYPE def_identifier disc_part_opt IS type_def ';'
                    ;
                    
disc_part_opt       :   /* Empty */
                    |   disc_part
                    |   '(' BOX ')'
                    ;
                    
type_def            :   enum_type
                    |   integer_type
                    |   real_type
                    |   array_type
                    |   record_type
                    |   access_type
                    |   derived_type
                    |   private_type
                    ;
                    
subtype_decl        :   SUBTYPE def_identifier IS subtype_ind ';'
                    ;
                    
subtype_ind         :   name constraint
                    |   name
                    ;
                    
constraint          :   range_constraint
                    |   digits_constraint
                    ;
                    
range_constraint    :   RANGE range
                    ;
                    
range_spec          :   range_constraint
                    ;

range               :   simple_expression DDOT simple_expression
                    |   name TICK range
                    |   name TICK range '(' expression ')'
                    ;
                    
digits_constraint   :   DIGITS expression range_spec_opt
                    ;
                    
range_spec_opt      :   /* Empty */
                    |   range_spec
                    ;
                    
object_decl         :   def_id_list ':' object_spec_opt object_subtype init_opt ';'
                    ;
                    
def_id_list         :   def_identifier
                    |   def_id_list ',' def_identifier
                    ;
                    
object_spec_opt     :   /* Empty */
                    |   ALIASED
                    |   CONSTANT
                    |   ALIASED CONSTANT
                    ;
                    
object_subtype      :   subtype_ind
                    |   array_type
                    ;

init_opt            :   ASSIGNMENT expression
                    ;
                    
number_decl         :   def_id_list ':' CONSTANT ASSIGNMENT expression
                    ;
                    
derived_type        :   derived_specs_opt NEW subtype_ind
                    |   derived_specs_opt NEW subtype_ind WITH PRIVATE
                    |   derived_specs_opt NEW subtype_ind WITH record_def
                    ;
                    
derived_specs_opt   :   /* Empty */
                    |   ABSTRACT
                    |   LIMITED
                    |   ABSTRACT LIMITED
                    ;
                    
enum_type           :   '(' enum_lit_s ')'
                    ;
                    
enum_lit_s          :   enum_lit
                    |   enum_lit_s ',' enum_lit
                    ;
                    
enum_lit            :   def_identifier
                    |   def_char
                    ;
                    
def_char            :   CHARACTER
                    ;
                    
integer_type        :   range_spec
                    |   MOD expression
                    ;
                    
real_type           :   float_type
                    |   fixed_type
                    ;
                    
float_type          :   DIGITS expression range_spec_opt
                    ;
                    
fixed_type          :   DELTA expression range_spec
                    |   DELTA expression DIGITS expression range_spec_opt
                    ;
                    
array_type          :   unconstr_array_type
                    |   constr_array_type
                    ;
                    
unconstr_array_type :   ARRAY '(' index_subtype_s ')' OF component_def
                    ;
                    
index_subtype_s     :   index_subtype
                    |   index_subtype_s ',' index_subtype
                    ;
                    
index_subtype       :   name RANGE BOX
                    ;
                    
constr_array_type   :   ARRAY iter_index_constraint OF component_def
                    ;
                    
component_def       :   aliased_opt subtype_ind
                    ;
                    
aliased_opt         :   /* Empty */
                    |   ALIASED
                    ;
component_subtype_def:  aliased_opt subtype_ind
	                ;
                    
iter_index_constraint: '(' iter_discrete_range_s ')'
                    ;
                    
iter_discrete_range_s:  discrete_range
                    |   iter_discrete_range_s ',' discrete_range
                    ;
                    
discrete_range      :   name range_spec_opt
                    |   range
                    ;
                    
record_type         :   tagged_opt limited_opt record_def
                    ;
                    
record_def          :   RECORD component_list END RECORD
                    |   NuLL RECORD
                    ;
                    
tagged_opt          :   /* Empty */
                    |   ABSTRACT TAGGED
                    |   TAGGED
                    ;
                    
limited_opt         :   /* Empty */
                    |   LIMITED
                    ;
                    
component_list      :   component_decl_s variant_part_opt
                    |   variant_part pragma_s
                    |   NuLL ';' pragma_s
                    ;
                    
component_decl_s    :   component_decl
                    |   component_decl_s pragma_s component_decl
                    ;
                    
variant_part_opt    :   pragma_s
	                |   pragma_s variant_part pragma_s
	                ;

component_decl      :   def_id_list ':' component_subtype_def init_opt ';'
	                ;

disc_part        : '(' discrim_spec_s ')'
	                ;

discrim_spec_s      :   discrim_spec
	                |   discrim_spec_s ';' discrim_spec
	                ;

discrim_spec        :   def_id_list ':' access_opt mark init_opt
	                |   error
	                ;

access_opt          :   /* Empty */
	                |   ACCESS
	                ;

variant_part        :   CASE simple_name IS pragma_s variant_s END CASE ';'
	                ;

variant_s           :   variant
	                |   variant_s variant
	                ;

variant             :   WHEN choice_s RLB pragma_s component_list
	                ;

choice_s            :   choice
	                |   choice_s '|' choice
	                ;

choice              :   expression
	                |   discrete_with_range
	                |   OTHERS
	                ;

discrete_with_range :   name range_constraint
	                |   range
                    ;

access_type         :   ACCESS subtype_ind
	                |   ACCESS CONSTANT subtype_ind
	                |   ACCESS ALL subtype_ind
	                |   ACCESS prot_opt PROCEDURE formal_part_opt
	                |   ACCESS prot_opt FUNCTION formal_part_opt RETURN mark
	                ;

prot_opt            :   /* Empty */
	                |   PROTECTED
	                ;

decl_part           :   /* Empty */
	                |   decl_item_or_body_s1
	                ;

decl_item_s         :   /* Empty */
	                |   decl_item_s1
	                ;

decl_item_s1        :   decl_item
	                |   decl_item_s1 decl_item
	                ;

decl_item           :   decl
	                |   use_clause
	                |   rep_spec
	                |   pragma
	                ;

decl_item_or_body_s1:   decl_item_or_body
	                |   decl_item_or_body_s1 decl_item_or_body
	                ;

decl_item_or_body   :   body
	                |   decl_item
	                ;

body                :   subprog_body
	                |   pkg_body
	                |   task_body
	                |   prot_body
	                ;
	                
name                :   simple_name
	                |   indexed_comp
	                |   selected_comp
	                |   attribute
	                |   operator_symbol
	                ;

mark                :   simple_name
	                |   mark TICK attribute_id
	                |   mark '.' simple_name
	                ;

simple_name         :   IDENTIFIER
	                ;

compound_name       :   simple_name
	                |   compound_name '.' simple_name
	                ;

c_name_list         :   compound_name
	                |   c_name_list ',' compound_name
	                ;

used_char           :   CHARACTER
	                ;

operator_symbol     :   STRING
	                ;

indexed_comp        :   name '(' value_s ')'
	                ;

value_s             :   value
	                |   value_s ',' value
	                ;

value               :   expression
	                |   comp_assoc
	                |   discrete_with_range
	                ;

selected_comp       :   name '.' simple_name
	                |   name '.' used_char
	                |   name '.' operator_symbol
	                |   name '.' ALL
	                ;

attribute           :   name TICK attribute_id
	                ;

attribute_id        :   IDENTIFIER
	                |   DIGITS
	                |   DELTA
	                |   ACCESS
	                ;

literal             :   NUMBER
	                |   used_char
	                |   NuLL
	                ;

aggregate           :   '(' comp_assoc ')'
	                |   '(' value_s_2 ')'
	                |   '(' expression WITH value_s ')'
                    |   '(' expression WITH NuLL RECORD ')'
                    |   '(' NuLL RECORD ')'
	                ;

value_s_2           :   value ',' value
	                |   value_s_2 ',' value
	                ;

comp_assoc          :   choice_s ARROW expression
	                ;
                            
expression          :   relation
                    |   expression logical_op relation
                    |   expression short_circuit_op relation
                    ;
choice_expression   :   choice_relation
                    |   choice_expression logical_op choice_relation
                    |   choice_expression short_circuit_op choice_relation
                    ;
rel_op              :   '='
                    |   INEQUALITY
                    |   '<'
                    |   LE
                    |   '>'
                    |   GE
                    ;
choice_relation     :   simple_expression
                    |   simple_expression rel_op simple_expression
                    ;
relation            :   simple_expression
                    |   simple_expression rel_op simple_expression
                    |   simple_expression membership mem_choice_list
                    ;
membership          :   IN
                    |   NOT IN
                    ;
mem_choice_list     :   mem_choice
                    |   mem_choice mem_choice_list
                    ;
mem_choice          :   choice_expression
                    |   range
                    ;
simple_expression   :   term
                    |   unary term
                    |   simple_expression binary_add term 
                    ;
unary               :   '+'
                    |   '-'
                    ;
binary_add          :   '+'
                    |   '-'
                    |   '&'
                    ;
term                :   factor
                    |   term mul_op factor
                    ;
                    ;
mul_op              :   '*'
                    |   '/'
                    |   MOD
                    |   REM
                    ;
factor              :   primary
                    |   primary EXPONENTIATE primary
                    |   ABS primary
                    |   NOT primary
                    ;

primary             :   literal
	                |   name
	                |   allocator
	                |   qualified
	                |   parenthesized_primary
	                ;

parenthesized_primary:  aggregate
	                |   '(' expression ')'
	                ;

qualified           :   name TICK parenthesized_primary
	                ;

allocator           :   NEW name
	                |   NEW qualified
	                ;
	                
logical_op          :   AND
                    |   OR
                    |   XOR
                    ;
                    
short_circuit_op    :   AND THEN
                    |   OR ELSE
                    ;
                    
statement_s         :   statement
                    |   statement_s statement
                    ;
                    
statement           :   unlabeled
                    |   label statement
                    ;
                    
unlabeled           :   simple_statement
                    |   compound_statement
                    ;
                    
simple_statement    :   null_statement
                    |   assign_statement
                    |   exit_statement
                    |   goto_statement
                    |   procedure_call_statement
                    |   requeue_statement
                    |   delay_statement
                    |   abort_statement
                    |   raise_statement
                    |   code_statement
                    |   error ';'
                            {
                                printf("Syntax error in line %d.\n",@1.first_line);
                            }
                    ;
                    
compound_statement  :   if_statement
                    |   case_statement
                    |   loop_statement
                    |   block_statement
                    |   accept_statement
                    |   select_statement
                    ;
                    
null_statement      :   NuLL ';'
                    ;
                    
label               :   LLB IDENTIFIER RLB
                    ;
                    
assign_statement    :   name ASSIGNMENT expression ';'
                    ;
                    
if_statement        :   IF cond_clause_s else_opt END IF ';'
                    ;
                    
cond_clause_s       :   cond_clause
                    |   ELSIF cond_clause_s
                    ;
                    
cond_clause         :   condition THEN statement_s
                    ;
                    
condition           :   expression
                    ;
                    
else_opt            :   /* Empty */
                    |   ELSE statement_s
                    ;
                    
case_statement      :   CASE expression IS pragma_s case_statement_alt_s END CASE ';'
                    ;
                    
case_statement_alt_s:   case_statement_alt
                    |   case_statement_alt_s case_statement_alt
                    ;
                    
case_statement_alt  :   WHEN choice_s ARROW statement_s
                    ;
                    
loop_statement      :   label_opt iteration_scheme_opt LOOP statement_s END LOOP id_opt ';'
                    ;
                    
label_opt           :   /* Empty */
                    |   IDENTIFIER ':'
                    ;
                    
id_opt              :   /* Empty */
                    |   IDENTIFIER
                    ;
                    
iteration_scheme_opt:   /* Empty */
                    |   iteration_scheme
                    ;
                    
iteration_scheme    :   WHILE condition
                    |   iter_part reverse_opt discrete_range
                    ;
iter_part           :   FOR IDENTIFIER IN
                    ;
                    
reverse_opt         :   /* Empty */
                    |   REVERSE
                    ;
                    
block_statement     :   label_opt decl_opt BegiN statement_s END id_opt ';'
                    ;
                    
decl_opt            :   /* Empty */
                    |   DECLARE decl_part
                    ;
                    
block_body          :   BegiN handled_stmt_s
	                ;
	                
handled_stmt_s      :   statement_s except_handler_part_opt 
	                ;
	                 
except_handler_part_opt:/*Empty*/
	                |   except_handler_part
	                ;
	                
exit_statement      :   EXIT name_opt when_opt ';'
                    ;
                    
name_opt            :   /* Empty */
                    |   name
                    ;
                    
when_opt            :   /* Empty */
                    |   WHEN condition
                    ;
                    
goto_statement      :   GOTO name ';'
                    ;
                    
subprog_decl        :   subprog_spec ';'
	                |   generic_subp_inst ';'
	                |   subprog_spec_is_push ABSTRACT ';'
	                ;

subprog_spec        :   PROCEDURE compound_name formal_part_opt
	                |   FUNCTION designator formal_part_opt RETURN name
	                |   FUNCTION designator
	                ;

designator          :   compound_name
	                |   STRING
	                ;

formal_part_opt     :   /* Empty */
	                |   formal_part
	                ;

formal_part         :   '(' param_s ')'
	                ;

param_s             :   param
	                |   param_s ';' param
	                ;

param               :   def_id_list ':' mode mark init_opt
	                ;

mode                :   /* Empty */
	                |   IN
	                |   OUT
	                |   IN OUT
	                |   ACCESS
	                ;

subprog_spec_is_push:   subprog_spec IS
	                ;

subprog_body        :   subprog_spec_is_push decl_part block_body END id_opt ';'
	                ;

procedure_call_statement:   name ';'
	                ;

pkg_decl            :   pkg_spec ';'
	                |   generic_pkg_inst ';'
	                ;

pkg_spec            :   PACKAGE compound_name IS decl_item_s private_part END c_id_opt
	                ;

private_part        :   /* Empty */
	                |   PRIVATE decl_item_s
	                ;

c_id_opt            :   /* Empty */
	                |   compound_name
	                ;

pkg_body            :   PACKAGE BODY compound_name IS decl_part body_opt END c_id_opt ';'
	                ;

body_opt            :   /* Empty */
	                |   block_body
	                ;

private_type        :   tagged_opt limited_opt PRIVATE
	                ;

limited_opt         :   /* Empty */
	                |   LIMITED
	                ;

use_clause          :   USE name_s ';'
	                |   USE TYPE name_s ';'
	                ;

name_s              :   name
	                |   name_s ',' name
	                ;

rename_decl         :   def_id_list ':' object_spec_opt subtype_ind renames ';'
	                |   def_id_list ':' EXCEPTION renames ';'
	                |   rename_unit
	                ;

rename_unit         :   PACKAGE compound_name renames ';'
	                |   subprog_spec renames ';'
	                |   generic_formal_part PACKAGE compound_name renames ';'
	                |   generic_formal_part subprog_spec renames ';'
	                ;

renames             :   RENAMES name
	                ;

task_decl           :   task_spec ';'
	                ;

task_spec           :   TASK simple_name task_def
	                |   TASK TYPE simple_name disc_part_opt task_def
	                ;

task_def            :   /* Empty */
	                |   IS entry_decl_s rep_spec_s task_private_opt END id_opt
	                ;

task_private_opt    :   /* Empty */
	                |   PRIVATE entry_decl_s rep_spec_s
	                ;

task_body           :   TASK BODY simple_name IS decl_part block_body END id_opt ';'
	                ;

prot_decl           :   prot_spec ';'
	                ;

prot_spec           :   PROTECTED IDENTIFIER prot_def
	                |   PROTECTED TYPE simple_name disc_part_opt prot_def
	                ;

prot_def            :   IS prot_op_decl_s prot_private_opt END id_opt
	                ;

prot_private_opt    :   /* Empty */
	                |   PRIVATE prot_elem_decl_s 
                    ;

prot_op_decl_s      :   /* Empty */
	                |   prot_op_decl_s prot_op_decl
	                ;

prot_op_decl        :   entry_decl
	                |   subprog_spec ';'
	                |   rep_spec
	                |   pragma
	                ;

prot_elem_decl_s    :   /* Empty */
	                |   prot_elem_decl_s prot_elem_decl
	                ;

prot_elem_decl      :   prot_op_decl
                    |   component_decl ;

prot_body           :   PROTECTED BODY simple_name IS prot_op_body_s END id_opt ';'
	                ;

prot_op_body_s      :   pragma_s
	                |   prot_op_body_s prot_op_body pragma_s
	                ;

prot_op_body        :   entry_body
	                |   subprog_body
	                |   subprog_spec ';'
	                ;

entry_decl_s        :   pragma_s
	                |   entry_decl_s entry_decl pragma_s
	                ;

entry_decl          :   ENTRY IDENTIFIER formal_part_opt ';'
	                |   ENTRY IDENTIFIER '(' discrete_range ')' formal_part_opt ';'
	                ;

entry_body          :   ENTRY IDENTIFIER formal_part_opt WHEN condition entry_body_part
	                |   ENTRY IDENTIFIER '(' iter_part discrete_range ')' formal_part_opt WHEN condition entry_body_part
	                ;

entry_body_part     :   ';'
	                |   IS decl_part block_body END id_opt ';'
	                ;

rep_spec_s          :   /* Empty */
	                |   rep_spec_s rep_spec pragma_s
	                ;

entry_call          :   procedure_call_statement
	                ;

accept_statement    :   accept_hdr ';'
	                |   accept_hdr DO handled_stmt_s END id_opt ';'
	                ;

accept_hdr          :   ACCEPT entry_name formal_part_opt
	                ;

entry_name          :   simple_name
	                |   entry_name '(' expression ')'
	                ;

delay_statement     :   DELAY expression ';'
	                |   DELAY UNTIL expression ';'
	                ;

select_statement    :   select_wait
	                |   async_select
	                |   timed_entry_call
	                |   cond_entry_call
	                ;

select_wait         :   SELECT guarded_select_alt or_select else_opt END SELECT ';'
	                ;

guarded_select_alt  :   select_alt
	                |   WHEN condition ARROW select_alt
	                ;

or_select           :   /* Empty */
	                |   or_select OR guarded_select_alt
	                ;

select_alt          :   accept_statement stmts_opt
	                |   delay_statement stmts_opt
	                |   TERMINATE ';'
	                ;

delay_or_entry_alt  :   delay_statement stmts_opt
	                |   entry_call stmts_opt
                    ;
                    
async_select        :   SELECT delay_or_entry_alt THEN ABORT statement_s END SELECT ';'
	                ;

timed_entry_call    :   SELECT entry_call stmts_opt OR delay_statement stmts_opt END SELECT ';'
	                ;

cond_entry_call     :   SELECT entry_call stmts_opt ELSE statement_s END SELECT ';'
	                ;

stmts_opt           :   /* Empty */
	                |   statement_s
	                ;

abort_statement     :   ABORT name_s ';'
	                ;

compilation         :   /* Empty */
	                |   compilation comp_unit
	                |   pragma pragma_s
	                ;

comp_unit           :   context_spec private_opt unit pragma_s
	                |   private_opt unit pragma_s
	                ;

private_opt         :   /* Empty */
	                |   PRIVATE
	                ;

context_spec        :   with_clause use_clause_opt
	                |   context_spec with_clause use_clause_opt
	                |   context_spec pragma
	                ;

with_clause         :   WITH c_name_list ';'
	                ;

use_clause_opt      :   /* Empty */
	                |   use_clause_opt use_clause
	                ;

unit                :   pkg_decl
	                |   pkg_body
	                |   subprog_decl
	                |   subprog_body
	                |   subunit
	                |   generic_decl
	                |   rename_unit
                    ;

subunit             :   SEPARATE '(' compound_name ')' subunit_body
	                ;

subunit_body        :   subprog_body
	                |   pkg_body
	                |   task_body
	                |   prot_body
	                ;

body_stub           :   TASK BODY simple_name IS SEPARATE ';'
	                |   PACKAGE BODY compound_name IS SEPARATE ';'
	                |   subprog_spec IS SEPARATE ';'
	                |   PROTECTED BODY simple_name IS SEPARATE ';'
	                ;

exception_decl      :   def_id_list ':' EXCEPTION ';'
	                ;

except_handler_part :   EXCEPTION exception_handler
	                |   except_handler_part exception_handler
	                ;

exception_handler   :   WHEN except_choice_s ARROW statement_s
	                |   WHEN IDENTIFIER ':' except_choice_s ARROW statement_s
	                ;

except_choice_s     :   except_choice
	                |   except_choice_s '|' except_choice
	                ;

except_choice       :   name
	                |   OTHERS
	                ;

raise_statement     :   RAISE name_opt ';'
	                ;

requeue_statement   :   REQUEUE name ';'
	                |   REQUEUE name WITH ABORT ';'
	                ;

generic_decl        :   generic_formal_part subprog_spec ';'
	                |   generic_formal_part pkg_spec ';'
	                ;

generic_formal_part :   GENERIC
	                |   generic_formal_part generic_formal
	                ;

generic_formal      :   param ';'
	                |   TYPE simple_name generic_discrim_part_opt IS generic_type_def ';'
	                |   WITH PROCEDURE simple_name formal_part_opt subp_default ';'
	                |   WITH FUNCTION designator formal_part_opt RETURN name subp_default ';'
	                |   WITH PACKAGE simple_name IS NEW name '(' BOX ')' ';'
	                |   WITH PACKAGE simple_name IS NEW name ';'
	                |   use_clause
	                ;

generic_discrim_part_opt :/* Empty */
	                |   disc_part
	                | '(' BOX ')'
	                ;

subp_default        :   /* Empty */
	                |   IS name
	                |   IS BOX
	                ;

generic_type_def    :   '(' BOX ')'
	                |   RANGE BOX
	                |   MOD BOX
	                |   DELTA BOX
	                |   DELTA BOX DIGITS BOX
	                |   DIGITS BOX
	                |   array_type
	                |   access_type
	                |   private_type
	                |   generic_derived_type
	                ;

generic_derived_type:   NEW subtype_ind
	                |   NEW subtype_ind WITH PRIVATE
	                |   ABSTRACT NEW subtype_ind WITH PRIVATE
	                ;

generic_subp_inst   :   subprog_spec IS generic_inst
	                ;

generic_pkg_inst    :   PACKAGE compound_name IS generic_inst
	                ;

generic_inst        :   NEW name
	                ;

rep_spec            :   attrib_def
	                |   record_type_spec
	                |   address_spec
	                ;

attrib_def          :   FOR mark USE expression ';'
	                ;

record_type_spec    :   FOR mark USE RECORD align_opt comp_loc_s END RECORD ';'
	                ;

align_opt           :   /* Empty */
	                |   AT MOD expression ';'
	                ;

comp_loc_s          :   /* Empty */
	                |   comp_loc_s mark AT expression RANGE range ';'
	                ;

address_spec        :   FOR mark USE AT expression ';'
	                ;

code_statement      :   qualified ';'
                    ;
%%

main() {
        yyparse();
        return 0;
}

yyerror(char *s) {
        //fprintf(stderr, "%s\n", s);
}
