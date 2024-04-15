%{

(* Partie recopiee dans le fichier CaML genere. *)
(* Ouverture de modules exploites dans les actions *)
(* Declarations de types, de constantes, de fonctions, d'exceptions exploites dans les actions *)

%}

/* Declaration des unites lexicales et de leur type si une valeur particuliere leur est associee */

%token UL_PACKAGE
%token UL_LEFT_BRACE UL_RIGHT_BRACE


%token UL_LEFT_PAREN 
%token UL_RIGHT_PAREN 
%token UL_DOT 
%token UL_COMMA 
%token UL_SEMICOLON 
%token UL_INTERFACE 
%token UL_EXTENDS 
%token UL_BOOLEAN 
%token UL_INT 
%token UL_VOID 

%token <string> UL_IDENT_INTERFACE 


/* Defini le type des donnees associees a l'unite lexicale */

%token <string> UL_IDENT_PACKAGE

/* Unite lexicale particuliere qui represente la fin du fichier */

%token UL_FIN

/* Type renvoye pour le nom terminal document */
%type <unit> package

/* Le non terminal document est l'axiome */
%start package

%% /* Regles de productions */

package : internal_package UL_FIN { (print_endline "package : internal_package FIN") }

internal_package : UL_PACKAGE UL_IDENT_PACKAGE UL_LEFT_BRACE internal_package_bis UL_RIGHT_BRACE { (print_endline "package : package IDENT_PACKAGE { }") }

internal_package_bis : choixPI {(print_endline "internal_package_bis : choixPI")}
                    | choixPI internal_package_bis {(print_endline "internal_package_bis : choixPI internal_package_bis")}
choixPI : internal_package {(print_endline "choixPI : internal_package")}
        |interface {(print_endline "choixPI : interface")}
interface : UL_INTERFACE UL_IDENT_INTERFACE choixVideEB  UL_LEFT_BRACE boucleMethode UL_RIGHT_BRACE {(print_endline "interface : UL_INTERFACE UL_IDENT_INTERFACE choixVideEB  UL_LEFT_BRACE boucleMethode UL_RIGHT_BRACE")}
choixVideEB : {(print_endline "choixVideEB : Vide")}
            | UL_EXTENDS boucleNomeQualifie {(print_endline "choixVideEB : UL_EXTENDS boucleNomeQualifie")}
boucleNomeQualifie : nomequalifie {(print_endline "boucleNomeQualifie   : nomequalifie")}
                    |nomequalifie UL_COMMA boucleNomeQualifie {(print_endline "boucleNomeQualifie  : nomequalifie UL_COMMA boucleNomeQualifie")}
boucleMethode : {(print_endline "boucleMethode: Vide")}
                |methode boucleMethode {(print_endline "boucleMethode : methode boucleMethode ")}
nomequalifie : boucleIdent UL_IDENT_INTERFACE {(print_endline "nomequalifie: boucleIdent UL_IDENT_INTERFACE")}
boucleIdent : {print_endline "boucleIdent :Vide"}
            |UL_IDENT_PACKAGE UL_DOT boucleIdent {(print_endline "boucleIdent : UL_IDENT_PACKAGE UL_DOT boucleIdent")}
methode : types UL_IDENT_PACKAGE UL_LEFT_PAREN choixVideBouclType UL_RIGHT_PAREN UL_SEMICOLON {(print_endline "methode: types UL_IDENT_PACKAGE UL_LEFT_PAREN choixVideBouclType UL_RIGHT_PAREN UL_SEMICOLON")}
choixVideBouclType : {(print_endline "choixVideBouclType : Vide")}
                    |boucleType {(print_endline "choixVideBouclType :boucleType")}
boucleType : types {(print_endline "boucleType : types")}
            |types UL_COMMA boucleType {(print_endline "boucleType : types UL_COMMA boucleType ")}
types : UL_BOOLEAN {(print_endline "types : UL_BOOLEAN")}
        |UL_INT {(print_endline "types : UL_INT")}
        |UL_VOID {(print_endline "types : UL_VOID")}
        | nomequalifie {(print_endline "types : nomequalifie")}
%%

