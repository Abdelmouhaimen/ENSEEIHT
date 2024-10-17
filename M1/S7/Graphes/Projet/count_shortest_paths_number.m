function [D,P] = count_shortest_paths_number(A)
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
    C = inf(n, 2);
    C(v0, :) = [0, 0]; 
    S = v0;
    R = setdiff(1:n, S);

    for j = neighbors(graph, v0).'
       C(j, :) = [1, 1];
    end

    while ~isempty(R)
        [~, idx] = min(C(R, 1));
        i = R(idx);
        R(idx) = [];

        for j = neighbors(graph, i).'
            if ismember(j, R)
                if C(j, 1) == C(i, 1) + 1
                    C(j, 2) = C(j, 2) + C(i, 2);
                elseif C(j, 1) > C(i, 1) + 1
                    C(j, :) = [C(i, 1) + 1, C(i, 2)];
                end
            end
        end
    end
end


