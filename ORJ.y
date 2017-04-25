%{
#include <stdio.h>
#include <string.h>

char intermediate_code[200][25]; /* 2D character array to store generated intermediate code */
char to_string[16];			 	 /* NUM to string value */
int store_to_stack[5];			 /* Location storage before execution of condition */
int code_line_number = 0;		 /* Index for intermediate code line number */
int current_line_number; 		 /* Line index stored in stack */
int stored_location;			 /* Location value stored in stack */
int lineno= 0;

int i = 0, x = 0;

void push(int code_line_number) {

	store_to_stack[i++] = code_line_number;

}

int pop() {

	if(i >= 0) {

		x = store_to_stack[--i];

		return x;
	}

	return 0;

}

%}


%union {
	int val;
	char *string;
}

/* Tokens from FLEX*/


%token LFLOWER RFLOWER LSQUARE RSQUARE LPAREN RPAREN 		/* brackets */

%token EQUAL GREATER LESS AND OR NOT						/* boolean operators */

%token TRUE FALSE											/* boolean keywords */

%token PLUS SUB MULTIPLY DIV  								/* arithmatic operators */

%token IF ELSE WHILE 										/* statement keywords */

%token READ PRINT											/* statement operators */

%token END 													/* end of statement */

%token <val> 	NUM       									/* NUM token contains a number */

%token <string> VAR   										/* VAR token contains a variable */

%token <string> STRING

%type <val> 	exp

%type <string> 	statement



/* Associativity of operators in order of increasing precedence */

%left 	GREATER LESS

%right 	ASSIGN

%left 	PLUS SUB

%left 	MULTIPLY DIV

%%

Program : 	/* empty */
			| Program Block
;

Block : 	END	| exp END 						{ lineno++; }
;

exp :    	statement
			  | exp PLUS exp	 	{
														strcpy(intermediate_code[code_line_number++],"plu\n");
									}

			  | exp SUB exp			{
														strcpy(intermediate_code[code_line_number++],"sub\n");
									}

			  | exp MULTIPLY exp	{
														strcpy(intermediate_code[code_line_number++],"mul\n");
									}

			  | exp DIV exp			{
														strcpy(intermediate_code[code_line_number++],"div\n");
									}

				| exp AND exp	 	{
														strcpy(intermediate_code[code_line_number++],"and\n");
									}

				| exp OR exp	 	{
														strcpy(intermediate_code[code_line_number++],"or\n");
									}

				| NOT exp  			{
														strcpy(intermediate_code[code_line_number++],"not\n");
									}

			  | VAR					{
														strcpy(intermediate_code[code_line_number],"tak ");
														strcat(intermediate_code[code_line_number],$1);
														strcat(intermediate_code[code_line_number++],"\n");
									}

			  | NUM 			    {
														strcpy(intermediate_code[code_line_number],"tak ");
														sprintf(to_string,"%d",$1);
														strcat(intermediate_code[code_line_number],to_string);
														strcat(intermediate_code[code_line_number++],"\n");
									}

			  | TRUE				{
														strcpy(intermediate_code[code_line_number],"tak ");
														strcat(intermediate_code[code_line_number],"true");
														strcat(intermediate_code[code_line_number++],"\n");
									}

	  		  | FALSE 				{
		 												strcpy(intermediate_code[code_line_number],"tak ");
														strcat(intermediate_code[code_line_number],"false");
														strcat(intermediate_code[code_line_number++],"\n");
	  								}
			
;

statement :
										  
			  	| VAR EQUAL STRING  {
				  										strcpy(intermediate_code[code_line_number],"str ");
														strcat(intermediate_code[code_line_number],$3);
														strcat(intermediate_code[code_line_number++],"\n");
														strcat(intermediate_code[code_line_number],"put ");
														strcat(intermediate_code[code_line_number],$1);
														strcat(intermediate_code[code_line_number++],"\n");
												
											
									}

			  	| PRINT STRING      {
			  											strcpy(intermediate_code[code_line_number],"str ");
														strcat(intermediate_code[code_line_number],$2);
														strcat(intermediate_code[code_line_number++],"\n");
														strcat(intermediate_code[code_line_number++],"prt\n");
													
									}

				| IF exp LSQUARE 	{
														strcpy(intermediate_code[code_line_number++],"bne ");
									}

				| RSQUARE			{
														current_line_number=pop();
														stored_location=pop();
														stored_location=code_line_number;
														sprintf(to_string,"%d",stored_location);
														strcat(intermediate_code[current_line_number],to_string);
														strcat(intermediate_code[current_line_number],"\n");
									}


				| WHILE exp LFLOWER {
														strcpy(intermediate_code[code_line_number++],"bne ");
									}

				
				| RFLOWER			{
														current_line_number=pop();
														stored_location=pop();

														strcpy(intermediate_code[code_line_number++],"tak 1\n");
														strcpy(intermediate_code[code_line_number],"beq ");
														sprintf(to_string,"%d",stored_location);
														strcat(intermediate_code[code_line_number],to_string);
														strcat(intermediate_code[code_line_number],"\n");
														stored_location=code_line_number++;
														sprintf(to_string,"%d",stored_location);
														strcat(intermediate_code[current_line_number],to_string);
													    strcat(intermediate_code[current_line_number],"\n");
									}


				| LPAREN condition RPAREN	{
														code_line_number=code_line_number-3;
														push(code_line_number);
														code_line_number=code_line_number+3;
														push(code_line_number);
											}

				| READ VAR			{
														strcpy(intermediate_code[code_line_number++],"inp\n");
														strcpy(intermediate_code[code_line_number],"put ");
														strcat(intermediate_code[code_line_number],$2);
														strcat(intermediate_code[code_line_number++],"\n");
									}

				| PRINT exp		 	{
														strcpy(intermediate_code[code_line_number++],"prt\n");
									}

				| VAR EQUAL exp		{
														strcpy(intermediate_code[code_line_number],"put ");
														strcat(intermediate_code[code_line_number],$1);
														strcat(intermediate_code[code_line_number++],"\n");
									}
;


condition :		| exp GREATER exp	{
														strcpy(intermediate_code[code_line_number++],"grt\n");
									}

				| exp LESS exp		{
														strcpy(intermediate_code[code_line_number++],"les\n");
									}
;

%%

#include<stdio.h>
#include<string.h>

extern FILE *yyin;
extern char *yytext;



int main (int argc,char **argv)
{

	char output_file_name[20];
   	FILE *fp;
   	++argv, --argc;
   	int i = 0;

   	if (argc > 0)	{

		strcpy(output_file_name, argv[0]);

     	yyin = fopen(argv[0], "r");

   	}
   	else 	{

     	yyin = stdin;
   	}

	yyparse();															/* parsing starts here */

   	strcat(output_file_name, ".int");									/* a file with extension .g28.int for intermediate code */

	fp = fopen(output_file_name, "w");

	strcpy(intermediate_code[code_line_number++], "end\n");				/* appending end of file to intermediate code generated */

   	while(i < code_line_number)	{

      	fprintf(fp,"%s", intermediate_code[i++]);

   	}

	fclose(fp);

	return 0;
}

int yyerror (char *s) 	{ 
											/* error case handling on parsing */

 printf ("ERROR: %s -----%s----- at line number :  %d\n",s,yytext,lineno+1);
 
 return 0;
}
