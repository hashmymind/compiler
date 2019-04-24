%{
/* to define functions and enumerate type of token */
#include "modula.h"
int lineCount = 0;
char* lineBuf[LineBufSize];
%}

letter [a-zA-Z_]
digit [0-9]
id {letter}({letter}|{digit})*

%%
 
[\n] 	{
		lineCount +=1;
		printf("%d: %s\n",lineCount,lineBuf);
		memset(lineBuf,0,LineBufSize);
	}
module 	{
		printf("<MODULE>\n");
		RECORD(yytext);
	}
{id} 	{
		printf("<%s>\n",yytext);
		RECORD(yytext);
	}

. {RECORD(yytext);}
%%

int main(){
	yylex();
}

