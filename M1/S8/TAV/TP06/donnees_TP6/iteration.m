function [x,y] = iteration(x,y,Fx,Fy,gamma,A)
ind = sub2ind(size(Fx),max(1,floor(y)),max(1,floor(x)));
Bx = - gamma * Fx(ind);
By = - gamma * Fy(ind);
x = A*x + Bx;
y = A*y + By;
end

