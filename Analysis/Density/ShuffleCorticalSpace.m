% Shuffle Cortical Space
%% Step 1: load paths + resample tree

addpath(genpath('/home/naureeng/cameraLucida')); 
addpath(genpath('/home/naureeng/cameraLucida/Dependencies/treestoolbox'));
load('neurons.mat');
n = length( neurons.folder_name );
% rng('shuffle');
retino_tree.tree1 = cell(n,1);
retino_tree.theta_axial = cell(n,1);
retino_tree.theta_deg = cell(n,1);

% get soma position of different cell
% ind = randperm(n); 
% load('X_pos');
% load('Y_pos');
X_pos = randsample(512,1);
Y_pos = randsample(512,1);

%% Step 2: re-compute retinotopy
for i = 1 : n
    folder_name = neurons.folder_name{i};
    file_name = neurons.file_name{i};
    
    folder_path = fullfile( '/home/naureeng/cameraLucida/' , folder_name );
    file_path = fullfile(folder_path, strcat(file_name, '_tracing.swc') );
    cd(folder_path);
    [tree,path,~] = load_tree( file_path, 'r' );
    tree = resample_tree(tree, 5); % resample tree every 5 microns
    retino_path = fullfile('/home/naureeng/cameraLucida/Retinotopy', strcat(neurons.retino_name{i} , '_neuRF_column_svd.mat'));
    load(retino_path);
    [~, tree1, ~, ~] = RetinoMap2( file_path, retino_path, file_name, X_pos, Y_pos );
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


