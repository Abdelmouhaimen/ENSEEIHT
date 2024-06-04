function x = moyenne_3D(I)

% Conversion en flottants :
I = single(I);

% Calcul des couleurs normalisees :
somme_canaux = max(1,sum(I,3));
r = I(:,:,1)./somme_canaux;
v = I(:,:,2)./somme_canaux;



% Calcul des couleurs moyennes :
r_barre = mean(r(:));
v_barre = mean(v(:));

%Calcul couleur moyenne rp_moy du pourtour et complemetaire du pourtour rc_moy
rayon = 1/6 * ((size(r,1) + size(r,2)) / 2);
cx = floor(size(r,1) /2);
cy = floor(size(r,2) / 2);
rp = r(:,:);
rc = r(:,:);

for i = 1:size(r,1)
    for j = 1:size(r,2)
        if abs(i - cx)^2 + abs(j - cy)^2 > rayon^2
            rc(i, j) = 0;
        else
            rp(i, j) = 0;
        end
    end
end

rp_moy = mean(rc(:));
rc_moy = mean(rp(:));

image(rp .* somme_canaux)
x = [r_barre v_barre rp_moy-rc_moy];
