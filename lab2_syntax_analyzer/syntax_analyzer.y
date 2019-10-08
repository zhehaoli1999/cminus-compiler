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
    SyntaxTreeNode * tn;
    char name[100];
    int val;
/********** TODO: Fill in this union structure *********/
}%error-verbose

%locations

/********** TODO: Your token definition here ***********/
%token<tn> ERROR
%token<tn>	ADD 
%token<tn>	SUB 
%token<tn>	MUL 
%token<tn>	DIV 
%token<tn>	LT 
%token<tn>	LTE 
%token<tn>	GT 
%token<tn>	GTE 
%token<tn>	EQ 
%token<tn>	NEQ 
%token<tn>	ASSIN 
%token<tn>	SEMICOLON 
%token<tn>	COMMA 
%token<tn>	LPARENTHESE 
%token<tn>	RPARENTHESE 
%token<tn>	LBRACKET 
%token<tn>	RBRACKET 
%token<tn>	LBRACE 
%token<tn>	RBRACE 
%token<tn>	ELSE 
%token<tn>	IF 
%token<tn>	INT 
%token<tn>	RETURN 
%token<tn>	VOID 
%token<tn>	WHILE 
%token<name>	IDENTIFIER
%token<tn>	NUMBER 
%token<tn>	ARRAY 
%token<tn>	LETTER 
%token<tn>	EOL 
%token<tn>	COMMENT 
%token<tn>	BLANK
%nonassoc LOWER_THAN_ELSE
%nonassoc ELSE

%type<tn> program
%type<tn> declaration-list
%type<tn> declaration
%type<tn> var-declaration
%type<tn> type-specifier
%type<tn> fun-declaration
%type<tn> params
%type<tn> param-list
%type<tn> param
%type<tn> compound-stmt
%type<tn> local-declarations
%type<tn> statement-list
%type<tn> statement
%type<tn> expression-stmt
%type<tn> selection-stmt
%type<tn> iteration-stmt
%type<tn> return-stmt
%type<tn> expression
%type<tn> var
%type<tn> simple-expression
%type<tn> relop
%type<tn> additive-expression
%type<tn> addop
%type<tn> term
%type<tn> mulop
%type<tn> factor
%type<tn> call
%type<tn> args
%type<tn> arg-list
%type<tn> ID




/* compulsory starting symbol */
%start program

%%
/*************** TODO: Your rules here *****************/

program: declaration-list{
    $$ = newSyntaxTreeNode("program");
    SyntaxTreeNode_AddChild($$, $1);
    gt->root = $$;
    }
    ;
declaration-list: declaration-list declaration {
        $$ = newSyntaxTreeNode("declaration-list");
        SyntaxTreeNode_AddChild($$, $1);
        SyntaxTreeNode_AddChild($$, $2);
    }
    | declaration {
        $$ = newSyntaxTreeNode("declaration-list"); 
        SyntaxTreeNode_AddChild($$, $1);
        }
    ;
declaration: var-declaration {
        $$ = newSyntaxTreeNode("declaration");
        SyntaxTreeNode_AddChild($$, $1);
    }
    | fun-declaration {
        $$ = newSyntaxTreeNode("declaration"); 
        SyntaxTreeNode_AddChild($$, $1);
    }
    ;
var-declaration: type-specifier ID SEMICOLON  {
        $$ = newSyntaxTreeNode("var-declaration"); 
        $3 = newSyntaxTreeNode(";");
        SyntaxTreeNode_AddChild($$, $1);
        SyntaxTreeNode_AddChild($$, $2);
        SyntaxTreeNode_AddChild($$, $3);
    }
    | type-specifier ID LBRACKET NUMBER RBRACKET   {
        $$ = newSyntaxTreeNode("var-declaration"); 
        $3 = newSyntaxTreeNode("(");
        $4 = newSyntaxTreeNode(yytext);
        $5 = newSyntaxTreeNode(")");
        SyntaxTreeNode_AddChild($$, $1);
        SyntaxTreeNode_AddChild($$, $2);
        SyntaxTreeNode_AddChild($$, $3);
        SyntaxTreeNode_AddChild($$, $4);
        SyntaxTreeNode_AddChild($$, $5);
    }
    ;
