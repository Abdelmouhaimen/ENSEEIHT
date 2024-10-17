function [outputArg1,outputArg2] = importer_donnees()

% Définir les noms de fichiers
files = ["donnes/topology_low.csv","donnes/topology_avg.csv","donnes/topology_high.csv"];

% Initialiser des conteneurs pour stocker les matrices d'adjacence et de distances
Adjs =containers.Map('KeyType', 'char', 'ValueType', 'any');
Distances =containers.Map('KeyType', 'char', 'ValueType', 'any');

% Définir les portées à considérer
portees = [20000,40000,60000];

% Parcourir les fichiers
for file =1:length(files)
    % Lire la matrice à partir du fichier CSV (en sautant la première ligne)
    M = csvread(files(file),1,0);
    
    % Obtenir le nombre de nœuds dans le graph
    n = size(M,1);
    
    % Initialiser la matrice des distances
    D = zeros(n,n);

    % Extraire les coordonnées des nœuds
    M = M(:,2:4);
    
    % Calculer les distances entre les nœuds
    for i= 1:n
        dx = (M(i,1) - M(:,1)).^2;
        dy = (M(i,2) - M(:,2)).^2;
        dz = (M(i,3) - M(:,3)).^2;
        ligne = sqrt(dx+dy+dz);
        D(i,:) = ligne'; 
    end
    % Extraire le nom du fichier sans extension
    namefile = char(files(file));
    indice1 = regexp(namefile, "_");
    indice2 = regexp(namefile, "\.");
    name =string(namefile(indice1+1: indice2-1));

     % Parcourir les différentes portées
    for k=1:length(portees)
        portee = portees(k);
        % Créer la matrice d'adjacence en fonction de la portée
        A = D <= portee;
        % Changer la diagonalle pour mettre des zeros à la place des 1 
        A(1:size(A, 1) + 1:end) = zeros(1,n);

        % Stocker la matrice d'adjacence et la matrice des distances dans les conteneurs
        Adjs(name +"_"+ portee) = A;
        Distances(name +"_"+ portee) = D;
     
    end
end

 % Renvoyer les conteneurs en sortie de la fonction
 outputArg1 = Adjs;
 outputArg2 = Distances;
end

