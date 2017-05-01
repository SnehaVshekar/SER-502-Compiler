%{
#include <stdio.h>
#include <string.h>

int i = 0, x = 0;

char IC[2000][250]; 		/* array to store generated intermediate code */
char append[160];			 	 /* convert number to string */
int datastruct[50];			 /* store in array before execution of condition */
int codeline = 0;		 
int linenumber; 		 
int loc;			 
int line= 0;
int v=0;

void push(int codeline) {

	datastruct[i++] = codeline;

}

int pop() {

	if(i >= 0) {

		x = datastruct[--i];

		return x;
	}

	return 0;

}

%}


%union {
	int val;
	char *string;
}

/* Tokens from LEXER FILE*/


%token LFLOWER RFLOWER LSQUARE RSQUARE LPAREN RPAREN 		/* brackets */

%token EQUAL GREATER LESS AND OR NOT ASSIGN						/* boolean operators */

%token TRUE FALSE											/* boolean keywords */

%token PLUS SUB MULTIPLY DIV  								/* arithmatic operators */

%token IF ELSE WHILE 										/* statement keywords */

%token READ PRINT											/* statement operators */

%token END 													/* end of statement */

/* TOKENS ASSOCIATED WITH THE TYPE OF VALUE. $1 is num, $2 is var, $3 is string*/

%token <val> 	NUM       									/* NUM token contains a number */

%token <string> VAR   										/* VAR token contains a variable */

%token <string> STRING

/*TYPE IDENTIFIERS*/

%type <val> 	exp 

%type <string> 	statement


/* Associativity of operators in order of increasing precedence */

%left 	GREATER LESS 

%right 	EQUAL ASSIGN

%left 	PLUS SUB

%left 	MULTIPLY DIV

%%

Program : 	/* empty */
			| Program Block
;

Block : 	END	| exp 				{ line++; }
;

exp :    		statement
			  	| exp PLUS exp 	 	{
														strcpy(IC[codeline++],"plu \n");
									}

			  	| exp SUB exp		{
														strcpy(IC[codeline++],"sub \n");
									}

			  	| exp MULTIPLY exp 	{
														strcpy(IC[codeline++],"mul \n");
									}

			  	| exp DIV exp			{
														strcpy(IC[codeline++],"div \n");
									}

				| exp AND exp  	{
														strcpy(IC[codeline++],"and \n");
									}

				| exp OR exp 	 	{
														strcpy(IC[codeline++],"or \n");
									}

				| NOT exp  			{
														strcpy(IC[codeline++],"not \n");
									}

			  	| VAR				{
														strcpy(IC[codeline],"get ");
														strcat(IC[codeline],$1);
														strcat(IC[codeline++],"\n");
									}

			  	| NUM 			    {
														strcpy(IC[codeline],"get ");
														sprintf(append,"%d",$1);
														strcat(IC[codeline],append);
														strcat(IC[codeline++],"\n");
									}

			  	| TRUE				{
														strcpy(IC[codeline],"get ");
														strcat(IC[codeline],"true");
														strcat(IC[codeline++],"\n");
									}

	  		  	| FALSE				{
		 												strcpy(IC[codeline],"get ");
														strcat(IC[codeline],"false");
														strcat(IC[codeline++],"\n");
	  								}

			
;

statement :
										  
			  	VAR EQUAL STRING   {
				  										strcpy(IC[codeline],"str ");
														strcat(IC[codeline],$3);
														strcat(IC[codeline++],"\n");
														strcat(IC[codeline],"put ");
														strcat(IC[codeline],$1);
														strcat(IC[codeline++],"\n");
												
											
									}

			  	| PRINT STRING       {
			  											strcpy(IC[codeline],"str ");
														strcat(IC[codeline],$2);
														strcat(IC[codeline++],"\n");
														strcat(IC[codeline++],"dsp \n");
													
									}

				| IF exp LSQUARE 	{
														strcpy(IC[codeline++],"bne ");
									}

				| RSQUARE 			{
														linenumber=pop();
														loc=pop();
														loc=codeline;
														loc++;
														sprintf(append,"%d",loc);
														if (v == 0){
															strcat(IC[linenumber],append);
															strcat(IC[linenumber],"\n");
															}
														else {
															loc=codeline++;
															sprintf(append,"%d",loc);
															strcat(IC[v],append);
														    strcat(IC[v],"\n"); 
															v=0;
														}
									}

				| ELSE LSQUARE 		{
														strcpy(IC[codeline++],"get 1\n");
														v = codeline;
														strcpy(IC[codeline++],"beq ");
									}	


				| WHILE exp LFLOWER {
														strcpy(IC[codeline++],"bne ");
									}

				
				| RFLOWER 			{
														linenumber=pop();
														loc=pop();

														strcpy(IC[codeline++],"get 1\n");
														strcpy(IC[codeline],"beq ");
														sprintf(append,"%d",loc);
														strcat(IC[codeline],append);
														strcat(IC[codeline],"\n");
														loc=codeline++;
														sprintf(append,"%d",loc);
														strcat(IC[linenumber],append);
													    strcat(IC[linenumber],"\n");
									}


				

				| READ VAR 			{
														strcpy(IC[codeline++],"inp \n");
														strcpy(IC[codeline],"put ");
														strcat(IC[codeline],$2);
														strcat(IC[codeline++],"\n");
									}

				| PRINT exp		 	{
														strcpy(IC[codeline++],"dsp \n");
									}

				| VAR EQUAL exp 	{
														strcpy(IC[codeline],"put ");
														strcat(IC[codeline],$1);
														strcat(IC[codeline++],"\n");
									}
				| LPAREN condition RPAREN 	{
														codeline=codeline-3;
														push(codeline);
														codeline=codeline+3;
														push(codeline);
											}
;


condition :		| exp GREATER exp 	{
														strcpy(IC[codeline++],"grt \n");
									}

				| exp LESS exp 		{
														strcpy(IC[codeline++],"les \n");
									}
				| exp ASSIGN exp 	{
														strcpy(IC[codeline++],"ass \n");
									}
;

%%

#include<stdio.h>
#include<string.h>
extern FILE *yyin;
extern char *yytext;


int main (int argc,char **argv)
{

	char outputfile[20];
   	FILE *fp;
   	++argv, --argc;
   	int i = 0;

   	if (argc > 0)	{

		strcpy(outputfile, argv[0]);

     	yyin = fopen(argv[0], "r");

   	}
   	else 	{

     	yyin = stdin;
   	}
   	/* PARSING STARTS HERE*/
	yyparse();														
	/*INTERMEDIATE CODE WITH .orj.int EXTENSION*/
   	strcat(outputfile, ".int");									

	fp = fopen(outputfile, "w");
	/*APPENDING END OF FILE TO THE INTERMEDIATE CODE GENERATED*/
	strcpy(IC[codeline++], "end\n");				

   	while(i < codeline)	{

      	fprintf(fp,"%s", IC[i++]);

   	}

	fclose(fp);

	return 0;
}

int yyerror (char *s) 	
{ 
	/*ERROR HANDLING*/
 printf ("ERROR: %s -----%s----- at line number :  %d\n",s,yytext,line+1);
 
 return 0;
}
