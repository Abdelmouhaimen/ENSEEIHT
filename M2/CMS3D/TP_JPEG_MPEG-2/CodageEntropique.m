
% TP Codages JPEG et MPEG-2 - 3SN-M - 2022
                                                                                      
%--------------------------------------------------------------------------
% Fonction de calcul d'entropie binaire
%--------------------------------------------------------------------------
% [poids, H] = CodageEntropique(V_coeff)
%
% sorties : poids = poids du vecteur de donnees encode (en ko)
%           H = entropie de la matrice (en bits/pixel)
% 
% entree  : V_coeff = vecteur contenant les symboles dont on souhaite 
%                     calculer l'entropie (ex : l'image vectorisee)
%--------------------------------------------------------------------------

function [poids, H] = CodageEntropique(V_coeff)
    h = histogram(V_coeff, max(V_coeff) - min(V_coeff) + 1); 
    f = h.Values / length(V_coeff);
    f = f(f > 0);
    H = -sum(f .* log2(f));
    octet = 8;
    ko = octet*1024;
    poids = H * length(V_coeff)/ko;
