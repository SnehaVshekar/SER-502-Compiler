
%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "y.tab.h"

%}

%option yylineno

L	    			[a-z][a-zA-Z0-9]*
DIGIT				[0-9]
%%
"+"					{ return (PLUS); }

"-"					{ return (SUB); }

"*"					{ return (MULTIPLY); }

"/"					{ return (DIV); }

"="	  			 { return (EQUAL); }
  
"is"        		{ return (IF); }

"isnot"			{ return (ELSE); }

"T"					{ return (TRUE); }

"F"					{ return (FALSE); }

">"				{ return (GREATER); }

"<"				{ return (LESS); }

"=="       			{ return (ASSIGN); }

"&"					{ return (AND); }

"|"					{return (OR); }

"!"					{return (NOT); }

"("					{ return (LPAREN); }

")"					{ return (RPAREN); }

"{"					{ return (LFLOWER); }

"}"					{ return (RFLOWER); }

"["					{ return (LSQUARE); }

"]"					{ return (RSQUARE); }

"loop" 		{ yylval.string=(char *)yytext; return (WHILE); }

"read"				{ yylval.string=(char *)yytext; return (READ); }

"write"				{ yylval.string=(char *)yytext; return (PRINT); }

"~"					{ return (END); }

\"[^"\n]*["\n] { yylval.string=(char *)yytext;return (STRING);}                    


" "              { ; }

[\r \n \t]       { ; }


{DIGIT}+			{ yylval.val = atoi(yytext); return (NUM); }

{L}+			{ yylval.string = (char *)yytext; return (VAR); }
%%
int yywrap(void){}