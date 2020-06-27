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
coma      [,]
endings   "despues"|"luego"|"a continuacion"|"fin"
%%

"(".*")"                
"Ingredientes:"         return INGREDIENTS_TOKEN;
"nuevo entero"          return TO_INT;
"entero"                return T_INTEGER;
"cadena"                return T_STRING;
"booleano"              return T_BOOLEAN;
"mientras"              return WHILE;
{coma}                  return COMMA;
"."                     return END_LINE;
"="                     return EQUAL_TO;
"mezclado con"          return ADD;
"sin"                   return SUBSTRACT;
"veces"                 return MULTIPLY;
"dividido en"           return DIVIDE;
"si"                    return IF;
"y"                     return AND;
"o"                     return OR;
"no se cumple que"      return NOT;
"verdadero"             return TRUE_VAL;
"falso"                 return FALSE_VAL;
"preparar"              return PREPARE;
"con"                   return WITH;
"usar"                  return USE;
"para"                  return FOR;
"Receta:"               return RECIPE_TOKEN;
"es mas grande que"     return G_THAN;
"es mas chico que"      return L_THAN;
"es igual a"            return IS_EQUAL;
"entonces:"             return THEN;
"hacer:"                return DO;
"comer"                 return EAT;
"lectura"               return READ;
"escritura"             return WRITE;
{endings}               return END;

{ws}                    /* white space */;


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

