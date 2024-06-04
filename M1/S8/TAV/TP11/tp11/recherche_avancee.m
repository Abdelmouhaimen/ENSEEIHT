function resultats = recherche_avancee(identifiants, temps_apparition, bdd)
    n = length(identifiants);
    resultats = [];

    for i = 1:n
        if bdd.isKey(identifiants(i))
            morceaux = bdd(identifiants(i));
            for j = 1:size(morceaux, 1)
                diff_temps = morceaux(j, 1) - temps_apparition(i);
                morceaux(j, 1)
                resultats = [resultats; morceaux(j, 2) diff_temps];
            end
        end
    end
end