type-specifier: INT {
        $$ = newSyntaxTreeNode("type-specifier"); 
        $1 = newSyntaxTreeNode("int");
        SyntaxTreeNode_AddChild($$, $1);
    }
    | VOID {
        $$ = newSyntaxTreeNode("type-specifier"); 
        $1 = newSyntaxTreeNode("void");
        SyntaxTreeNode_AddChild($$, $1);
    }
    ;
fun-declaration: type-specifier ID LPARENTHESE params RPARENTHESE compound-stmt{
        $$ = newSyntaxTreeNode("fun-declaration"); 
        $3 = newSyntaxTreeNode("(");
        $5= newSyntaxTreeNode(")");
        SyntaxTreeNode_AddChild($$, $1);
        SyntaxTreeNode_AddChild($$, $2);
        SyntaxTreeNode_AddChild($$, $3);
        SyntaxTreeNode_AddChild($$, $4);
        SyntaxTreeNode_AddChild($$, $5);
        SyntaxTreeNode_AddChild($$, $6);
    }
    ; 
params: param-list {
        $$ = newSyntaxTreeNode("params"); 
        SyntaxTreeNode_AddChild($$, $1);
    }
    | VOID {
        $$ = newSyntaxTreeNode("params"); 
        $1 = newSyntaxTreeNode("void");
        SyntaxTreeNode_AddChild($$, $1);
    }
param-list: param-list COMMA param {
        $$ = newSyntaxTreeNode("param-list"); 
        $2 = newSyntaxTreeNode(",");
        SyntaxTreeNode_AddChild($$, $1);
        SyntaxTreeNode_AddChild($$, $2);
        SyntaxTreeNode_AddChild($$, $3);
    }
    | param {
        $$ = newSyntaxTreeNode("param-list"); 
        SyntaxTreeNode_AddChild($$, $1);
        }
    ;
param: type-specifier ID {
        $$ = newSyntaxTreeNode("param"); 
        // $2 = newSyntaxTreeNode(yytext);
        SyntaxTreeNode_AddChild($$, $1);
        SyntaxTreeNode_AddChild($$, $2);
    }
    | type-specifier ID ARRAY {
        $$ = newSyntaxTreeNode("param"); 
        // $2 = newSyntaxTreeNode(yytext);
        $3 = newSyntaxTreeNode("[]");
        SyntaxTreeNode_AddChild($$, $1);
        SyntaxTreeNode_AddChild($$, $2);
        SyntaxTreeNode_AddChild($$, $3);
        }
    ;
compound-stmt: LBRACE local-declarations statement-list RBRACE{
        $$ = newSyntaxTreeNode("compound-stmt"); 
        $1 = newSyntaxTreeNode("{"); 
        $4 = newSyntaxTreeNode("}"); 
        SyntaxTreeNode_AddChild($$, $1);
        SyntaxTreeNode_AddChild($$, $2);
        SyntaxTreeNode_AddChild($$, $3);
        SyntaxTreeNode_AddChild($$, $4);
    }
    ;
local-declarations: /* empty */{
        $$ = newSyntaxTreeNode("local-declarations"); 
        // $1 = newSyntaxTreeNode("epsilon");
        SyntaxTreeNode_AddChild($$, newSyntaxTreeNode("epsilon"));
    }
    | local-declarations var-declaration  {
        $$ = newSyntaxTreeNode("local-declarations"); 
        SyntaxTreeNode_AddChild($$, $1);
        SyntaxTreeNode_AddChild($$, $2);
        }
    ;
