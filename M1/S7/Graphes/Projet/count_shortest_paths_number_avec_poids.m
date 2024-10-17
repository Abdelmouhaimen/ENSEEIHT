function [D,P] = count_shortest_paths_number_avec_poids(A)
    n= size(A,1);
    G= graph(A);
    P = zeros(n,n);
    D = zeros(n,n);
    for i = 1:n 
        djikstra_start = dijkstra(G, i);
        D(i,:) = djikstra_start(:,1)';
        P(i,:) = djikstra_start(:,2)';
    end 
    
end

function C = dijkstra(graph, v0)
    n = numnodes(graph); 
    C = inf(n, 2);  % Matrice pour stocker le nombre de sauts minimum et le nombre de chemins
    C(v0, :) = [0, 1];  % Nombre de sauts pour le nœud de départ est 0, et il y a 1 chemin pour y arriver
    minCost = inf(n, 1); % Matrice pour stocker le coût minimum pour atteindre chaque nœud
    minCost(v0) = 0;    % Coût pour le nœud de départ est 0
    S = v0;             % Ensemble des nœuds visités
    R = setdiff(1:n, S); % Ensemble des nœuds restants
    edgeWeights = graph.Edges.Weight; % Récupération des poids des arêtes

    for j = neighbors(graph, v0).' 
        edgeIdx = findedge(graph, v0, j);
        if edgeIdx > 0
            minCost(j) = edgeWeights(edgeIdx); 
            C(j, :) = [1, 1];  % 1 saut et 1 chemin pour les voisins
        end
    end

    while ~isempty(R)
        [~, idx] = min(minCost(R)); % Trouver le nœud avec le coût minimal en poids
        i = R(idx);
        R(idx) = [];            % Retirer ce nœud de l'ensemble R

        for j = neighbors(graph, i).' 
            if ismember(j, R)
                edgeIdx = findedge(graph, i, j);
                if edgeIdx > 0
                    edgeWeight = edgeWeights(edgeIdx);
                    newCost = minCost(i) + edgeWeight;
                    if minCost(j) == newCost
                        C(j, 2) = C(j, 2) + C(i, 2); % Augmenter le nombre de chemins
                    elseif minCost(j) > newCost
                        minCost(j) = newCost;
                        C(j, :) = [C(i, 1) + 1, C(i, 2)]; % Mettre à jour le nombre de sauts et le nombre de chemins
                    end
                end
            end
        end
    end
end



