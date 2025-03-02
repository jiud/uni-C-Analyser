/*
    * Ομάδα 15

    Όνομα αρχείου:      uni_c_analyser.c
    Περιγραφή:          Λεκτικός Αναλυτής για την γλώσσα προγραμματισμού Uni-C
    Συγγραφείς:         ΟΜΑΔΑ 15:
                        Διονύσης Νικολόπουλος
                        Αθανάσιος Αναγνωστόπουλος
                        Άριστείδης Αναγνωστόπουλος
                        Σπυρίδων Φλώρος
    Σχόλια:             Κάποια σχόλια έχουν γίνει πάνω στον κώδικα, αλλά ο
                        κώδικας επίσης εξηγήται στο PDF της εργασίας.
    Οδηγίες Εκτέλεσης:  Λόγω της υλοποίησης makefile, τρέχετε απλά την εντολή
                        make στον τρέχοντα κατάλογο που βρίσκεται το αρχέιο.
*/

/* H anagnwsh periorizetai se ena mono arxeio kai termatizei sto prwto EOF */
%option noyywrap

/* Kwdikas C gia orismo twn apaitoumenwn header files kai twn metablhtwn.
   Otidhpote anamesa sta %{ kai %} metaferetai autousio sto arxeio C pou
   tha dhmiourghsei to Flex. */

%{

#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include "bison-SA.tab.h"

/* Orismos metrhth trexousas grammhs */
int line = 1;

%}
/* Onomata kai antistoixoi orismoi (ypo morfh kanonikhs ekfrashs).
   Meta apo auto, mporei na ginei xrhsh twn onomatwn (aristera) anti twn,
   synhthws idiaiterws makroskelwn kai dysnohtwn, kanonikwn ekfrasewn */

