{

(* Partie recopiée dans le fichier CaML généré. *)
(* Ouverture de modules exploités dans les actions *)
(* Déclarations de types, de constantes, de fonctions, d'exceptions exploités dans les actions *)

  open Parser 
  exception LexicalError

}

(* Déclaration d'expressions régulières exploitées par la suite *)
let chiffre = ['0' - '9']
let minuscule = ['a' - 'z']
let majuscule = ['A' - 'Z']
let alphabet = minuscule | majuscule
let alphanum = alphabet | chiffre | '_'
let commentaire =
  (* Commentaire fin de ligne *)
  "#" [^'\n']*

rule lexer = parse
  | ['\n' '\t' ' ']+					{ (lexer lexbuf) }
  (*| commentaire						{ (lexer lexbuf) }*)
  | "{"							{ UL_LEFT_BRACE }
  | "}"							{ UL_RIGHT_BRACE }
  | "package"						{ UL_PACKAGE }
  
  | "(" {UL_LEFT_PAREN}
  | ")" {UL_RIGHT_PAREN}
  | "." {UL_DOT}
  | "," { UL_COMMA}
  | ";" { UL_SEMICOLON}
 
  | "interface" {UL_INTERFACE}
  | "extends" {UL_EXTENDS}
  | "boolean" {UL_BOOLEAN}
  | "int" {UL_INT}
  | "void" {UL_VOID}

  | ['A' - 'Z']['a' - 'z''A' - 'Z']* as texte { UL_IDENT_INTERFACE texte }

  | minuscule alphabet* as name                         { UL_IDENT_PACKAGE name }
  | eof							{ UL_FIN }
  | _ as texte				 		{ (print_string "Erreur lexicale : ");(print_char texte);(print_newline ()); raise LexicalError }

{

}
