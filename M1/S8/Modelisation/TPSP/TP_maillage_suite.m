%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% CONSEIL : A METTRE DANS UN AUTRE SCRIPT %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear;
close all;


load donnees;
view(3);
% Calcul des faces du maillage à garder

 
% Étape 1 : Construction de la matrice de faces
FACES = [];
n = size(tri, 1);

for i = 1:n
    
        FACES = [ FACES ;
              sort([tri(i,1) tri(i,2) tri(i,3)]) ; ...
              sort([tri(i,2) tri(i,3) tri(i,4)]) ; ...
              sort([tri(i,3) tri(i,4) tri(i,1)]) ; ...
              sort([tri(i,4) tri(i,1) tri(i,2)]) ; ...
              ];
end

% Étape 2 : Tri des faces

FACES = sortrows(FACES,'ascend');
deleted_indices = [] ;
% Étape 3 : Parcours et suppression des faces en double
for i = 1:(size(FACES,1)-1)
    if FACES(i,:) == FACES(i+1,:)
        deleted_indices = [deleted_indices,i,i+1];

    end 
end
deleted_indices = unique(deleted_indices);
FACES(deleted_indices,:) = [];



fprintf('Calcul du maillage final termine : %d faces. \n',size(FACES,1));

%Affichage du maillage final
figure(1);

for i = 1:size(FACES,1)
   hold on
   plot3([X(1,FACES(i,1)) X(1,FACES(i,2))],[X(2,FACES(i,1)) X(2,FACES(i,2))],[X(3,FACES(i,1)) X(3,FACES(i,2))],'r');
   hold on
   plot3([X(1,FACES(i,1)) X(1,FACES(i,3))],[X(2,FACES(i,1)) X(2,FACES(i,3))],[X(3,FACES(i,1)) X(3,FACES(i,3))],'r');
   hold on

   plot3([X(1,FACES(i,3)) X(1,FACES(i,2))],[X(2,FACES(i,3)) X(2,FACES(i,2))],[X(3,FACES(i,3)) X(3,FACES(i,2))],'r');
end
hold off;