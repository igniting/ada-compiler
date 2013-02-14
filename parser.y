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

%{
#include <stdio.h>
#define YYSTYPE char*
%}

%%
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
                    |   slice        
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
                
slice               :   prefix'(' discreterange ')'
                    ;
                
selected_comp       :   prefix '.' selector_name
                    ;                
                
selector_name       :   IDENTIFIER
                    |   CHARACTER
                    |   operator
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
                    |   choice_relation AND choice_expression
                    |   choice_relation OR choice_expression
                    |   choice_relation XOR choice_expression
                    |   choice_relation AND THEN choice_expression
                    |   choice_relation OR ELSE choice_expression
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
                    |   procedure_call_statement
                    |   simple_ret_statement
                    |   entry_call_statement
                    |   requeue_statement
                    |   delay_statement
                    |   abort_statement
                    |   raise_statement
                    |   code_statement
                    ;
compound_statement  :   if_statement
                    |   case_statement
                    |   loop_statement
                    |   block_statement
                    |   extended_ret_statement
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
                    |   iter_part reverse_opt discreterange
                    ;
iter_part           :   FOR IDENTIFIER IN
                    ;
reverse_opt         :   /* Empty */
                    |   REVERSE
                    ;
block_statement     :   label_opt decl_opt BegiN seq_of_statement END id_opt ';'
                    ;
decl_opt            :   /* Empty */
                    |   DECLARE decl_part
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
        fprintf(stderr, "%s\n", s);
}
