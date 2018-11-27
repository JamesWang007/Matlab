[X,Y] = meshgrid(-2:.2:2);                                
%Z = X .* exp(-X.^2 - Y.^2);
surf(X,Y,Z)


%t = Y - X;
Z = (Y - X)^2;

%surf(X, Y, Z)

countour3(X, Y, Z)

%%%%%%%%%%%%%%

[X,Y] = meshgrid(-5:0.25:5);
Z = X.^2 + Y.^2;
contour3(Z)
contour3(X,Y,Z,50)





%%%%%%%%%%%%%
[X,Y] = meshgrid(-2:0.0125:2);
Z = X.*exp(-X.^2-Y.^2);
[M,c] = contour3(X,Y,Z,30);
c.LineWidth = 3;