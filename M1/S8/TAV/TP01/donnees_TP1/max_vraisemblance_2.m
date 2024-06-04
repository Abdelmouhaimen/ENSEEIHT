function parametres_estim = max_vraisemblance_2(D_app,parametres_test,sigma)
np = size(parametres_test,1);
sum_fp = zeros(np,1);
for i = 1:np
    r_p1 = calcul_r(D_app,parametres_test(i,1,:));
    r_p2 = calcul_r(D_app,parametres_test(i,2,:));
    
    pi_1 = 0.5;
    pi_2 = 0.5;

    sum_fp(i) = sum(log(pi_1/sigma * exp(-r_p1.^2 / 2*sigma^2) +  pi_2/sigma * exp(-r_p2.^2 / 2*sigma^2)));
end

[~, indice_p] = max(sum_fp);

parametres_estim = parametres_test(indice_p, :);

