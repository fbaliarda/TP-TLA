%{
  void yyerror (char *s);
  int yylex();
  #include <stdio.h> 
  #include <stdlib.h>
  #include <ctype.h>
  #include <string.h>
  #include "tree.h"
  char buff[30];
%}

%start program

%union {
	char * str;
	struct Node * node;
}

%token <str> STRING ID NUM
%token INGREDIENTS_TOKEN RECIPE_TOKEN END_LINE COMMA END
%token EQUAL_TO USE FOR PREPARE WITH EAT IF THEN WHILE DO COMA
%token ADD SUBSTRACT DIVIDE MULTIPLY
%token AND OR NOT
%token IS_EQUAL G_THAN L_THAN TRUE_VAL FALSE_VAL
%token T_INTEGER T_STRING T_BOOLEAN

%type <node> program ingredients ingredient_sentences
%type <node> ingredient recipe recipe_sentences instruction
%type <node> assignment expression call recipe_args arg
%type <node> return condition cond_term cmp if while bool
%type <node> type string

%%

program             :   ingredients recipe                      {   $$ = nodeNew("program");
																 	nodeAppend($$, nodeNewLeaf(NULL, _main));
																	nodeAppend($$, nodeNewLeaf(NULL, _opar));
																	nodeAppend($$, nodeNewLeaf(NULL, _cpar));
																 	nodeAppend($$, nodeNewLeaf(NULL, _obracket));
																	nodeAppend($$, $1);
																	nodeAppend($$, $2);
																	nodeAppend($$, nodeNewLeaf(NULL, _cbracket));
																	printTree($$);
															    }
                    ;

ingredients         :   INGREDIENTS_TOKEN ingredient_sentences  {   $$ = nodeNew("ingredients");
															    	nodeAppend($$, $2);
															    }
                    ;

ingredient_sentences:   ingredient 							    {   $$ = nodeNew("ingredient_sentences");
															    	nodeAppend($$, $1);
															    }
                    |   ingredient ingredient_sentences         {   $$ = nodeNew("ingredient_sentences");
															    	nodeAppend($$, $1);
															    	nodeAppend($$, $2);
															    }
                    ;

ingredient          :   type ID END_LINE 					    {   $$ = nodeNew("ingredient");
															    	nodeAppend($$, $1);
															    	nodeAppend($$, nodeNewLeaf($2, _variable));
															    	nodeAppend($$, nodeNewLeaf(NULL, _endline));
															    }
                    |   type ID EQUAL_TO expression END_LINE    {   $$ = nodeNew("ingredient");
															    	nodeAppend($$, $1);
															    	nodeAppend($$, nodeNewLeaf($2, _variable));
															    	nodeAppend($$, nodeNewLeaf(NULL, _equal));
															    	nodeAppend($$, $4);
															    	nodeAppend($$, nodeNewLeaf(NULL, _endline));															     
															    }
                    |   type ID EQUAL_TO string END_LINE        {   $$ = nodeNew("ingredient");
															    	nodeAppend($$, $1);
															    	nodeAppend($$, nodeNewLeaf($2, _variable));
															    	nodeAppend($$, nodeNewLeaf(NULL, _equal));
															    	nodeAppend($$, $4);
															    	nodeAppend($$, nodeNewLeaf(NULL, _endline));															     
															    }
                    |   type ID EQUAL_TO bool END_LINE          {   $$ = nodeNew("ingredient");
															    	nodeAppend($$, $1);
															    	nodeAppend($$, nodeNewLeaf($2, _variable));
															    	nodeAppend($$, nodeNewLeaf(NULL, _equal));
															    	nodeAppend($$, $4);
															    	nodeAppend($$, nodeNewLeaf(NULL, _endline));															     
															    }
                    ;

recipe              :   RECIPE_TOKEN recipe_sentences           {   $$ = nodeNew("recipe");
															    	nodeAppend($$, $2);															     
															    }
                    ;

recipe_sentences    :   instruction 						    {   $$ = nodeNew("recipe_sentences");
															    	nodeAppend($$, $1);															     
															    }
                    |   instruction recipe_sentences            {   $$ = nodeNew("recipe_sentences");
															    	nodeAppend($$, $1);	
															    	nodeAppend($$, $2);															     
															    }
                    ;

