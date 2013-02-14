%{
/**************Lexical Analyser for ADA*************/
/*Source:Ada Reference Manual, ISO/IEC 8652:2012(E)*/
# include "y.tab.h"
extern YYSTYPE yylval;
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
(?i:ABORT)      return(ABORT);
(?i:ABS)        return(ABS);
(?i:ABSTRACT)   return(ABSTRACT);
(?i:ACCEPT)     return(ACCEPT);
(?i:ACCESS)     return(ACCESS);
(?i:ALIASED)    return(ALIASED);
(?i:ALL)        return(ALL);
(?i:AND)        return(AND);
(?i:ARRAY)      return(ARRAY);
(?i:AT)         return(AT);
(?i:BegiN)      return(BegiN);
(?i:BODY)       return(BODY);
(?i:CASE)       return(CASE);
(?i:CONSTANT)   return(CONSTANT);
(?i:DECLARE)    return(DECLARE);
(?i:DELAY)      return(DELAY);
(?i:DELTA)      return(DELTA);
(?i:DIGITS)     return(DIGITS);
(?i:DO)         return(DO);
(?i:ELSE)       return(ELSE);
(?i:ELSIF)      return(ELSIF);
(?i:END)        return(END);
(?i:ENTRY)      return(ENTRY);
(?i:EXCEPTION)  return(EXCEPTION);
(?i:EXIT)       return(EXIT);
(?i:FOR)        return(FOR);
(?i:FUNCTION)   return(FUNCTION);
(?i:GENERIC)    return(GENERIC);
(?i:GOTO)       return(GOTO);
(?i:IF)         return(IF);
(?i:IN)         return(IN);
(?i:INTERFACE)  return(INTERFACE);
(?i:IS)         return(IS);
(?i:LIMITED)    return(LIMITED);
(?i:LOOP)       return(LOOP);
(?i:MOD)        return(MOD);
(?i:NEW)        return(NEW);
(?i:NOT)        return(NOT);
(?i:NuLL)       return(NuLL);
(?i:OF)         return(OF);
(?i:OR)         return(OR);
(?i:OTHERS)     return(OTHERS);
(?i:OUT)        return(OUT);
(?i:OVERRIDING) return(OVERRIDING);
(?i:PACKAGE)    return(PACKAGE);
(?i:PRAGMA)     return(PRAGMA);
(?i:PRIVATE)    return(PRIVATE);
(?i:PROCEDURE)  return(PROCEDURE);
(?i:PROTECTED)  return(PROTECTED);
(?i:RAISE)      return(RAISE);
(?i:RANGE)      return(RANGE);
(?i:RECORD)     return(RECORD);
(?i:REM)        return(REM);
(?i:RENAMES)    return(RENAMES);
(?i:REQUEUE)    return(REQUEUE);
(?i:RETURN)     return(RETURN);
(?i:REVERSE)    return(REVERSE);
(?i:SELECT)     return(SELECT);
(?i:SEPARATE)   return(SEPARATE);
(?i:SUBTYPE)    return(SUBTYPE);
(?i:SYNCHRONIZED)return(SYNCHRONIZED);
(?i:TAGGED)     return(TAGGED);
(?i:TASK)       return(TASK);
(?i:TERMINATE)  return(TERMINATE);
(?i:THEN)       return(THEN);
(?i:TYPE)       return(TYPE);
(?i:UNTIL)      return(UNTIL);
(?i:USE)        return(USE);
(?i:WHEN)       return(WHEN);
(?i:WHILE)      return(WHILE);
(?i:WITH)       return(WITH);
(?i:XOR)        return(XOR);
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
{IDENTIFIER}    { yylval = strdup(yytext); return(IDENTIFIER);}
{NUMBER}        { yylval = strdup(yytext); return(NUMBER);}
{CHARACTER}     { yylval = strdup(yytext); return(CHARACTER);}
{STRING}        { yylval = strdup(yytext); return(STRING);}
{COMMENT}       ;
%%
