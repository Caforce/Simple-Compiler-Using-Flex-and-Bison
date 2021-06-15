    /* calculator #1 l file-1707003 */
%{
    #include "project.tab.h"
    #include <stdlib.h>
    #include<string.h>
    #include<stdio.h>
    void yyerror(char *);
%}

name 		[a-zA-Z][a-zA-Z0-9_]*
number 		[-]?[0-9]+
keyword 	return|inumber|fnumber
header		"import"[ ]+[^\n]+[.h][ ]*
sents       ["].+["]

scomment     "//"[a-zA-Z0-9]*
mcomment    "/*"(.|\n)*"*/"


%%

"inumber"	{return INT;}
"string"	{return STRING;}
"main"		{ return MAIN;}
"begin"		{return begin;}
"end"		{return end;}
"if"		{return IF;}
"fi" 		{return FI;}
"else"		{return ELSE;}
"display"	{return OUT;}
"switch"	{return SWITCH;}
"case"		{return CASE;}
"DEFAULT"	{return DEFAULT;}
"loop"		{return LOOP;}
"pool"      {return POOL;}
"done" 		{return DONE;}

"**"		{return POW;}

"=="        {return EQ;}
">="        {return GE;}
"<="        {return LE;}
"!="        {return NE;}


{sents}        {
                yylval.string = strdup(yytext);
                return SENTS;
                }
{scomment}   {printf("Single line comment\n");}
{mcomment}   {printf("Multiple line comment\n");}


{name}       {
                yylval.string = strdup(yytext);
                return varname;
            }

{number}      {
                yylval.integer = atoi(yytext);
                return num;
            }

[-+()=/*<>,;:%]     {return *yytext;}



{header}	;
[ \t\n]   ;       /* skip whitespace */

.               {printf("%s --> invalid\n",yytext);}

%%

int yywrap(void) {
    return 1;
}