SEMI                 ;
HASH                 #
TILDE                ~
NEQ                  !=
MOD                  \%
POW                  \^
COMMA                \,
COLON                \:
AMPER                \&
PAR_END              \)
PAR_START            \(
BRACE_END            \}
BRACE_START          \{
BRACKET_END          \]
BRACKET_START        \[
LOGICAL_OR           \|\|
TYPE_EQ              ==?
TYPE_DIV             \/=?
TYPE_MULTI           \*=?
TYPE_EXCLA           \!=?
TYPE_AMPER           \&\&
TYPE_LESSER          \<=?
TYPE_GREATER         \>=?
WHITESPACE           [ \t]+
TYPE_PLUS            \+[\+=]?
TYPE_MINUS           \-[\-=]?
STRING               '.*'|\".*\"
INTCONST             0|[1-9]+[0-9]*
COMMENT              \/\*(.|\n)*?\*\/|\/\/.*
IDENTIFIER           [a-zA-Z_]([0-9_a-zA-Z]*)
FLOAT                [0-9]+\.[0-9]+|[0-9]+\.[0-9]+e[0-9]+

%x REALLYEND

/* Gia kathe pattern (aristera) pou tairiazei ekteleitai o antistoixos
   kwdikas mesa sta agkistra. H entolh return epitrepei thn epistrofh
   mias arithmhtikhs timhs mesw ths synarthshs yylex() */

/* Σχόλιο Ομάδας 15
    Σημείωσεις για:
    -{IDENTIFIER} : Ο λεκτικός μας αναλυτής, πρώτα ανιχνεύει την συμβολοσειρά ως
                    identifier, και μετά ξεκαθαρίζει άμα είναι keyword ή απλά το
                    όνομα μιας μεταβλητής ή συνάρτησης.
    -{.} :          Ο λεκτικός μας αναλυτής, εφόσον ανιχνεύσει τα στοιχεία τα
                    οποία είναι άγνωστα, τα αναφέρει, και παρακάτω αναμένουμε
                    τον συντακτικό αναλυτή να αναφέρει ολοκληρωμένες συμβολοσειρές
                    που είναι λανθασμένες λόγω άγνωστου χαρακτήρα.
    -Σημεία Στίξης: Ο λεκτικός μας αναλυτής, ανιχνεύει επίσης και τα στοιχεία στίξης,
                    αυτά που είναι σημαντικότερα (παρενθέσεις, αγκύλες κτλ.) τα επιτρέφει
                    ως συγκεκριμένα token για ευκολία του συντακτικού αναλυτή.
                    Τα υπόλοιπα τα αναφέρει απλά σαν σημεία στίξης γιατί η κατανόηση
                    της ορθότητας τους είναι δουλειά που αναλαμβάνει ο συντακτικός αναλυτής,
                    καθώς απαιτεί συντακτική ανάλυση (επεξεργασία προηγούμενων και επόμενων
                    λέξεων, κτλ.) 
    -Κενά:          Ο λεκτικός μας αναλυτής αγνοεί τα κενά και τις κενές γραμμές, δεν
                    επιτρέφει token για αυτά για το συντακτικό αναλυτή. */
%%
{MOD}           {   return MOD;            }
{POW}           {   return POW;            }
{SEMI}          {   return SEMI;           }
{COMMA}         {   return COMMA;          }
{FLOAT}         {   return FLOAT;          }
{STRING}        {   return STRING;         }
{PAR_END}       {   return PAR_END;        }
{INTCONST}      {   return INTCONST;       }
{PAR_START}     {   return PAR_START;      }
{BRACE_END}     {   return BRACE_END;      }
{LOGICAL_OR}    {   return LOGICAL_OR;     }
{BRACE_START}   {   return BRACE_START;    }
{BRACKET_END}   {   return BRACKET_END;    }
{BRACKET_START} {   return BRACKET_START;  }
{IDENTIFIER}    {
                    if      ( !strcmp(yytext,"if"      ) ) return KEYWORD;
                    else if ( !strcmp(yytext,"do"      ) ) return KEYWORD;
                    else if ( !strcmp(yytext,"for"     ) ) return KEYWORD;
                    else if ( !strcmp(yytext,"void"    ) ) return KEYWORD;
                    else if ( !strcmp(yytext,"while"   ) ) return KEYWORD;
                    else if ( !strcmp(yytext,"break"   ) ) return KEYWORD;
                    else if ( !strcmp(yytext,"sizeof"  ) ) return KEYWORD;
                    else if ( !strcmp(yytext,"struct"  ) ) return KEYWORD;
                    else if ( !strcmp(yytext,"return"  ) ) return KEYWORD_RET;
                    else if ( !strcmp(yytext,"case"    ) ) return KEYWORD_CASE;
                    else if ( !strcmp(yytext,"else"    ) ) return KEYWORD_ELSE;
                    else if ( !strcmp(yytext,"func"    ) ) return KEYWORD_FUNC;
                    else if ( !strcmp(yytext,"include" ) ) return KEYWORD_INCL;
                    else if ( !strcmp(yytext,"continue") ) return KEYWORD_CONT;
                    else if ( !strcmp(yytext,"switch"  ) ) return KEYWORD_SWITCH;
                    else if ( !strcmp(yytext,"int"     ) ) return KEYWORD_VAR_TYPE;
                    else if ( !strcmp(yytext,"long"    ) ) return KEYWORD_VAR_TYPE;
                    else if ( !strcmp(yytext,"short"   ) ) return KEYWORD_VAR_TYPE;
                    else if ( !strcmp(yytext,"float"   ) ) return KEYWORD_VAR_TYPE;
                    else if ( !strcmp(yytext,"const"   ) ) return KEYWORD_VAR_TYPE;
                    else if ( !strcmp(yytext,"double"  ) ) return KEYWORD_VAR_TYPE;
                    else return IDENTIFIER;
                }
{TYPE_EXCLA}    {
                    if (!strcmp(yytext, "!=")) return NEQ;
                    else return EXCLA;
                }
{TYPE_EQ}       {
                    if (!strcmp(yytext, "==")) return EQQ;
                    else return EQ;
                }
{TYPE_DIV}      {
                    if (!strcmp(yytext, "/=")) return EQ_DIV;
                    else return DIV;
                }
{TYPE_MULTI}    {
                    if (!strcmp(yytext, "*=")) return EQ_MULTI;
                    else return MULTI;
                }
{TYPE_LESSER}   {
                    if (!strcmp(yytext, "<=")) return LESSER_EQ;
                    else return LESSER;
                }
{TYPE_GREATER}  {
                    if (!strcmp(yytext, ">=")) return GREATER_EQ;
                    else return GREATER;
                }
{TYPE_AMPER}    {
                    if (!strcmp(yytext, "&&")) return LOGICAL_AND;
                    else return AMPER;
                }
{TYPE_MINUS}    {
                    if      (!strcmp(yytext, "--")) return MINUSMINUS;
                    else if (!strcmp(yytext, "-=")) return EQ_MINUS;
                    else return MINUS;
                }
{TYPE_PLUS}     {
                    if      (!strcmp(yytext, "++")) return PLUSPLUS;
                    else if (!strcmp(yytext, "+=")) return EQ_PLUS;
                    else return EQ_PLUS;
                }
{WHITESPACE}    { /*Do nothing, whitespace*/ }
{COMMENT}       { /*Do nothing, comment*/    }
\n              { line++;                    }
 /*Εδώ το flex "πιάνει" οποιονδήποτε άλλο χαρακτήρα που δεν περιγράφεται απο
  τις παραπάνω κανονικές εκφράσεις.*/
. { return UNKNOWN; }
 /*Εδώ καλούμε ένα τμήμα κώδικα που μας βοηθά να δώσουμε ένα token στον bison
  για να δηλώσουμε το τέλος του αρχείου, αποτρέποντας όμως τον bison να
  τερματίζει άμεσα την εκτέλεση. Έτσι, καταφέρνουμε να εκτελούμε την συνάρτηση
  print_report() στο bison-SA.y, για να ανεφέρουμε τον αριθμό των σωστών και
  λανθασμένων λέξεων και εκφράσεων.*/
<INITIAL><<EOF>>  { BEGIN(REALLYEND); printf("#END-OF-FILE#\n"); return EOP; }
 /*Εδώ, μετά την πάροδο των προηγούμενων, "πραγματικά" τερματίζουμε την
  εκτέλεση του flex, έχουμε ήδη τυπώσει την αναφορά με την print_report() με το
  bison, και αρχίζουμε να τερματίζουμε το πρόγραμμα συνολικά.*/
<REALLYEND><<EOF>> {yyterminate();}
%%
/* Το πρόγραμμα αυτό δεν έχει main(), καθώς δεν τρέχει αυτόνομα, είναι απλά ο
   λεκτικός αναλυτής, η συντακτική ανάλυση γίνεται από τον bison. */
