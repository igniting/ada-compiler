%{
/**************Lexical Analyser for ADA*************/
/*Source:Ada Reference Manual, ISO/IEC 8652:2012(E)*/
# include "y.tab.h"
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
{IDENTIFIER}    return(IDENTIFIER);
{NUMBER}        return(NUMBER);
{CHARACTER}     return(CHARACTER);
{STRING}        return(STRING);
{COMMENT}       ;
"'"             return(TICK);
"("             return('(');
")"             return(')');
"*"             return('*');
"+"             return('+');
","             return(',');
"-"             return('-');
"."             return('.');
"/"             return('/');
":"             return(':');
";"             return(';');
"<"             return('<');
"="             return('=');
">"             return('>');
"|"             return('|');
"=>"            return(ARROW);
".."            return(DDOT);
"**"            return(EXPONENTIATE);
":="            return(ASSIGNMENT);
"/="            return(INEQUALITY);
">="            return(GE);
"<="            return(LE);
"<<"            return(LLB);
">>"            return(RLB);
"<>"            return(BOX);
%%

typedef struct {
        char* key;
        int value;
}TABLE;

#define MAX 72

TABLE key_table[MAX] = {
        {"ABORT",       ABORT},
        {"ABS",         ABS},
	{"ABSTRACT",	ABSTRACT},
        {"ACCEPT",      ACCEPT},
        {"ACCESS",      ACCESS},
	{"ALIASED",	ALIASED},
        {"ALL",         ALL},
        {"AND",         AND},
        {"ARRAY",       ARRAY},
        {"AT",          AT},
        {"BEGIN",       BegiN},
        {"BODY",        BODY},
        {"CASE",        CASE},
        {"CONSTANT",    CONSTANT},
        {"DECLARE",     DECLARE},
        {"DELAY",       DELAY},
        {"DELTA",       DELTA},
        {"DIGITS",      DIGITS},
        {"DO",          DO},
        {"ELSE",        ELSE},
        {"ELSIF",       ELSIF},
        {"END",         END},
        {"ENTRY",       ENTRY},
        {"EXCEPTION",   EXCEPTION},
        {"EXIT",        EXIT},
        {"FOR",         FOR},
        {"FUNCTION",    FUNCTION},
        {"GENERIC",     GENERIC},
        {"GOTO",        GOTO},
        {"IF",          IF},
        {"IN",          IN},
        {"INTERFACE",   INTERFACE},
        {"IS",          IS},
        {"LIMITED",     LIMITED},
        {"LOOP",        LOOP},
        {"MOD",         MOD},
        {"NEW",         NEW},
        {"NOT",         NOT},
        {"NULL",        NuLL},
        {"OF",          OF},
        {"OR",          OR},
        {"OTHERS",      OTHERS},
        {"OUT",         OUT},
        {"OVERRIDING",  OVERRIDING},
        {"PACKAGE",     PACKAGE},
        {"PRAGMA",      PRAGMA},
        {"PRIVATE",     PRIVATE},
        {"PROCEDURE",   PROCEDURE},
	{"PROTECTED",	PROTECTED},
        {"RAISE",       RAISE},
        {"RANGE",       RANGE},
        {"RECORD",      RECORD},
        {"REM",         REM},
        {"RENAMES",     RENAMES},
	{"REQUEUE",	REQUEUE},
        {"RETURN",      RETURN},
        {"REVERSE",     REVERSE},
        {"SELECT",      SELECT},
        {"SEPARATE",    SEPARATE},
        {"SUBTYPE",     SUBTYPE},
        {"SYNCHRONIZED",SYNCHRONIZED},
	{"TAGGED",	TAGGED},
        {"TASK",        TASK},
        {"TERMINATE",   TERMINATE},
        {"THEN",        THEN},
        {"TYPE",        TYPE},
	{"UNTIL",	UNTIL},
        {"USE",         USE},
        {"WHEN",        WHEN},
        {"WHILE",       WHILE},
        {"WITH",        WITH},
        {"XOR",         XOR}
};
