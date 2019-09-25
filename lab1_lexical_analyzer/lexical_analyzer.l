%option noyywrap
%{
/*****************声明和选项设置  begin*****************/
#include <string.h>
#include <stdio.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <dirent.h>
int files_count = 0;
int lines = 1;
int pos_start = 0;
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
	BLANK = 290,
	NEWLINE = -1,
	UNCOMMENT = -2

};
/*****************end*****************/

%}



 /****请在此补全所有flex的模式与动作  start******/

letter 		[a-zA-Z]
digit		[0-9]
identifier	{letter}{letter}*
number		{digit}{digit}* 

%%	
	
{number}		{return NUMBER;}
int				{return INT;}
if			 	{return IF;}
void			{return VOID;}
while			{return WHILE;}
return			{return RETURN;}
else			{return ELSE;}
[\t]			{return BLANK;}
"{"				{return LBRACE;}
"}"				{return RBRACE;}
"("				{return LPARENTHESE;}
")"				{return RPARENTHESE;}
"["				{return LBRACKET;}
"]"				{return RBRACKET;}
"+"				{return ADD;}
"-"				{return SUB;}
"*"				{return MUL;}
"/"				{return DIV;}
">="			{return GTE;}
"<="			{return LTE;}
"=="			{return EQ;}
">"				{return GT;}
"<"				{return LT;}
","				{return COMMA;}
" "				{return BLANK;}
\/\*			{return COMMENT;}
\n				{return NEWLINE;}
\*\/			{return UNCOMMENT;}
";"				{return SEMICOLON;}
"!="			{return NEQ;}
"="				{return ASSIN;}
{identifier}\[{number}\]+ {return ARRAY;}
{identifier} 	{return IDENTIFIER;} 


. 				{return ERROR;}
 /****  end******/
%%

/****************请按需求补全C代码 start*************/

/// \brief analysize a *.cminus file
///
///	\param input_file_name
/// \param output_file_name
/// \todo student should fill this function
void analyzer(char* input_file_name, char* output_file_name){
	/// compute file's name
	char input_path[256] = "./testcase/";
	char output_path[256] = "./tokens/";
	char cminus[256] = ".cminus";
	char token_str[256] = ".tokens";
	char name[256];
	strcat(input_path, input_file_name);
	char *p = strstr(input_file_name, ".");
	strncpy(name, output_file_name, p - output_file_name);
	strcat(output_path, name);
	strcat(output_path, token_str);
	
	if(!(yyin = fopen(input_path,"r"))){
		printf("[ERR] No input file\n");
		exit(1);
	}
	printf("[START]: Read from: %s\n", input_path);
	FILE *fp = fopen(output_path,"w+");
	if(fp == NULL){
		printf("[ERR] No output file\n");
		exit(1);
	}
	int token;
	int flag = 0;
	while(token = yylex()){
		if(flag == 0){
			switch(token){
			case ERROR:
				fprintf(fp, "[ERR]: unable to analysize %s at %d line, from %d to %d\n", yytext, lines, pos_start, pos_end);
				break;
			case COMMENT:
				flag = 1;
				break;
			case NEWLINE:
				lines++;
				pos_start = 0; pos_end = 1;
				break;
			case BLANK:
				pos_end++;
				//fprintf(fp, "%s\t%d\t%d\t%d\t%d\n",yytext, token, lines, pos_start, pos_end);
				break;
			case EOL:
				break;
			default :
				pos_start = pos_end;
				pos_end += strlen(yytext);
				fprintf(fp, "%s\t%d\t%d\t%d\t%d\n",yytext, token, lines, pos_start, pos_end);
		}
		} else if(flag == 1){
			if(token == UNCOMMENT){
				flag = 0;
			}
		}
		
		
	}
	fclose(fp);
	printf("[END]: Analysis completed.\n");
}

/// \brief get all file paths under 'testcase' directory
///
/// under 'testcase' directory, there could be *.cminus files.
/// \todo student should fill this function
void getAllTestcase(char filename[][256]){
    DIR *dir;
	// dir = (DIR*)malloc(sizeof(DIR));
    struct dirent *ent;
	//len = offsetof(struct dirent, d_name) + pathconf("/home/jasmine/Documents/lab1/lab1_lexical_analyzer/testcase", _PC_NAME_MAX) + 1;
  	//ent = malloc(len);
    int count = 0;
    if ((dir = opendir ("./testcase/")) != NULL) {
        while((ent = readdir(dir)) != NULL && strlen(ent->d_name) > 0){
            //tmp = ent->d_name;
            if(ent->d_name[0]  == '.'){
				continue;
			}
			
            strcpy(filename[files_count++], ent->d_name);
            //printf("%d %s\n", ++count, tmp.substr(0, tmp.rfind('.')).c_str());
        }
        closedir(dir);
		//free(ent);
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
	getAllTestcase(filename);
	//printf("getalltestcase done");
	for(int i = 0; i < files_count; i++){
			//strcat(output_file_name, filename[i]);
			//strcat(output_file_name, '.token');
			pos_end = 1;
			pos_start = 0;
			lines = 1;
			analyzer(filename[i],filename[i]);
	}
	return 0;
}
/**************** end*************/
