%{
/* to define functions and enumerate type of token */
#include "modula.h"
int lineCount = 0;
char* lineBuf[LineBufSize];
%}

letter [a-zA-Z_]
digit [0-9]
id {letter}({letter}|{digit})*
keyword module|begin|print|end
string \"[^\"]*\"
comment \/\/[^\n]+\n
%%
 
[\n] 		{
			lineCount +=1;
			printf("%d: %s\n",lineCount,lineBuf);
			memset(lineBuf,0,LineBufSize);
		}
{string}	{
			printf("<string: %s>\n",yytext);
			RECORD(yytext);
		}
{comment}	{
			printf("<comment: %s>\n", yytext);
			RECORD(yytext);
		}
{keyword}	{
			printf("<keyword: %s>\n",yytext);
			RECORD(yytext);
		}
	
{id} 		{
			printf("<id: %s>\n",yytext);
			RECORD(yytext);
		}

. {RECORD(yytext);}
%%

int main(){
	yylex();
}

