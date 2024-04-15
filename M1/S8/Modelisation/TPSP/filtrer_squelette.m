function [new_vx,new_vy] = filtrer_squelette(vx,vy , P,mask)

[nb_lignes,nb_colonnes] = size(mask);
vx_1 = vx(1,:);
vx_2 = vx(2,:);
vy_1 = vy(1,:);
vy_2 = vy(2,:);

filtre_x = vx_1 >= 1;
vx_1 = vx_1(filtre_x);
vx_2 = vx_2(filtre_x);
vy_1 = vy_1(filtre_x);
vy_2 = vy_2(filtre_x);


filtre_x = vx_1 <= nb_colonnes;
vx_1 = vx_1(filtre_x);
vx_2 = vx_2(filtre_x);
vy_1 = vy_1(filtre_x);
vy_2 = vy_2(filtre_x);





ind_y = vy_1 >= 1;
vx_1 = vx_1(ind_y);
vx_2 = vx_2(ind_y);
vy_1 = vy_1(ind_y);
vy_2 = vy_2(ind_y);



ind_y = vy_1 <= nb_lignes;
vx_1 = vx_1(ind_y);
vx_2 = vx_2(ind_y);
vy_1 = vy_1(ind_y);
vy_2 = vy_2(ind_y);


ind_y = vy_2 >= 1;
vx_1 = vx_1(ind_y);
vx_2 = vx_2(ind_y);
vy_1 = vy_1(ind_y);
vy_2 = vy_2(ind_y);






vx = [vx_1;
      vx_2];
vy = [vy_1; 
      vy_2];

%%%%%%%%%%%%%%%%%%%%%%%%%%
max_x = max(P(:,2));
max_y = max(P(:,1));
min_x = min(P(:,2));
min_y = min(P(:,1));
%%%%%%%%%%%%%%%%%%%%%%%
y = find(vx(1,:) <min_x);
vx(:,y) = [];
vy(:,y) = [];
y = find(vx(1,:) > max_x);
vx(:,y) = [];
vy(:,y) = [];
y = find(vx(2,:) <min_x);
vx(:,y) = [];
vy(:,y) = [];
y = find(vx(2,:) > max_x);
vx(:,y) = [];
vy(:,y) = [];
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
y= find(vy(1,:) <min_y);
vx(:,y) = [];
vy(:,y) = [];
y = find(vy(1,:) > max_y);
vx(:,y) = [];
vy(:,y) = [];
y= find(vy(2,:) <min_y);
vx(:,y) = [];
vy(:,y) = [];
y = find(vy(2,:) > max_y);
vx(:,y) = [];
vy(:,y) = [];


new_vx =[];
new_vy =[];
n= size(vx,2);
for i =1:n
    if mask(floor(vy(1,i)),floor(vx(1,i))) == 1 &&  mask(floor(vy(2,i)),floor(vx(2,i))) == 1 

        new_vy =[new_vy ,vy(:,i)];
        new_vx =[new_vx ,vx(:,i)];
    end
end



end
