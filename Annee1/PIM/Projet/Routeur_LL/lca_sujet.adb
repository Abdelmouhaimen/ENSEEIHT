with Ada.Text_IO;           use Ada.Text_IO;
with Ada.Integer_Text_IO;   use Ada.Integer_Text_IO;
with SDA_Exceptions; 		use SDA_Exceptions;


with LCA;

procedure Test_LCA is

	package LCA_String_Integer is
		new LCA (T_Cle => Integer, T_Donnee => Integer);
	use LCA_String_Integer;





	procedure Afficher (S : Integer; N: in Integer) is
	begin
		Put (S);
		Put ("^2 = ");
		Put (N, 1);
		New_Line;
	end Afficher;

	-- Afficher la Sda.
	procedure Afficher is
		new Pour_Chaque (Afficher);
    
    Carre : T_LCA;
begin
	Initialiser (Carre);
	
	Afficher (Carre);
    Put("-------------------------------------");
	New_Line;
	
	Pragma Assert(Est_Vide (Carre));
	Pragma Assert( Taille (Carre) = 0);
	
	Enregistrer (Carre, 1 , 1 );
	Afficher (Carre);
	Put("-------------------------------------");
	New_Line;
	
	
	Pragma Assert( Cle_Presente(Carre, 1) );
	
	Pragma Assert( La_Donnee (Carre, 1) = 1);
	
	Supprimer (Carre, 1);
	Pragma Assert(Est_Vide (Carre));
	Pragma Assert( Taille (Carre) = 0);
	
	Enregistrer (Carre, 2 , 4 );
	Enregistrer (Carre, 3 , 9 );
	Afficher (Carre);
	
	Vider (Carre);
	Pragma Assert(Est_Vide (Carre));
	Pragma Assert( Taille (Carre) = 0);
	
	
	
	Put_Line ("Fin de scenario: OK.");
end Test_LCA;
