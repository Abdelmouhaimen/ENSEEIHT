% Fermer toutes les fenêtres graphiques et effacer toutes les variables
close all;
clear all;

% Ajouter les chemins vers les bibliothèques nécessaires
addpath('matlab_bgl');      %load graph libraries
addpath('matlab_tpgraphe'); %load tp ressources

% Définir les fichiers de données, les conteneurs pour les matrices 
% d'adjacence et de distances, et les portées à considérer
files = ["donnes/topology_low.csv","donnes/topology_avg.csv","donnes/topology_high.csv"];
Adjs =containers.Map('KeyType', 'char', 'ValueType', 'any');
Distances =containers.Map('KeyType', 'char', 'ValueType', 'any');
portees = [20000,40000,60000];

% Parcourir les fichiers
for file =1:length(files)

    % Charger la matrice de données à partir du fichier CSV
    M = csvread(files(file),1,0);

    % Créer des identifiants pour chaque nœud
    id = num2cell(0:(size(M,1)-1));
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
    % Appliquer cmdscale pour obtenir les positions des nœuds
    Y = cmdscale(D);
    pos=Y(:,1:2);

    % Rotation des positions pour aligner la carte avec le nord
    %pos=kamada_kawai_spring_layout(sparse(D));
    %theta=0.95;
    theta=-1.6; %rotation of the map to align it with north
    x = pos(:,1)*cos(theta) + pos(:,2)*sin(theta);
    y = -pos(:,1)*sin(theta) + pos(:,2)*cos(theta); 
    %pos(:,1)=x;
    %pos(:,2)=-y;
    pos(:,1)=-x;%verical flip
    pos(:,2)=y;

    % Extraire le nom du fichier sans extension qui va etre le nom de la
    % clé de notre conteneur
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
        % Visualiser le graphe en utilisant la fonction viz_adj
        viz_adj(D,A,pos,id);
        % Stocker la matrice d'adjacence et la matrice des distances dans les conteneurs
        Adjs(name +"_"+ portee) = A;
        Distances(name +"_"+ portee) = D;
     
    end
end

