{
  exception Error of string
  open Latsi_parser
}

let digit = ('-'|'+')? ['0'-'9']+
let letter = ['A'-'Z']
let chaine = '"' [' '','''''_' ';' ':''('')''.''a'-'z''A'-'Z']* '"'

rule token = parse
  | [' ' '\t' '\n' '\r']+    { token lexbuf }
  | '+'                      { PLUS }
  | '-'                      { MINUS }
  | '*'                      { MULT }
  | '/'                      { DIV }
  | ','                      { VIRG }
  | "<"                      { PP }
  | ">"                      { PG }
  | "<="                     { PPE }
  | ">="                     { PGE }
  | "=="                     { EGAL }
  | "<>"|"><"                { DIFF }
  | "="                      { ASSIGNE }
  | "("                      { LPAREN }
  | ")"                      { RPAREN }
  | "IMPRIME"                { IMPRIME }
  | "SI"                     { SI }
  | "ALORS"                  { ALORS }
  | "VAVERS"                 { VAVERS }
  | "REM"                    { COMMENTAIRE }
  | "NL"                     { NL }
  | "FIN"                    { FIN }
  | "ENTREE"                 { ENTREE }
  | digit as num             { INT(int_of_string num) }
  | chaine as str            { STR(str) }
  | letter as var            { VAR(var) }
  | eof                      { EOF }
  | _ as char { 
    raise (Failure (Printf.sprintf "Erreur dans le fichier du programme : caractere %c inattendu" char))
}
