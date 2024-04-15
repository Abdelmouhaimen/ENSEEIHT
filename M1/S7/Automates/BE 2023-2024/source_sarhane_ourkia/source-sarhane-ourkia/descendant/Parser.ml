open Tokens

(* Type du résultat d'une analyse syntaxique *)
type parseResult =
  | Success of inputStream
  | Failure
;;

(* accept : token -> inputStream -> parseResult *)
(* Vérifie que le premier token du flux d'entrée est bien le token attendu *)
(* et avance dans l'analyse si c'est le cas *)
let accept expected stream =
  match (peekAtFirstToken stream) with
    | token when (token = expected) ->
      (Success (advanceInStream stream))
    | _ -> Failure
;;

(* accept : token -> inputStream -> parseResult *)
(* Vérifie que le premier token du flux d'entrée est bien le token attendu *)
(* et avance dans l'analyse si c'est le cas *)
let acceptPackageIdent stream =
  match (peekAtFirstToken stream) with
    | UL_PACKAGE_IDENT _ ->
      (Success (advanceInStream stream))
    | _ -> Failure
;;

let acceptInterfaceIdent stream =
  match (peekAtFirstToken stream) with
    | UL_INTERFACE_IDENT _ ->
      (Success (advanceInStream stream))
    | _ -> Failure
;;

(* Définition de la monade  qui est composée de : *)
(* - le type de donnée monadique : parseResult  *)
(* - la fonction : inject qui construit ce type à partir d'une liste de terminaux *)
(* - la fonction : bind (opérateur >>=) qui combine les fonctions d'analyse. *)

(* inject inputStream -> parseResult *)
(* Construit le type de la monade à partir d'une liste de terminaux *)
let inject s = Success s;;

(* bind : 'a m -> ('a -> 'b m) -> 'b m *)
(* bind (opérateur >>=) qui combine les fonctions d'analyse. *)
(* ici on utilise une version spécialisée de bind :
   'b  ->  inputStream
   'a  ->  inputStream
    m  ->  parseResult
*)
(* >>= : parseResult -> (inputStream -> parseResult) -> parseResult *)
let (>>=) result f =
  match result with
    | Success next -> f next
    | Failure -> Failure
;;


(* parseMachine : inputStream -> parseResult *)
(* Analyse du non terminal Programme *)
let rec parsePackage stream =
  (print_string "Package -> ");
  (match (peekAtFirstToken stream) with
   | UL_PACKAGE ->
      (print_endline "package UL_PACKAGE_IDENT { E SE }");
      ((inject stream) >>=
        (accept UL_PACKAGE) >>=
        acceptPackageIdent >>=
        (accept UL_LEFT_BRACE) >>=
        parseE >>=
        parseSE >>=
        (accept UL_RIGHT_BRACE))
   | _ -> Failure)


and parseSE stream = 
  (print_string "SE -> ");
  (match (peekAtFirstToken stream) with
    | UL_RIGHT_BRACE ->
        (print_endline "");
        (inject stream)
    | (UL_PACKAGE | UL_INTERFACE) ->
        (print_endline "E SE");
        ((inject stream) >>=
        parseE >>=
        parseSE)
    | _ -> Failure)


and parseE stream =
  (print_string "E -> ");
  (match (peekAtFirstToken stream) with
    | UL_PACKAGE ->
        (print_endline "P");
        ((inject stream) >>=
        parsePackage)
    | UL_INTERFACE ->
        (print_endline "I");
        ((inject stream) >>=
        parseI)
    | _ -> Failure)

and parseI stream = 
  (print_string "I -> ");
  (match (peekAtFirstToken stream) with
   | UL_INTERFACE ->
      (print_endline "interface UL_INTERFACE_IDENT X { SM }");
      ((inject stream) >>=
        (accept UL_INTERFACE) >>=
        acceptInterfaceIdent >>=
        parseE >>=
        (accept UL_LEFT_BRACE) >>=
        parseSM >>=
        (accept UL_RIGHT_BRACE))
   | _ -> Failure)


and parseX stream =
  (print_string "X -> ");
  (match (peekAtFirstToken stream) with
    | UL_LEFT_BRACE ->
      (print_endline "");
      (inject stream)
    | UL_EXTENDS ->
      (print_endline "extends Q UL_INTERFACE_IDENT SQ");
      ((inject stream) >>=
        (accept UL_EXTENDS) >>=
        parseQ >>=
        acceptInterfaceIdent >>=
        parseSQ)
    | _ -> Failure)


and parseQ stream =
  (print_string "Q -> ");
  (match (peekAtFirstToken stream) with
    | UL_INTERFACE_IDENT _ ->
      (print_endline "");
      (inject stream)
    | UL_PACKAGE_IDENT _ ->
      (print_endline "UL_PACKAGE_IDENT UL_DOT Q");
      ((inject stream) >>=
        acceptPackageIdent >>=
        (accept UL_DOT) >>=
        parseQ)
    | _ -> Failure)


and parseSQ stream =
  (print_string "SQ -> ");
  (match (peekAtFirstToken stream) with
    | UL_LEFT_BRACE ->
      (print_endline "");
      (inject stream)
    | UL_COMMA ->
      (print_endline "UL_COMMA Q UL_INTERFACE_IDENT SQ");
      ((inject stream) >>=
      (accept UL_COMMA) >>=
      parseQ >>=
      acceptInterfaceIdent >>=
      parseSQ)
    | _ -> Failure)


and parseSM stream =
  (print_string "SM -> ");
  (match (peekAtFirstToken stream) with
    | UL_RIGHT_BRACE ->
      (print_endline "");
      (inject stream)
    | (UL_BOOLEAN | UL_INT | UL_VOID | (UL_INTERFACE_IDENT _) | (UL_PACKAGE_IDENT _)) ->
      (print_endline "M SM");
      ((inject stream) >>=
      parseM >>=
      parseSM)
    | _ -> Failure)



and parseM stream =
  (print_string "M -> ");
  (match (peekAtFirstToken stream) with
    | (UL_BOOLEAN | UL_INT | UL_VOID | (UL_INTERFACE_IDENT _) | (UL_PACKAGE_IDENT _)) ->
      (print_endline "T UL_PACKAGE_IDENT UL_LEFT_PAREN O UL_RIGHT_PAREN");
      ((inject stream) >>=
      acceptPackageIdent >>=
      (accept UL_LEFT_PAREN) >>=
      parseO >>=
      (accept UL_RIGHT_PAREN))
    | _ -> Failure)


and parseO stream = 
  (print_string "O -> ");
  (match (peekAtFirstToken stream) with
    | UL_RIGHT_PAREN ->
      (print_endline "");
      (inject stream)
    | (UL_BOOLEAN | UL_INT | UL_VOID | (UL_INTERFACE_IDENT _) | (UL_PACKAGE_IDENT _)) ->
      (print_endline "T ST");
      ((inject stream) >>=
      parseT >>=
      parseST >>=
      (accept UL_RIGHT_PAREN))
    | _ -> Failure)


and parseST stream = 
  (print_string "ST -> ");
  (match (peekAtFirstToken stream) with
    | UL_RIGHT_PAREN ->
      (print_endline "");
      (inject stream)
    | UL_COMMA ->
      (print_endline "UL_COMMA T ST");
      ((inject stream) >>=
      accept UL_COMMA >>=
      parseT >>=
      parseST >>=
      (accept UL_RIGHT_PAREN))
    | _ -> Failure)


and parseT stream =
  (print_string "ST -> ");
  (match (peekAtFirstToken stream) with
    | UL_BOOLEAN ->
      (print_endline "UL_BOOLEAN");
      ((inject stream) >>=
      accept UL_BOOLEAN)
    | UL_INT ->
      (print_endline "UL_INT");
      ((inject stream) >>=
      accept UL_INT)
    | UL_VOID ->
      (print_endline "UL_VOID");
      ((inject stream) >>=
      accept UL_VOID)
    | ((UL_INTERFACE_IDENT _) | (UL_PACKAGE_IDENT _)) ->
      (print_endline "Q UL_INTERFACE_IDENT");
      ((inject stream) >>=
      parseQ >>=
      acceptInterfaceIdent)
    | _ -> Failure)