statement-list: /* empty */{
    $$ = newSyntaxTreeNode("statement-list"); 
    // $1 = newSyntaxTreeNode("epsilon");
    SyntaxTreeNode_AddChild($$, newSyntaxTreeNode("epsilon"));
    }
    | statement-list statement {
        $$ = newSyntaxTreeNode("statement-list"); 
        SyntaxTreeNode_AddChild($$, $1);
        SyntaxTreeNode_AddChild($$, $2);
        }
    ;
statement: expression-stmt {
        $$ = newSyntaxTreeNode("statement"); 
        SyntaxTreeNode_AddChild($$, $1);
    }
    | compound-stmt {
        $$ = newSyntaxTreeNode("statement"); 
        SyntaxTreeNode_AddChild($$, $1);
    }
    | selection-stmt {
        $$ = newSyntaxTreeNode("statement");
        SyntaxTreeNode_AddChild($$, $1);
    }
    | iteration-stmt  {
        $$ = newSyntaxTreeNode("statement");
        SyntaxTreeNode_AddChild($$, $1);
    }
    | return-stmt {
        $$ = newSyntaxTreeNode("statement");
        SyntaxTreeNode_AddChild($$, $1);
    }
    ;
expression-stmt: expression SEMICOLON{
        $$ = newSyntaxTreeNode("expression-stmt"); 
        $2 = newSyntaxTreeNode(";");
        SyntaxTreeNode_AddChild($$, $1);
        SyntaxTreeNode_AddChild($$, $2);
    }
    | SEMICOLON {
        $$ = newSyntaxTreeNode("expression-stmt"); 
        $1 = newSyntaxTreeNode(";");
        SyntaxTreeNode_AddChild($$, $1);
    }
    ;
selection-stmt: IF LPARENTHESE expression RPARENTHESE statement %prec LOWER_THAN_ELSE{
        $$ = newSyntaxTreeNode("selection-stmt"); 
        $1 = newSyntaxTreeNode("if");
        $2 = newSyntaxTreeNode("(");
        $4 = newSyntaxTreeNode(")");
        SyntaxTreeNode_AddChild($$, $1);
        SyntaxTreeNode_AddChild($$, $2);
        SyntaxTreeNode_AddChild($$, $3);
        SyntaxTreeNode_AddChild($$, $4);
        SyntaxTreeNode_AddChild($$, $5);
    }
    | IF LPARENTHESE expression RPARENTHESE statement ELSE statement {
        $$ = newSyntaxTreeNode("selection-stmt"); 
        $1 = newSyntaxTreeNode("if");
        $2 = newSyntaxTreeNode("(");
        $4 = newSyntaxTreeNode(")");
        $6 = newSyntaxTreeNode("else");
        SyntaxTreeNode_AddChild($$, $1);
        SyntaxTreeNode_AddChild($$, $2);
        SyntaxTreeNode_AddChild($$, $3);
        SyntaxTreeNode_AddChild($$, $4);
        SyntaxTreeNode_AddChild($$, $5);
        SyntaxTreeNode_AddChild($$, $6);
        SyntaxTreeNode_AddChild($$, $7);
    }
    ;
iteration-stmt: WHILE LPARENTHESE expression RPARENTHESE statement{
        $$ = newSyntaxTreeNode("iteration-stmt"); 
        $1 = newSyntaxTreeNode("while");
        $2 = newSyntaxTreeNode("(");
        $4 = newSyntaxTreeNode(")");
        SyntaxTreeNode_AddChild($$, $1);
        SyntaxTreeNode_AddChild($$, $2);
        SyntaxTreeNode_AddChild($$, $3);
        SyntaxTreeNode_AddChild($$, $4);
        SyntaxTreeNode_AddChild($$, $5);
    }
    ;
