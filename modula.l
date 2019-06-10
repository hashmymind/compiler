%{
/* to define functions and enumerate type of token */
#include "modula.h"
#include "symbol.hpp"
#include <cstring>
int lineCount = 0;
char lineBuf[LineBufSize];
extern "C"
{
    int yywrap();
    int yylex();
}
%}

letter [a-zA-Z_]
digit [0-9]
integer 0|[1-9]{digit}*
id {letter}({letter}|{digit})*
delimiter ,|:|\.|;|\(|\)|\[|\]|\{|\}
single_operator \+|-|\*|\/|%|<|>|=|~
operator <=|>=|<>|:=|\|\||&&
keyword array|boolean|begin|const|do|else|end|if|integer|real|string|loop|module|print|println|procedure|then|var|while|of|continue|break|return
boolean true|false
plain_real [+|-]?{integer}\.{digit}+
exp_real {plain_real}E-?{integer}
real {plain_real}|{exp_real}
string \"(\"\"|[^\"])*\"
comment \/\/[^\n]*

%x CMT
%%

[\n] {
    lineCount +=1;
    memset(lineBuf,0,LineBufSize);
}
"(*" {
    BEGIN CMT;
    RECORD(yytext);
}
<CMT>"*)" {
    BEGIN INITIAL;
    RECORD(yytext);
}
<CMT>. {RECORD(yytext);};
<CMT>\n {
    lineCount +=1;
    memset(lineBuf,0,LineBufSize);
}
{string} {	
    TOKEN("string");
    RECORD(yytext);
    yylval.string_val = new string(yytext);
    return CONST_STR;
}
{comment} {
    RECORD(yytext);
}
{keyword} {	
    TOKEN("keyword");
    RECORD(yytext);
    RETURN_TOKEN(yytext);
}
{operator} {
    TOKEN("keyword");
    RECORD(yytext);
    RETURN_TOKEN(yytext);
}
{boolean} {
    TOKEN("bool");
    RECORD(yytext);
    if(strcmp(yytext,"true")==0)
        yylval.bool_val = true;
    else
        yylval.bool_val = false;
    return CONST_BOOL;
}
{delimiter} {
    TOKEN("delimiter");
    RECORD(yytext);
    RETURN_CHAR(yytext[0]);
}
{single_operator} {
    TOKEN("operator");
    RECORD(yytext);
    RETURN_CHAR(yytext[0]);
}
{id} {
    RECORD(yytext);
    yylval.string_val = new string(yytext);
    return ID;
}
{integer} {
    TOKEN("integer");
    RECORD(yytext);
    yylval.int_val = atoi(yytext);
    return CONST_INT;
}

{real} {
    TOKEN("real");
    RECORD(yytext);
    yylval.real_val = atof(yytext);
    return CONST_REAL;
}
[ \t]* {RECORD(yytext);}

. {
    RECORD(yytext);
    printf("%d: %s\n",lineCount,lineBuf);
    printf("bad character:’%s’\n",yytext);
    exit(-1);
}
%%

int yywrap()
{
    return 1;
}
