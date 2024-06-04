function probas = probabilites_EM(D_app,parametres_estim,proportion_1,proportion_2,sigma)

r_p1 = calcul_r(D_app,parametres_estim(1,:));
r_p2 = calcul_r(D_app,parametres_estim(2,:));

pi_1 = proportion_1;
pi_2 = proportion_2;

den = pi_1/sigma * exp(-r_p1.^2 / 2*sigma^2) + pi_2/sigma * exp(-r_p2.^2 / 2*sigma^2);
num_1 = pi_1/sigma * exp(-r_p1.^2 / 2*sigma^2);
num_2 = pi_2/sigma * exp(-r_p2.^2 / 2*sigma^2);
probas = [num_1./den ; num_2./den];
end

