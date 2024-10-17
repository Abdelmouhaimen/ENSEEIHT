open Tds

open Ast
open AstType
open Type
open AstPlacement
open Code
open Tam

type t1 = Ast.AstPlacement.programme
type t2 = string

(*Analyse de l'affectable 
modif : boolean = false si c'est pas une expression modifiable||  true si une expression ne l'est pas
a :  type affectable
*)
let rec analyse_code_affectable a modif =
  match a with
  |Ident ia -> 
    begin
      match info_ast_to_info  ia with 
      |InfoVar(_, t, dep,reg) ->
        let taille_type =  getTaille t in 
        if modif then 
          let code  = store taille_type dep reg in (t, code)
      else 
        let code = load taille_type dep reg in (t, code)
      |InfoConst (_,n) ->
        let code = loadl_int n in (Int, code )
      |_ -> failwith"error"
      end
  |Deref  aff -> 
    let (t, code ) = analyse_code_affectable aff false in
    let taille_type =  getTaille t in
    if modif then 
      (t, code ^ (storei taille_type))
    else 
      (t, code ^ loadi taille_type)
  |Acces (aff, e) -> 
    begin
      let (t,codeaff) =  analyse_code_affectable aff false  in 
      let (_,code_exp) =  analyse_code_expression e in 
      match t with 
      |Tableau (t1)-> 
        let taille_type =  getTaille t1 in 
        if modif then 
          (t1,(codeaff ^ (loadl_int taille_type) ^ code_exp ^ (subr "IMul") ^ (subr "IAdd") 
          ^ (storei taille_type) ))
        else
          (t1,(codeaff ^ (loadl_int taille_type) ^ code_exp ^ (subr "IMul") ^ (subr "IAdd") 
          ^ (loadi taille_type) ))
        
      | _ -> failwith "err"
      end




