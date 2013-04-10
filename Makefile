final: y.tab.o lex.yy.o errormsg.o util.o absyn.o symbol.o table.o prabsyn.o type.o
	cc -g y.tab.o lex.yy.o errormsg.o util.o absyn.o symbol.o table.o prabsyn.o type.o -o final

y.tab.o: y.tab.c
	cc -g -c y.tab.c

y.tab.c: parser.y
	yacc --debug -vd parser.y

y.tab.h: y.tab.c
	echo "y.tab.h was created at the same time as y.tab.c"

errormsg.o: errormsg.c errormsg.h util.h
	cc -g -c errormsg.c

lex.yy.o: lex.yy.c y.tab.h errormsg.h util.h
	cc -g -c lex.yy.c

lex.yy.c: lexer.l
	lex lexer.l

util.o: util.c util.h
	cc -g -c util.c

absyn.o: absyn.c absyn.h
	cc -g -c absyn.c

prabsyn.o: prabsyn.c prabsyn.h
	cc -g -c prabsyn.c
	
symbol.o: symbol.c symbol.h
	cc -g -c symbol.c

table.o: table.c table.h
	cc -g -c table.c

type.o: type.c type.h
	cc -g -c type.c
			
clean: 
	rm -f final *.o lex.yy.c y.tab.c y.tab.h y.output