return-stmt: RETURN SEMICOLON {
    $$ = newSyntaxTreeNode("return-stmt"); 
    $1 = newSyntaxTreeNode("return");
    $2 = newSyntaxTreeNode(";");
    SyntaxTreeNode_AddChild($$, $1);
    SyntaxTreeNode_AddChild($$, $2);
    }
    | RETURN expression SEMICOLON {
        $$ = newSyntaxTreeNode("return-stmt"); 
        $1 = newSyntaxTreeNode("return");
        $3 = newSyntaxTreeNode(";");
        SyntaxTreeNode_AddChild($$, $1);
        SyntaxTreeNode_AddChild($$, $2);
        SyntaxTreeNode_AddChild($$, $3);
        }
    ;
expression: var ASSIN expression {
        $$ = newSyntaxTreeNode("expression"); 
        $2 = newSyntaxTreeNode("=");
        SyntaxTreeNode_AddChild($$, $1);
        SyntaxTreeNode_AddChild($$, $2);
        SyntaxTreeNode_AddChild($$, $3);
    }
    | simple-expression {
        $$ = newSyntaxTreeNode("expression"); 
        SyntaxTreeNode_AddChild($$, $1);
    }
    ;
var: ID {
        $$ = newSyntaxTreeNode("var"); 
        SyntaxTreeNode_AddChild($$, $1);
    }
    | ID LBRACKET expression RBRACKET {
        $$ = newSyntaxTreeNode("var"); 
        // $1 = newSyntaxTreeNode(yytext);
        $2 = newSyntaxTreeNode("(");
        $4 = newSyntaxTreeNode(")");
        SyntaxTreeNode_AddChild($$, $1);
        SyntaxTreeNode_AddChild($$, $2);
        SyntaxTreeNode_AddChild($$, $3);
        SyntaxTreeNode_AddChild($$, $4);
    }
    ;
simple-expression: additive-expression relop additive-expression {
    $$ = newSyntaxTreeNode("simple-expression"); 
    SyntaxTreeNode_AddChild($$, $1);
    SyntaxTreeNode_AddChild($$, $2);
    SyntaxTreeNode_AddChild($$, $3);
    }
    | additive-expression {
        $$ = newSyntaxTreeNode("simple-expression"); 
        SyntaxTreeNode_AddChild($$, $1);
        }
    ;
relop: LTE {
       $1 = newSyntaxTreeNode("<=");
       $$ = newSyntaxTreeNode("relop"); 
       SyntaxTreeNode_AddChild($$, $1);
    }
    | LT  {
        $1 = newSyntaxTreeNode("<");
        $$ = newSyntaxTreeNode("relop"); 
        SyntaxTreeNode_AddChild($$, $1);
    }
    | GT {
        $1 = newSyntaxTreeNode(">");
        $$ = newSyntaxTreeNode("relop"); 
        SyntaxTreeNode_AddChild($$, $1);
    }
    | GTE {
        $1 = newSyntaxTreeNode(">=");
        $$ = newSyntaxTreeNode("relop"); 
        SyntaxTreeNode_AddChild($$, $1);
    }
    | EQ {
        $1 = newSyntaxTreeNode("==");
        $$ = newSyntaxTreeNode("relop"); 
        SyntaxTreeNode_AddChild($$, $1);
    }
    | NEQ{
        $1 = newSyntaxTreeNode("!=");
        $$ = newSyntaxTreeNode("relop"); 
        SyntaxTreeNode_AddChild($$, $1);
    }
    ;
additive-expression: additive-expression addop term {
        $$ = newSyntaxTreeNode("additive-expression"); 
        SyntaxTreeNode_AddChild($$, $1);
        SyntaxTreeNode_AddChild($$, $2);
        SyntaxTreeNode_AddChild($$, $3);
    }
    | term  {
        $$ = newSyntaxTreeNode("additive-expression"); 
        SyntaxTreeNode_AddChild($$, $1);
    }
    ;
addop: ADD {
        $$ = newSyntaxTreeNode("addop"); 
        $1 = newSyntaxTreeNode("+");
        SyntaxTreeNode_AddChild($$, $1);
    }
    | SUB {
        $$ = newSyntaxTreeNode("addop"); 
        $1 = newSyntaxTreeNode("-");
        SyntaxTreeNode_AddChild($$, $1);
        }
    ;
