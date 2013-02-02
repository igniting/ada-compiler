%{
/**************Lexical Analyser for ADA*************/
/*Source:Ada Reference Manual, ISO/IEC 8652:2012(E)*/
# include <stdio.h>
%}

LETTER              [A-Za-z]
DIGIT               [0-9]
EXTENDED_DIGIT      [0-9A-F]

IDENTIFIER          {LETTER}(_?({LETTER}|{DIGIT}))*

NUMERAL             {DIGIT}(_?{DIGIT})*
EXTENDED_NUMERAL    {EXTENDED_DIGIT}(_?{EXTENDED_DIGIT})*
EXPONENT            [eE](\+|-)?{NUMERAL}
DECIMAL_NUMBER      {NUMERAL}(\.{NUMERAL})?{EXPONENT}?
BASE_NUMBER         {NUMERAL}#{EXTENDED_NUMERAL}(\.{EXTENDED_NUMERAL})?#{EXPONENT}?
NUMBER              {DECIMAL_NUMBER}|{BASE_NUMBER}

CHARACTER           '.'

NON_QUOTE           [^\"]
STRING              \"((\"\")|{NON_QUOTE})*\"

COMMENT             --[^\n]*

%%
(?i:ABORT)      printf("ABORT");
(?i:ABS)        printf("ABS");
(?i:ABSTRACT)   printf("ABSTRACT");
(?i:ACCEPT)     printf("ACCEPT");
(?i:ACCESS)     printf("ACCESS");
(?i:ALIASED)    printf("ALIASED");
(?i:ALL)        printf("ALL");
(?i:AND)        printf("AND");
(?i:ARRAY)      printf("ARRAY");
(?i:AT)         printf("AT");
(?i:BegiN)      printf("BegiN");
(?i:BODY)       printf("BODY");
(?i:CASE)       printf("CASE");
(?i:CONSTANT)   printf("CONSTANT");
(?i:DECLARE)    printf("DECLARE");
(?i:DELAY)      printf("DELAY");
(?i:DELTA)      printf("DELTA");
(?i:DIGITS)     printf("DIGITS");
(?i:DO)         printf("DO");
(?i:ELSE)       printf("ELSE");
(?i:ELSIF)      printf("ELSIF");
(?i:END)        printf("END");
(?i:ENTRY)      printf("ENTRY");
(?i:EXCEPTION)  printf("EXCEPTION");
(?i:EXIT)       printf("EXIT");
(?i:FOR)        printf("FOR");
(?i:FUNCTION)   printf("FUNCTION");
(?i:GENERIC)    printf("GENERIC");
(?i:GOTO)       printf("GOTO");
(?i:IF)         printf("IF");
(?i:IN)         printf("IN");
(?i:INTERFACE)  printf("INTERFACE");
(?i:IS)         printf("IS");
(?i:LIMITED)    printf("LIMITED");
(?i:LOOP)       printf("LOOP");
(?i:MOD)        printf("MOD");
(?i:NEW)        printf("NEW");
(?i:NOT)        printf("NOT");
(?i:NuLL)       printf("NuLL");
(?i:OF)         printf("OF");
(?i:OR)         printf("OR");
(?i:OTHERS)     printf("OTHERS");
(?i:OUT)        printf("OUT");
(?i:OVERRIDING) printf("OVERRIDING");
(?i:PACKAGE)    printf("PACKAGE");
(?i:PRAGMA)     printf("PRAGMA");
(?i:PRIVATE)    printf("PRIVATE");
(?i:PROCEDURE)  printf("PROCEDURE");
(?i:PROTECTED)  printf("PROTECTED");
(?i:RAISE)      printf("RAISE");
(?i:RANGE)      printf("RANGE");
(?i:RECORD)     printf("RECORD");
(?i:REM)        printf("REM");
(?i:RENAMES)    printf("RENAMES");
(?i:REQUEUE)    printf("REQUEUE");
(?i:RETURN)     printf("RETURN");
(?i:REVERSE)    printf("REVERSE");
(?i:SELECT)     printf("SELECT");
(?i:SEPARATE)   printf("SEPARATE");
(?i:SUBTYPE)    printf("SUBTYPE");
(?i:SYNCHRONIZED)printf("SYNCHRONIZED");
(?i:TAGGED)     printf("TAGGED");
(?i:TASK)       printf("TASK");
(?i:TERMINATE)  printf("TERMINATE");
(?i:THEN)       printf("THEN");
(?i:TYPE)       printf("TYPE");
(?i:UNTIL)      printf("UNTIL");
(?i:USE)        printf("USE");
(?i:WHEN)       printf("WHEN");
(?i:WHILE)      printf("WHILE");
(?i:WITH)       printf("WITH");
(?i:XOR)        printf("XOR");
"'"             printf("TICK");
"("             printf("(");
")"             printf(")");
"*"             printf("*");
"+"             printf("+");
","             printf(",");
"-"             printf("-");
"."             printf(".");
"/"             printf("/");
":"             printf(":");
";"             printf(";");
"<"             printf("<");
"="             printf("=");
">"             printf(">");
"|"             printf("|");
"=>"            printf("ARROW");
".."            printf("DDOT");
"**"            printf("EXPONENTIATE");
":="            printf("ASSIGNMENT");
"/="            printf("INEQUALITY");
">="            printf("GE");
"<="            printf("LE");
"<<"            printf("LLB");
">>"            printf("RLB");
"<>"            printf("BOX");
{IDENTIFIER}    printf("IDENTIFIER");
{NUMBER}        printf("NUMBER");
{CHARACTER}     printf("CHARACTER");
{STRING}        printf("STRING");
{COMMENT}       printf("COMMENT");
[ \t\n]		ECHO;
.		fprintf(stderr,"ILLEGAL CHARACTER");
%%

main() {
	yylex();
}
