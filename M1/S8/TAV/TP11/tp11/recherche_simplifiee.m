function resultats = recherche_simplifiee(identifiants, bdd)

    n = length(identifiants);

    resultats = [];

    for i=1:n

        if bdd.isKey(identifiants(i))
            morceaux = bdd(identifiants(i));
            resultats = [resultats; morceaux(:,2)];
        end

    end 


end

