with Ada.Strings;               use Ada.Strings;
with Ada.Text_IO;               use Ada.Text_IO;
with Ada.Integer_Text_IO;       use Ada.Integer_Text_IO;
with Ada.Strings.Unbounded;     use Ada.Strings.Unbounded;
with Ada.Text_IO.Unbounded_IO;  use Ada.Text_IO.Unbounded_IO;
with Ada.Command_Line;          use Ada.Command_Line;
with Ada.Exceptions;            use Ada.Exceptions;
with LCA; use LCA;


procedure routeur_simple is
    function split (Chaine_de_carateres: in Unbounded_String; caratere_limite: in Character;k: in integer) return String is
    type T_Liste is array (1..10) of Unbounded_String;
    Chaine : String := To_String(Trim(Chaine_de_carateres, both));
    c : Integer := 1;
    Liste : T_Liste;
    begin
        for i in Chaine'Range loop
            if Chaine(i) = caratere_limite then
                c := c + 1;
            else
                Append (Liste(c), Chaine(i));
            end if;       
        end loop;
        return To_String(Liste(k));
    end split;

    UN_OCTET: constant T_Adresse_IP := 2 ** 8;       -- 256
    type T_Policy is (FIFO, LFU, LRU);

-- Initialisation des variables pour stocker les options
    Cache_Size : Integer := 10;
    Cache_Policy : T_Policy := FIFO;
    Show_Stats : Boolean := True;
    Table_FileName : Unbounded_String := To_Unbounded_String("table.txt");
    Packets_FileName : Unbounded_String := To_Unbounded_String("paquets.txt");
    Results_FileName : Unbounded_String := To_Unbounded_String("resultats.txt");



    Table_Routage_Fichier : File_Type;	-- Le descripteur du ficher d'entrée
    Paquets_Fichier : File_Type;	-- Le descripteur du ficher d'entrée
    Resultats_Fichier : File_Type;	-- Le descripteur du ficher de sortie
    
    line : Unbounded_String;
    IP1 : T_Adresse_IP;
    Paquet_txt : Unbounded_String;
    Destination_txt : Unbounded_String;
    Masque_txt : Unbounded_String;
    Paquet : T_Adresse_IP;
    Destination : T_Adresse_IP;
    Masque : T_Adresse_IP;
    Sortie : Unbounded_String;
    Table_Routage : T_LCA;
    Arguments_Valides : Boolean := True;
    i : integer := 1;
