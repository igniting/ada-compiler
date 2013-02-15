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

%start        seq_of_statement

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
	                
basic_decl          :   type_decl
                    |   subtype_decl
                    |   object_decl
                    |   number_decl
                    |   subprog_decl
                    |   abs_subprog_decl
                    |   null_proc_decl
                    |   expression_fn_decl
                    |   package_decl
                    |   renaming_decl
                    |   exception_decl
                    |   generic_decl
                    |   generic_instantiation
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
                    |   interface_type
                    ;
                    
subtype_decl        :   SUBTYPE def_identifier IS subtype_ind ';'
                    ;
                    
subtype_ind         :   name constraint
                    |   name
                    ;
                    
constraint          :   range_constraint
                    |   digits_constraint
                    ;
                    
range_spec          :   RANGE range
                    ;

range               :   simple_expression DDOT simple_expression
                    |   name TICK range
                    |   name TICK range '(' expression ')'
                    ;
                    
digits_constraint   :   DIGITS expression range_spec_opt
                    ;
                    
range_spec_opt    :   /* Empty */
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
                    
aggregate           :   record_aggregate
                    |   extension_aggregate
                    |   array_aggregate
                    ;

record_aggregate    :   record_component_association_list
                    ;
                
record_component_association_list:record_component_association
                    |   record_component_association ',' record_component_association
                    |   NuLL RECORD
                    ;
                            
record_component_association:expression
                    |   component_choice_list ARROW expression
                    |   component_choice_list ARROW BOX /* pointing to NULL */
                    ;

component_choice_list:  component_selector_name
                    |   component_selector_name '|' component_selector_name
                    |   OTHERS
                    ;

component_selector_name:IDENTIFIER
                    |   CHARACTER
                    |   STRING
                    ;
                    
extension_aggregate :   ancestor_part WITH record_component_association_list
                    ;

ancestor_part       :   expression
                    |   subtype_mark /* Defined in Type Definition (actually NAME)*/
                    ;

array_aggregate     :   positional_array_aggregate
                    |   named_array_aggregate
                    ;
                                
positional_array_aggregate:'('expression ',' expression')'
                    |   '('expression ',' expression ',' expression')'
                    |   '('expression ',' OTHERS ARROW expression ')'
                    |   '('expression ',' expression ',' OTHERS ARROW expression ')'
                    |   '('expression ',' OTHERS ARROW BOX ')'
                    |   '('expression ',' expression ',' OTHERS ARROW BOX ')'
                    ;
                        
named_array_aggregate:  '(' array_component_association ')'
                    |   '(' array_component_association ',' array_component_association ')'
                    ;
                        
array_component_association:discrete_choice_list ARROW expression
                    |   discrete_choice_list ARROW BOX
                    ;
                        
discrete_choice_list:   discrete_choice
                    |   discrete_choice '|' discrete_choice
                    ;
                            
discrete_choice     :   expression
                    |   RANGE
                    |   OTHERS
                    ;
                
subtype_mark        :   name
                    ;

name                :   directname
                    |   indexed_comp
                    /*
                    |   slice
                    */        
                    |   selected_comp
                    |   attribute_ref
                    ;
                
directname          :   IDENTIFIER
                    ;
                
prefix              :   name
                    |   implicitderef
                    ;
                
explicitderef       :   name '.' ALL
                    ;
                
implicitderef       :   name
                    ;
                
indexed_comp        :   prefix'('expression_s')'
                    ;
                
expression_s        :   expression
                    |   expression_s ',' expression
                    ;
/*                
slice               :   prefix'(' discreterange ')'
                    ;
*/                
selected_comp       :   prefix '.' selector_name
                    ;                
                
selector_name       :   IDENTIFIER
                    |   CHARACTER
                    /*
                    |   operator
                    */
                    ;
                                    
attribute_ref       :   prefix TICK attribute_id
                    ;
                
attribute_id        :   IDENTIFIER
                    |   DELTA
                    |   DIGITS
                    |   ACCESS
                    |   MOD
                    ;
                            
literal             :   NUMBER
                    |   CHARACTER
                    |   NuLL
                    |   STRING
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
range               :   simple_expression DDOT simple_expression
                    |   name TICK RANGE
                    |   name TICK RANGE '(' expression ')'
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
primary             :   NUMBER
                    |   NuLL
                    |   STRING
                    |   name
                    |   '('expression')'
                    ;
logical_op          :   AND
                    |   OR
                    |   XOR
                    ;
short_circuit_op    :   AND THEN
                    |   OR ELSE
                    ;
highest_prec_op     :   EXPONENTIATE
                    |   ABS
                    |   NOT
                    ;
seq_of_statement    :   statement
                    |   seq_of_statement statement
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
/*
                    |   procedure_call_statement
                    |   simple_ret_statement
                    |   entry_call_statement
                    |   requeue_statement
                    |   delay_statement
                    |   abort_statement
                    |   raise_statement
                    |   code_statement
*/
                    |   error ';'
                            {
                                printf("Syntax error in line %d.\n",@1.first_line);
                            }
                    ;
compound_statement  :   if_statement
                    |   case_statement
                    |   loop_statement
                    |   block_statement
/*
                    |   extended_ret_statement
                    |   accept_statement
                    |   select_statement
*/
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
cond_clause         :   condition THEN seq_of_statement
                    ;
condition           :   expression
                    ;
else_opt            :   /* Empty */
                    |   ELSE seq_of_statement
                    ;
case_statement      :   CASE expression IS case_statement_alt_s END CASE ';'
                    ;
case_statement_alt_s:   case_statement_alt
                    |   case_statement_alt case_statement_alt_s
                    ;
case_statement_alt  :   WHEN discrete_choice_list ARROW seq_of_statement
                    ;
loop_statement      :   label_opt iteration_scheme_opt LOOP seq_of_statement END LOOP id_opt ';'
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
                    /*
                    |   iter_part reverse_opt discreterange
                    */
                    ;
iter_part           :   FOR IDENTIFIER IN
                    ;
reverse_opt         :   /* Empty */
                    |   REVERSE
                    ;
block_statement     :   label_opt decl_opt BegiN seq_of_statement END id_opt ';'
                    ;
decl_opt            :   /* Empty */
                    /*
                    |   DECLARE decl_part
                    */
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
simple_ret_statement:   RETURN ';'
                    |   RETURN expression ';'
                    ; 
%%

main() {
        yyparse();
        return 0;
}

yyerror(char *s) {
        //fprintf(stderr, "%s\n", s);
}
