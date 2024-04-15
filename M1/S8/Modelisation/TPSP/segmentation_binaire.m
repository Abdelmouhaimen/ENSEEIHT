function image_binaire = segmentation_binaire (superpixels,centers,Sh)
K = size(centers,1);
[n,m] = size(superpixels);
image_binaire = zeros(n,m);


for i=1:K 
    masque = ( superpixels == i);
    color_c = centers(i,3:5) ;
    % Convertir de l'espace Lab à l'espace RVB
    color_rgb = lab2rgb(reshape(color_c, [1, 1, 3]));
    color_rgb = round(color_rgb *255 ); % Convertir de [0,1] à [0,255]
    
    % Conditions pour séparer l'orange et le bleu en RVB
    if norm(reshape(color_rgb,1,3) - [198 130 80]) <= Sh
        image_binaire(masque) = 255;
    end

end


% Afficher les germes (centres de clusters)
figure
imshow(image_binaire);
hold on;
 
title('segmentation binaire');
end

