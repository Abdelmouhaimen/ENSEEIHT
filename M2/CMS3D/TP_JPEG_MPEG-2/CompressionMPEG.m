
% TP Codages JPEG et MPEG-2 - 3SN-M - 2022

%--------------------------------------------------------------------------
% Fonction d'encodage MPEG d'une image (+ reference en JPEG)
%--------------------------------------------------------------------------
% [IRes_Codee,MVdr,Ir_Codee,Poids,Compression] = ...
%        CompressionMPEG(Ic_Originale,Ir_Originale,canal,methode,F_Qualite)
%
% sorties : IRes_Codee = image residuelle (DCT quantifiee)
%           MVdr = matrice des vecteurs de deplacements relatifs
%           Ir_Codee = image de reference (DCT quantifiee)
%           Poids = poids de l'image en ko pour les differentes etapes de 
%                   la compression (inclure les mouvements pour MPEG)
%           Compression = taux de compression final
% 
% entrees : Ic_Originale = image courante originale
%           Ir_Originale = image de reference originale
%           canal = canal pour le choix de la table de quantification :
%                   'Luminance', 'Chrominance' ou 'Residu'
%           methode = methode de calcul de la DCT : 'Matlab' ou 'Rapide'
%           F_Qualite = facteur de qualite pour la compression
%--------------------------------------------------------------------------
% Fonctions a coder/utiliser : EstimationMouvement.m
%                              PredictionImage.m
%                              CompressionJPEG.m
%--------------------------------------------------------------------------

function [IRes_Codee,MVdr,Ir_Codee,Poids,Compression] = ...
         CompressionMPEG(Ic_Originale,Ir_Originale,canal,methode,F_Qualite)
    MVdr = EstimationMouvement(Ic_Originale, Ir_Originale);
    Ip = PredictionImage(Ir_Originale, MVdr);
    IRes = Ic_Originale - Ip;

    [Ir_Codee,~,~,~,~] = CompressionJPEG(Ir_Originale, canal, methode, F_Qualite);

    [IRes_Codee,Poids_Res,~,~,~] = CompressionJPEG(IRes, 'Residu', methode, F_Qualite);


    [Poids.MVdr, ~] = CodageEntropique(MVdr(:));
    [h, w] = size(Ic_Originale);
    Poids_Original = h * w * 8; % Poids initial en bits (taille brute)
    Poids.Origine = Poids_Original / (8 * 1024); % Conversion en Ko
    Poids.H_MPEG = Poids_Res.H_JPEG + Poids.MVdr;
    
    Compression = (1 - Poids.Origine /Poids.H_MPEG)*100;


end
