open Latsi_ast;;

let fd = Unix.openfile Sys.argv.(1) [Unix.O_RDONLY] 0o644;;
let lexbuf = Lexing.from_channel (Unix.in_channel_of_descr fd);;
let vars = Array.init 26 (fun _ -> 0) ;;
let fin = ref false ;;
let result_tmp = Latsi_parser.program Latsi_lexer.token lexbuf ;;
let ligne = ref 0 ;;
let modifie = ref false ;;
let ordre = Stack.create () ;;

let est_vide program =
  Array.length program = 0 || (Array.for_all (fun {instr; _} -> 
    match instr with
    | Vide | Commentaire _ -> true
    | _ -> false 
  ) program)
;;

let process_instructions program =
  let tbl = Hashtbl.create 50 in
  Array.iter (fun {ligne; instr} ->
    Hashtbl.replace tbl ligne instr
  ) program;
  let final_instr = Hashtbl.fold (fun ligne instr acc ->
    {ligne; instr} :: acc
  ) tbl [] in
  let sorted_instr = List.sort (fun {ligne=l1; _} {ligne=l2; _} -> compare l1 l2) final_instr in
  Array.of_list sorted_instr
;;

let result = process_instructions result_tmp ;;

let entree v =
  Printf.printf "Entrez la valeur de %c : " v ;
  flush stdout;
  let line = Scanf.scanf "%d\n" (fun x -> x) in
  line
;;

let rec find_index arr i idx =
  if idx >= Array.length arr then
    None
  else if arr.(idx).ligne = i then
    Some idx
  else
    find_index arr i (idx + 1)
;;

let rec eval_expression expr =
  match expr with
  | Int i -> i
  | Str _ -> failwith "Les chaines de caracteres ne sont pas gerees pour les expressions arithmetiques."
  | Var v -> vars.((int_of_char (Char.uppercase_ascii v) - int_of_char 'A'))
  | Puissance (e1, e2) -> int_of_float (float_of_int (eval_expression e1) ** float_of_int (eval_expression e2))
  | Fact e -> (
      let rec fact n =
        if n = 0 then 1
        else n * fact (n - 1)
      in
      fact (eval_expression e))
  | Plus (e1, e2) -> (eval_expression e1) + (eval_expression e2)
  | Minus (e1, e2) -> (eval_expression e1) - (eval_expression e2)
  | Mult (e1, e2) -> (eval_expression e1) * (eval_expression e2)
  | Div (e1, e2) ->
        (let num = eval_expression e1 in
        let denom = eval_expression e2 in
        if denom = 0 then failwith "Division par zero"
        else num / denom)
  | Paren e -> eval_expression e
;;

let eval_relop e1 r e2 = 
  match r with
  | Egal -> eval_expression e1 = eval_expression e2
  | Diff -> eval_expression e1 != eval_expression e2
  | PlusPetit -> eval_expression e1 < eval_expression e2
  | PlusGrand -> eval_expression e1 > eval_expression e2
  | PlusPetitEgal -> eval_expression e1 <= eval_expression e2
  | PlusGrandEgal -> eval_expression e1 >= eval_expression e2
;;

let rec eval_instruction instr =
  match instr with
  | Imprime l -> (
      match l with
      | [] -> Printf.printf "\n"
      | h::t -> 
          match h with
          | Str s -> Printf.printf "%s" (String.sub s 1 ((String.length s) - 2) ) ; eval_instruction (Imprime t)
          | _ -> Printf.printf "%d" (eval_expression h) ; eval_instruction (Imprime t)
  )
  | SiAlors(e1, r, e2, i) -> 
    if eval_relop e1 r e2 then eval_instruction i
  | Assigne (v, e) -> 
      let i = int_of_char v - int_of_char 'A' in
      let res = eval_expression e in
      vars.(i) <- res
  | NouvelleLigne -> Printf.printf "\n"
  | Fin -> fin := true
  | Commentaire _ -> ()
  | Entree l -> (
      match l with
      | [] -> ()
      | h::t -> 
        match h with
        | Var v -> vars.((int_of_char v - int_of_char 'A')) <- entree v ; eval_instruction (Entree t)
        | _ -> failwith "Entree : expression non valide"
  )
  | Vavers l -> (
    match find_index result l 0 with
    | Some idx -> ligne := idx; modifie := true
    | None -> failwith "Vavers : ligne non trouvee"
  )
  | Sousroutine i -> (
      Stack.push (!ligne + 1) ordre;  
      ligne := Option.get (find_index result i 0); 
      modifie := true
  )
  | Retourne -> (
    if Stack.is_empty ordre then
      fin := true
    else
      ligne := Stack.pop ordre;
      modifie := true
  )
  | Vide -> ()
  | AssigneList l -> List.iter eval_instruction l
  | TantQue (e1, r, e2, i) -> (
    while eval_relop e1 r e2 do
      List.iter eval_instruction i
    done
  )
;;

let exec program =
  while not !fin && !ligne < Array.length program do
    eval_instruction (program.(!ligne)).instr;
    flush stdout;
    if !modifie then
      modifie := false
    else
      ligne := !ligne + 1;
  done
;;

let () =
  try
    match est_vide result with
    | true -> failwith "Programme vide"
    | false -> ();
    Printf.printf "/----------------------------\\\n";
    Printf.printf "|Programme parse avec succès.|\n";
    Printf.printf "\\----------------------------/\n";
    print_program result;
    Printf.printf "/------------------------------------\\\n";
    Printf.printf "|Debut de l'execution du programme...|\n";
    Printf.printf "\\------------------------------------/\n";
    exec result;
    Printf.printf "/-------------------------------\\\n";
    Printf.printf "|Execution terminee avec succes.|\n";
    Printf.printf "\\-------------------------------/\n";
  with
  | Failure s -> Printf.printf "Erreur : %s\n" s
  | _ -> Printf.printf "Erreur inconnue\n"