function u_kp1 = debruitage(b,u_k,lambda,Dx,Dy,epsilon)
nb_pixels = length(u_k);

abs_u_carre = (Dx*u_k).^2 + (Dy*u_k).^2;
e = 1./sqrt(abs_u_carre+epsilon);
W_k = spdiags(e,0,nb_pixels,nb_pixels);
Lap = -Dx'*W_k*Dx -Dy'*W_k*Dy;
A_k = speye(nb_pixels) - lambda*Lap;

u_kp1 = A_k\b;
end
