with Ada.Text_IO.Unbounded_IO;  use Ada.Text_IO.Unbounded_IO;
with Ada.Text_IO;  use Ada.Text_IO;
with Ada.Integer_Text_IO;    use Ada.Integer_Text_IO;
with SDA_Exceptions;         use SDA_Exceptions;
with Ada.Unchecked_Deallocation;

package body LCA is
	UN_OCTET: constant T_Adresse_IP := 2 ** 8; 
	procedure Free is
		new Ada.Unchecked_Deallocation (Object => T_Cellule, Name => T_LCA);


	procedure Initialiser(Sda: out T_LCA) is
	begin
		Sda := Null;
	end Initialiser;


	function Est_Vide (Sda : T_LCA) return Boolean is
	begin
		return Sda = Null;
	end;


	function Taille (Sda : in T_LCA) return Integer is
	begin
		if Sda = Null then
		    return 0;
		else
		    return 1 + Taille(Sda.all.suivant);
		end if;
	end Taille;


	procedure Enregistrer (Sda : in out T_LCA ; Destination : in T_Adresse_IP ; Masque : in T_Adresse_IP; Sortie : in Unbounded_String) is
	
	Nouvelle_Cellule: T_LCA;
	begin
		if Sda = Null then
		    Nouvelle_Cellule := new T_Cellule;
		    Nouvelle_Cellule.all.Destination := Destination;
		    Nouvelle_Cellule.all.Masque := Masque;
			Nouvelle_Cellule.all.Sortie := Sortie;
		    Nouvelle_Cellule.all.Suivant := Null;
		    Sda := Nouvelle_Cellule;
		else
		    if Sda.all.Destination = Destination then
		        Sda.all.Masque := Masque;
				Sda.all.Sortie := Sortie;
		    else
		        Enregistrer(Sda.all.Suivant, Destination, Masque, Sortie);
		    end if;
		end if;
	end Enregistrer;




	function L_Sortie (Sda : in T_LCA ; Paquet : in T_Adresse_IP) return Unbounded_String is
	Aux : T_LCA := Sda;
	Masque : T_Adresse_IP;
	Sortie : Unbounded_String := To_Unbounded_String("");
	UN_OCTET: constant T_Adresse_IP := 2 ** 8;
	begin
		Masque := 0;
		Masque := Masque * UN_OCTET + 0; 
		Masque := Masque * UN_OCTET + 0;
		Masque := Masque * UN_OCTET + 0;
		while Aux /= Null loop
			if (Paquet and Aux.all.Masque) = Aux.all.Destination then
				if Aux.all.Masque >= Masque then
					Masque := Aux.all.Masque;
					Sortie := Aux.all.Sortie;
				end if;
			end if;
			Aux := Aux.all.Suivant;
		end loop;
		
		

		return Sortie;
	end L_Sortie;


	--procedure Supprimer (Sda : in out T_LCA ; Cle : in T_Cle) is
	
	--A_Detruire : T_LCA;
	--begin
		--if Sda = Null then
		    --raise Cle_Absente_Exception;
		--else
		    --if Sda.all.Cle = Cle then

	            --A_Detruire := Sda;
	            --Sda := Sda.all.Suivant;
	            --Free (A_Detruire);

		    --else
		        --Supprimer(Sda.all.SUivant, Cle);
		    --end if;
		--end if;
	--end Supprimer;


	--procedure Vider (Sda : in out T_LCA) is
	--begin
		--if Sda /= Null then
			--Vider (Sda.all.Suivant);
			--Free (Sda);
		--else
			--Null;
		--end if;
	--end Vider;


	procedure Pour_Chaque (Sda : in T_LCA) is
	begin
		if Sda /= Null then
			begin
		    	--Traiter (Sda.all.Cle, Sda.all.Donnee);
				Put (Natural ((Sda.all.Destination / UN_OCTET ** 3) mod UN_OCTET), 1); Put (".");
				Put (Natural ((Sda.all.Destination / UN_OCTET ** 2) mod UN_OCTET), 1); Put (".");
				Put (Natural ((Sda.all.Destination / UN_OCTET ** 1) mod UN_OCTET), 1); Put (".");
				Put (Natural  (Sda.all.Destination mod UN_OCTET), 1);
				Put(" ");
				Put (Natural ((Sda.all.Masque / UN_OCTET ** 3) mod UN_OCTET), 1); Put (".");
				Put (Natural ((Sda.all.Masque / UN_OCTET ** 2) mod UN_OCTET), 1); Put (".");
				Put (Natural ((Sda.all.Masque / UN_OCTET ** 1) mod UN_OCTET), 1); Put (".");
				Put (Natural  (Sda.all.Masque mod UN_OCTET), 1);
				Put(" ");
				Put(Sda.all.Sortie);
				New_Line;
		    	Pour_Chaque (Sda.all.Suivant);
		    exception
		    	when others => Null;
		    end;
		else
		   Null;
		end if;
		
	end Pour_Chaque;


end LCA;
