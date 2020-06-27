YACC_FILE=recetas.y
LEX_FILE=recetas.l
PARSER_FILES=y.tab.c lex.yy.c tree.c
OUTPUT=recetas
OUTPUT_FILES=lex.yy.c y.tab.c y.tab.h
GCC=gcc
YACC=yacc
LEX=lex


all: yacc lex parser cleaner

yacc: 
	$(YACC) -d  $(YACC_FILE)

lex: 
	$(LEX) $(LEX_FILE)

parser:
	$(GCC) -o $(OUTPUT) $(PARSER_FILES)

cleaner:
	rm -f $(OUTPUT_FILES)

clean: 
	rm -f $(OUTPUT_FILES) $(OUTPUT)

.PHONY: all clean