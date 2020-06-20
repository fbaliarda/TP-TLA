%{
  void yyerror (char *s);
  int yylex();
  #include <stdio.h> 
  #include <stdlib.h>
  #include <ctype.h>
  #include <string.h>
  char buff[30];
%}

%start program

%token <str> STRING ID NUM
%token INGREDIENTS_TOKEN, RECIPE_TOKEN, END_LINE, COMMA, END
%token EQUAL_TO, USE, FOR, PREPARE, WITH, EAT, IF, THEN, WHILE, DO
%token ADD, SUBSTRACT, DIVIDE, MULTIPLY
%token AND, OR, NOT
%token IS_EQUAL, G_THAN, L_THAN, TRUE_VAL, FALSE_VAL

%%

program             :   ingredients recipe { }
                    ;

ingredients         :   INGREDIENTS_TOKEN ingredient_sentences { }
                    ;

ingredient_sentences:   ingredient { } 
                    |   ingredient ingredient_sentences { }
                    ;

ingredient          :   ID END_LINE { }
                    |   ID EQUAL_TO expression END_LINE { }
                    |   ID EQUAL_TO STRING END_LINE { }
                    |   ID EQUAL_TO bool END_LINE { }
                    ;

recipe              :   RECIPE_TOKEN recipe_sentences { }
                    ;

recipe_sentences    :   instruction { }
                    |   instruction recipe_sentences { }
                    ;

instruction         :   assignment END_LINE { }
                    |   call END_LINE { }
                    |   EAT END_LINE { }
                    |   if { }
                    |   while { }

assignment          :   USE ID FOR expression { }
                    |   USE ID FOR STRING { }
                    |   USE ID FOR bool { }
                    ;

expression          :   ID { }
                    |   NUM { }
                    |   call { }
                    |   expression ADD expression { }
                    |   expression SUBSTRACT expression { }
                    |   expression MULTIPLY expression { }
                    |   expression DIVIDE expression { }
                    ;

call                :   PREPARE ID { }
                    |   PREPARE ID WITH recipe_args { }
                    ;

recipe_args         :   arg { }
                    |   arg COMMA recipe_args { }
                    ;

arg                 :   expression { }
                    |   STRING { }
                    |   bool { }
                    ;

return              :   EAT expression { }
                    |   EAT STRING { }
                    |   EAT condition { }    
                    ;

condition           :   cond_term { }
                    |   cond_term AND condition { }
                    |   cond_term OR condition { }
                    |   NOT condition { }
                    ;

cond_term           :   bool { }
                    |   expression cmp expression { }
                    |   call { }
                    |   ID { }
                    ;

cmp                 :   IS_EQUAL { }
                    |   G_THAN { }
                    |   L_THAN { }
                    ;

if                  :   IF condition THEN recipe_sentences END { }
                    ;

while               :   WHILE condition DO recipe_sentences END { }


bool                :   TRUE_VAL { }
                    |   FALSE_VAL { }
                    ;

%%

int main() {
  yyparse();
  EAT 0;
}

void yyerror(char * s) {
  fprintf(stderr, "%s\n", s);
  EAT;
}
