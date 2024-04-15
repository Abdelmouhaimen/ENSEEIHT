function plot_superpixel_borders(image, labels)

    
    % Trouver les bordures entre les superpixels
    borders = find_superpixel_borders(labels);
    
    % Dessiner les bordures sur l'image
    for y = 1:size(image, 1)
        for x = 1:size(image, 2)
            if borders(y, x)
                image(y, x, :) = [1, 0, 0]; % Rouge pour les bordures
            end
        end
    end
    
    % Afficher l'image
    imshow(image);
end

function borders = find_superpixel_borders(labels)
    [height, width] = size(labels);
    borders = false(height, width);
    
    % Parcourir chaque pixel et vérifier ses voisins
    for y = 2:height-1
        for x = 2:width-1
            if labels(y, x) ~= labels(y-1, x) || ...
               labels(y, x) ~= labels(y+1, x) || ...
               labels(y, x) ~= labels(y, x-1) || ...
               labels(y, x) ~= labels(y, x+1)
                borders(y, x) = true;
            end
        end
    end
end


