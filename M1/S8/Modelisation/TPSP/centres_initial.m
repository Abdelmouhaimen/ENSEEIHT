function centers = centres_initial(I,S,K)
[n,m,~] = size(I);

rows = round((S/2)):S:n;
cols = round((S/2)):S:m ;
centers = I(rows,cols,:);
[np,mp,~] = size(centers);
matrice_ind = zeros(np,mp,5);
matrice_ind(:,:,1) =  repmat(rows',1,mp);
matrice_ind(:,:,2) =  repmat(cols,np,1) ;
matrice_ind(:,:,3:5) = centers ;
centers = reshape(matrice_ind ,[],5);


end

