function P = estimation_frontiere(mask)

[n,m] = size(mask);
q= [];
i = 50;
non_fin = true;
while i<=n && non_fin
    for j = 1:m
        if mask(i,j) == 1
            q=[i j];
            non_fin = false;
            break;
        end
    end
    i=i+1;
end
P = bwtraceboundary(mask ,q,'SW');
end

