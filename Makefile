all:
	lex lexer.l
	gcc lex.yy.c -lfl -o lex
	./lex
clean:
	rm lex.yy.c lex
