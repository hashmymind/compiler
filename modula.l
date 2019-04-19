%{
/* to define functions and enumerate type of token */
#include "modula.h"
%}
digit [0-9]
letter [a-zA-z_]
id ^{letter}[{letter}|{digit}]+?
string "\""[^("\n)]+"\""
%%
 
[ \t\n] ;
{id}		{ printf("Identifier\n");}
{string} 	{ printf("constant string\n");}
. 		{ printf("Unexpected shit\n");}

%%

int main(){
	yylex();
}