term: term mulop factor {
        $$ = newSyntaxTreeNode("term"); 
        SyntaxTreeNode_AddChild($$, $1);
        SyntaxTreeNode_AddChild($$, $2);
        SyntaxTreeNode_AddChild($$, $3);
    }
    | factor {
        $$ = newSyntaxTreeNode("term"); 
        SyntaxTreeNode_AddChild($$, $1);
        }
    ;
mulop: MUL {
        $$ = newSyntaxTreeNode("mulop"); 
        $1 = newSyntaxTreeNode("*");
        SyntaxTreeNode_AddChild($$, $1);
    }
    | DIV {
        $$ = newSyntaxTreeNode("mulop"); 
        $1 = newSyntaxTreeNode("/");
        SyntaxTreeNode_AddChild($$, $1);
    }
    ;
factor: LPARENTHESE expression RPARENTHESE {
        $$ = newSyntaxTreeNode("factor"); 
        $1 = newSyntaxTreeNode("("); 
        $3 = newSyntaxTreeNode(")");   
        SyntaxTreeNode_AddChild($$, $1);
        SyntaxTreeNode_AddChild($$, $2);
        SyntaxTreeNode_AddChild($$, $3);
    }
    | var  {
        $$ = newSyntaxTreeNode("factor"); 
        SyntaxTreeNode_AddChild($$, $1);
        }
    | call {
        $$ = newSyntaxTreeNode("factor"); 
        SyntaxTreeNode_AddChild($$, $1);
        }
    | NUMBER {
        $$ = newSyntaxTreeNode("factor"); 
        $1 = newSyntaxTreeNode(yytext);
        SyntaxTreeNode_AddChild($$, $1);
    }
    ;
call: ID LPARENTHESE args RPARENTHESE{
        $$ = newSyntaxTreeNode("call"); 
        // $1 = newSyntaxTreeNode(yytext);
        printf("ID: %s", yytext);
        $2 = newSyntaxTreeNode("(");
        $4 = newSyntaxTreeNode(")");
        SyntaxTreeNode_AddChild($$, $1);
        SyntaxTreeNode_AddChild($$, $2);
        SyntaxTreeNode_AddChild($$, $3);
        SyntaxTreeNode_AddChild($$, $4);
    }
    ;
args: /* empty */{
        $$ = newSyntaxTreeNode("args"); 
        // $1 = newSyntaxTreeNode("epsilon");
        SyntaxTreeNode_AddChild($$, newSyntaxTreeNode("epsilon"));
    }
    | arg-list  {
        $$ = newSyntaxTreeNode("args"); 
        SyntaxTreeNode_AddChild($$, $1);
    }
    ;
arg-list: arg-list COMMA expression {
        $$ = newSyntaxTreeNode("arg-list"); 
        $2 = newSyntaxTreeNode(",");
        SyntaxTreeNode_AddChild($$, $1);
        SyntaxTreeNode_AddChild($$, $2);
        SyntaxTreeNode_AddChild($$, $3);
    }
    | expression {
        $$ = newSyntaxTreeNode("arg-list"); 
        SyntaxTreeNode_AddChild($$, $1);
    }
ID: IDENTIFIER {
    $$ = newSyntaxTreeNode($1);
}
%%

void yyerror(const char * s)
{
	// TODO: variables in Lab1 updates only in analyze() function in lexical_analyzer.l
	//       You need to move position updates to show error output below
	fprintf(stderr, "%s:%d syntax error for %s\n in %d %d", s, lines, yytext, yylloc.first_column, yylloc.last_column);

}


/// \brief Syntax analysis from input file to output file
///
/// \param input basename of input file
/// \param output basename of output file
void syntax(const char * input, const char * output)
{
	gt = newSyntaxTree();

	char inputpath[256] = "./testcase/";
	char outputpath[256] = "./syntree/";
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
