function X = moindres_carres_ponderes(D_app, probas)
    D_app = D_app';
    x = D_app(:,1);
    y = D_app(:,2);
    n_app = length(x);
    A = [x.^2 x.*y y.^2 x y ones(n_app,1)];
    A_cont = [A; [1 0 1 0 0 0]];
    B = [zeros(n_app,1); 1];

    X = A_cont\B;
end

