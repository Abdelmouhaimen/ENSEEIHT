(* Module de la passe de gestion des identifiants *)
(* doit être conforme à l'interface Passe *)
open Tds
open Exceptions
open Ast


type t1 = Ast.AstSyntax.programme
type t2 = Ast.AstTds.programme

(* verfieEtiq : string  -> (string * info_ast) list -> (string * info_ast) list *)
(* Paramètre n : Chaîne de caractères représentant l'étiquette à rechercher et retirer *)
(* Paramètre list :  Liste d'éléments où chaque élément est un tuple de la forme (étiquette, information) *)
(*  recherche l'étiquette [n] dans la liste [list] et la retire si présente.*)

let rec verfieEtiq n list =
  match list with 
  |[] -> []
  | t::q -> let (n1,_) =t in if n1 = n then 
    q else t::(verfieEtiq n q)


(* chercheredansliste : string  -> (string * info_ast) list -> Booléen *)
(* Paramètre n : Élément à rechercher dans la liste*)
(* Paramètre list :  Liste d'éléments où chaque élément est un tuple de la forme (étiquette, information) *)
(*  recherche la présence de l'élément [n] dans la liste [list].*)
let rec chercheredansliste n list = 
  match list with
  | [] -> false
  | t::q -> let (n1,_) = t in if n1 = n then
    true else chercheredansliste n q


(* analyse_tds_affectable : tds -> AstSyntax.affectable -> AstTds.affectable *)
(* Paramètre tds : la table des symboles courante *)
(* Paramètre a : l'affectable  à analyser *)
(* Paramètre modif :  indique si l affectable est a gauche ou bien a droite d une instruction *)
(* Vérifie la bonne utilisation des identifiants et tranforme l'affectable
en une affectable de type AstTds.affectable *)
(* Erreur si mauvaise utilisation des identifiants *)

let rec analyse_tds_affectable tds a modif =
  match a with
  |AstSyntax.Ident id -> 
    begin
      match chercherGlobalement tds id with
      |None -> raise (IdentifiantNonDeclare id)
      |Some ia -> (
        match info_ast_to_info ia with
        |InfoVar _ ->  AstTds.Ident ia 
        |InfoFun _ -> raise (MauvaiseUtilisationIdentifiant id)
        |InfoConst _ -> 
          if modif then raise (MauvaiseUtilisationIdentifiant id) else (AstTds.Ident ia)
        |_ -> failwith "err"
      )
    end
  |AstSyntax.Deref aff -> let naff = analyse_tds_affectable tds aff modif in
                AstTds.Deref(naff)
  |AstSyntax.Acces (aff,e) -> 
    let naff = analyse_tds_affectable tds aff modif in
    let ne = analyse_tds_expression tds e in
    AstTds.Acces(naff,ne)
      

(* analyse_tds_expression : tds -> AstSyntax.expression -> AstTds.expression *)
(* Paramètre tds : la table des symboles courante *)
(* Paramètre e : l'expression à analyser *)
(* Vérifie la bonne utilisation des identifiants et tranforme l'expression
en une expression de type AstTds.expression *)
(* Erreur si mauvaise utilisation des identifiants *)
and analyse_tds_expression tds e = match e with 
    |AstSyntax.Booleen (b) -> AstTds.Booleen(b) 
    |AstSyntax.Entier n -> AstTds.Entier n 
    |AstSyntax.Unaire (op,e1) ->
      begin
        let ae = analyse_tds_expression tds e1 in 
        AstTds.Unaire(op,ae)
      end

    |AstSyntax.Binaire(op,e1,e2) ->
      begin
        let ae1 = analyse_tds_expression tds e1 in
        let ae2 = analyse_tds_expression tds e2 in 
        AstTds.Binaire(op,ae1,ae2)
      end
    |AstSyntax.AppelFonction (a,le) -> 
      begin 
        match chercherGlobalement tds a with
        |Some ia -> (match  info_ast_to_info ia with
              |InfoFun _ -> let ale = List.map (analyse_tds_expression tds) le  in
                            AstTds.AppelFonction (ia,ale)
              |_ -> raise (MauvaiseUtilisationIdentifiant a)
              )
        |None -> raise (IdentifiantNonDeclare a)
      end
    |AstSyntax.Null -> AstTds.Null
    |AstSyntax.New t -> AstTds.New t
    |AstSyntax.Adresse a -> 
      begin 
        match chercherGlobalement tds a with
        |Some ia -> (match info_ast_to_info ia with
              |InfoVar _ -> AstTds.Adresse ia
              |_ -> raise (MauvaiseUtilisationIdentifiant a)
              )
        |None ->  raise (IdentifiantNonDeclare a)
      end
    |AstSyntax.Affectable aff -> 
      begin
        let naff =  analyse_tds_affectable tds aff false in
        AstTds.Affectable naff
      end
    |AstSyntax.Newtableau (t , e) -> let ne = analyse_tds_expression tds e in
                          AstTds.Newtableau(t,ne)

    |AstSyntax.Initialisation  le -> let nle = List.map (analyse_tds_expression tds) le in
                            AstTds.Initialisation nle 

 
        
        




(* analyse_tds_instruction : tds -> info_ast option -> AstSyntax.instruction -> AstTds.instruction *)
(* Paramètre tds : la table des symboles courante *)
(* Paramètre oia : None si l'instruction i est dans le bloc principal,
                   Some ia où ia est l'information associée à la fonction dans laquelle est l'instruction i sinon *)
(* Paramètre i : l'instruction à analyser *)
(* Paramètre tdsmaingoto : la tds qui va gerer les etiquettes*) 
(* Paramètre liste : La liste des étiquettes utilisées mais non encore définies*)    
(* Vérifie la bonne utilisation des identifiants et tranforme l'instruction
en une instruction de type AstTds.instruction *)
(* Erreur si mauvaise utilisation des identifiants *)
let rec analyse_tds_instruction tds tdsmaingoto liste oia i =
  match i with
  | AstSyntax.Declaration (t, n, e) ->
      begin
        match chercherLocalement tds n with
        | None ->
            (* L'identifiant n'est pas trouvé dans la tds locale,
            il n'a donc pas été déclaré dans le bloc courant *)
            (* Vérification de la bonne utilisation des identifiants dans l'expression *)
            (* et obtention de l'expression transformée *)
            let ne = analyse_tds_expression tds e in
            (* Création de l'information associée à l'identfiant *)
            let info = InfoVar (n,Undefined, 0, "") in
            (* Création du pointeur sur l'information *)
            let ia = info_to_info_ast info in
            (* Ajout de l'information (pointeur) dans la tds *)
            ajouter tds n ia;
            (* Renvoie de la nouvelle déclaration où le nom a été remplacé par l'information
            et l'expression remplacée par l'expression issue de l'analyse *)
            AstTds.Declaration (t, ia, ne)
        | Some _ ->
            (* L'identifiant est trouvé dans la tds locale,
            il a donc déjà été déclaré dans le bloc courant *)
            raise (DoubleDeclaration n)
      end
  | AstSyntax.Affectation (n,e) ->
      begin
        let na = analyse_tds_affectable tds n true in
        let  ne = analyse_tds_expression tds e in
        AstTds.Affectation(na, ne)
      end
  | AstSyntax.Constante (n,v) ->
      begin
        match chercherLocalement tds n with
        | None ->
          (* L'identifiant n'est pas trouvé dans la tds locale,
             il n'a donc pas été déclaré dans le bloc courant *)
          (* Ajout dans la tds de la constante *)
          ajouter tds n (info_to_info_ast (InfoConst (n,v)));
          (* Suppression du noeud de déclaration des constantes devenu inutile *)
          AstTds.Empty
        | Some _ ->
          (* L'identifiant est trouvé dans la tds locale,
          il a donc déjà été déclaré dans le bloc courant *)
          raise (DoubleDeclaration n)
      end
  | AstSyntax.Affichage e ->
      (* Vérification de la bonne utilisation des identifiants dans l'expression *)
      (* et obtention de l'expression transformée *)
      let ne = analyse_tds_expression tds e in
      (* Renvoie du nouvel affichage où l'expression remplacée par l'expression issue de l'analyse *)
      AstTds.Affichage (ne)
  | AstSyntax.Conditionnelle (c,t,e) ->
      (* Analyse de la condition *)
      let nc = analyse_tds_expression tds c in
      (* Analyse du bloc then *)
      let tast = analyse_tds_bloc tds tdsmaingoto liste oia t in
      (* Analyse du bloc else *)
      let east = analyse_tds_bloc tds tdsmaingoto liste oia e in
      (* Renvoie la nouvelle structure de la conditionnelle *)
      AstTds.Conditionnelle (nc, tast, east)
  | AstSyntax.TantQue (c,b) ->
      (* Analyse de la condition *)
      let nc = analyse_tds_expression tds c in
      (* Analyse du bloc *)
      let bast = analyse_tds_bloc tds tdsmaingoto liste oia b in
      (* Renvoie la nouvelle structure de la boucle *)
      AstTds.TantQue (nc, bast)
  | AstSyntax.Retour (e) ->
      begin
      (* On récupère l'information associée à la fonction à laquelle le return est associée *)
      match oia with
        (* Il n'y a pas d'information -> l'instruction est dans le bloc principal : erreur *)
      | None -> raise RetourDansMain
        (* Il y a une information -> l'instruction est dans une fonction *)
      | Some ia ->
        (* Analyse de l'expression *)
        let ne = analyse_tds_expression tds e in
        AstTds.Retour (ne,ia)
      end
  |AstSyntax.For (t,n1,e1,e2,n2,e3,li) ->
    begin 
      match chercherLocalement tds n1 with
        |Some _  -> raise (DoubleDeclaration n1)
        |None -> 
          let tdsfor = creerTDSFille tds in
          let info = InfoVar (n1,Undefined, 0, "") in
          let ia = info_to_info_ast info in
          (* Ajout de l'information (pointeur) dans la tds *)
          ajouter tdsfor n1 ia;
          begin
            let ne1 =  analyse_tds_expression tdsfor e1 in
            let ne2 =  analyse_tds_expression tdsfor e2 in
            match chercherLocalement tdsfor n2 with
            |None -> raise (IdentifiantNonDeclare n2)
            |Some infoast -> let nli = analyse_tds_bloc tdsfor tdsmaingoto liste  oia li in
              let ne3 =  analyse_tds_expression tdsfor e3 in
              AstTds.For(t,ia,ne1,ne2,infoast,ne3,nli)
          end
    end
  | AstSyntax.Etiquette n -> 
    begin 
      match chercherLocalement tdsmaingoto n with
      | Some _ ->  raise (DoubleDeclaration n)
      | None -> 
        (match (List.assoc_opt n (!liste)) with
        |Some ia -> 
          liste := (verfieEtiq n (!liste)) ;
          ajouter tdsmaingoto n ia ;  
          AstTds.Etiquette ia
        |None -> 
          let info = InfoGoto (n) in 
          let ia = info_to_info_ast info in
          ajouter tdsmaingoto n  ia ; 
          AstTds.Etiquette ia
          ) 
      end 
  | AstSyntax.Goto n   -> 
    match chercherLocalement tdsmaingoto n with 
    |Some ia ->  AstTds.Goto (ia)
    |None ->  
      (match (List.assoc_opt n (!liste)) with 
      |Some info_ast  -> AstTds.Goto info_ast
      |None  -> 
        let infoa = info_to_info_ast (InfoGoto (n)) in liste := (n,infoa)::(!liste);
        AstTds.Goto (infoa)
       )


    


  
    
  


          


(* analyse_tds_bloc : tds -> info_ast option -> AstSyntax.bloc -> AstTds.bloc *)
(* Paramètre tds : la table des symboles courante *)
(* Paramètre oia : None si le bloc li est dans le programme principal,
                   Some ia où ia est l'information associée à la fonction dans laquelle est le bloc li sinon *)
(* Paramètre tdsmaingoto : la tds qui va gerer les etiquettes*) 
(* Paramètre liste : La liste des étiquettes utilisées mais non encore définies*)                 
(* Paramètre li : liste d'instructions à analyser *)
(* Vérifie la bonne utilisation des identifiants et tranforme le bloc en un bloc de type AstTds.bloc *)
(* Erreur si mauvaise utilisation des identifiants *)
and analyse_tds_bloc tds tdsmaingoto liste oia li  =
  (* Entrée dans un nouveau bloc, donc création d'une nouvelle tds locale
  pointant sur la table du bloc parent *)
  let tdsbloc = creerTDSFille tds in
  (* Analyse des instructions du bloc avec la tds du nouveau bloc.
     Cette tds est modifiée par effet de bord *)
   let nli = List.map (analyse_tds_instruction tdsbloc tdsmaingoto liste oia) li in
   (* afficher_locale tdsbloc ; *) (* décommenter pour afficher la table locale *)
   nli


(* analyse_tds_fonction : tds -> AstSyntax.fonction -> AstTds.fonction *)
(* Paramètre tds : la table des symboles courante *)
(* Paramètre : la fonction à analyser *)
(* Vérifie la bonne utilisation des identifiants et tranforme la fonction
en une fonction de type AstTds.fonction *)
(* Erreur si mauvaise utilisation des identifiants *)
let analyse_tds_fonction maintds  (AstSyntax.Fonction(t,n,lp,li)) =
  let tdsfoncgoto = creerTDSMere () in 
  let ma_liste_globale_fonc : (string * info_ast) list ref = ref[] in 
  match chercherGlobalement maintds n with
  |Some _ -> raise (DoubleDeclaration n)
  |None -> 
    begin
      let info= InfoFun (n,Undefined,[]) in
      let tdsbloc = creerTDSFille maintds in
      let info_ast = info_to_info_ast info in
      ajouter maintds n info_ast ;
  
      let alp = List.map (fun (typ,nom) -> 
        match chercherLocalement tdsbloc nom with
          | Some _ -> raise (DoubleDeclaration nom) 
          | None -> let info_p = InfoVar (nom,Undefined,0,"") in
                    let info_ast_p = info_to_info_ast info_p in
                    ajouter  tdsbloc nom info_ast_p;
                    (typ,info_ast_p)) lp
      in let ali = analyse_tds_bloc tdsbloc tdsfoncgoto ma_liste_globale_fonc (Some info_ast) li
      in ((!ma_liste_globale_fonc), AstTds.Fonction(t,info_ast,alp ,ali))
    end
      
    

      

  

(* analyser : AstSyntax.programme -> AstTds.programme *)
(* Paramètre : le programme à analyser *)
(* Vérifie la bonne utilisation des identifiants et tranforme le programme
en un programme de type AstTds.programme *)
(* Erreur si mauvaise utilisation des identifiants *)
let analyser (AstSyntax.Programme (fonctions,prog)) = 
  (* La liste des étiquettes utilisées mais non encore définies  c est une variable globale *)
  let  ma_liste_globale_main : (string * info_ast) list ref = ref[] in 
  let tds = creerTDSMere () in
  let tdsmaingoto =  creerTDSMere () in 
  let (lliste,nf) = List.split (List.map (analyse_tds_fonction tds  ) fonctions) in
  let nb = analyse_tds_bloc tds tdsmaingoto ma_liste_globale_main None prog  in
  let nbetiquettenondeclare_main =  List.length (!ma_liste_globale_main) in 
  let letiq = List.flatten lliste in 
  let nbetiquettenondeclare_foncs = List.length (letiq) in 
  if nbetiquettenondeclare_main = 0  && nbetiquettenondeclare_foncs =0 then 
    AstTds.Programme (nf,nb)
  else 
    let (efoncs,_) = List.split (letiq) in 
    let (emain, _) = List.split (!ma_liste_globale_main) in 
     raise (EtiquetteNonDecalre (efoncs @ emain))

