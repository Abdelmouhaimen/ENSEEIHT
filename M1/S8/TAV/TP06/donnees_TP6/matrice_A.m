function A = matrice_A(N,alpha,beta,gamma)
e = ones(N,1);
D2 = spdiags([e -2*e e],-1:1,N,N);
D2(1,end) = 1;
D2(end,1) = 1;
A = speye(N) + gamma*(alpha*D2-beta*(D2'*D2));
end

