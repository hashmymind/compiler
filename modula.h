#pragma once
/* we define functions and token types here */
#include <cstdio>
#include <cstdlib>
#include <cstring>
#include <map>
#include <string>
#include <iostream>
#include "y.tab.hpp"
#define LineBufSize 1000
#define MaxIdLen 20
using namespace std;


/* inital keyword map */
map<string, int> token_map;
int token_inited = 0;
void init_token_map(){
    token_map["<="] = LET;
    token_map[">="] = BET;
    token_map["<>"] = NE;
    token_map["&&"] = AND;
    token_map["||"] = OR;
    token_map[":="] = ASS;
    token_map["begin"] = _BEGIN;
    token_map["end"] = END;
    token_map["module"] = MODULE;
    token_map["procedure"] = PROCEDURE;
    token_map["if"] = IF;
    token_map["then"] = THEN;
    token_map["else"] = ELSE;
    token_map["while"] = WHILE;
    token_map["do"] = DO;
    token_map["var"] = VAR;
    token_map["const"] = CONST;
    token_map["array"] = ARRAY;
    token_map["of"] = OF;
    token_map["print"] = PRINT;
    token_map["println"] = PRINTLN;
    token_map["integer"] = INT_TYPE;
    token_map["real"] = REAL_TYPE;
    token_map["string"] = STR_TYPE;
    token_map["boolean"] = BOOL_TYPE;
    token_map["return"] = _RETURN;
    token_map["continue"] = CONTINUE;
    token_map["break"] = BREAK;
    token_inited = 1;
}

int token_mapping(string text){
    if(!token_inited)
        init_token_map();
    return token_map[text];
}

/* define marco */

#define RECORD(text) ( \
		strcat(lineBuf,text)\
		)
#define TOKEN(type) ({\
		/*printf("<%s: %s>\n",type,yytext);*/\
		})
#define RETURN_TOKEN(text) ({\
        string std_text(text);\
        return token_mapping(std_text);\
        })
#define RETURN_CHAR(c) ({\
        return c;\
        })\