instruction         :   assignment END_LINE                     {   $$ = nodeNew("instruction");
															    	nodeAppend($$, $1);	
															    	nodeAppend($$, nodeNewLeaf(NULL, _endline));																	     
															    }
                    |   call END_LINE                           {   $$ = nodeNew("instruction");
															    	nodeAppend($$, $1);	
															    	nodeAppend($$, nodeNewLeaf(NULL, _endline));															     
															    }
                    |   return END_LINE                         {   $$ = nodeNew("instruction");
															    	nodeAppend($$, $1);	
															    	nodeAppend($$, nodeNewLeaf(NULL, _endline));															     
															    }
                    |   if                                      {   $$ = nodeNew("instruction");
															    	nodeAppend($$, $1);															     
															    }
                    |   while                                   {   $$ = nodeNew("instruction");
															    	nodeAppend($$, $1);															     
															    }

assignment          :   USE ID FOR expression                   {   $$ = nodeNew("assignment");
															    	nodeAppend($$, nodeNewLeaf($2, _variable));
															    	nodeAppend($$, nodeNewLeaf(NULL, _equal));
															    	nodeAppend($$, $4);
															    	nodeAppend($$, nodeNewLeaf(NULL, _endline));			
															    }
                    |   USE ID FOR string                       {   $$ = nodeNew("assignment");
															    	nodeAppend($$, nodeNewLeaf($2, _variable));
															    	nodeAppend($$, nodeNewLeaf(NULL, _equal));
															    	nodeAppend($$, $4);
															    	nodeAppend($$, nodeNewLeaf(NULL, _endline));			
															    }
                    |   USE ID FOR bool                         {   $$ = nodeNew("assignment");
															    	nodeAppend($$, nodeNewLeaf($2, _variable));
															    	nodeAppend($$, nodeNewLeaf(NULL, _equal));
															    	nodeAppend($$, $4);
															    	nodeAppend($$, nodeNewLeaf(NULL, _endline));			
															    }
                    ;

expression          :   ID 									    {   $$ = nodeNew("expression");
																	nodeAppend($$, nodeNewLeaf($1, _variable));															
															    }
                    |   NUM                                     {   $$ = nodeNew("expression");
																	nodeAppend($$, nodeNewLeaf($1, _literal));															
															    }
                    |   call 								    {   $$ = nodeNew("expression");
																	nodeAppend($$, $1);															
															    }
                    |   expression ADD expression 			    {   $$ = nodeNew("expression");
																	nodeAppend($$, $1);	
																	nodeAppend($$, nodeNewLeaf(NULL, _plus));
																	nodeAppend($$, $3);															
															    }
                    |   expression SUBSTRACT expression         {   $$ = nodeNew("expression");
																	nodeAppend($$, $1);	
																	nodeAppend($$, nodeNewLeaf(NULL, _minus));
																	nodeAppend($$, $3);															
															    }
                    |   expression MULTIPLY expression          {   $$ = nodeNew("expression");
																	nodeAppend($$, $1);	
																	nodeAppend($$, nodeNewLeaf(NULL, _multiplication));
																	nodeAppend($$, $3);															
															    }
                    |   expression DIVIDE expression            {   $$ = nodeNew("expression");
																	nodeAppend($$, $1);	
																	nodeAppend($$, nodeNewLeaf(NULL, _division));
																	nodeAppend($$, $3);															
															    }
                    ;

call                :   PREPARE ID { } /* TODO */
                    |   PREPARE ID WITH recipe_args { }
                    ;

recipe_args         :   arg { }
                    |   arg COMMA recipe_args { }
                    ;

arg                 :   expression { }
                    |   string { }
                    |   bool { }
                    ;

return              :   EAT expression 						    {   $$ = nodeNew("return");
															    	nodeAppend($$, nodeNewLeaf(NULL, _return));
																	nodeAppend($$, $2);
															    	nodeAppend($$, nodeNewLeaf(NULL, _endline));														
															    }
                    |   EAT string                              {   $$ = nodeNew("return");
															    	nodeAppend($$, nodeNewLeaf(NULL, _return));
																	nodeAppend($$, $2);
															    	nodeAppend($$, nodeNewLeaf(NULL, _endline));															
															    }
                    |   EAT condition                           {   $$ = nodeNew("return");
															    	nodeAppend($$, nodeNewLeaf(NULL, _return));
																	nodeAppend($$, $2);
															    	nodeAppend($$, nodeNewLeaf(NULL, _endline));															
															    } 
                    ;

