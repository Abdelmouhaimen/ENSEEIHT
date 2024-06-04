function affichage_image(Im,message,numero)

figure('Name',message,'Position',[(numero-1)*550,0,550,450]);
imagesc(Im);
if (size(Im,3)==1)
	colormap(gray);
end;
axis equal;
axis off;
