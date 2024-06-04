clear;
close all;

% Lecture de l'image u :
u = imread('Images/Lena.jpg');
u = double(u);
[nb_lignes,nb_colonnes,nb_canaux] = size(u);

% Calcul de l'image filtree avec ROF :
epsilon = 0.01;         % Parametre pour garantir la differentiabilite de la variation totale :
lambda = 100;			% Poids de la regularisation
u_filtre = ROF(u,lambda,epsilon);