begin
    IP1 := 147;
    IP1 := IP1 * UN_OCTET + 128;
    while ((i <= Argument_Count) and Arguments_Valides) loop
        
        if Argument(i)  = "-c" then
            begin
            Cache_Size := Integer'Value(Argument(i+1));
            i := i + 2;
            Exception
                when others => 
                    Arguments_Valides:= False;
                    New_Line;
                    Put_Line ("Usage : " & Command_Name & " -c <taille>");
                    New_Line;
                    Put_Line ("Définir la taille du cache. <taille> est la taille du cache. La valeur 0 indique qu’il n y a pas de cache. La valeur par défaut est 10.");
                    New_Line;
            end;
            
        elsif Argument(i)  = "-P" then
            if Argument(i + 1) = "FIFO" then
                i := i + 2;
                Cache_Policy := FIFO;

            elsif Argument(i + 1) = "LFU" then
                i := i + 2;
                Cache_Policy := LFU;
            elsif Argument(i + 1) = "LRU" then
                i := i + 2;
                Cache_Policy := LRU;
            else
                Arguments_Valides:= False;
                    i := i + 2;
                    New_Line;
                    Put_Line ("Usage : " & Command_Name & " -P FIFO|LRU|LFU");
                    New_Line;
                    Put_Line ("Définir la politique utilisée pour le cache (par défaut FIFO)");
                    New_Line;
            end if;
        elsif Argument(i) = "-s" then
            Show_Stats := True;
            i := i + 1;
        elsif Argument(i) = "-S" then
            Show_Stats := False;
            i := i + 1;
        elsif Argument(i) = "-t" then
            Table_FileName := To_Unbounded_String(Argument(i+1));
            i := i + 2;
        elsif Argument(i) = "-p" then
            Packets_FileName := To_Unbounded_String(Argument(i+1));
            i := i + 2;
        elsif Argument(i) = "-r" then
            Results_Filename := To_Unbounded_String(Argument(i+1));
            i := i + 2;
        else
            Arguments_Valides := False;
            New_Line;
            Put_Line ("Usage : " & Command_Name & " [-c <taille>] [-p FIFO|LRU|LFU] ([-s]|[-S]) [-t <fichier>] [-p <fichier>] [-r <fichier>]");
            New_Line;
            Put_Line ("Options :");
            New_Line;
            Put_Line ("-c <taille> : Définir la taille du cache. <taille> est la taille du cache. La valeur 0 indique qu’il n y a pas de cache. La valeur par défaut est 10.");
            New_Line;
            Put_Line ("-p FIFO|LRU|LFU : Définir la politique utilisée pour le cache (par défaut FIFO)");
            New_Line;
            Put_Line ("-s : Afficher les statistiques (nombre de défauts de cache, nombre de demandes de route, taux de défaut de cache). C’est l’option activée par défaut.");
            New_Line;
            Put_Line ("-S : Ne pas afficher les statistiques.");
            New_Line;
            Put_Line ("-t <fichier> : Définir le nom du fichier contenant les routes de la table de routage. Par défaut, on utilise le fichier table.txt.");
            New_Line;
            Put_Line ("-p <fichier> : Définir le nom du fichier contenant les paquets à router. Par défaut, on utilise le fichier paquets.txt.");
            New_Line;
            Put_Line ("-r <fichier> : Définir le nom du fichier contenant les résultats (adresse IP destination du paquet et interface utilisée). Par défaut, on utilise le fichier resultats.txt.");
            New_Line;
        end if;
    end loop;

    

    if Arguments_Valides then
        Create (Resultats_Fichier, Out_File, To_String(Results_FileName));
        Open (Table_Routage_Fichier, In_File, To_String(Table_FileName));
        Open (Paquets_Fichier, In_File, To_String(Packets_FileName));

        Initialiser(Table_Routage);
        begin
            loop
                Get_Line (Table_Routage_Fichier, line);
                
                Destination_txt := To_Unbounded_String(split(line, ' ',1));
                Masque_txt := To_Unbounded_String(split(line, ' ',2));
                Sortie := To_Unbounded_String(split(line, ' ',3));
                Destination := T_Adresse_IP'Value(split(Destination_txt, '.',1));
                Destination := Destination * UN_OCTET + T_Adresse_IP'Value(split(Destination_txt, '.',2));
                Destination := Destination * UN_OCTET + T_Adresse_IP'Value(split(Destination_txt, '.',3));
                Destination := Destination * UN_OCTET + T_Adresse_IP'Value(split(Destination_txt, '.',4));
                
                
                Masque := T_Adresse_IP'Value(split(Masque_txt, '.',1));
                Masque := Masque * UN_OCTET + T_Adresse_IP'Value(split(Masque_txt, '.',2));
                Masque := Masque * UN_OCTET + T_Adresse_IP'Value(split(Masque_txt, '.',3));
                Masque := Masque * UN_OCTET + T_Adresse_IP'Value(split(Masque_txt, '.',4));

                Enregistrer (Table_Routage,Destination ,Masque , Sortie );

                exit when End_Of_File (Table_Routage_Fichier);
            end loop;
        exception
            when End_Error =>
                Put ("Blancs en surplus à la fin du fichier.");
                null;
        end;
        
        begin
            loop
                Get_Line (Paquets_Fichier, Paquet_txt );
                Paquet := T_Adresse_IP'Value(split(Paquet_txt, '.',1));
                Paquet := Paquet * UN_OCTET + T_Adresse_IP'Value(split(Paquet_txt, '.',2));
                Paquet := Paquet * UN_OCTET + T_Adresse_IP'Value(split(Paquet_txt, '.',3));
                Paquet := Paquet * UN_OCTET + T_Adresse_IP'Value(split(Paquet_txt, '.',4));
                Sortie := L_Sortie (Table_Routage, Paquet);
                Put(Resultats_Fichier, Paquet_txt);
                Put(Resultats_Fichier, " ");
                Put(Resultats_Fichier, sortie);
                New_Line (Resultats_Fichier);
                exit when End_Of_File (Paquets_Fichier);
                end loop;
            exception
                when End_Error =>
                    Put ("Blancs en surplus à la fin du fichier.");
                    null;
        end;

        



        Close (Resultats_Fichier);
        Close (Table_Routage_Fichier);
        Close (Paquets_Fichier);
    end if;
end routeur_simple;