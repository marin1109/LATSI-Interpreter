{
  exception Error of string
  open Latsi_parser
}

let digit = ('-'|'+')? ['0'-'9']+
let letter = ['A'-'Z'] | ['a'-'z']
let chaine = "\"" ( [^ '"' '\\'] | "\\" ['"' '\\'] )* "\""

rule token = parse
  | [' ' '\t' '\n' '\r']+    { token lexbuf }
  | '+'                      { PLUS }
  | '-'                      { MINUS }
  | '*'                      { MULT }
  | '/'                      { DIV }
  | ','                      { VIRG }
  | "<"                      { PP }
  | ">"                      { PG }
  | "=="                     { EGAL }
  | "<="                     { PPE }
  | ">="                     { PGE }
  | "<>"|"><"                { DIFF }
  | "="                      { ASSIGNE }
  | "("                      { LPAREN }
  | ")"                      { RPAREN }
  | "!"                      { FACT }
  | "^"                      { PUISS }
  | "IMPRIME"                { IMPRIME }
  | "SI"                     { SI }
  | "ALORS"                  { ALORS }
  | "VAVERS"                 { VAVERS }
  | "REM"                    { COMMENTAIRE }
  | "NL"                     { NL }
  | "FIN"                    { FIN }
  | "SOUSROUTINE"            { SROUTINE }
  | "RETOURNE"               { RETOURNE }
  | "ENTREE"                 { ENTREE }
  | "TANTQUE"                { TANTQUE }
  | "FAIRE"                  { FAIRE }
  | ";"                      { PV }
  | digit as num             { INT(int_of_string num) }
  | chaine as str            { STR(str) }
  | letter as var            { VAR(var) }
  | eof                      { EOF }
  | _ as char { 
    raise (Failure (Printf.sprintf "Erreur dans le fichier du programme : caractere %c non gere." char))
}
