clear;
close all;
% Numero d'image utilisee pour le SLIC et la segmentation binaire
N_Image = 1;

% Nombre d'images utilisees
nb_images = 36; 

% chargement des images
for i = 1:nb_images
    if i<=10
        nom = sprintf('images/viff.00%d.ppm',i-1);
    else
        nom = sprintf('images/viff.0%d.ppm',i-1);
    end;
    % im est une matrice de dimension 4 qui contient 
    % l'ensemble des images couleur de taille : nb_lignes x nb_colonnes x nb_canaux 
    % im est donc de dimension nb_lignes x nb_colonnes x nb_canaux x nb_images
    im(:,:,:,i) = imread(nom); 
end;

% Affichage des images
figure; 
subplot(2,2,1); imshow(im(:,:,:,1)); title('Image 1');
subplot(2,2,2); imshow(im(:,:,:,9)); title('Image 9');
subplot(2,2,3); imshow(im(:,:,:,17)); title('Image 17');
subplot(2,2,4); imshow(im(:,:,:,25)); title('Image 25');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% A COMPLETER                                             %
% Calculs des superpixels                                 % 
% Conseil : afficher les germes + les régions             %
% à chaque étape / à chaque itération                     %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
K = 200;
m = 40;
iter_max = 20;
Seuil = 5;
[superpixels,centers] = SLIC(im(:,:,:,N_Image),K,m,iter_max,Seuil);
% ........................................................%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% A COMPLETER                                             %
% Binarisation de l'image à partir des superpixels        %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Sh = 117;
image_binaire = segmentation_binaire (superpixels,centers,Sh);
% ........................................................%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% A FAIRE SI VOUS UTILISEZ LES MASQUES BINAIRES FOURNIS   %
% Chargement des masques binaires                         %
% de taille nb_lignes x nb_colonnes x nb_images           %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ... 
load mask;
for i = 1:nb_images
    im_mask(:,:,i) =(im_mask(:,:,i)==0) ; 
end;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% A DECOMMENTER ET COMPLETER                              %
% quand vous aurez les images segmentées                  %
% Affichage des masques associes                          %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure
subplot(2,2,1); imshow(im_mask(:,:,1)) ; title('Masque image 1');
subplot(2,2,2); imshow(im_mask(:,:,9)) ; title('Masque image 9');
subplot(2,2,3); imshow(im_mask(:,:,17)) ; title('Masque image 17');
subplot(2,2,4); imshow(im_mask(:,:,25)) ; title('Masque image 25');


