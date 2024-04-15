function [superpixels,centers] = SLIC(I,K,m,iter_max,seuil)

% Convertir l'image RGB en Lab
I = rgb2lab(I);


%Initialize cluster centers Ck = [lk, ak, bk, xk, yk]T by sampling pixels at regular grid steps 
[n,m_row,~] = size(I);
Np = n*m_row;
S = round((sqrt(Np/K)));
centers = centres_initial(I,S,K);
superpixels = zeros(n,m_row);

% Affinement de la grille
for k = 1:size(centers,1)
    center_row = centers(k, 1);
    center_col = centers(k, 2);
    
    % la taille du voisinage
    n_size = 3; 
    
    % Extraire le voisinage local autour du centre
    row_start = max(1, center_row - n_size);
    row_end = min(n, center_row + n_size);
    col_start = max(1, center_col - n_size);
    col_end = min(m_row, center_col + n_size);
    neighborhood = I(row_start:row_end, col_start:col_end, :);
    
    % Calculer les gradients dans le voisinage
    [gx, gy] = imgradientxy(neighborhood(:, :, 1)); % Utiliser le canal L pour le calcul du gradient
    
    % Trouver le pixel avec le plus faible gradient
    [~, min_idx] = min(gx(:).^2 + gy(:).^2); % Squared gradient magnitude
    [min_row, min_col] = ind2sub(size(neighborhood), min_idx);
    
    % Mettre à jour le centre vers le pixel avec le plus faible gradient
    centers(k, 1) = row_start - 1 + min_row;
    centers(k, 2) = col_start - 1 + min_col;
end

% Boucle jusqu'à la convergence
E = inf;

iter = 0;

% Création de la figure
figure;

while iter<=iter_max && E>seuil
    
     % Afficher les germes (centres de clusters)
    % Effacer la figure précédente
    clf;
    
    % Afficher les germes (centres de clusters)
    subplot(1, 2, 1);
    imshow(I);
    hold on;
    plot(centers(:,2), centers(:,1), 'r*'); % Coordonnées x et y des centres de clusters
    title('Germes (Centres de clusters)');
    hold off;



    for i = 1:n
        for j = 1:m_row
            idx = trouverCentreLePlusProche(centers, I, i, j, S, m);
            superpixels(i,j) = idx;
        end
    end
    
    % Afficher les superpixels avec des frontières
    subplot(1, 2, 2);
    %%%%%%%%%%%%%%%%%
    plot_superpixel_colors(superpixels)
    %%%%%%%%%%%%%%%%%
    %plot_superpixel_borders(I, superpixels)
    
    hold off;

    % Mettre à jour l'affichage
    drawnow;
    
    % Pause pour créer une animation
    %pause(0.01); % Réglez cette valeur pour ajuster la vitesse de l'animation





    % Mise à jour des centres
    new_centers = zeros(size(centers,1),size(centers,2));
    for i = 1:size(centers, 1)
        mask = (superpixels == i);
        
        if sum(mask(:)) == 0
            new_centers(i, :) = centers(i, :);
        else
          
            [row,col] = find(mask); 
     

            mean_color = mean(reshape(I(repmat(mask, [1 1 3])), [], 3));
            
            mean_pos = [mean(row), mean(col)];
            
            new_centers(i, :) = [mean_pos,mean_color];
            
        end
    end
    
    E = norm(new_centers - centers);
    centers = new_centers;
    


    % Incrémenter l'itération
    iter = iter + 1;
end
figure;
plot_superpixel_borders(I, superpixels)
end

