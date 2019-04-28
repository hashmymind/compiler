%{
/* to define functions and enumerate type of token */
#include "modula.h"
int lineCount = 0, state = NormalState;
char lineBuf[LineBufSize];
%}

letter [a-zA-Z_]
digit [0-9]
integer 0|[1-9]{digit}*
id {letter}({letter}|{digit})*
delimiter ,|:|\.|;|\(|\)|\[|\]|\{|\}
operator \+|-|\*|\/|%|<|<=|>|>=|=|<>|:=
keyword module|begin|print|end
boolean true|false
plain_real [+|-]?{integer}.{digit}+
exp_real {plain_real}E-?{integer}
real {plain_real}|{exp_real}
string \"[^\"]*\"
comment \/\/[^\n]*
%%
 
[\n] 		{
			lineCount +=1;
			printf("%d: %s\n",lineCount,lineBuf);
			memset(lineBuf,0,LineBufSize);
		}
"(*"		{
			state = CommentState;
			RECORD(yytext);
		}
"*)"		{
			state = NormalState;
			RECORD(yytext);
		}
{string}	{	
			TOKEN("string");
			RECORD(yytext);
		}
{comment}	{
			RECORD(yytext);
		}
{keyword}	{	
			TOKEN("keyword");
			RECORD(yytext);
		}
{delimiter}	{
			TOKEN("delimiter");
			RECORD(yytext);
		}
{operator}	{
			TOKEN("operator");
			RECORD(yytext);
		}
{id} 		{
			if(state == NormalState){
				printf("<id: %s>\n",yytext);
				insert(yytext);
			}
			RECORD(yytext);
		}
{integer}	{
			TOKEN("integer");
			RECORD(yytext);
		}
{real}		{
			TOKEN("real");
			RECORD(yytext);
		}
{boolean}	{
			TOKEN("bool");
			RECORD(yytext);
		}
. {RECORD(yytext);}
%%

int main(){
	/* create symbol table */
	create();
	yylex();
	printf("\nSymbols\n");
	dump();
}

