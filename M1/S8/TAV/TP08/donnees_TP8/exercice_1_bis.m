clear;
close all;

% Lecture de l'image u :
u = imread('Images/Barbara.png');
u = double(u);
[nb_lignes,nb_colonnes,~] = size(u);

% Calcul du spectre s de l'image u :
%sR = fft2(u(:,:,1));
%sR = fftshift(sR); % Permet de positionner l'origine (0,0) au centre
%sG = fft2(u(:,:,2));
%sG = fftshift(sG);
%sB = fft2(u(:,:,3));
%sB = fftshift(sB);
s = fft2(u);
s = fftshift(s);

% Partition de s_u :
eta = 0.05;
[f_x,f_y] = meshgrid(1:nb_colonnes,1:nb_lignes);
f_x = f_x/nb_colonnes-0.5;
f_y = f_y/nb_lignes-0.5;
selection = 1./(1 + (f_x.^2 + f_y.^2)/eta);

% Calcul du spectre filtre :
s_filtre = selection.*s;

% Calcul de l'image filtree :
u_filtre = real(ifft2(ifftshift(s_filtre)));

% Mise en place de la figure pour affichage :
taille_ecran = get(0,'ScreenSize');
L = taille_ecran(3);
H = taille_ecran(4);
figure('Name','Decomposition par modification du spectre','Position',[0.2*L,0,0.8*L,H]);

% Affichage des images u, u_filtre et u-u_filtre :
subplot(2,3,1);
affichage(u,'$x$','$y$','Image');
subplot(2,3,2);
affichage(u_filtre,'$x$','$y$','Image filtree');
subplot(2,3,3);
affichage(u-u_filtre,'$x$','$y$','Image complementaire');

% Affichage du logarithme du module des spectres s, s_filtre et s-s_filtre :
subplot(2,3,4);
affichage(log(abs(s)),'$f_x$','$f_y$','Spectre');
subplot(2,3,5);
affichage(log(abs(s_filtre)),'$f_x$','$f_y$','Spectre filtre');
subplot(2,3,6);
affichage(log(abs(s-s_filtre)),'$f_x$','$f_y$','Spectre complementaire');
