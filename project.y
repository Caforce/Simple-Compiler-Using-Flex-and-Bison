/* Y file - 1707003*/

%{
    #include <stdio.h>
	#include <stdlib.h>
	#include <math.h>
    #include<string.h>
	void yyerror(char *);
	int yylex(void);

	char vars[100][23];
    int value[100];
    int varc = 0;


    int isDeclare(char *s)
    {
        int i;
        for(i=0; i<varc; i++){
            if(strcmp(s,vars[i]) == 0) return i;
        }
        return -1;
    }


%}

%union{
    int integer;
    char* string;
}

%type <integer> num expression statement 
%type <string> varname SENTS

%token num varname INT FLOAT begin end MAIN STRING IF FI ELSE OUT SWITCH CASE DEFAULT
%token LOOP DONE POW  EQ GE LE NE POOL SENTS
%nonassoc SWITCH
%nonassoc CASE
%nonassoc DEFAULT

%left '<' '>' EQ LE GE NE
%left '+' '-'
%left '/' '*'
%left POW '%'

%%

program:
        MAIN begin cstatement end   {printf("\n\nProgram terminated succesfully!\n");}
        ;
cstatement: /*null*/
	| cstatement statement
	;

statement:';'						{}
    | expression ';'				{ printf("value of expression: %d\n", $1); $$=$1;}
	| declaration ';'           	{}         
    | varname '=' expression ';'	{
                                        int pos = isDeclare($1);
                                        if(pos != -1){
                                            value[pos]=$3;
                                            printf("Assignment: %s  = %d\n",$1,$3);
                                        }
                                        else{
                                            printf("%s is not declared/n", $1);
                                        }
                                    }

	| IF '(' expression ')' expression ';' FI	{
													if($3){
														printf("\nValue of expression in IF: %d\n", $5);
													}
													else{
														printf("Condition of IF is false\n");
													}
												}
	| IF '(' expression ')' expression ';' FI ELSE expression ';' FI {
																		if($3){
																			printf("value of expression in IF: %d\n",$5);
																		}
																		else{
																			printf("value of expression in ELSE: %d\n\n",$9);
																		}
																	}
    | IF '(' expression ')' expression ';' FI ELSE IF '(' expression ')' expression ';' FI ELSE expression ';' FI {
                                                                                                if($3){
                                                                                                    printf("value of expression in IF: %d\n",$5);
                                                                                                }else if($11) {
                                                                                                    printf("value of expression in ELSE IF: %d\n",$13);
                                                                                                }else{
                                                                                                    printf("value of expression in ELSE IF: %d\n\n",$17);
                                                                                                }
                                                                                            }
                                                                    
	| OUT '(' expression ')' ';'						{printf("Displaying value of expression: %d\n", $3); } 
    | OUT '(' SENTS ')' ';'						{printf("Displaying Sentence: %s\n\n", $3); } 
	
	| SWITCH '(' varname ')' begin B end 				{//sym[30] = sym[$3]; 
															//printf("Value in witch: %d\n\n", 33);
														}
	
	|LOOP '(' varname ':' varname ')' statement DONE		{ int i, pos1 = isDeclare($3), pos2 = isDeclare($5);
                                                                if(pos1 > -1 && pos2 > -1){
																    for(i = value[pos1]; i < value[pos2]; i++){
																	printf("Value of loop: %d, expression value: %d\n", i, $7);}
                                                                }else{
                                                                    printf("Undeclared variable found in loop\n");
                                                                }
															}
	|LOOP '(' varname ':' varname ':' expression')' statement DONE	{ int i, pos1 = isDeclare($3), pos2 = isDeclare($5);
																if(pos1 > -1 && pos2 > -1){
																    for(i = value[pos1]; i < value[pos2]; i = i + $7){
																	printf("Value of loop: %d, expression value: %d\n", i, $9);}
                                                                }else{
                                                                    printf("Undeclared variable found in loop\n");
                                                                }
															}
    |POOL '(' varname ':' varname ')' statement DONE		{ int i, pos1 = isDeclare($3), pos2 = isDeclare($5);
                                                                if(pos1 > -1 && pos2 > -1){
																    for(i = value[pos1]; i > value[pos2]; i--){
																	printf("Value of pool: %d, expression value: %d\n", i, $7);}
                                                                }else{
                                                                    printf("Undeclared variable found in pool\n");
                                                                }
															}
	|POOL '(' varname ':' varname ':' expression')' statement DONE	{ int i, pos1 = isDeclare($3), pos2 = isDeclare($5);
																if(pos1 > -1 && pos2 > -1){
																    for(i = value[pos1]; i > value[pos2]; i = i - $7){
																	printf("Value of pool: %d, expression value: %d\n", i, $9);}
                                                                }else{
                                                                    printf("Undeclared variable found in pool\n");
                                                                }
															}
							
	;

