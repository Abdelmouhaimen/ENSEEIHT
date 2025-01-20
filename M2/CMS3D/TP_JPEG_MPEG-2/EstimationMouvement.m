
% TP Codages JPEG et MPEG-2 - 3SN-M - 2022

%--------------------------------------------------------------------------
% Fonction d'estimation du mouvement par "block-matching"
%--------------------------------------------------------------------------
% MVr = EstimationMouvement(Ic,Ir)
%
% sortie  : MVdr = matrice des vecteurs de deplacements relatifs
% 
% entrees : Ic = image courante
%           Ir = image de reference
%--------------------------------------------------------------------------

function MVr = EstimationMouvement(Ic,Ir)
    [h,w] = size(Ic);
    taille_bloc = 16;
    nb_blocs_x = floor(h / taille_bloc);
    nb_blocs_y = floor(w / taille_bloc);
    MVr = zeros(nb_blocs_x, nb_blocs_y, 2);
    for i = 1:nb_blocs_x
        for j = 1:nb_blocs_y
            coordx = (i-1)*taille_bloc + 1;
            coordy = (j-1)*taille_bloc + 1;
            MB_IC = Ic(coordx:coordx+taille_bloc-1, coordy:coordy+taille_bloc-1);

            Vm = CSAMacroBloc(MB_IC,[coordx coordy], Ir);

            MVr(i, j, :) = Vm;
        end
    end


end

%--------------------------------------------------------------------------
% Fonction de recherche par 'Cross Search Algorithm' :         
%   - Recherche pour un macro-bloc de l'image courante
%--------------------------------------------------------------------------
% Vm = CSAMacroBloc(MBc, Vp, Iref)
%
% sorties : Vm = vecteur de mouvement 
% 
% entrées : Mbc = macro-bloc dans l'image courante Ic
%           Vp = vecteur de prediction (point de depart du MacroBloc)
%           Iref = image de reference (qui sera conservee dans le GOP)
%--------------------------------------------------------------------------

function Vm = CSAMacroBloc(MB_IC, Vp, IRef)
    taille_bloc = size(MB_IC, 1);
    % Initialisation
    stop = false;
    Vm = Vp;
    [h,w] = size(IRef);

    while ~ stop

        coordx = Vm(2) : (Vm(2) + taille_bloc-1) ;
        coordy = Vm(1) : (Vm(1) + taille_bloc-1) ;
        MB_IC_V = MB_IC(:);

        % Calcul des erreurs EQM pour chaque voisin
        EQM_c = EQMMacrocBlocVoisin(MB_IC_V, IRef, w, h, coordx, coordy, 'centre');
        EQM_h = EQMMacrocBlocVoisin(MB_IC_V, IRef, w, h, coordx, coordy, 'haut');
        EQM_b = EQMMacrocBlocVoisin(MB_IC_V, IRef, w, h, coordx, coordy, 'bas');
        EQM_g = EQMMacrocBlocVoisin(MB_IC_V, IRef, w, h, coordx, coordy, 'gauche');
        EQM_d = EQMMacrocBlocVoisin(MB_IC_V, IRef, w, h, coordx, coordy, 'droite');
        EQM_bd = EQMMacrocBlocVoisin(MB_IC_V, IRef, w, h, coordx, coordy, 'bas_droite');
        EQM_hd = EQMMacrocBlocVoisin(MB_IC_V, IRef, w, h, coordx, coordy, 'haut_droite');
        EQM_bg = EQMMacrocBlocVoisin(MB_IC_V, IRef, w, h, coordx, coordy, 'bas_gauche');
        EQM_hg = EQMMacrocBlocVoisin(MB_IC_V, IRef, w, h, coordx, coordy, 'haut_gauche');

        % Liste des erreurs et trouver le minimum
        EQM_list = [EQM_c, EQM_h, EQM_b, EQM_g, EQM_d, EQM_bd, EQM_hd, EQM_bg, EQM_hg];
        [~, idx] = min(EQM_list);

        % Vérifier si un minimum local est atteint
        if idx == 1
            stop = true;
        else
            % Mise à jour du vecteur de mouvement
            switch idx
                case 2, Vm = Vm + [-1, 0]; % Haut
                case 3, Vm = Vm + [1, 0];  % Bas
                case 4, Vm = Vm + [0, -1]; % Gauche
                case 5, Vm = Vm + [0, 1];  % Droite
                case 6, Vm = Vm + [1, 1];  % Bas_Droite
                case 7, Vm = Vm + [-1, 1]; % Haut_Droite
                case 8, Vm = Vm + [1, -1]; % Bas_Gauche
                case 9, Vm = Vm + [-1, -1]; % Haut_Gauche
            end
        end
    end

    % Calculer le déplacement relatif
    Vm = Vm - Vp;

end

%--------------------------------------------------------------------------
% Fonction de calcul de l'EQM avec differents voisins 
% dans l'image de reference
%--------------------------------------------------------------------------
% EQM = EQMMacrocBlocVoisin(MB_IC_V,IRef,size_x_Ref,size_y_Ref,coordx,coordy,voisin)
%
% sortie  : EQM = erreur quadratique moyenne entre macro-blocs
% 
% entrées : MB_IC_V = macro-bloc dans l'image courante (vectorise)
%           Ir = Image de reference
%           w = nombre de lignes de Ir (pour effets de bords)
%           h = nombre de colonnes de Ir (pour effets de bords)
%           coordx = les 16 coordonnees du bloc suivant x
%           coordy = les 16 coordonnees du bloc suivant y
%           voisin = choix du voisin pour decaler le macro-bloc dans Ir
%                    ('haut', 'gauche', 'centre', 'droite', bas', ...)
%--------------------------------------------------------------------------

function EQM = EQMMacrocBlocVoisin(MB_IC_V,Ir,w,h,coordx,coordy,voisin)
    EQM = inf;
    switch voisin
        case 'haut'
            if coordy(1) > 1
                coordy = coordy -1 ;
            end
        case 'bas'
            if coordy(end) < h
                coordy = coordy + 1 ;
            end
        case 'gauche'
            if coordx(1) > 1
                coordx = coordx - 1 ;
            end
        case 'droite'
            if coordx(end) < w
                coordx = coordx + 1 ;
            end
    
    
        case 'bas_droite' 
            if coordx(end) < w  && coordy(end) < h 
                coordx = coordx + 1 ;
                coordy = coordy + 1 ;
            end
    
        case 'bas_gauche' 
            if coordx(1) >1  && coordy(end) < h 
                coordx = coordx - 1 ;
                coordy = coordy + 1 ;
            end
        
    
        case 'haut_droite' 
            if coordx(end) < w  && coordy(1) > 1
                coordx = coordx + 1 ;
                coordy = coordy - 1 ;
            end
    
    
        case 'haut_gauche'
            if coordx(1) >1  && coordy(1) > 1
                coordx = coordx - 1 ;
                coordy = coordy - 1 ;
            end
    end
    MB_IR_V = Ir(coordy, coordx);
    EQM = sum ((MB_IR_V(:) - MB_IC_V ).^2);
    

end
