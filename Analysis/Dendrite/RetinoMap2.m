%% Retinotopy Analysis 
% superimpose neuron on corresp retinotopy

function [tree, tree1, retX, retY] = RetinoMap2( file_path, retino_path, fname, X_pos, Y_pos )

% OUTPUTS:
% tree  = cortical space [microns]
% tree1 = visual space   [degrees]
% retX  = retinotopyX    [degrees]
% retY  = retinotopyY    [degrees]

%%  Step 1: load paths + resample tree

addpath(genpath('C:\Users\Experiment\cameraLucida')); 
addpath(genpath('C:\Users\Experiment\treestoolbox'));
addpath(genpath('C:\Users\Experiment\Retinotopy'));

[tree,~,~] = load_tree(file_path,'r');
tree = resample_tree(tree, 5); % resample tree every 5 microns
tree1 = tree;

%% Step 2: center all coordinates to the soma
load(retino_path);

% find soma coordinates
% Y_pos = db.starterYX(1,1); % [px]
% X_pos = db.starterYX(1,2); % [px]
micronsSomaX = micronsX - micronsX( X_pos ); % [um]
micronsSomaY = micronsY - micronsY( Y_pos ); % [um]

% center retinotopy
retX = retX - retX(Y_pos, X_pos); % [um]
retY = retY - retY(Y_pos, X_pos); % [um]
retY = -retY; % invert elevation map

% center dendritic tree
tree.X = tree.X -tree.X(1); % [px]
tree.Y = tree.Y -tree.Y(1); % [px]
tree.Y = tree.Y*range(micronsY)/512; % [um]
tree.X = tree.X*range(micronsX)/512; % [um]

%%
figure;
subplot(1,2,1);
contour(micronsSomaX, micronsSomaY , retX ,'r','LineWidth',1);
hold on;
contour(micronsSomaX, micronsSomaY , retY, 'r','LineWidth',1);
% 
% % plot preferred orientation
% [w,h] = size(retX);
% [theta, rho] = cart2pol(retX, retY); % [-pi, pi]
% theta(theta<0) = theta(theta<0) + pi; % [0, pi]
% angle_rad = abs ( (db.prefDir-180).*(pi/180) );
% contour(micronsSomaX, micronsSomaY, theta, [angle_rad angle_rad], 'g--', 'LineWidth', 3);
% %contour(micronsSomaX, micronsSomaY, theta < angle_rad+0.1 & theta > angle_rad-0.1, [1 1],'g--','LineWidth',3);
% view([0 -90]) 

%% Step 3: plot dendrite on top

hold on;
plot_tree(tree);

%% Step 4: label first plot

xlabel('Azimuth [um] ');
ylabel('Elevation [um] ');
set(gca, 'fontsize', 12); 
axis image
% axis([-256 256 -256 256]);

% add title
title('Cortical Space');

% % label origin axes
% plot( [-256 256], [0 0], 'm--', 'LineWidth', 3);
% plot( [0 0], [-256 256], 'm--', 'LineWidth', 3);

%% Step 5: create visual space plot

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

% contour
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
plot_tree( tree1 );


%% Step 6: label second plot
xlabel('Azimuth [deg] ');
ylabel('Elevation [deg] ');
set(gca, 'fontsize', 12); 
axis([-15 15 -15 15]);

% add title
title('Visual Space');

% label origin axes
% plot( [-15 15], [0 0], 'm--', 'LineWidth', 3);
% plot( [0 0], [-15 15], 'm--', 'LineWidth', 3);

% %% Step 7: plot preferred orientation
% 
% hold on;
% contour(retX, retY, theta, [angle_rad angle_rad], 'g--', 'LineWidth', 3);
% %contour(retX,retY, theta < angle_rad+0.1 & theta > angle_rad-0.1, [1 1], 'g--', 'LineWidth', 3); 

%% Step 8: 
img_1 = strcat(fname, '_retino');
print(img_1, '-dtiff');

end





