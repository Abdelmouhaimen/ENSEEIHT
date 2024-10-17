% Fermer toutes les figures et effacer toutes les variables existantes
close all;
clear all;

% Ajouter les chemins des bibliothèques pour les graphes
addpath('matlab_bgl');      %load graph libraries
addpath('matlab_tpgraphe'); %load tp ressources
addpath('maximalCliques');

% Importer les données depuis la fonction importer_donnees
[Adjs,Distances] = importer_donnees();
keys = keys(Adjs);
for i =  keys
    key = string(i);
    Distances(key) = (Distances(key).^2).*(Adjs(key)) ;
end


%le conteneur pour les matrices  qui contient les plus courts chemins
%pourd'adjacence et de distances, et les portées à considérer 
%chaque ensemble de donnée et pour chaque portée
chemins =containers.Map('KeyType', 'char', 'ValueType', 'any');
nb_chemins = containers.Map('KeyType', 'char', 'ValueType', 'any');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Partie 2 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 

% Définir les portées à considérer

% Définir les fichiers de données
files = ["donnes/topology_low.csv","donnes/topology_avg.csv","donnes/topology_high.csv"];

%%%%%%%%%%%%%%%%%% Question 1
% Degré moyen et coefficient de clustering
for file =1:length(files)
    % Extraire le nom du fichier sans extension qui va etre le nom de la
    % clé de notre conteneur
    namefile = char(files(file));
    indice1 = regexp(namefile, "_");
    indice2 = regexp(namefile, "\.");
    
    fprintf("\n");
    fprintf(namefile +"\n");

    name =string(namefile(indice1+1: indice2-1));
              
     portee = 60000;
     fprintf("la portée :%f\n",portee);
     % clé du conteneur
     indice = name + "_" + portee;
     % recuperer la matrice d'adjacence associée à ce jeu de données
     A = Adjs(indice);
     % on calcule le degrée des noeuds en sommant la ligne associée à chaque noeud
     degree = sum(A);

     %Degré moyen
     degree_moyen = mean(degree);
     fprintf("      Degré moyen des données  : %f\n", degree_moyen);

     % distribution du degré
     degree_distribution = hist(degree, unique(degree));
     % Tracer l'histogramme
     figure;
     bar(unique(degree), degree_distribution);
     xlabel('Degré');
     ylabel('Fréquence');
     title("Distribution du degré des données " + namefile + " pour la portée " + portee);
     grid on;

     % moyenne du degré de clustering
     clustering = clustering_coefficients(sparse(A));
     fprintf('      Moyenne du degré de clustering : %f\n', mean(clustering));


     % distribution du degré de clustering
     % Tracer l'histogramme
     figure;
     histogram(clustering, 'BinEdges', 0:0.05:1, 'EdgeColor', 'black', 'FaceAlpha', 0.7);

     
     %bar(unique(clustering), clustering_distribution,'BarWidth', 20);
     xlabel('degré de clustering');
     ylabel('Fréquence');
     title("Distribution du coefficient de clustering pour les données " + namefile + " pour la portée " + portee);
     grid on;


     
end


%%%%%%%%%%%%%%%%%% Question 2
%Nombre de cliques (et leurs ordres), nombre de composantes connexes (et leurs ordres)
fprintf("\n");
dec = false ;
for file =1:length(files)

    % Extraire le nom du fichier sans extension qui va etre le nom de la
    % clé de notre conteneur
    namefile = char(files(file));
    indice1 = regexp(namefile, "_");
    indice2 = regexp(namefile, "\.");
    name =string(namefile(indice1+1: indice2-1));
    fprintf("\n");
    fprintf(namefile +"\n");
     
     portee = 60000;
     % clé du conteneur
     indice = name + "_" + portee;
     % recuperer la matrice d'adjacence associée à ce jeu de données
     A = Adjs(indice);
     % Nombre de cliques
     [ MC ] = maximalCliques( A );
   
     fprintf("la portée :%f\n",portee);

     %Nombre de cliques (et leurs ordres)
     %Nombre de cliques dans cette matrice est le nombre de colonnes. 
     nb_cliques = size(MC,2);
     % chaque colonne represent un clique au il y'a des 1 et des 0 en 
     % sommant  chaque colonne en trouve l'ordre de chaque clique 
     cliques_ordes = sum(MC,1);
     fprintf ("     nombre de cliques est :%f\n",nb_cliques);
     dec = input('vous voullez afficher l ordre des cliques  ? [o/n]: ', 's');
     if dec == "o"
          fprintf("leurs ordes : ")
          disp(cliques_ordes);
     end


     % nombre des composantes connexes (et leurs ordres)
     [ci ,sizes] = components(sparse(A));
     %The number of connected components is max(components(A))
     nb_compconnexes = max(components(sparse(A)));
     
     fprintf ("     nombre de composantes connexes pour la portée :%f\n",nb_compconnexes);
     dec = input('vous voullez afficher l ordre des composantes connexes  ? [o/n]: ', 's');
     if dec == "o"
        fprintf("leurs ordes : ")
        disp(sizes');
     end

     
end



%%%%%%%%%%%%%%%%%% Question 3
%Longueur des chemins les plus courts, distribution des plus courts chemins et nombre des plus courts
%chemins (en nombre de sauts entre tous les couples de sommets connectés)
fprintf("\n");
for file =1:length(files)

    % Extraire le nom du fichier sans extension qui va etre le nom de la
    % clé de notre conteneur
    namefile = char(files(file));
    indice1 = regexp(namefile, "_");
    indice2 = regexp(namefile, "\.");
    name =string(namefile(indice1+1: indice2-1));

    fprintf(namefile +"\n");
    
     portee = 60000;
     % clé du conteneur
     indice = name + "_" + portee;
     % recuperer la matrice d'adjacence associée à ce jeu de données
     A = Adjs(indice);
     D = Distances(indice);
     % %Longueur des chemins les plus courts, distribution des plus courts chemins et nombre des plus courts
     % %chemins (en nombre de sauts entre tous les couples de sommets connectés)
     
     [D,P] = count_shortest_paths_number_avec_poids(D);

     % % stocker les matrices des plus courts chemins dans un conteneur

     chemins(indice) = D;
     nb_chemins(indice) = P; 
  

     %distribution des plus courts chemins et nombre des plus courts chemins 

      
     %distribution_chemins(end) = distribution_chemins(end) -1;
     figure;
     histogram(D(:));
     xlabel('longueur du chemin');
     ylabel('Fréquence');
     title("distribution des plus courts chemins : " + namefile + "  pour la portée " + portee);
     grid on;



     
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Affichage %%%%%%%%%%%%%%%%%%%%%%%
% demander la longueur de plus court chemin entre i j
% affichage des distances 
option = true;
while option 
    name_file = input('Veuillez entrer le nome des donnees ? [low/avg/high] : ', 's');
    portee = 60000;
    name = name_file + "_" + portee;
    D = chemins(name); 
    source = str2double(input('Veuillez entrer la source : ', 's'));
    destination = str2double(input('Veuillez entrer la destination : ', 's'));
    longeur_chemin = D(source,destination);
    P = nb_chemins(name) ;
    
    if longeur_chemin ~= Inf 

        fprintf ("la longueur  du chemin le plus court entre "+source+" et "+destination+ " est :%f\n",D(source,destination));
        fprintf (" le nombre des plus courts chemins : %f\n",P(source,destination));

    else 
        fprintf("Il n y'a pas de chemin entre "+source+" et " + destination + "\n" );
    end

    dec = input('vous voullez continuer ? [o/n]: ', 's');
    if dec =="n"
        option = false;
    end

end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

