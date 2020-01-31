%% Shuffled Neurons in -XY

addpath('/home/naureeng/cameraLucida/Dependencies/treestoolbox'); 

cd('/home/naureeng/cameraLucida/Analysis/Density');
load('db.mat');
%load('subset_1.mat');

cd('/home/naureeng/cameraLucida/Analysis/Density/AE');
files_AE = dir('*.mat');

% comment out below for unshuffled data
ind = 1:18;
% ind = randperm(18);

%%
figure;
for n = 1:length(files_AE) %length(subset_1) %1:length(files_AE)
    tree = load(files_AE(n).name); %load(files_XY(subset_1(n)).name);
    tree_rot = rot_tree( tree.tree1 , [0 0 db.prefDir(ind(n))]); %rot_tree( tree.tree1 , [0 0 db.prefDir((subset_1(ind(n)))) ]);
    lego_tree( tree_rot, 4); % (tree_rot, 4 ); 
    hold on;
end

%[0 0 db.prefDir((subset_1(ind(n)))) ] for shuffling subsets


map = [0 0 0.3
0 0 0.4
0 0 0.5
0 0 0.6
0 0 0.8
0 0 1.0];
colormap(flipud(map));
caxis([0 4])

%%
% Federico Rossi density plotting code

figure;
for n = 1:length(files_AE)
    tree = load(files_AE(n).name);
    tree_rot = rot_tree( tree.tree1, [0 0 db.prefDir(ind(n))] );
    plot_Density2D(tree_rot.X, tree_rot.Y, 1, 0.1 , []  , 1, 1);
    hold on;
end
