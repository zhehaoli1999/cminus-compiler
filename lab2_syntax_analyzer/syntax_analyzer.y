%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "common/common.h"
#include "syntax_tree/SyntaxTree.h"

#include "lab1_lexical_analyzer/lexical_analyzer.h"

// #include "../common/common.h"
// #include "../syntax_tree/SyntaxTree.h"

// #include "../lab1_lexical_analyzer/lexical_analyzer.h"

// external functions from lex
extern int yylex();
extern int yyparse();
extern int yyrestart();
extern FILE * yyin;
extern int yydebug;
yydebug = 1;

// external variables from lexical_analyzer module
extern int lines;
extern char * yytext;

// Global syntax tree.
SyntaxTree * gt; 

void yyerror(const char * s);
%}

%union {
    char name[100];
    int val;
/********** TODO: Fill in this union structure *********/
}%error-verbose

/********** TODO: Your token definition here ***********/
%token ERROR
%token	ADD 
%token	SUB 
%token	MUL 
%token	DIV 
%token	LT 
%token	LTE 
%token	GT 
%token	GTE 
%token	EQ 
%token	NEQ 
%token	ASSIN 
%token	SEMICOLON 
%token	COMMA 
%token	LPARENTHESE 
%token	RPARENTHESE 
%token	LBRACKET 
%token	RBRACKET 
%token	LBRACE 
%token	RBRACE 
%token	ELSE 
%token	IF 
%token	INT 
%token	RETURN 
%token	VOID 
%token	WHILE 
%token	IDENTIFIER 
%token	NUMBER 
%token	ARRAY 
%token	LETTER 
%token	EOL 
%token	COMMENT 
%token	BLANK
%nonassoc LOWER_THAN_ELSE
%nonassoc ELSE

%type<name> ID
%type<val> exp NUM

/* compulsory starting symbol */
%start program

%%
/*************** TODO: Your rules here *****************/
program: declaration-list
    ;
declaration-list: declaration-list declaration {}
    | declaration
    ;
declaration: var-declaration 
    | fun-declaration
    ;
var-declaration: type-specifier IDENTIFIER SEMICOLON  
    | type-specifier IDENTIFIER LPARENTHESE NUMBER RPARENTHESE  
    ;
type-specifier: INT 
    | VOID
    ;
fun-declaration: type-specifier IDENTIFIER LPARENTHESE params RPARENTHESE compound-stmt
    ;
params: param-list 
    | VOID
param-list: param-list COMMA param 
    | param
    ;
param: type-specifier IDENTIFIER 
    | type-specifier IDENTIFIER ARRAY
    ;
compound-stmt: LBRACE local-declarations statement-list RBRACE
    ;
local-declarations: /* empty */
    | local-declarations var-declaration 
    ;
statement-list: /* empty */
    | statement-list statement {printf("stamlist\n");}
    ;
statement: expression-stmt 
    | compound-stmt
    | selection-stmt

    | iteration-stmt 
    | return-stmt
    ;
expression-stmt: expression SEMICOLON
    | SEMICOLON
    ;
selection-stmt: IF LPARENTHESE expression RPARENTHESE statement %prec LOWER_THAN_ELSE
    | IF LPARENTHESE expression RPARENTHESE statement ELSE statement
    ;
iteration-stmt: WHILE LPARENTHESE expression RPARENTHESE statement
    ;
return-stmt: RETURN SEMICOLON 
    | RETURN expression SEMICOLON
    ;
expression: var ASSIN expression 
    | simple-expression
    ;
var: IDENTIFIER 
    | IDENTIFIER LBRACKET expression RBRACKET
    ;
simple-expression: additive-expression relop additive-expression 
    | additive-expression
    ;
relop: LTE { printf("%d", $1.tn->childnum)}
    | LT { printf("%d", $1.tn->childnum)}
    | GT { printf("%d", $1.tn->childnum)}
    | GTE { printf("%d", $1.tn->childnum)}
    | EQ { printf("%d", $1.tn->childnum)}
    | NEQ{ printf("%d", $1.tn->childnum)}
    ;
additive-expression: additive-expression addop term 
    | term 
    ;
addop: ADD 
    | SUB
    ;
term: term mulop factor 
    | factor
    ;
mulop: MUL 
    | DIV
    ;
factor: LPARENTHESE expression RPARENTHESE 
    | var 
    | call 
    | NUMBER
    ;
call: IDENTIFIER LPARENTHESE args RPARENTHESE
    ;
args: /* empty */
    | arg-list 
    ;
arg-list: arg-list COMMA expression 
    | expression

%%

void yyerror(const char * s)
{
	// TODO: variables in Lab1 updates only in analyze() function in lexical_analyzer.l
	//       You need to move position updates to show error output below
	fprintf(stderr, "%s:%d syntax error for %s\n", s, lines, yytext);
}

/// \brief Syntax analysis from input file to output file
///
/// \param input basename of input file
/// \param output basename of output file
void syntax(const char * input, const char * output)
{
	gt = newSyntaxTree();

	char inputpath[256] = "../testcase/";
	char outputpath[256] = "../syntree/";
	strcat(inputpath, input);
	strcat(outputpath, output);
	
	
	if (!(yyin = fopen(inputpath, "r"))) {
		fprintf(stderr, "[ERR] Open input file %s failed.", inputpath);
		exit(1);
	}
	yyrestart(yyin);
	printf("[START]: Syntax analysis start for %s\n", input);
	FILE * fp = fopen(outputpath, "w+");
	if (!fp)	return;

	// yyerror() is invoked when yyparse fail. If you still want to check the return value, it's OK.
	// `while (!feof(yyin))` is not needed here. We only analyze once.
	yyparse();

	printf("[OUTPUT] Printing tree to output file %s\n", outputpath);
	printSyntaxTree(fp, gt);
	// deleteSyntaxTree(gt);
	gt = 0;

	fclose(fp);
	printf("[END] Syntax analysis end for %s\n", input);
	
}

/// \brief starting function for testing syntax module.
///
/// Invoked in test_syntax.c
int syntax_main(int argc, char ** argv)
{	
	char filename[10][256];
	char output_file_name[256];
	// printf("syntax()\n");
	// printf("%d, %d", pos_end, pos_start);
	const char * suffix = ".syntax_tree";
	int fn = getAllTestcase(filename);
	for (int i = 0; i < fn; i++) {
        printf("analyzing\n");
        int name_len = strstr(filename[i], ".cminus") - filename[i];
        strncpy(output_file_name, filename[i], name_len);
        strcpy(output_file_name+name_len, suffix);
        syntax(filename[i], output_file_name);
	}
	return 0;
}
