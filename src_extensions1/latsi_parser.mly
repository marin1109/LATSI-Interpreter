%{
open Latsi_ast
%}

%token <int> INT
%token <string> STR
%token <char> VAR 
%token PLUS MINUS MULT DIV VIRG PP PG EGAL DIFF ENTREE
%token ASSIGNE IMPRIME SI ALORS VAVERS COMMENTAIRE NL FIN 
%token SROUTINE RETOURNE PPE PGE LPAREN RPAREN FACT PUISS
%token TANTQUE FAIRE PV EOF


%left PLUS MINUS
%left MULT DIV
%right FACT PUISS

%start program
%type <Latsi_ast.program> program

%%

program:
  | lines EOF { Array.of_list $1 }

lines:
  |   { [] }
  | line lines { $1 :: $2 }

line:
  | INT instr { { ligne = $1; instr = $2 } }
  | INT { { ligne = $1; instr = Vide } }

instr:
  | IMPRIME expressions { Imprime $2 }
  | SI expression relop expression ALORS instr { SiAlors($2, $3, $4, $6) }
  | VAVERS INT { Vavers $2 }
  | assignementList { AssigneList $1 }
  | COMMENTAIRE STR { Commentaire $2 }
  | NL { NouvelleLigne }
  | FIN { Fin }
  | SROUTINE INT { Sousroutine $2 }
  | RETOURNE { Retourne }
  | ENTREE entree { Entree $2 }
  | TANTQUE expression relop expression FAIRE instrs { TantQue($2, $3, $4, $6) }

instrs:
  | instr PV { [$1] }
  | instr PV instrs { $1 :: $3 }

assignementList:
  | assignement { [ $1 ] }
  | assignement VIRG assignementList { $1 :: $3 }

assignement:
  | VAR ASSIGNE expression { Assigne($1, $3) }

expressions:
  | expression { [$1] }
  | expression VIRG expressions { $1 :: $3 }

entree:
  | VAR { [Var $1] }
  | entree VIRG VAR { $1 @ [Var $3] } 

expression:
  | INT { Int $1 }
  | STR { Str $1 }
  | VAR { Var $1 }
  | expression PUISS expression { Puissance($1, $3) }
  | expression FACT { Fact($1)}
  | expression PLUS expression { Plus($1, $3) }
  | expression MINUS expression { Minus($1, $3) }
  | expression MULT expression { Mult($1, $3) }
  | expression DIV expression { Div($1, $3) }
  | LPAREN expression RPAREN { Paren $2}

relop:
  | PP { PlusPetit }
  | PG { PlusGrand }
  | EGAL { Egal }
  | DIFF { Diff }
  | PPE { PlusPetitEgal }
  | PGE { PlusGrandEgal }