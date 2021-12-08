function plot_swcLines(db)

if ispc
    addpath('C:\Users\Federico\Documents\MATLAB\gplot3');
else
    addpath('/Users/Federico/Documents/MATLAB/gplot3');
end

[X,Y,Z,soma, parent, nodeNum]  = cameraLucida.loadSWC(db, 'neuTube');

dA = cameraLucida.swcAdjacencyMat(nodeNum, parent);

% graphNodesXY = [X,Y];
% graphNodesXZ = [X,Z];
% graphNodesYZ = [Y,Z];

% [X,Y,Z] = cameraLucida.interpSWC(X,Y,Z, parent);

% Z = Z + soma(3);

%% plotting
figure
[x y z]= sphere;


subplot(1,3,1)
gplot3(dA, [X, Y, -Z], 'k'); hold on; axis image
surf(x*10, y*10, z*10, 'EdgeColor', 'none','FaceColor', 'r', 'FaceLighting', 'gouraud', 'AmbientStrength', 0.5);
camlight('rigth');%lightangle( 50,50);
view([90 0])
ylim([ -279.5000  279.5000])
zlim([-289.5000 +147.5000])
xlabel('Y')

subplot(1,3,2)
gplot3(dA, [X, Y, -Z], 'k'); hold on; axis image
surf(x*10, y*10, z*10, 'EdgeColor', 'none','FaceColor', 'r', 'FaceLighting', 'gouraud', 'AmbientStrength', 0.5);
camlight('rigth');%lightangle( 50,50);
view([0 0])
xlim([ -267.5000  267.5000])
zlim([-289.5000 +147.5000])
xlabel('X')

subplot(1,3,3)
gplot3(dA, [X, Y, -Z], 'k'); hold on; axis image
surf(x*10, y*10, z*10, 'EdgeColor', 'none','FaceColor', 'r', 'FaceLighting', 'gouraud', 'AmbientStrength', 0.5);
camlight('rigth');%lightangle( 50,50);
view([0 90])
xlim([  -267.5000  267.5000])
ylim([ -279.5000  279.5000])
xlabel('X')

end