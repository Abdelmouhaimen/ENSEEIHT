clear;
close all;
taille_ecran = get(0,'ScreenSize');
L = taille_ecran(3);
H = taille_ecran(4);

couleurs_classes = [0 0.1250 1.0 ; 0.1750 1.0 0.2250 ; 1.0 1.0 0 ; 1.0 0.3750 0];

% Dimensions de l'image :
nb_lignes = 100;
nb_colonnes = 100;

% Parametres des lois normales :
mu_1 = 40;
sigma_1 = 18;
mu_2 = 100;
sigma_2 = 18;
mu_3 = 160;
sigma_3 = 18;
mu_4 = 220;
sigma_4 = 18;

% Premier segment (fond de l'image) :
I = mu_1+sigma_1*randn(nb_lignes,nb_colonnes);
k_VT = ones(nb_lignes,nb_colonnes);

% Deuxieme segment (disque) :
for i = 1:nb_lignes
	for j = 1:nb_colonnes
		if (i-30)^2+(j-30)^2<600
			I(i,j) = mu_2+sigma_2*randn;
			k_VT(i,j) = 2;
		end
	end
end

% Troisieme segment (carre) :
for i = 1:nb_lignes
	for j = 1:nb_colonnes
		if abs(i-60)<20 & abs(j-40)<20
			I(i,j) = mu_3+sigma_3*randn;
			k_VT(i,j) = 3;
		end
	end
end

% Quatrieme segment (ellipse) :
for i = 1:nb_lignes
	for j = 1:nb_colonnes
		if (i-50)^2+5*(j-70)^2+3*(i-50)*(j-70)<32^2
			I(i,j) = mu_4+sigma_4*randn;
			k_VT(i,j) = 4;
		end
	end
end

% Troncature des niveaux de gris negatifs ou supérieurs a 255 :
I = max(0,I);
I = min(I,255);

% Affichage de l'image :
figure('Name',['Segmentation par classification'],'Position',[0.25*L,0,0.75*L,0.6*H]);
subplot(1,2,1);
imagesc(I);
colormap gray;
axis off;
axis equal;
