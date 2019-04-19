/* we define functions and token types here */

enum{
	NO = 0
};

/* Create a symbol table. */
void creat();
/* Returns index of the entry for string s, or nil if s is not found. */
int lookup(char*);
/* Inserts s into a new entry of the symbol table and returns index of the entry. */
int insert(char*);
/* Dumps all entries of the symbol table. returns index of the entry. */
void dump();

