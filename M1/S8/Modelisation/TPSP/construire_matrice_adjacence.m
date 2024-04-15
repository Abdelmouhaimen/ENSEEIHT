function [A,pts] = construire_matrice_adjacence(vx, vy)
    m = size(vx,2);
    vx_bar = vx';
    vy_bar = vy';
    
    pts = [vx_bar(:) , vy_bar(:)];
    [C,~,~] = unique(pts,'rows','stable');

    pts = C;
    n = size(pts ,1);
    % Initialiser la matrice d'adjacence avec des zéros
    
    A = zeros(n,n);
    % Parcourir chaque paire de points
    for i = 1:n
        i_x = find(vx(1,:) == pts(i,1) & vy(1,:) == pts(i,2) );
        voisins_x = vx(2,i_x);
        voisins_y = vy(2,i_x);
        voisins = [voisins_x',voisins_y'];
        for k = 1:length(i_x)
            indice = find((pts == voisins(k,:)));
            A(i,indice(1)) = 1;

        end
       
    end
end