figure;
for i = 1:nb_images
    %%%Estimation de la fronti`ere
    contour = estimation_frontiere(im_mask(:,:,i)) ;
    % Estimation des points du squelette
    [vx,vy] = voronoi(contour(1:10:end,2), contour(1:10:end,1));
    
    
    
    
    % Filtrer les points sur le squelette
    [new_vx,new_vy] = filtrer_squelette(vx,vy , contour ,im_mask(:,:,i));
    
    subplot(1,2,1);
    imshow(im_mask(:,:,i));
    hold on;
    plot(contour(:,2), contour(:,1), 'g'); 
    hold on ;
    plot(new_vx(1,:),new_vy(1,:), 'm*','MarkerSize', 5);
    hold off;
    title ("les points de l’axe m´edian interne");
    
    %Estimation de la topologie du squelette
    [A,pts] = construire_matrice_adjacence(new_vx,new_vy);
    
    points = [new_vx(1,:)',new_vy(1,:)'];

    subplot(1,2,2)
    imshow(im_mask(:,:,i));
    hold on;
    %gplot(A,pts,"-");
    plot(new_vx,new_vy, 'b','MarkerSize', 3);
    hold off;
    title("L’axe m´edian interne.")
    pause;
    close;
end
% chargement des points 2D suivis 
% pts de taille nb_points x (2 x nb_images)
% sur chaque ligne de pts 
% tous les appariements possibles pour un point 3D donne
% on affiche les coordonnees (xi,yi) de Pi dans les colonnes 2i-1 et 2i
% tout le reste vaut -1
pts = load('viff.xy');
% Chargement des matrices de projection
% Chaque P{i} contient la matrice de projection associee a l'image i 
% RAPPEL : P{i} est de taille 3 x 4
load dino_Ps;

% Reconstruction des points 3D
X = []; % Contient les coordonnees des points en 3D
color = []; % Contient la couleur associee
% Pour chaque couple de points apparies
for i = 1:size(pts,1)
    % Recuperation des ensembles de points apparies
    l = find(pts(i,1:2:end)~=-1);
    % Verification qu'il existe bien des points apparies dans cette image
    if size(l,2) > 1 & max(l)-min(l) > 1 & max(l)-min(l) < 36
        A = [];
        R = 0;
        G = 0;
        B = 0;
        % Pour chaque point recupere, calcul des coordonnees en 3D
        for j = l
            A = [A;P{j}(1,:)-pts(i,(j-1)*2+1)*P{j}(3,:);
            P{j}(2,:)-pts(i,(j-1)*2+2)*P{j}(3,:)];
            R = R + double(im(int16(pts(i,(j-1)*2+1)),int16(pts(i,(j-1)*2+2)),1,j));
            G = G + double(im(int16(pts(i,(j-1)*2+1)),int16(pts(i,(j-1)*2+2)),2,j));
            B = B + double(im(int16(pts(i,(j-1)*2+1)),int16(pts(i,(j-1)*2+2)),3,j));
        end;
        [U,S,V] = svd(A);
        X = [X V(:,end)/V(end,end)];
        color = [color [R/size(l,2);G/size(l,2);B/size(l,2)]];
    end;
end;
fprintf('Calcul des points 3D termine : %d points trouves. \n',size(X,2));

%affichage du nuage de points 3D
figure;
hold on;
for i = 1:size(X,2)
    plot3(X(1,i),X(2,i),X(3,i),'.','col',color(:,i)/255);
end;
axis equal;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% A COMPLETER                  %
% Tetraedrisation de Delaunay  %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
T = DelaunayTri(X(1,:)',X(2,:)', X(3,:)') ;                  

% %A DECOMMENTER POUR AFFICHER LE MAILLAGE
fprintf('Tetraedrisation terminee : %d tetraedres trouves. \n',size(T,1));
%Affichage de la tetraedrisation de Delaunay
figure; %sommets (on pourra utiliser plusieurs barycentres avec diff´erents
%poids de mani`ere `a ce que le barycentre se rapproche successivement de chaque sommet) 
tetramesh(T);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% A DECOMMENTER ET A COMPLETER %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Calcul des barycentres de chacun des tetraedres
poids = [ 1 1 1 1 ; ...
          4 1 1 1 ; ...
          1 4 1 1 ; ...
          1 1 4 1 ; ...
          1 1 1 4 ];
nb_barycentres = size(poids,1);
for i = 1:size(T,1)
    %Calcul des barycentres differents en fonction des poids differents
    %En commencant par le barycentre avec poids uniformes
    Ti = T(i,:);
    Pi = T.X(Ti,:);
    for k=1:nb_barycentres
        C_g(:,i,k) = [(1/sum(poids(k,:)))*sum(Pi.*poids(k,:)',1) 1]'; 
    end
end

% A DECOMMENTER POUR VERIFICATION 
% A RE-COMMENTER UNE FOIS LA VERIFICATION FAITE
% Visualisation pour vérifier le bon calcul des barycentres
% figure;
% for i = 1:nb_images
%    for k = 1:nb_barycentres
%        o = P{i}*C_g(:,:,k);
%        o = o./repmat(o(3,:),3,1);
%        imshow(im_mask(:,:,i));
%        hold on;
%        plot(o(2,:),o(1,:),'rx');
%        pause;
%        close;
%    end
% end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% A DECOMMENTER ET A COMPLETER %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Copie de la triangulation pour pouvoir supprimer des tetraedres
tri=T.Triangulation;
% Retrait des tetraedres dont au moins un des barycentres 
% ne se trouvent pas dans au moins un des masques des images de travail
%Pour chaque barycentre
remov_ind = [];
[row,col] = size(im_mask(:,:,1));
for k=1:nb_barycentres
  for i = 1:nb_images
        o = P{i}*C_g(:,:,k);
        o = o./repmat(o(3,:),3,1);


        for j  = 1:size(o,2)
            if ~ismember(j,remov_ind)
                if (o(1,j)  <= row && o(1,j)>=1)&&((o(2,j)  <= col && o(2,j)>=1))
                    if im_mask(round(o(1,j)),round(o(2,j)),i) == 0
                         remov_ind = [remov_ind, j];
                    end
                end
            end
        end

  end
end
remov_ind = unique(remov_ind);
tri(remov_ind,:)  = [];

% A DECOMMENTER POUR AFFICHER LE MAILLAGE RESULTAT
% Affichage des tetraedres restants
 fprintf('Retrait des tetraedres exterieurs a la forme 3D termine : %d tetraedres restants. \n',size(tri,1));
 figure;
 trisurf(tri,X(1,:),X(2,:),X(3,:));

% Sauvegarde des donnees
save donnees;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% CONSEIL : A METTRE DANS UN AUTRE SCRIPT %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% load donnees;
% Calcul des faces du maillage à garder
% FACES = ...;
% ...

% fprintf('Calcul du maillage final termine : %d faces. \n',size(FACES,1));

% Affichage du maillage final
% figure;
% hold on
% for i = 1:size(FACES,1)
%    plot3([X(1,FACES(i,1)) X(1,FACES(i,2))],[X(2,FACES(i,1)) X(2,FACES(i,2))],[X(3,FACES(i,1)) X(3,FACES(i,2))],'r');
%    plot3([X(1,FACES(i,1)) X(1,FACES(i,3))],[X(2,FACES(i,1)) X(2,FACES(i,3))],[X(3,FACES(i,1)) X(3,FACES(i,3))],'r');
%    plot3([X(1,FACES(i,3)) X(1,FACES(i,2))],[X(2,FACES(i,3)) X(2,FACES(i,2))],[X(3,FACES(i,3)) X(3,FACES(i,2))],'r');
% end;
