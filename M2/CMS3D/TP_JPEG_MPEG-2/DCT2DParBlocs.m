
% TP Codages JPEG et MPEG-2 - 3SN-M - 2022
                                               
%--------------------------------------------------------------------------
% Fonction de transformee (directe et inverse) en cosinus discrete par blocs
%--------------------------------------------------------------------------
% I_DCT = DCT2DParBlocs(sens,I,methode,taille_bloc)
%
% sortie  : I_DCT = image de la DCT ou IDCT par blocs
% 
% entrees : sens = sens pour la DCT : 'Direct' ou 'Inverse'
%           I = image avant DCT ou IDCT par blocs
%           methode = methode de calcul de la DCT : 'Matlab' ou 'Rapide'
%           taille_bloc = taille des blocs pour la DCT (ici 8x8)
%--------------------------------------------------------------------------

function I_DCT = DCT2DParBlocs(sens,I,methode,taille_bloc)
    [n,m] = size(I);
    I_DCT = zeros(n,m);
    
    for i = 1:taille_bloc:n
        for j = 1:taille_bloc:m
            bloc = I(i:i+(taille_bloc-1), j:j+(taille_bloc-1));
            if sens == "Direct"
                if methode == "Matlab"
                    bloc_transforme = dct2(bloc);
                elseif methode == "Rapide"
                    bloc_transforme = DCT2Rapide(bloc, taille_bloc);
                end
            elseif sens == "Inverse"
                if methode == "Matlab"
                    bloc_transforme = idct2(bloc);
                elseif methode == "Rapide"
                    bloc_transforme = IDCT2Rapide(bloc, taille_bloc);
                end
            end
            I_DCT(i:i+(taille_bloc-1), j:j+(taille_bloc-1)) = bloc_transforme;
        end
    end


end
  
%--------------------------------------------------------------------------
% Fonction de calcul de transformee en cosinus discrete rapide 
% pour un bloc de taille 8x8
%--------------------------------------------------------------------------
% Bloc_DCT2 = DCT2Rapide(Bloc_Origine, taille_bloc)
%
% sortie  : Bloc_DCT2 = DCT du bloc
% 
% entrees : Bloc_Origine = Bloc d'origine
%           taille_bloc = taille des blocs pour la DCT (ici 8x8)
%--------------------------------------------------------------------------
function Bloc_DCT2 = DCT2Rapide(Bloc_Origine,taille_bloc)
    
v = (pi/16):pi/16:(7*pi/16) ;
Bloc_DCT2 = zeros(taille_bloc,taille_bloc);
beta =  0.5 * cos(v);
M1 = [beta(4) beta(4) beta(4) beta(4);
       beta(2) beta(6) -beta(6) -beta(2);
       beta(4) -beta(4) -beta(4) beta(4);
       beta(6) -beta(2) beta(2) -beta(6)];

M2 = [beta(1) beta(3) beta(5) beta(7);
     beta(3) -beta(7) -beta(1) -beta(5);
     beta(5) -beta(1) beta(7) beta(3);
     beta(7) -beta(5) beta(3) -beta(1)];

ind = 1:8;
ind_paire = ind(rem(ind, 2) == 0);
ind_impaire = ind(rem(ind, 2) == 1);

% Calcul de la DCT sur les lignes
Bloc_DCT2(:,ind_paire) = ...
    (M1 * (Bloc_Origine(:,[1,2,3,4]) + Bloc_Origine(:,[8,7,6,5]))')';
Bloc_DCT2(:,ind_impaire) = ...
    (M2 * (Bloc_Origine(:,[1,2,3,4]) - Bloc_Origine(:,[8,7,6,5]))')';

% Calcul de la DCT sur les colonnes
Bloc_DCT2(ind_paire ,:) = ...
    (M1 * (Bloc_DCT2([1,2,3,4],:) + Bloc_DCT2([8,7,6,5],:)));
Bloc_DCT2(ind_impaire,:) = ...
    (M2 * (Bloc_DCT2([1,2,3,4],:) - Bloc_DCT2([8,7,6,5],:)));

end

%--------------------------------------------------------------------------
% Fonction de calcul de transformee en cosinus discrete inverse rapide
% pour un bloc de taille 8x8
%--------------------------------------------------------------------------
% Bloc_IDCT2 = IDCT2Rapide(Bloc_DCT2,taille_bloc)
%
% sortie  : Bloc_IDCT2 = Bloc reconstruit par DCT inverse
% 
% entrees : Bloc_DCT2 = DCT du bloc 
%           taille_bloc = taille des blocs pour la DCT (ici 8x8)
%--------------------------------------------------------------------------

function Bloc_IDCT2 = IDCT2Rapide(Bloc_DCT2,taille_bloc)
    v = (pi/16):pi/16:(7*pi/16) ;
    Bloc_IDCT2 = zeros(taille_bloc,taille_bloc);
    beta =  0.5 * cos(v);
    M1 = [beta(4) beta(4) beta(4) beta(4);
           beta(2) beta(6) -beta(6) -beta(2);
           beta(4) -beta(4) -beta(4) beta(4);
           beta(6) -beta(2) beta(2) -beta(6)]';
    
    M2 = [beta(1) beta(3) beta(5) beta(7);
         beta(3) -beta(7) -beta(1) -beta(5);
         beta(5) -beta(1) beta(7) beta(3);
         beta(7) -beta(5) beta(3) -beta(1)]';

    ind = 1:8;
    ind_paire = ind(rem(ind, 2) == 0);
    ind_impaire = ind(rem(ind, 2) == 1);

    % Calcul de la DCTI sur les colonnes
    Bloc_IDCT2([1,2,3,4] ,: ) = M1 * Bloc_DCT2(ind_paire , :) + M2 * Bloc_DCT2(ind_impaire , :);
    Bloc_IDCT2([7,6,5,4] ,: ) = M1 * Bloc_DCT2(ind_impaire , :) + M2 * Bloc_DCT2(ind_impaire , :);
    
    % Calcul de la DCTI sur les lignes
    Bloc_IDCT2(:,[1,2,3,4]) = (M1 * Bloc_DCT2(:,ind_paire)')' + (M2 * Bloc_DCT2(:,ind_impaire)')';
    Bloc_IDCT2(:,[1,2,3,4]) = (M1 * Bloc_DCT2(:,ind_paire)')' + (M2 * Bloc_DCT2(:,ind_impaire)')';


end