B   : C
	| C D
    ;
C   : C '+' C
	| CASE num ':' expression ';'  	{
										printf("Value of expression(case): %d\n", $4);
										
									}
	;
D   : DEFAULT ':' expression ';'	{printf("Value of expression(default): %d\n\n", $3); } 

			

declaration: TYPE ID1 
	;

TYPE: INT
	| STRING
	;

ID1:	ID1 ',' varname				{
                                        int pos = isDeclare($3);
                                        if(pos != -1){
                                            printf("\n%s is already declared\n", $3);
                                        }
                                        else{
                                            strcpy(vars[varc],$3);
                                            value[varc]=0;
                                            ++varc;
                                            printf("%s  = %d\n",$3,0);
                                        }
                                	}
	| varname						{
                                        int pos = isDeclare($1);
                                        if(pos != -1){
                                            printf("\n%s is already declared\n", $1);
                                        }
                                        else{
                                            strcpy(vars[varc],$1);
                                            value[varc]=0;
                                            ++varc;
                                            printf("%s  = %d\n",$1,0);
                                        }                                        
                                	}
	| ID1 ',' varname '=' expression         	{ 
                                        int pos = isDeclare($3);
                                        if(pos != -1){
                                        	printf("\n%s is already declared\n", $3);
                                        }
                                        else{
                                            strcpy(vars[varc],$3);
                                            value[varc]=$5;
                                            ++varc;
                                            printf("%s  = %d\n",$3,$5);
                                        }                                        
                                    }
	|varname '=' expression                 	{
                                        int pos = isDeclare($1);
                                        if(pos != -1){
                                            printf("\n%s is already declared\n", $1);
                                        }
                                        else{
                                            strcpy(vars[varc],$1);
                                            value[varc]=$3;
                                            printf("%s  = %d\n",$1,$3);
                                            ++varc;
                                        }
                                    }
	
	;

expression:
    num							
    | varname                      	{ int pos = isDeclare($1);
										if(pos > -1) $$ = value[pos];
                                        else printf("%s is not declared\n", $1); 
									}
	| expression '+' expression     { $$ = $1 + $3; }
	| expression '-' expression     { $$ = $1 - $3; }
	| expression '*' expression     { $$ = $1 * $3; }
	| expression '/' expression     { if($3) {$$ = $1 / $3; }
										else{ printf("Divide by ziro found!\n\n");}
									}
	| '(' expression ')'            { $$ = $2; }
	| expression '<' expression		{ $$ = $1 < $3; }
	| expression '>' expression		{ $$ = $1 > $3; }
    | expression POW expression		{ $$ = pow($1, $3);}
	| expression '%' expression		{ $$ = $1 % $3;}
	| expression EQ expression      { $$ = $1 == $3;}
	| expression LE expression      { $$ = $1 <= $3;}
	| expression GE expression      { $$ = $1 >= $3;}
	| expression NE expression      { $$ = $1 != $3;}

    ;

%%

void yyerror(char *s) {
    fprintf(stderr, "%s\n", s);
}

int main(void) {
	freopen("input.txt","r",stdin);
   	yyparse();
}
