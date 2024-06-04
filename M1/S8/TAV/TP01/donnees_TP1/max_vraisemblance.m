function parametres_MV = max_vraisemblance(D_app,parametres_test)
np = size(parametres_test,1);
sum_r = zeros(np,1);
for i = 1:np
    r_p = sum(calcul_r(D_app,parametres_test(i,:)).^2);
    sum_r(i) = r_p;
end

[~, indice_p] = min(sum_r);

parametres_MV = parametres_test(indice_p, :);

