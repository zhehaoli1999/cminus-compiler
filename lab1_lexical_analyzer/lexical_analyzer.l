%option noyywrap
%{
/*****************声明和选项设置  begin*****************/
#include <string.h>
#include <stdio.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <dirent.h>
int files_count = 0;
int lines = 0;
int pos_start = 1;
int pos_end = 1;

enum cminus_token_type{
	ERROR = 258,
	ADD = 259,
	SUB = 260,
	MUL = 261,
	DIV = 262,
	LT = 263,
	LTE = 264,
	GT = 265,
	GTE = 266,
	EQ = 267,
	NEQ = 268,
	ASSIN = 269,
	SEMICOLON = 270,
	COMMA = 271,
	LPARENTHESE = 272,
	RPARENTHESE = 273,
	LBRACKET = 274,
	RBRACKET = 275,
	LBRACE = 276,
	RBRACE = 277,
	ELSE = 278,
	IF = 279,
	INT = 280,
	RETURN = 281,
	VOID = 282,
	WHILE = 283,
	IDENTIFIER = 284,
	NUMBER = 285,
	LETTER = 286,
	ARRAY = 287,
	EOL = 288,
	COMMENT = 289,
	BLANK = 290
};
/*****************end*****************/

%}

%%

 /****请在此补全所有flex的模式与动作  start******/

LETTER 		[a-zA-Z]
digit		[0-9]
IDENTIFIER	LETTER LETTER*
number		digit digit*
arrary		identifier'['number']'

{IDENTIFIER} 	{return IDENTIFIER;} 		
number			{return NUMBER;}
if			 	{return IF;}
void			{return VOID;}
while			{return WHILE;}
return			{return RETURN;}
if			 	{return IF;}
else			{return ELSE;}
{				{return LBRACE;}
}				{return RBRACE;}
(				{return LBRACKET;}
)				{return LBRACKET;}
+				{return ADD;}
-				{return SUB;}
\*				{return MUL;}
\\				{return DIV;}
>=				{return GTE;}
<=				{return LTE;}
>				{return GT;}
<				{return LT;}
\n				{return }
\/\*			{return COMMENT;}
\*\/			{return ENDCOMMENT;}
array			{return ARRAY;}
[\t]+			{return BLANK;}
[\n]+			{return ENTER;}
\\ todo 





. {return ERROR;}


 /****  end******/
%%

/****************请按需求补全C代码 start*************/

/// \brief analysize a *.cminus file
///
///	\param input_file_name
/// \param output_file_name
/// \todo student should fill this function
void analyzer(char* input_file_name, char* output_file_name){
	char input_path[256] = "./testcase/";
	strcat(input_path, input_file_name);
	char output_path[256] = "./tokens/";
	strcat(output_path, output_file_name);
	if(!(yyin = fopen(input_path,"r"))){
		printf("[ERR] No input file\n");
		exit(1);
	}
	printf("[START]: Read from: %s\n", input_file_name);
	FILE *fp = fopen(output_path,"w+");
	int token;
	while(token = yylex()){
		pos_start = pos_end + 1;
		pos_end += strlen(yytext);
		switch(token){
			case ERROR:
				fprintf(fp, "[ERR]: unable to analysize %s at %d line, from %d to %d\n", yytext, lines, pos_start, pos_end);
				break;
			case COMMENT:
			case BLANK:
				break;
			case EOL:
				break;
			default :
				fprintf(fp, "%s\t%d\t%d\t%d\t%d\n",yytext, token, lines, pos_start, pos_end);
		}
	}
	fclose(fp);
	printf("[END]: Analysis completed.\n");
}

/// \brief get all file paths under 'testcase' directory
///
/// under 'testcase' directory, there could be many *.cminus files.
/// \todo student should fill this function
void getAllTestcase(char filename[][256]){
    DIR * dir;
    struct dirent *ent;
    int count = 0;
    if ((dir = opendir ("/Users/jasmine/CLionProjects/foo/testcases/")) != nullptr) {
        while((ent = readdir(dir)) != nullptr && strlen(ent->d_name) > 0){
            string tmp = ent->d_name;
            if(tmp[0]  == '.')
                continue;
            strcpy(filename[files_count++], tmp.substr(0, tmp.rfind('.')).c_str());
            // printf("%d %s\n", ++count, tmp.substr(0, tmp.rfind('.')).c_str());
        }
        closedir(dir);
    } else{
        // printf("open file failed !");
        return exit(1);
    }
}


/// \brief process all *.cminus file
///
/// note that: use relative path for all i/o operations
///	process all *.cminus files under 'testcase' directory,
/// then create *.tokens files under 'tokens' directory
/// \todo student should fill this function
int main(int argc, char **argv){
	char filename[10][256];
	char output_file_name[256];
	char input_file_name[256];
	char suffix[] = ".tokens";
	getAllTestcase(filename);
	for(int i = 0; i < files_count; i++){
			strcpy(input_file_name, filename[i]+'.cminus')
			strcpy(output_file_name, filename[i]+'.token')
			analyzer(filename[i],output_file_name);
	}
	return 0;
}
/**************** end*************/
