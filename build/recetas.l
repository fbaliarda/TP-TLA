%{
  #include <stdio.h>
  #include "./y.tab.h"
  void yyerror (char *s);
  int yylex();
%}

word      [a-zA-Z][_a-zA-Z0-9]*
number    [0-9][0-9]*
space     [ \t\n]
ws        {space}+

%%

"(".*")"                /* comment */;
{ws}                    /* white space */;
"ingredientes:"         return MAIN;     
"receta"                return INGREDIENTS_TOKEN;
"mientras"              return WHILE
","                     return COMA
"."                     return END_LINE
"son iguales"
\"[^\"]*\"              {char *str = malloc(strlen(yytext)+1);
                        strcpy(str, yytext);
                        yylval.str = str;
                        return STRING;
                        }  

{number}                {char *str = malloc(strlen(yytext)+1);
                        strcpy(str, yytext);
                        yylval.str = str;
                        return NUM;
                        }

{word}                  {char *str = malloc(strlen(yytext)+1);
                        strcpy(str, yytext);
                        yylval.str = str;
                        return ID;
                        }

.                       {yyerror("Unexpected character");}

%%

int yywrap(void) 
{
  return 1;
}

