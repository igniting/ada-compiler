final: y.tab.o lex.yy.o errormsg.o util.o
	cc -g y.tab.o lex.yy.o errormsg.o util.o -o final

y.tab.o: y.tab.c
	cc -g -c y.tab.c

y.tab.c: parser.y
	yacc -vd parser.y

y.tab.h: y.tab.c
	echo "y.tab.h was created at the same time as y.tab.c"

errormsg.o: errormsg.c errormsg.h util.h
	cc -g -c errormsg.c

lex.yy.o: lex.yy.c y.tab.h errormsg.h util.h
	cc -g -c lex.yy.c

lex.yy.c: lexer.l
	lex tiger.lex

util.o: util.c util.h
	cc -g -c util.c

clean: 
	rm -f final util.o lex.yy.c lex.yy.o errormsg.o y.tab.c y.tab.h y.tab.o y.output
