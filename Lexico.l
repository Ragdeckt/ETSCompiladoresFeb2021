%option noyywrap
 
%{
	#include <stdio.h>
	#include <stdlib.h>
	#include <string.h>
	#include "symtab.h"
	#include "semantico.tab.h"
	extern FILE *yyin;
	extern FILE *yyout;
 
	int lineNumber = 1;
	void yyerror();
%}
 
%x ML_COMMENT
 
letters 	[a-zA-Z]
digit 		[0-9]
letternum 	{letters}{digit}
print		[ -~]
 
ID 			{letters}+{letternum}*
ICONST		"0"|[0-9]{digit}*
CCONST		(\'{print}\')|(\'\\[nftrbv]\')
 
%%
 
<ML_COMMENT>"*/" 		{ printf("to line %d\n", lineNumber); BEGIN(INITIAL); }
<ML_COMMENT>[^*\n]+		
<ML_COMMENT>"*"			
<ML_COMMENT>"\n"		{ lineNumber += 1; }
 
"main"|"MAIN"           { return MAIN; }
"char"|"CHAR"       	{ return CHAR; }
"int"|"INT"				{ return INT; }
"if"|"IF"				{ return IF; }
"else"|"ELSE"			{ return ELSE; }
"while"|"WHILE"			{ return WHILE; }
"for"|"FOR"				{ return FOR; }
"continue"|"CONTINUE"	{ return CONTINUE; }
"break"|"BREAK"			{ return BREAK; }
"void"|"VOID"			{ return VOID; }
"return"|"RETURN"		{ return RETURN; }
"concat"|"CONCAT"		{ return CONCAT; }
 
 
"+"|"-"					{ return ADDOP; }
"*"						{ return MULOP; }
"/"						{ return DIVOP; }
"++"|"--"				{ return INCR; }
"||"					{ return OROP; }
"&&"					{ return ANDOP; }
"!"						{ return NOTOP; }
"=="|"!="				{ return EQUOP; }
">"|"<"|">="|"<="		{ return RELOP; }
 
 
"("				{ return LPAREN; }
")"				{ return RPAREN; }
"]"				{ return LBRACK; }
"["				{ return RBRACK; }
"{"				{ return LBRACE; }
"}"				{ return RBRACE; }
";"				{ return SEMI; }
"."				{ return DOT; }
","				{ return COMMA; }
"="				{ return ASSIGN; }
"&"				{ return REFER; }
 
{ID} 			{
					insert(yytext, strlen(yytext), strlen(yytext -1), lineNumber);
			        //printf("token %s \n", yytext);
					return ID;
				}
{ICONST} 		{ yylval.entero=atoi(yytext); return ICONST; }
{CCONST} 		{ return CCONST; }

 
"\n"			{ lineNumber += 1; }
[ \t\r\f]+		
 
.				{ yyerror("Caracter invalido"); }
 
%%
