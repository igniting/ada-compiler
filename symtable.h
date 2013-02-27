#define NSYMS 500	/* maximum number of symbols */
typedef struct 
{ 
    char *name;
    char *type;
}symtab;

symtab symtable[NSYMS];

/* symbol table lookup - insert if not found 
   uses a sequential search
*/

int symlook(char *s)
{ 
  char *p;
  symtab *sp;
  /* uses the equivalence of subscripts and pointers */
  for(sp = symtable; sp < &symtable[NSYMS]; sp++) 
  {/* test to see if s is in table at this location*/
	if(sp->name && !strcmp(sp->name, s))
		{return 1;}
	/* is this entry empty – we can use it for the new name */
	if(!sp->name) 
        { sp->name = strdup(s); return 0;}
	/* otherwise continue to next */
  }
  yyerror("Too many symbols");
  exit(1);
} /* end of symbol table lookup */
