function resultat = calcul_U(I,c,R,S,beta)
Ui_total = 0;
for i = 1:(N-1)
    Ui_total = Ui_moyen_total + calcul_Ui_moyen(I,c(i,:),R,gamma,S);
    for j = i+1:N
        if norm(c(i,:) - c(j,:)) <= (sqrt(2)*R)
            Ui_total = Ui_total + beta;
        end
    end
end
resultat = Ui_total;

