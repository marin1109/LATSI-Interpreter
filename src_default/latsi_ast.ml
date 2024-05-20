type expression =
  | Int of int
  | Str of string
  | Var of char
  | Plus of expression * expression
  | Minus of expression * expression
  | Mult of expression * expression
  | Div of expression * expression
  | Paren of expression

type relop =
  | PlusPetit 
  | PlusGrand 
  | Egal 
  | Diff 
  | PlusPetitEgal
  | PlusGrandEgal

type instruction =
  | Imprime of expression list
  | SiAlors of expression * relop * expression * instruction
  | Vavers of int
  | Assigne of char * expression
  | Commentaire of string
  | NouvelleLigne
  | Fin
  | Entree of expression list
  | Vide

type ligne = {
  ligne : int;
  instr : instruction;
}

type program = ligne array

let rec print_expression = function
  | Int i -> Printf.printf "%d" i
  | Str s -> Printf.printf "%s" s
  | Var v -> Printf.printf "%c" v
  | Plus (e1, e2) -> print_expression e1; Printf.printf " + "; print_expression e2
  | Minus (e1, e2) -> print_expression e1; Printf.printf " - "; print_expression e2
  | Mult (e1, e2) -> print_expression e1; Printf.printf " * "; print_expression e2
  | Div (e1, e2) -> print_expression e1; Printf.printf " / "; print_expression e2
  | Paren e -> Printf.printf " ( "; print_expression e; Printf.printf " ) "
;;

let print_relop = function
  | PlusPetit -> Printf.printf "<"
  | PlusGrand -> Printf.printf ">"
  | Egal -> Printf.printf "=="
  | Diff -> Printf.printf "<>"
  | PlusPetitEgal -> Printf.printf "<="
  | PlusGrandEgal -> Printf.printf ">="
;;

let rec print_instruction = function
  | Imprime e -> Printf.printf "IMPRIME ";
  List.iter (fun expr -> print_expression expr; Printf.printf " , ") e;
  | SiAlors (e1, r, e2, i) ->
      Printf.printf "SI ";
      print_expression e1;
      print_relop r;
      print_expression e2;
      Printf.printf " ALORS ";
      print_instruction i;
  | Vavers e -> Printf.printf "VAVERS "; print_int e
  | Assigne (v, e) -> Printf.printf "%c" v; Printf.printf " = "; print_expression e
  | Commentaire s -> Printf.printf "REM %s" s
  | NouvelleLigne -> Printf.printf "NL"
  | Fin -> Printf.printf "FIN"
  | Entree e -> Printf.printf "ENTREE "; List.iter (fun expr -> print_expression expr; Printf.printf " , ") e
  | Vide -> ()
;;

let print_line {ligne; instr} =
  Printf.printf "%d " ligne;
  print_instruction instr;
  Printf.printf "\n"
;;

let print_program p =
  Array.iter print_line p
;;