(* analyse_code_expression : AstType.expression -> string *)
(*Paramètre  e : l'expression pour laquelle la génération de code est souhaitée :*)
(* Produit le code correspondant à l'expression. L'execution de ce code 
   laissera en sommet de pile le résultat de l'évaluation de cette expression *)

and analyse_code_expression e =
  match e with 
  | AstType.Booleen b ->
    if b then (Bool,loadl_int 1)
    else (Bool, loadl_int 0)
  | AstType.Entier n -> (Int, loadl_int n)
  | AstType.Null -> (Pointeur (Undefined), loadl_int (-1))
  | AstType.New t ->
    let taille_type = getTaille t in 
    (Tableau(t), (loadl_int taille_type) ^ (subr "Malloc"))
  | AstType.Adresse a -> 
    begin 
      match info_ast_to_info a with 
          | InfoVar(_,t,dep,reg)-> (Pointeur (t), loada dep reg)
          | _ -> failwith"error"
    end
  | AstType.Affectable a ->
    let (t,code) = analyse_code_affectable a false in (t,code)
  | AstType.Unaire (u, e1) -> 
    begin
      let (_,code) = analyse_code_expression e1 in
      match u with
      | AstType.Numerateur -> (Int,code ^ (pop 0 1))
      | AstType.Denominateur -> (Int, code ^ (pop 1 1))
    end
  | AstType.Binaire (op,e1,e2) -> 
    begin 
      let  (_,code1) = analyse_code_expression e1 in
      let  (_,code2) =  analyse_code_expression e2 in
      match op with
        | AstType.MultInt -> (Int,code1 ^ code2 ^ subr "IMul")
        | AstType.MultRat -> (Rat,code1 ^ code2 ^ call "SB" "RMul")
        | AstType.PlusInt -> (Int,code1 ^ code2 ^ subr "IAdd")
        | AstType.PlusRat -> (Rat,code1 ^ code2 ^ call "SB" "RAdd")
        | AstType.EquBool -> (Bool, code1 ^ code2 ^ subr "IEq")
        | AstType.Inf -> (Bool, code1 ^ code2 ^ subr "ILss")
        | AstType.EquInt -> (Bool, code1 ^ code2 ^ subr "IEq")
        | AstType.Fraction -> (Rat,code1 ^ code2 ^ call "SB" "norm")
    end

  | AstType.AppelFonction (n, le) ->
    begin
      let (_,code) = List.split ((List.map analyse_code_expression le)) in 
      match info_ast_to_info n with
      | InfoFun(id,t,_) -> (t,(String.concat "" code) ^ call "SB" id)
      | _ -> failwith "Error"
    end

  |Newtableau (t, e) -> 
    begin
      let (_ , code) = analyse_code_expression e in
      let taille = getTaille t in 
      (Tableau (t) ,(code ^ (loadl_int taille) ^ (subr "IMul") ^ (subr "Malloc")))
    end
  |Initialisation le -> 
    begin 
      let (ltype,liste_code) = List.split (List.map (analyse_code_expression) le ) in
      let t = List.hd ltype in 
      let code =  String.concat "" liste_code in 
      let taille_bloc  = (List.length liste_code) * (getTaille t) in 
      (Tableau (t), ((loadl_int taille_bloc) ^ (subr "Malloc") ^ code ^ (loada (-taille_bloc-1) "ST") ^ (loadi (1))
      ^ (storei taille_bloc) ))
    end




         
  


      

      

      
      


  

(* analyse_code_instruction : AstPlacement.instruction -> string *)
(*Paramètre  i : l'instruction pour laquelle la génération de code est souhaitée :*)
(* Produit le code correspondant à l'instruction.*) 

let rec  analyse_code_instruction i =
  match i with 
  | AstPlacement.Affectation(a,e)-> 
    let (_,code1 )= analyse_code_expression e in 
    let (_,code2) = analyse_code_affectable a true in 
    code1 ^ code2   
  | AstPlacement.Declaration(info, e) -> 
    begin
      match info_ast_to_info info with
      | InfoVar (_,t,dep,reg) -> 
                            let (_,code )= analyse_code_expression e in
                            let taille = getTaille t in 
                             push taille ^ code ^ (store taille dep reg) 
      | _ -> failwith "error" 
      end
  | AstPlacement.AffichageBool e -> let (_,code) =  (analyse_code_expression e) in code ^ subr "BOut"
  | AstPlacement.AffichageInt e -> let (_,code) =( analyse_code_expression e) in  code ^ subr "IOut"
  | AstPlacement.AffichageRat e -> let (_,code) =  (analyse_code_expression e) in code ^ call "SB" "ROut" 
  |AstPlacement.Retour(e,res,param) ->  let (_,code) =  (analyse_code_expression e) in code ^ (return res param )
  | AstPlacement.Empty -> ""
  | AstPlacement.TantQue(e, li) ->
    begin
      let (_,cond )=  analyse_code_expression e in 
      let debutTQ = getEtiquette() in 
      let finTQ = getEtiquette() in
      let codeli =  analyse_code_bloc li in
      (label debutTQ) ^ cond ^ (jumpif 0 finTQ) ^ codeli ^ (jump debutTQ) ^ (label finTQ)
    end 
  | AstPlacement.Conditionnelle(e,bif,belse) -> 
    let (_,cond) = analyse_code_expression e in 
    let codeif = analyse_code_bloc bif in
    let codeelse =  analyse_code_bloc belse in 
    let blocelse = getEtiquette() in
    let finIf =  getEtiquette() in 
    (cond ^ (jumpif 0 blocelse) ^ codeif ^ (jump finIf) 
    ^ (label blocelse ) ^ codeelse ^ (label finIf )) 
  | AstPlacement.For(a1,e1,e2,a2,e3,li) -> 
    let code = analyse_code_instruction(AstPlacement.Declaration(a1, e1)) in
    let codebloc =  analyse_code_bloc li  in 
    let (_,cond)  = analyse_code_expression e2 in 
    let codeajout =  analyse_code_instruction (AstPlacement.Affectation(Ident (a2),e3)) in 
    let debutFor =  getEtiquette() in
    let finFor = getEtiquette() in 
    (code ^ (label debutFor) ^ cond ^ (jumpif 0 finFor) ^ 
    codebloc ^ codeajout ^ (jump debutFor) ^ (label finFor) ^
    (pop 0 1))

  | AstPlacement.Goto (ia) ->  
    begin
      match info_ast_to_info ia with 
      |InfoGoto (n) -> (jump n )
      | _ -> failwith "err"
    end
  | AstPlacement.Etiquette(ia) -> 
    begin
      match info_ast_to_info ia with 
      |InfoGoto (n) -> (label n )
      | _ -> failwith "err"
    end

      
(* analyse_code_bloc : AstPlacement.bloc -> string *)
(*Paramètre  i : le bloc pour lequelle la génération de code est souhaitée :*)
(* Produit le code correspondant au bloc.*) 


and analyse_code_bloc (li, taille) = 
  let code = String.concat "" (List.map (analyse_code_instruction) li)
  ^ pop 0 taille in 
  code 

(* analyse_code_fonction : AstPlacement.Fonction -> string *)
(*Paramètre  i : la fonction  pour laquelle la génération de code est souhaitée :*)
(* Produit le code correspondant a la  fonction.*) 
let analyse_code_fonction (AstPlacement.Fonction(n,_,b)) = 
  match info_ast_to_info n with 
  |InfoFun(id, _, _) -> 
  let code = analyse_code_bloc b in
    (label id) ^ "\n" ^ code          
  | _ -> failwith "err"

let analyser (Programme(fonctions, prog)) =
    let codefonc =  String.concat "" (List.map (analyse_code_fonction) fonctions) in
    let codemain = label "main" ^ (analyse_code_bloc prog) ^ halt in 
    
     getEntete() ^ codefonc ^ codemain 
    






    