condition           :   cond_term 							    {   $$ = nodeNew("condition");
																	/*nodeAppend($$, $1);*/
															    }
                    |   cond_term AND condition                 {   $$ = nodeNew("condition");
																	nodeAppend($$, $1);
																	nodeAppend($$, nodeNewLeaf(NULL, _and));
																	nodeAppend($$, $3);
															    }
                    |   cond_term OR condition                  {   $$ = nodeNew("condition");
																	nodeAppend($$, $1);
																	nodeAppend($$, nodeNewLeaf(NULL, _or));
																	nodeAppend($$, $3);
															    }
                    |   NOT condition 						    {   $$ = nodeNew("condition");
                    												nodeAppend($$, nodeNewLeaf(NULL, _not));
																	/*nodeAppend($$, $1);*/
															    }
                    ;

cond_term           :   bool 								    {   $$ = nodeNew("cond_term");
														        	nodeAppend($$, $1);
															    }					
                    |   expression cmp expression               {   $$ = nodeNew("cond_term");
														        	nodeAppend($$, $1);
														        	nodeAppend($$, $2);
														        	nodeAppend($$, $3);
															    }		
                    |   call                                    {   $$ = nodeNew("cond_term");
														        	nodeAppend($$, $1);
															    }		
                    |   ID                                      {   $$ = nodeNew("cond_term");
														        	nodeAppend($$, nodeNewLeaf($1, _variable));
															    }		
                    ;

cmp                 :   IS_EQUAL 							    {   $$ = nodeNew("cmp");
																	nodeAppend($$, nodeNewLeaf(NULL, _is_equal));
															    }
                    |   G_THAN 								    {   $$ = nodeNew("cmp");
																	nodeAppend($$, nodeNewLeaf(NULL, _is_greater));
															    }
                    |   L_THAN 								    {   $$ = nodeNew("cmp");
																	nodeAppend($$, nodeNewLeaf(NULL, _is_lower));
															    }
                    ;

if                  :   IF condition THEN recipe_sentences END  {   $$ = nodeNew("if");
																	nodeAppend($$, nodeNewLeaf(NULL, _if));
																	nodeAppend($$, nodeNewLeaf(NULL, _opar));
																	nodeAppend($$, $2);
																	nodeAppend($$, nodeNewLeaf(NULL, _cpar));
																	nodeAppend($$, nodeNewLeaf(NULL, _obracket));
																	nodeAppend($$, $4);
																	nodeAppend($$, nodeNewLeaf(NULL, _cbracket));
																}
                    ;

while               :   WHILE condition DO recipe_sentences END {   $$ = nodeNew("while");
																	nodeAppend($$, nodeNewLeaf(NULL, _while));
																	nodeAppend($$, nodeNewLeaf(NULL, _opar));
																	nodeAppend($$, $2);
																	nodeAppend($$, nodeNewLeaf(NULL, _cpar));
																	nodeAppend($$, nodeNewLeaf(NULL, _obracket));
																	nodeAppend($$, $4);
																	nodeAppend($$, nodeNewLeaf(NULL, _cbracket));
																}


bool                :   TRUE_VAL 								{   $$ = nodeNew("bool");
																	nodeAppend($$, nodeNewLeaf(NULL, _one));
																}
                    |   FALSE_VAL 								{   $$ = nodeNew("bool");
																	nodeAppend($$, nodeNewLeaf(NULL, _zero));
																}
                    ;

type                :   T_INTEGER 								{   $$ = nodeNew("type");
																	nodeAppend($$, nodeNewLeaf(NULL, _integer));
																}
                    |   T_STRING                                {   $$ = nodeNew("type");
																	nodeAppend($$, nodeNewLeaf(NULL, _string));
																}
                    |   T_BOOLEAN                               {   $$ = nodeNew("type");
																	nodeAppend($$, nodeNewLeaf(NULL, _boolean));
																}
                    ;          

string              :   STRING 									{   $$ = nodeNew("string");
																	nodeAppend($$, nodeNewLeaf($1, _literal));
																}
%%

int main() {
  yyparse();
  return 0;
}

void yyerror(char * s) {
  fprintf(stderr, "%s\n", s);
  return;
}
