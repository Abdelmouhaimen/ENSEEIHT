function score_partition = calcul_score(Y_pred,Y)
copieY = Y_pred(:);
copieY(Y_pred == 1) = 2;
copieY(Y_pred == 2) = 1;

copieY2 = Y_pred(:);
copieY2(Y_pred == 3) = 2;
copieY2(Y_pred == 2) = 3;

copieY3 = Y_pred(:);
copieY3(Y_pred == 3) = 1;
copieY3(Y_pred == 1) = 3;

copieY4 = Y_pred(:);
copieY4(Y_pred == 1) = 2;
copieY4(Y_pred == 2) = 3;
copieY4(Y_pred == 3) = 1;

copieY5 = Y_pred(:);
copieY5(Y_pred == 1) = 3;
copieY5(Y_pred == 3) = 2;
copieY5(Y_pred == 2) = 1;






perm_Y_pred = [Y_pred copieY copieY2 copieY3 copieY4 copieY5];
score_partition = max(sum((perm_Y_pred - Y) == 0,1)) / length(Y);

end

