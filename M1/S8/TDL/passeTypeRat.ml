open Tds
open Exceptions
open Ast
open Type

type t1 = Ast.AstTds.programme
type t2 = Ast.AstType.programme

let getType info = 
  match info_ast_to_info info with
  | InfoVar (_,t,_,_) -> t
  | InfoConst _ -> Int

  | InfoFun (_,t,_) -> t
  | _ -> failwith "err"

(* analyse_type_affectable : AstTds.affectable -> AstType.affectable *)
(* Paramètre a : l'affectable à analyser *)
(* Vérifie la bonne utilisation des types et tranforme l'affectable
en un affectable de type AstType.affectable *)
(* Erreur si mauvaise utilisation des types *)
let rec  analyse_type_affectable a =
  match a with 
  |AstTds.Ident info -> 
    begin
      match (info_ast_to_info info) with
      | InfoVar(_,t,_,_) -> (t,AstType.Ident(info))
      | InfoConst _ -> (Int,AstType.Ident(info))
      | _ -> failwith ("Internal error")
    end
  |AstTds.Deref aff -> 
    begin
      let (t,naff) = analyse_type_affectable aff in
      match t with
      |Pointeur tp -> (tp , AstType.Deref naff)
      | _ ->  raise (TypeInattendu (t,Pointeur Undefined))
    end
  |AstTds.Acces (aff,e) ->
    begin
      let (t,naff) = analyse_type_affectable aff in
      match t with
      |Tableau t2 -> 
        let (te,ne) = analyse_type_expression e in 
        if est_compatible te Int then 
          (t2,AstType.Acces(naff,ne))
        else 
          raise (TypeInattendu (te,Int))
      |_ -> raise (TypeInattendu (Tableau Undefined,t))
    end
      

(* analyse_type_expression : AstTds.expression -> AstType.expression *)
(* Paramètre e : l'expression à analyser *)
(* Vérifie la bonne utilisation des types et tranforme l'expression
en une expression de type AstType.expression *)
(* Erreur si mauvaise utilisation des types *)
and analyse_type_expression e = 
  match e with
  | AstTds.Entier n -> (Int,AstType.Entier n)
  | AstTds.Booleen b ->(Bool,AstType.Booleen b)
  | AstTds.Affectable a -> 
    let (t,na) = analyse_type_affectable a in
    (t,AstType.Affectable na)
  | AstTds.Unaire (op,e1) -> 
    begin 
      let (t,ae1) = analyse_type_expression e1  in
      if est_compatible t Rat then 
        begin
          match op with
          |AstSyntax.Numerateur -> (Int,AstType.Unaire(AstType.Numerateur,ae1))
          |AstSyntax.Denominateur -> (Int,AstType.Unaire(AstType.Denominateur,ae1)) 
        end
      else raise (TypeInattendu(t,Rat)) 
    end
  |AstTds.Binaire (op,e1,e2) ->
    begin
      let (t1,ae1) = analyse_type_expression e1 in
      let (t2,ae2) = analyse_type_expression e2 in
      match op with 
      |AstSyntax.Fraction -> 
        begin
          match (t1,t2) with
          | (Int,Int) ->  (Rat, AstType.Binaire (Fraction, ae1,  ae2))
          | _ -> raise (TypeBinaireInattendu (Fraction, t1, t2))
        end
      |AstSyntax.Plus -> 
        begin
          match (t1,t2) with
          | (Rat, Rat) -> (Rat, AstType.Binaire (PlusRat, ae1,  ae2))

          | (Int, Int) ->  (Int, AstType.Binaire (PlusInt, ae1,  ae2))
          
          | _ -> raise (TypeBinaireInattendu (Plus, t1, t2))
        end 
      |AstSyntax.Mult -> 
        begin
          match (t1,t2) with
          | (Rat, Rat) -> (Rat, AstType.Binaire (MultRat, ae1,  ae2))
          | (Int, Int) ->  (Int, AstType.Binaire (MultInt, ae1,  ae2))
          
          | _ -> raise (TypeBinaireInattendu (Mult, t1, t2))
        end
      |AstSyntax.Equ ->
        begin
          match (t1,t2) with
          | (Bool, Bool) -> (Bool, AstType.Binaire (EquBool, ae1,  ae2))
          | (Int, Int) ->  (Bool, AstType.Binaire (EquInt, ae1,  ae2))
          | _ -> raise (TypeBinaireInattendu (Equ, t1, t2))
        end
      |AstSyntax.Inf ->
        begin
          match (t1,t2) with
          | (Int, Int) ->  (Bool, AstType.Binaire (Inf, ae1,  ae2))
          | _ -> raise (TypeBinaireInattendu (Inf, t1, t2))
        end
    end
  |AstTds.AppelFonction (i,le) -> 
    begin
      
      let (t,ltp) =  (match info_ast_to_info i with
                    |InfoFun(_,t,ltp) -> (t,ltp)
                    |_ -> failwith "err") in
      let (lta,lpa) = List.split (List.map (analyse_type_expression) le ) in
      if est_compatible_list lta ltp then
        (t,AstType.AppelFonction (i,lpa))
      else
        raise (TypesParametresInattendus(lta,ltp))
    end
  |AstTds.Null -> (Pointeur (Undefined),AstType.Null)
  |AstTds.New t -> (Pointeur(t), AstType.New t)
  |AstTds.Adresse a -> 
    begin
      match info_ast_to_info a with
      |InfoVar(_,t,_,_)-> (Pointeur t ,  AstType.Adresse a)
      | _ -> failwith "err"
    end
  |AstTds.Newtableau (t , e) -> 
    begin
      let (te,ne) = analyse_type_expression  e in
      if est_compatible Int te then 
          (Tableau (t),AstType.Newtableau (t,ne))
      else
        raise (TypeInattendu (Int, te))
      end

  |AstTds.Initialisation le -> 
    begin
      let (lte,lne) = List.split ( List.map (analyse_type_expression) le ) in
      let  check_different_type list =
        match list with
        | [] -> None
        | first_type::rest ->
          let rec aux first_type remaining_list = 
            match remaining_list with
            | [] -> None
            | hd::tl ->
                if est_compatible first_type hd then
                  aux first_type tl
                else
                  Some hd
          in
          aux first_type rest
        in

      match check_different_type lte with
      | None -> (Tableau (List.hd lte),AstType.Initialisation (lne))
      | Some type_elem_inattendu -> raise (TypeInattendu((List.hd lte), type_elem_inattendu))
      end

        

  
(* analyse_type_instruction : AstTds.instruction -> AstType.instruction *)
(* Paramètre i : l'instruction à analyser *)
(* Vérifie la bonne utilisation des types et tranforme l'instruction
en une instruction de type AstTds.expression *)
(* Erreur si les types ne sont pas compatibles *)
let rec analyse_type_instruction i =
  match i with
  |AstTds.Declaration (t,a,e) -> 
    modifier_type_variable t a ;
    let (te,ae) = analyse_type_expression e in
    if est_compatible te t then
      AstType.Declaration(a,ae)
    else
      raise (TypeInattendu(te,t))
  |AstTds.Affectation(a,e) ->
    let (ta,na) = analyse_type_affectable a in
    let (te,ae) = analyse_type_expression e in 
    if est_compatible te ta then 
      AstType.Affectation(na,ae)
    else     
      raise (TypeInattendu(te,ta))
  |AstTds.Affichage e -> 
    begin
      let (te,ae) = analyse_type_expression e in 
      match te with 
      | Int -> AstType.AffichageInt ae 
      | Rat -> AstType.AffichageRat ae
      | Bool -> AstType.AffichageBool ae
      | _ -> raise (Division_by_zero)
    end
  |AstTds.Retour(e,infofun) -> 
    let t = getType infofun in
    let (te,ae) = analyse_type_expression e in
    if est_compatible te t then
      AstType.Retour(ae,infofun)
    else
      raise (TypeInattendu (te,t))
  |AstTds.Conditionnelle(e,bif,belse) -> 
    let (te,ae) =  analyse_type_expression e in
    if est_compatible te Bool then
      let abif = analyse_type_bloc bif in
      let abelse = analyse_type_bloc belse in
      AstType.Conditionnelle(ae,abif,abelse)
    else
      raise (TypeInattendu (te, Bool))
  |AstTds.TantQue(e,b) -> 
    begin
      let (te,ae) =  analyse_type_expression e in
      if est_compatible te Bool then
        let ab =   analyse_type_bloc b in
        AstType.TantQue(ae,ab)
      else
        raise (TypeInattendu (te, Bool))
    end
  |AstTds.Empty -> AstType.Empty
  |AstTds.For(t,a1,e1,e2,a2,e3,li) ->
    begin
        modifier_type_variable t a1 ;
        let (te1,ne1) = analyse_type_expression e1 in
        if est_compatible te1 t then
            let (te2,ne2) = analyse_type_expression e2 in
            if est_compatible te2 Bool then
              let t2 = getType a2 in 
              let (te3,ne3) = analyse_type_expression e3 in
              if est_compatible te3 t2 then 
                let nli = analyse_type_bloc li in
                AstType.For(a1,ne1,ne2,a2,ne3,nli)
              else
                raise (TypeInattendu(te3,t2))
            else
              raise (TypeInattendu(te2,Bool))

        else
          raise (TypeInattendu(te1,t))
      
  
    end
  | AstTds.Goto(ia) -> AstType.Goto(ia)
  | AstTds.Etiquette(ia) -> AstType.Etiquette(ia)


(* analyse_type_bloc : AstTds.bloc -> AstType.bloc *)
(* Paramètre i : le bloc  à analyser *)
(* Vérifie la bonne utilisation des types et tranforme le bloc
en un bloc de type AstType.bloc *)
(* Erreur si les types ne sont pas compatibles *)
and analyse_type_bloc li = 
  let nli=List.map (analyse_type_instruction ) li in
  nli

(* analyse_type_fonction : AstTds.fonction -> AstType.fonction *)
(* Paramètre : la fonction à analyser *)
(* Vérifie la bonne utilisation des types et tranforme la fonction
en une fonction de type AstType.fonction *)
(* Erreur si mauvaise utilisation des identifiants *)
let analyse_type_fonction (AstTds.Fonction(t,n,lp,li)) =
  List.iter (fun (x,y) -> modifier_type_variable x y) lp;
  let lt,lip = List.split lp in modifier_type_fonction t lt n;
  let nli = analyse_type_bloc li in 
  AstType.Fonction (n,lip,nli)

(* analyser : AstTds.Programme -> AstType.Programme *)
(* Paramètre : le programme à analyser *)
(* Vérifie la bonne utilisation des types et tranforme le programme
en un programme de type AstType.Programme *)
(* Erreur si mauvaise utilisation des identifiants *)
let analyser (AstTds.Programme (fonctions,prog)) =
  let nf = List.map (analyse_type_fonction) fonctions in
  let nb = analyse_type_bloc  prog in
  AstType.Programme (nf,nb)




    


      
    
    
