open Tds

open Ast
open Type

type t1 = Ast.AstType.programme
type t2 = Ast.AstPlacement.programme

let getType ia =  
  match info_ast_to_info ia with
  | InfoVar (_,t,_,_) -> t
  | _ -> failwith "err"

(* analyse_placement_instrucion : AstType.instruction -> - >int -> string -> int * AstPlacement.instruction *)
(* Paramètre i : l'instruction  à analyser *)
(* Paramètre d : déplacement  *)
(* Paramètre r : le registre dans lequel l'adresse de la variable doit être stockée    *)
(* VFonction récursive pour l'analyse de placement des instructions *)
let rec analyse_placement_instrucion i d r =
  match i with
  |AstType.Declaration(a,e) ->
    modifier_adresse_variable d r a;
    let taille_type =  getType a in
    (getTaille(taille_type),AstPlacement.Declaration(a,e))
  |AstType.Affectation(a,e) -> (0,AstPlacement.Affectation (a, e))
  |AstType.AffichageInt(e) -> (0,AstPlacement.AffichageInt(e))
  |AstType.AffichageBool(e) -> (0,AstPlacement.AffichageBool(e))
  |AstType.AffichageRat(e) -> (0,AstPlacement.AffichageRat(e))
  |AstType.Conditionnelle (e,b1,b2) ->
    let ab1 = analyse_placement_bloc b1 d r in
    let ab2 = analyse_placement_bloc b2 d r in
    (0,AstPlacement.Conditionnelle(e,ab1,ab2))
  |AstType.TantQue(e,b) ->
    let ab = analyse_placement_bloc b d r in
    (0,AstPlacement.TantQue(e,ab))
  |AstType.Retour (e,infofun) ->
    begin
      match (info_ast_to_info infofun) with
      |InfoFun (_,t,ltp) -> 
          let taille_parametres = List.fold_right (fun typ sum -> sum + (getTaille typ)) ltp 0 in
          let taille_retour = getTaille t in
          (0,AstPlacement.Retour (e, taille_retour, taille_parametres))
      |_ -> failwith "error" 
    end
  |AstType.Empty -> (0,AstPlacement.Empty)

  |AstType.For(a1,e1,e2,a2,e3,li) -> 
    modifier_adresse_variable d r a1;
    let nli = analyse_placement_bloc li (d + getTaille(getType a1)) r in 
    (0,AstPlacement.For(a1,e1,e2,a2,e3,nli))

  | AstType.Goto (ia) -> (0,AstPlacement.Goto(ia))
  | AstType.Etiquette (ia) -> (0,AstPlacement.Etiquette(ia))


(* analyse_placement_bloc : AstType.bloc -> - >int -> string-> AstPlacement.instruction * int *)
(* Paramètre li : le bloc  à analyser *)
(* Paramètre d : déplacement  *)
(* Paramètre r : le registre dans lequel l'adresse des  variables doivent être stockée    *)
(* VFonction  pour l'analyse de placement des bloc *)

and analyse_placement_bloc li d r =
  match li with
  |[] -> ([],0)
  |t::q -> 
    let (taille,ai) = (analyse_placement_instrucion t d r) in
    let (airestant,taillebloc) =  (analyse_placement_bloc q (taille + d) r) in
    (ai::airestant,taille+taillebloc)
 
(* analyse_placement_fonction : AstType.fonction ->  AstPlacement.fonction*)
(* Paramètre  : la fonction   à analyser *)

(* VFonction  pour l'analyse de placement des fonctions *)
let analyse_placement_fonction (AstType.Fonction(n,lp,li)) =  
  begin
    let aux p d =( match info_ast_to_info p with
      |InfoVar(_,t,_,_) -> 
        let dep = d - (getTaille t) in
        modifier_adresse_variable dep "LB" p; dep 
      | _ -> failwith "err"
      )
    in  let _ = List.fold_right aux lp 0 in
    let ali = analyse_placement_bloc li 3 "LB" in
    AstPlacement.Fonction(n,lp,ali)
  end
    

(* analyse : AstType.Programme -> AstPlacement.Programme*)
(* Paramètre  : le Programme   à analyser *)

(* VFonction  pour l'analyse de placement du Programme *)

let analyser (AstType.Programme (fonctions,prog)) = 
  let nf = List.map (analyse_placement_fonction) fonctions in
  let nb = analyse_placement_bloc prog 0 "SB" in
  AstPlacement.Programme (nf,nb)
    
