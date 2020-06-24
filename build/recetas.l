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
coma      [,]|[y]
endings   "despues"|"luego"|"a continuacion"
%%

"(".*")"                /* comment */;
{ws}                    /* white space */;
"Ingredientes:"         return INGREDIENTS_TOKEN;
"mientras"              return WHILE
{coma}                  return COMA
"."                     return END_LINE
"="                     return EQUAL_TO
"mezclado con"          return ADD  
"sin"                   return SUBSTRACT
"veces"                 return MULTIPLY
"dividido en"           return DIVIDE
"si"                    return IF
"&&"                    return AND
"||"                    return OR  /*revisar que no tire error x simbolos */
"!"                     return NOT
"verdadero"             return TRUE_VAL
"falso"                 return FALSE_VAL
"preparar"              return PREPARE
"con"                   return WITH
"usar"                  return USE
"para"                  return FOR
"Receta"                return RECIPE_TOKEN
"es mas grande que"     return G_THAN/*revisar si funca con espacios*/
"es mas chico que"      return L_THAN
"es igual a"            return IS_EQUAL
"entonces"              return THEN
"hacer"                 return DO//no like
{endings}               return END
"comer"                 return EAT


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

