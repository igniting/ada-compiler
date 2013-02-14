/**************Parser for ADA*************/
%{
#include <stdio.h>
#include <stdlib.h>
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
expression			:	relation
					|	relation AND expression
					|	relation OR expression
					|	relation XOR expression
					|	relation AND THEN expression
					|	relation OR ELSE expression
					;
choice_expression	:	choice_relation
					|	choice_relation AND choice_expression
					|	choice_relation OR choice_expression
					|	choice_relation XOR choice_expression
					|	choice_relation AND THEN choice_expression
					|	choice_relation OR ELSE choice_expression
					;
rel_op				:	'='
					|	INEQUALITY
					|	'<'
					|	LE
					|	'>'
					|	GE
					;
choice_relation		:	simple_expression
					|	simple_expression rel_op simple_expression
					;
relation			:	simple_expression
					|	simple_expression rel_op simple_expression
					|	simple_expression not IN mem_choice_list
					;
not					:	/* Empty */
					|	NOT
					;
mem_choice_list		:	mem_choice
					|	mem_choice mem_choice_list
					;
mem_choice			:	choice_expression
					;
simple_expression	:	unary_add term binary_term
					;
binary_term			:	/* Empty */
					|	binary_add term binary_term
					;
unary_add			:	/* Empty */
					|	'+'
					|	'-'
					;
binary_add			:	'+'
					|	'-'
					|	'&'
					;
term				:	factor
					|	factor mul_op factor
					;
mul_op				:	'*'
					|	'/'
					|	MOD
					|	REM
					;
factor				:	primary
					|	primary EXPONENTIATE primary
					|	ABS primary
					|	NOT primary
					;
primary				:	NUMBER
					|	NuLL
					|	STRING
					|	'('expression')'
					;
name		        :	directname
		            |	indexed_comp
		            |	slice	
		            |	selected_comp
		            |	attribute_ref
		            ;
		
directname	        :	IDENTIFIER
		            ;
		
prefix		        :	name
		            |	implicitderef
		            ;
		
explicitderef	    :	name.all
		            ;
		
implicitderef	    :	name
		            ;
		
indexed_comp	    :	prefix'('expression_s')'
		            ;
		
expression_s	    :	expression
		            |	expression_s ',' expression
		            ;
		
slice		        :	prefix'(' discreterange ')'
		            ;
		
selected_comp	    :	prefix '.' selector_name
		            ;		
		
selector_name	    :	IDENTIFIER
		            |	CHARACTER
		            |	OPERATOR
		            ;
		            	
attribute_ref	    :	prefix'''attribute_id
		            ;
		
attribute_id	    :	IDENTIFIER
		            |	DELTA
		            |	DIGITS
		            |	ACCESS
		            |	MOD
		            ;
		            
literal		        :	NUMBER
		            |	CHARACTER
		            |	NuLL
		            |	STRING
		            ;
%%

main() {
        yyparse();
        return 0;
}

yyerror(char *s) {
        fprintf(stderr, "%s\n", s);
}
