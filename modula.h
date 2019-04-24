/* we define functions and token types here */
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#define LineBufSize 1000
enum{
	NormalState = 0,
	CommentState
};

/* Create a symbol table. */
void creat();
/* Returns index of the entry for string s, or nil if s is not found. */
int lookup(char*);
/* Inserts s into a new entry of the symbol table and returns index of the entry. */
int insert(char*);
/* Dumps all entries of the symbol table. returns index of the entry. */
void dump();

/* define marco */

#define RECORD(text) ( \
		strcat(lineBuf,text)\
		)

