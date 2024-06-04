function probas = probabilites(D_app,parametres_estim,sigma)

r_p1 = calcul_r(D_app,parametres_estim(1,:));
r_p2 = calcul_r(D_app,parametres_estim(2,:));

pi_1 = 0.5;
    pi_2 = 0.5;

probas = [pi_1/sigma * exp(-r_p1.^2 / 2*sigma^2) ; pi_2/sigma * exp(-r_p2.^2 / 2*sigma^2)];

end

