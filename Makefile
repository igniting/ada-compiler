all:lex
	./lex
lex:lex.yy.c
	gcc lex.yy.c -lfl -o lex
lex.yy.c:lexer.l
	lex lexer.l
clean:
	rm -f lex.yy.c lex
