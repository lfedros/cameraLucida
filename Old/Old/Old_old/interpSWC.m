function [nX,nY,nZ] = interpSWC(X, Y, Z, parent)

nNode = numel(parent);

% round the coordinates to the closest micron

X = round(X);
Y = round(Y);
Z = round(Z);

% initialise the new coordinates with the root of the tree

nX = X(1);
nY = Y(1);
nZ = Z(1);

for iN = 2:nNode
    
    root = parent(iN);
    %coordinates of root
    rx = X(root);
    ry= Y(root);
    rz = Z(root);
    %coordinates of point
    x = X(iN);
    y= Y(iN);
    z = Z(iN);
    % distance
    dx = abs(x-rx);
    dy = abs(y-ry);
    dz = abs(z-rz);
  
    % if the 2 are more distant than 1 in any dimension, interpolate
    if dx > 1 || dy>1 || dz>1
        
        %find how many new pixels we need
        nPx = max([dx, dy, dz]) + 1;
        %linearly space the new coordinates and round them to nearest pixel
        nx = round(linspace(rx,x, nPx));
        ny = round(linspace(ry,y, nPx));
        nz = round(linspace(rz,z, nPx));
        
        nX = [nX; makeVec(nx(2:end))];
        nY = [nY; makeVec(ny(2:end))];
        nZ = [nZ; makeVec(nz(2:end))];
    else
       nX = [nX; x];
       nY = [nY; y];
       nZ = [nZ; z]; 

    end
    
end


end