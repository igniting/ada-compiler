%{
/**************Lexical Analyser for ADA*************/
/*Source:Ada Reference Manual, ISO/IEC 8652:2012(E)*/
#include "y.tab.h"
#include <string.h>
#include "util.h"
#include "errormsg.h"

int charPos=1;

int yywrap(void)
{
 charPos=1;
 return 1;
}


void adjust(void)
{
 EM_tokPos=charPos;
 charPos+=yyleng;
}
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
(?i:ABORT)      { adjust(); return(ABORT);}
(?i:ABS)        { adjust(); return(ABS);}
(?i:ABSTRACT)   { adjust(); return(ABSTRACT);}
(?i:ACCEPT)     { adjust(); return(ACCEPT);}
(?i:ACCESS)     { adjust(); return(ACCESS);}
(?i:ALIASED)    { adjust(); return(ALIASED);}
(?i:ALL)        { adjust(); return(ALL);}
(?i:AND)        { adjust(); return(AND);}
(?i:ARRAY)      { adjust(); return(ARRAY);}
(?i:AT)         { adjust(); return(AT);}
(?i:BegiN)      { adjust(); return(BegiN);}
(?i:BODY)       { adjust(); return(BODY);}
(?i:CASE)       { adjust(); return(CASE);}
(?i:CONSTANT)   { adjust(); return(CONSTANT);}
(?i:DECLARE)    { adjust(); return(DECLARE);}
(?i:DELAY)      { adjust(); return(DELAY);}
(?i:DELTA)      { adjust(); return(DELTA);}
(?i:DIGITS)     { adjust(); return(DIGITS);}
(?i:DO)         { adjust(); return(DO);}
(?i:ELSE)       { adjust(); return(ELSE);}
(?i:ELSIF)      { adjust(); return(ELSIF);}
(?i:END)        { adjust(); return(END);}
(?i:ENTRY)      { adjust(); return(ENTRY);}
(?i:EXCEPTION)  { adjust(); return(EXCEPTION);}
(?i:EXIT)       { adjust(); return(EXIT);}
(?i:FOR)        { adjust(); return(FOR);}
(?i:FUNCTION)   { adjust(); return(FUNCTION);}
(?i:GENERIC)    { adjust(); return(GENERIC);}
(?i:GOTO)       { adjust(); return(GOTO);}
(?i:IF)         { adjust(); return(IF);}
(?i:IN)         { adjust(); return(IN);}
(?i:INTERFACE)  { adjust(); return(INTERFACE);}
(?i:IS)         { adjust(); return(IS);}
(?i:LIMITED)    { adjust(); return(LIMITED);}
(?i:LOOP)       { adjust(); return(LOOP);}
(?i:MOD)        { adjust(); return(MOD);}
(?i:NEW)        { adjust(); return(NEW);}
(?i:NOT)        { adjust(); return(NOT);}
(?i:NuLL)       { adjust(); return(NuLL);}
(?i:OF)         { adjust(); return(OF);}
(?i:OR)         { adjust(); return(OR);}
(?i:OTHERS)     { adjust(); return(OTHERS);}
(?i:OUT)        { adjust(); return(OUT);}
(?i:OVERRIDING) { adjust(); return(OVERRIDING);}
(?i:PACKAGE)    { adjust(); return(PACKAGE);}
(?i:PRAGMA)     { adjust(); return(PRAGMA);}
(?i:PRIVATE)    { adjust(); return(PRIVATE);}
(?i:PROCEDURE)  { adjust(); return(PROCEDURE);}
(?i:PROTECTED)  { adjust(); return(PROTECTED);}
(?i:RAISE)      { adjust(); return(RAISE);}
(?i:RANGE)      { adjust(); return(RANGE);}
(?i:RECORD)     { adjust(); return(RECORD);}
(?i:REM)        { adjust(); return(REM);}
(?i:RENAMES)    { adjust(); return(RENAMES);}
(?i:REQUEUE)    { adjust(); return(REQUEUE);}
(?i:RETURN)     { adjust(); return(RETURN);}
(?i:REVERSE)    { adjust(); return(REVERSE);}
(?i:SELECT)     { adjust(); return(SELECT);}
(?i:SEPARATE)   { adjust(); return(SEPARATE);}
(?i:SUBTYPE)    { adjust(); return(SUBTYPE);}
(?i:SYNCHRONIZED){ adjust(); return(SYNCHRONIZED);}
(?i:TAGGED)     { adjust(); return(TAGGED);}
(?i:TASK)       { adjust(); return(TASK);}
(?i:TERMINATE)  { adjust(); return(TERMINATE);}
(?i:THEN)       { adjust(); return(THEN);}
(?i:TYPE)       { adjust(); return(TYPE);}
(?i:UNTIL)      { adjust(); return(UNTIL);}
(?i:USE)        { adjust(); return(USE);}
(?i:WHEN)       { adjust(); return(WHEN);}
(?i:WHILE)      { adjust(); return(WHILE);}
(?i:WITH)       { adjust(); return(WITH);}
(?i:XOR)        { adjust(); return(XOR);}
"'"             { adjust(); return(TICK);}
"("             { adjust(); return('(');}
")"             { adjust(); return(')');}
"*"             { adjust(); return('*');}
"+"             { adjust(); return('+');}
","             { adjust(); return(',');}
"-"             { adjust(); return('-');}
"."             { adjust(); return('.');}
"/"             { adjust(); return('/');}
":"             { adjust(); return(':');}
";"             { adjust(); return(';');}
"<"             { adjust(); return('<');}
"="             { adjust(); return('=');}
">"             { adjust(); return('>');}
"|"             { adjust(); return('|');}
"&"             { adjust(); return('&');}
"=>"            { adjust(); return(ARROW);}
".."            { adjust(); return(DDOT);}
"**"            { adjust(); return(EXPONENTIATE);}
":="            { adjust(); return(ASSIGNMENT);}
"/="            { adjust(); return(INEQUALITY);}
">="            { adjust(); return(GE);}
"<="            { adjust(); return(LE);}
"<<"            { adjust(); return(LLB);}
">>"            { adjust(); return(RLB);}
"<>"            { adjust(); return(BOX);}
{IDENTIFIER}    { yylval = strdup(yytext); return(IDENTIFIER);}
{NUMBER}        { yylval = strdup(yytext); return(NUMBER);}
{CHARACTER}     { yylval = strdup(yytext); return(CHARACTER);}
{STRING}        { yylval = strdup(yytext); return(STRING);}
{COMMENT}       ;
[ \t]           ;
[\n]            yylloc.first_line++;
.               printf("Invalid token in line %d.\n",yylloc.first_line);
%%
