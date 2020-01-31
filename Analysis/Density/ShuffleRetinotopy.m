% Shuffle Retinotopy 
%% Step 1: load paths + resample tree

addpath(genpath('/home/naureeng/cameraLucida')); 
addpath(genpath('/home/naureeng/cameraLucida/Dependencies/treestoolbox'));
load('neurons.mat');
n = length( neurons.folder_name );
% rng('shuffle');
ind = 1 : n; 
% ind = randperm( n );
retino_tree.tree1 = cell(n,1);
retino_tree.theta_axial = cell(n,1);
retino_tree.theta_deg = cell(n,1);
%% Step 2: re-compute retinotopy
for i = 1 : n
    folder_name = neurons.folder_name{i};
    file_name = neurons.file_name{i};
    
    folder_path = fullfile( '/home/naureeng/cameraLucida/' , folder_name );
    file_path = fullfile(folder_path, strcat(file_name, '_tracing.swc') );
    cd(folder_path);
    [tree,path,~] = load_tree( file_path, 'r' );
    tree = resample_tree(tree, 5); % resample tree every 5 microns
    retino_path = fullfile('/home/naureeng/cameraLucida/Retinotopy', strcat(neurons.retino_name{ ind(i) } , '_neuRF_column_svd.mat'));
    load(retino_path);
    [~, tree1, ~, ~] = RetinoMap( file_path, retino_path, file_name);
    file_name_vis = strcat(file_name, '_V');
    [theta_axial, theta_deg] = DendriteBox_Moment( tree1, file_name_vis );
    retino_tree.theta_axial{i,1} = theta_axial;
    retino_tree.theta_deg{i,1} = theta_deg;
    retino_tree.tree1{i,1} = tree1;
end

save('retino_tree','retino_tree');
%%

for j = 1 : n
    lego_tree ( retino_tree.tree1{j,1}, 4 );
    hold on;
end

addpath('/home/naureeng/cameraLucida/Dependencies/cbrewer/cbrewer/cbrewer');
CT=cbrewer('seq', 'Reds', 4);
colormap(CT);

%% Federico Density Plotting Code

for j = 1 : n
    tree1 = retino_tree.tree1{j,1};
    plot_Density2D(tree1.X, tree1.Y, 1, 1, [], 1, 1);
    hold on;
end

    
    





