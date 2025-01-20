
% TP Codages JPEG et MPEG-2 - 3SN-M - 2022

%--------------------------------------------------------------------------
% Prediction de l'image courante avec l'image de reference et le mouvement
%--------------------------------------------------------------------------
% Ip = PredictionImage(Ir,MVr)
%
% sortie  : Ip = image predictive
%           
% entrees : Ir = image de reference
%           MVr = matrice des vecteurs de déplacements relatifs
%--------------------------------------------------------------------------

function Ip = PredictionImage(Ir,MVr)
    [h,w] = size(Ir);
    taille_bloc = 16;
    nb_blocs_x = floor(h / taille_bloc);
    nb_blocs_y = floor(w / taille_bloc);
    for i = 1:nb_blocs_x
        for j = 1:nb_blocs_y
            coordx = (i-1)*taille_bloc + 1;
            coordy = (j-1)*taille_bloc + 1;
            Vp = MVr(i , j, : );
            Ip(coordx:coordx+taille_bloc-1, coordy:coordy+taille_bloc-1)  = Ir(coordx + Vp(1) : coordx+ (Vp(1) + taille_bloc-1) , coordy+ Vp(2) : coordy+(Vp(2) + taille_bloc-1));
        end
    end


end
