function k = recuit_simule(k,AD,beta,T)
   
    for i=1:size(k,1)
        for j=1:size(k,2)
            ks = k(i,j);
            new_ks = ks;
            while new_ks == ks
                new_ks = randi(4);
            end

            masque = k(max(i-1,1):min(i+1,size(k,1)),max(j-1,1):min(j+1,size(k,2)));

            ssum = sum(sum(masque ~= ks));
            new_ssum = sum(sum(masque ~= new_ks));

            
            Us = AD(i,j,ks) + beta * ssum;
            new_Us = AD(i,j,new_ks) + beta * new_ssum;
            if new_Us < Us
                k(i,j) = new_ks;
            elseif rand <= exp(-(new_Us - Us)/T)
                k(i,j) = new_ks;
            end
        end
    end
end

