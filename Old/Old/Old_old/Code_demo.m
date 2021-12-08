%% Add path to cameraLucida repo

clear; 
addpath(genpath('C:\Users\Federico\Documents\GitHub\cameraLucida')); 

db_morph_example;

%% laod example dendritic reconstruction

[X,Y,Z,soma, parent, id]  = loadSWC(db, 'neuTube', 'all');

%% plot dendritic morphology

cameraLucida.plot_swcLines(X,Y,Z, parent);

%% interpolate dendrite with equally spaced sample points

[newX,newY,newZ] = interpSWC(X,Y,Z, parent);

%% Plot dendrite density

plot_Density3D(newX,newY,newZ, 1, 1, [], true);


