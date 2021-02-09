%{
	#include "symtab.c"
	#include <stdio.h>
	#include <stdlib.h>
	#include <string.h>
	extern FILE *yyin;
	extern FILE *yyout;
	extern int lineNumber;
	extern int yylex();
	void yyerror();
	void showtext(int valor);
	int value = 0;
%}

%union 
{
    int entero;
}
 
/* todos los tokens que puede mandar el .l */
%token CHAR INT IF ELSE WHILE FOR CONTINUE BREAK VOID MAIN RETURN CONCAT
%token ADDOP MULOP DIVOP INCR OROP ANDOP NOTOP EQUOP RELOP
%token LPAREN RPAREN LBRACK RBRACK LBRACE RBRACE SEMI DOT COMMA ASSIGN REFER
%token ID ICONST FCONST CCONST STRING

%type <entero> valor

%start init
/* reglas */
 
%%

init: init main init | function { printf("Metodo inicial\n"); };
function: function_type variable LPAREN function_rules RPAREN structure;
function_rules: fun_declaration | /* empty */ ;
function_type: VOID | type ;
main: VOID MAIN LPAREN RPAREN LBRACE program RETURN SEMI RBRACE ;
program: declarations calls;
declarations: declarations declaration | declaration;
declaration: type names asignacion;
fun_declaration: type fun_var_names;
fun_var_names: fun_var_names variable | variable COMMA type variable;
asignacion: SEMI | ASSIGN expression SEMI | ASSIGN function_call SEMI;
type: INT | CHAR ;
names: variable | names COMMA variable;
variable: ID ;
function_call: reference variable LPAREN function_content RPAREN;
function_content: function_content COMMA function_content | constant | variable | /* empty */ ;
calls: calls call | call;
call: if_call | for_call | while_call | function_call SEMI| assigment | decrement | declaration | CONTINUE SEMI | BREAK SEMI;
if_call: IF LPAREN expression RPAREN structure else_part;
else_part: ELSE structure | else_if_part | /* empty */ ; 
else_if_part: ELSE IF LPAREN expression RPAREN structure; 
for_call: FOR LPAREN expression SEMI expression SEMI expression RPAREN structure;
while_call: WHILE LPAREN expression RPAREN structure;
structure: LBRACE calls RBRACE ;
expression:
    expression ADDOP expression |
    expression MULOP expression |
    expression DIVOP expression |
    expression INCR |
    INCR expression |
    expression OROP expression |
    expression ANDOP expression |
    NOTOP expression |
    expression EQUOP expression |
    expression RELOP expression |
    LPAREN expression RPAREN |
    variable |
    sign constant |
    expression ASSIGN expression |
    function_call
;
 
sign: ADDOP | /* empty */ ; 
constant: valor | FCONST | CCONST; 
valor: ICONST{ showtext($$); };
decrement: reference variable INCR SEMI; 
assigment: reference variable ASSIGN expression SEMI;
reference: REFER | /* empty */ ;
 
%%
 
void yyerror ()
{
  fprintf(stderr, "Syntax error at line %d\n", lineNumber);
  exit(1);
}
 
int main (int argc, char *argv[]){
	init_hash_table();
 
	int flag;
	yyin = fopen(argv[1], "r");
	flag = yyparse();
	fclose(yyin);
 
	// Escribir en la tabla de simbolos
	yyout = fopen("tabla_simbolos.out", "w");
	symtab_dump(yyout);
	fclose(yyout);	
 
	return flag;
}

void showtext(int valor) {
    printf("Valor de la variable %d\n", valor);
}
