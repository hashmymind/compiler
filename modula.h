/* we define functions and token types here */
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#define LineBufSize 1000
#define MaxIdLen 20

enum{
	NormalState = 0,
	CommentState
};

typedef struct Symbol{
	int id;
	char name[MaxIdLen];
	struct Symbol* next;
} Symbol;

/* initialize symbol table */
Symbol* head;
Symbol* tail;

/* Create a symbol table. */
void create(){
	head = (Symbol*)malloc(sizeof(Symbol));
	head->id=-1;
	head->next = NULL;
	tail = head;
}
/* Returns index of the entry for string s, or nil if s is not found. */
int lookup(char* name){
	/* loop through all symbol and compare for its name */
	Symbol* iter = head->next;
	while(iter != NULL){
		if(strcmp(iter->name,name)==0)
			return iter->id;
		iter = iter->next;
	}
	return -1;
}
/* Inserts s into a new entry of the symbol table and returns index of the entry. */
int insert(char* name){
	/* check dup */
	int check_id = lookup(name);
	if(check_id != -1)
		return check_id;

	int new_id = tail->id + 1;
	Symbol* new_symbol = (Symbol*)malloc(sizeof(Symbol));
	new_symbol->id = new_id;
	strcpy(new_symbol->name,name);
	tail->next = new_symbol;
	tail = new_symbol;
}
/* Dumps all entries of the symbol table. returns index of the entry. */
void dump(){	
	Symbol* iter = head->next;
	while(iter != NULL){
		printf("%d: %s\n",iter->id, iter->name);
		iter = iter->next;
	}
}

/* define marco */

#define RECORD(text) ( \
		strcat(lineBuf,text)\
		)
#define TOKEN(type) ({\
		if(state == NormalState)\
			printf("<%s: %s>\n",type,yytext);\
		})\
