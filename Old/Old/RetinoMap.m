function [tree, tree1, retX, retY] = RetinoMap( folder_name, dbVis )

% RETINOMAP 	warps neuron reconstruction from cortical space to visual space
%  
%		INPUTS:
%       [1] folder_name = neuron reconstruction [string]
%       [2] dbVis       = retinotopy            [struct]
%
%       OUTPUTS:
%       [1] tree  = cortical space neuron [microns] [struct]
%       [2] tree1 = visual space neuron   [degrees] [struct]
%       [3] retX  = retinotopyX           [degrees] [.mat]
%       [4] retY  = retinotopyY           [degrees] [.mat]
%       [5] image of cortical space v. visual space [.tif]

% 2020 N Ghani and LF Rossi

%%  Step 1: resample tree by interpolating pixel-by-pixel

file_path = strcat( folder_name, '_tracing.swc' );
[tree,~,~] = load_tree(file_path,'r'); % [pixels]

% to compute in visual space
tree1 = tree;

%% Step 2: center all coordinates to the soma

% load( strcat( folder_name, '_neuRF_column_svd.mat' ) );

% find soma coordinates
Y_pos = dbVis.starterYX(1,1); % [px]
X_pos = dbVis.starterYX(1,2); % [px]
micronsSomaX = dbVis.micronsX - dbVis.micronsX( X_pos ); % [um]
micronsSomaY = dbVis.micronsY - dbVis.micronsY( Y_pos ); % [um]

% center retinotopy
retX = dbVis.retX - dbVis.retX(Y_pos, X_pos); % [um]
retY = dbVis.retY - dbVis.retY(Y_pos, X_pos); % [um]
retY = -retY; % invert elevation map

% center dendritic tree
tree.X = tree.X -tree.X(1); % [px]
tree.Y = tree.Y -tree.Y(1); % [px]
tree.Y = tree.Y* ( dbVis.fovy/512 ); % [um]
tree.X = tree.X* ( dbVis.fovx/512 ); % [um]

%% Step 3: create cortical space plot

% plot countour lines
figure;
subplot(1,2,1);
contour(micronsSomaX, micronsSomaY , retX ,'r','LineWidth',1);
hold on;
contour(micronsSomaX, micronsSomaY , retY, 'r','LineWidth',1);

% plot dendritic tree 
hold on;
plot_tree(tree);

%% Step 4: label cortical space plot

xlabel('Azimuth [um] ');
ylabel('Elevation [um] ');
set(gca, 'fontsize', 12); 
axis image

% add title
title('Cortical Space');
set(gca, 'fontname', 'Te X Gyre Heros'); % due to Linux compatability issue with Helvetica font

%% Step 5: create visual space plot

% warp dendritic tree
X = tree.X;
Y = tree.Y;

% pre-alloc
j = zeros(length(X), 1);
i = zeros(length(X), 1); 
% transform data
for n = 1:length(X)
    [~ , j(n, 1)] = min( abs (micronsSomaX - X(n) ));
    [~ , i(n, 1)] = min( abs (micronsSomaY - Y(n) ));
end

% we re-mapped [j i] as [X Y]
% so we have it in the correct, standardized format

% previous error made: used [j i] and not [i j] in loop below
% correction:  [i j] as [X Y] 

% pre-alloc
A = zeros(length(j),1);
E = zeros(length(j),1);
for n = 1:length(j)
    A(n,1) = retX(i(n), j(n));
    E(n,1) = retY( i(n), j(n));
end

subplot(1,2,2);

% plot contour lines
hold on;
data = -15:0.0586:15; % 1x512 vector of values from -15 to 15
[gridX, gridY] = meshgrid(data);
contour(data, data, gridX, 'r', 'LineWidth', 1);
contour(data, data, gridY, 'r', 'LineWidth', 1);

% rescale dendrites
tree1.X = A; %- A(1);
tree1.Y = E; % - E(1);
tree1.D = repmat(0.15,length(X),1);
tree1.R = repmat(0.15,length(X),1);

% plot dendritic tree
plot_tree( tree1 );

%% Step 6: label visual space plot

xlabel('Azimuth [deg] ');
ylabel('Elevation [deg] ');
set(gca, 'fontsize', 12); 
axis([-15 15 -15 15]);

% add title
title('Visual Space');
set(gca, 'fontname', 'Te X Gyre Heros');  % due to Linux compatability issue with Helvetica font

%% Step 7: save final image (cortical space v. visual space)

img_1 = strcat( folder_name , '_retino');
print(img_1, '-dtiff');

%% Step 8: save outputs [dendritic trees as structs]

XY_tree = strcat(folder_name, '_XY');
AE_tree = strcat(folder_name, '_AE');
save( XY_tree, 'tree' );
save( AE_tree, 'tree1' ); 

end





