a.out: lex.yy.c y.tab.cpp
	g++ lex.yy.c y.tab.cpp symbol.cpp code.cpp -w -ll -ly -std=c++11

y.tab.cpp: modula.y
	bison -d modula.y -o y.tab.cpp

lex.yy.c: modula.l
	flex modula.l

clean:
	rm y.tab.cpp lex.yy.c y.tab.hpp y.output