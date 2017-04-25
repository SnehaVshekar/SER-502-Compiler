
%{
#include <stdio.h>
#include <string.h>
#include "ORJ.tab.h"
static void forget_to_close_comment_error(void);
static void skip_single_line_comment(void);
static void skip_multiple_line_comment(void);

%}

%option yylineno
%option noyywrap

L				[a-zA-Z]
DIGIT				[0-9]
%%
"+"					{ return PLUS; }

"-"					{ return SUB; }

"*"					{ return MULTIPLY; }

"/"					{ return DIV; }

"->"				{ return EQUAL; }

"is"        		{ return IF; }

"isnot"			{ return ELSE; }

"T"					{ return TRUE; }

"F"					{ return FALSE; }

">"				{ return GREATER; }

"<"				{ return LESS; }

"&"					{ return AND; }

"|"					{return OR; }

"!"					{return NOT; }

"LP"					{ return LPAREN; }

"RP"					{ return RPAREN; }

"LF"					{ return LFLOWER; }

"RF"					{ return RFLOWER; }

"LS"					{ return LSQUARE; }

"RS"					{ return RSQUARE; }

"loop" 		{ yylval.string=(char *)yytext; return WHILE; }

"read"				{ yylval.string=(char *)yytext; return READ; }

"write"				{ yylval.string=(char *)yytext; return PRINT; }

"~"					{ return END; }

\"[^"\n]*["\n] { yylval.string=(char *)yytext;return STRING;}

"//".*                                    { /* DO NOTHING */ }
[/][*][^*]*[*]+([^*/][^*]*[*]+)*[/]       { /* DO NOTHING */ }
                    
[/][*]                                    {forget_to_close_comment_error(); }
                    

" "               { /* empty */ }
[\n|\r\n\t]       { /* empty */ }

{DIGIT}+			{ yylval.val = atoi(yytext); return NUM; }

{L}+			{ yylval.string = (char *)yytext; return VAR; }
%%


static void forget_to_close_comment_error(void){
   fprintf(stderr, "Tokenizing error: '%c'\n", *yytext); 
 fprintf(stderr, "Error unclosed comment, expect */\n");
        exit(-1);
}

static void skip_single_line_comment(void)
{
  int c;
  /* Read until we find \n or EOF */
  while((c = input()) != '\n' && c != EOF)
    ;

  /* Maybe you want to place back EOF? */
  if(c == EOF)
    unput(c);
}

static void skip_multiple_line_comment(void)
{
  int c;

  for(;;)
  {
    switch(input())
    {
      /* We expect ending the comment first before EOF */
      case EOF:
        fprintf(stderr, "Error unclosed comment, expect */\n");
        exit(-1);
        goto done;
      break;
      /* Is it the end of comment? */
      case '*':
        if((c = input()) == '/')
          goto done;
        unput(c);
        break;
      default:
        /* skip this character */
        break;
    }
  }

done:
  /* exit entry */ ;
}
