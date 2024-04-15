function idx = trouverCentreLePlusProche(centers, I, x, y, S, m)
minDs = inf;
idx = -1;
[rows,cols,~] = size(I);
% Déterminer les limites du voisinage
x_start = max(1, x - S);
x_end = min(rows, x + S);
y_start = max(1, y - S);
y_end = min(cols, y + S);
K = size(centers,1);
for i = 1:K
    center_x = centers(i, 1);
    center_y = centers(i, 2);
    % Vérifier si le centre est dans le voisinage du pixel
    if center_x >= x_start && center_x <= x_end && center_y >= y_start && center_y <= y_end
        % Calculer la distance euclidienne entre le pixel et le centre
        % Calcul de la distance
        color_diff = norm(double(reshape(I(x, y, :), 1, 3))- centers(i, 3:5));
        pos_diff = norm([x, y] - centers(i, 1:2));
        Ds = sqrt(color_diff^2 + (m/S)^2 * pos_diff^2);
        
        if Ds < minDs
            minDs = Ds;
            idx = i;
        end
        
    end
end
end

