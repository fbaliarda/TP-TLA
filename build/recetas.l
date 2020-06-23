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
"ingredients:"          return MAIN;     
"recipe"                return INGREDIENTS_TOKEN;


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

