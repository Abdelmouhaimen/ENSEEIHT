clear;
close all;
taille_ecran = get(0,'ScreenSize');
L = taille_ecran(3);
H = taille_ecran(4);

% Lecture et affichage de l'image a segmenter :
I = imread('coins.png');
[nb_lignes,nb_colonnes,nb_canaux] = size(I);
if nb_canaux==3
	I = rgb2gray(I);
end
I = double(I);
I = I/max(I(:));
figure('Name','Champ de force externe','Position',[0.1*L,0.1*H,0.9*L,0.7*H]);
subplot(1,3,1);
imagesc(I);
colormap gray;
axis image off;
title('Image a segmenter','FontSize',20);
	


% Champ de force externe  avec Gaussien:
sigma = 5;
T = 3*sigma;
G = fspecial('gaussian',[T,T],sigma);
G_conv_I = conv2(G,I);

% Affichage d'image flou
subplot(1,3,2);
imagesc(G_conv_I);
colormap gray;
axis image off;
title('Image apres filtre gaussien','FontSize',20);

[GI_x,GI_y] = gradient(G_conv_I);
Eext = -(GI_x.*GI_x+GI_y.*GI_y);
[Fx,Fy] = gradient(Eext);

% Normalisation du champ de force externe pour l'affichage :
norme = sqrt(Fx.*Fx+Fy.*Fy);
Fx_normalise = Fx./(norme+eps);
Fy_normalise = Fy./(norme+eps);

% Affichage du champ de force externe :
subplot(1,3,3);
imagesc(I);
colormap gray;
axis image off;
hold on;
pas_fleches = 5;
taille_fleches = 1;
[x,y] = meshgrid(1:pas_fleches:nb_colonnes,1:pas_fleches:nb_lignes);
Fx_normalise_quiver = Fx_normalise(1:pas_fleches:nb_lignes,1:pas_fleches:nb_colonnes);
Fy_normalise_quiver = Fy_normalise(1:pas_fleches:nb_lignes,1:pas_fleches:nb_colonnes);
hq = quiver(x,y,Fx_normalise_quiver,Fy_normalise_quiver,taille_fleches);
set(hq,'LineWidth',1,'Color',[1,0,0]);
title('Champ de force externe elementaire','FontSize',20);
I = G_conv_I;
save force_externe;

