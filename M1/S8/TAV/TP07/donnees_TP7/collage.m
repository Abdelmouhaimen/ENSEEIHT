function u = collage(r,s,interieur)
r = double(r);
s = double(s);

nb_lignes = size(r(:,:,1),1);
nb_colonnes = size(r(:,:,1),2);
N = nb_lignes * nb_colonnes;
% Operateur gradient :
e = ones(N,1);
Dx = spdiags([-e e],[0 nb_lignes],N,N);
Dx(end-nb_lignes+1:end,:) = 0;
Dy = spdiags([-e e],[0 1],N,N);
Dy(nb_lignes:nb_lignes:end,:) = 0;

% Matrice A du systeme :
A = -Dx'*Dx -Dy'*Dy;

% Calculer les indices des pixels du bord de r
n_bord_r = 2 * (nb_lignes + nb_colonnes) - 4;
n_r = N;
indices_bord_r = zeros(n_bord_r, 1);

% Bords supérieur et inférieur
indices_bord_r(1:2*nb_colonnes) = [1:nb_lignes:N  nb_lignes:nb_lignes:N];
% Bords gauche et droit
indices_bord_r(2*nb_colonnes+1:end) = [2:nb_lignes-1 nb_lignes*(nb_colonnes-1)+2:N-1];
% Imposer la condition au bord u = c pour A
A(indices_bord_r,:) = sparse(1:n_bord_r,indices_bord_r,ones(n_bord_r,1),n_bord_r,n_r);


% Calcul de l'imagette resultat u, canal par canal :
u = r;
for k = 1:size(r,3)
    r_k = r(:,:,k);    


	s_k = s(:,:,k);
    % Calcul de g
    r_k_reshaped = reshape(r_k,N,1);
    grad_c_k = [Dx*r_k_reshaped Dy*r_k_reshaped];
    g_k = grad_c_k;
    s_k_reshaped = reshape(s_k,N,1);
    grad_s_k = [Dx*s_k_reshaped Dy*s_k_reshaped];
    g_k(interieur,:) = grad_s_k(interieur,:);
    
    

    b_k = Dx*g_k(:,1) + Dy*g_k(:,2);
    b_k(indices_bord_r) = r_k(indices_bord_r);
    u_k = A\b_k;
	u(:,:,k) = reshape(u_k,nb_lignes,nb_colonnes);
end
