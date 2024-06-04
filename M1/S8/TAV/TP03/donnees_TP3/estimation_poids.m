function [poids,argument] = estimation_poids(mu_test,sigma_test,liste_nvg,F)

A = repmat(1/(sigma_test*sqrt(2*pi)),length(liste_nvg),1) * exp(-(repmat(liste_nvg',1,length(mu_test)) - repmat(mu_test,length(liste_nvg),1))./repmat(((sigma_test.^2)*2),length(liste_nvg),1));
poids = A\F;
argument = A*poids - F;
end

