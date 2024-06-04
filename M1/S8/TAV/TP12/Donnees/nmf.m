function[D,A] = nmf(S,D_0,A_0,iter_max)
epsilon = 1e-16;
A = A_0;
D = D_0;
for i=1:iter_max
    A = A.*(D'*S)./((D'*D*A) + epsilon);
    D = D.*(S*A')./((D*(A*A')) +epsilon);
end
end

