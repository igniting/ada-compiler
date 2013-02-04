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

%%
name		:	directname
		|	indexed_comp
		|	slice	
		;
		
directname	:	IDENTIFIER
		;
		
prefix		:	name
		|	implicitderef
		;
		
explicitderef	:	name.all
		;
		
implicitderef	:	name
		;
		
indexed_comp	:	prefix'('expression_s')'
		;
		
expression_s	:	expression
		|	expression_s ',' expression
		;
		
slice		:	prefix'('  ')'		

%%

main() {
        yyparse();
        return 0;
}

yyerror(char *s) {
        fprintf(stderr, "%s\n", s);
}
