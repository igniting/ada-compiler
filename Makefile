all:lex
	./lex
lex:lex.yy.c y.tab.c y.tab.h
	gcc lex.yy.c y.tab.c y.tab.h -lfl -o lex
lex.yy.c:lexer.l
	lex lexer.l
y.tab.c y.tab.h:parser.y
	yacc -vd parser.y
clean:
	rm -f lex.yy.c lex y.tab.c y.tab.h y.output
