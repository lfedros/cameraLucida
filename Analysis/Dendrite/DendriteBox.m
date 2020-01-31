%% Dendrite Morpho Analysis box-by-box
% computes theta based on (X,Y) coordin of each 5 x 5 um box

% Dependencies: 
%  Trees ToolBox by Hermann Cuntz [Hausser Lab]

% %% Step 1: load + resample tree
% clear; close all;
% addpath(genpath('C:\Users\Experiment\cameraLucida')); 
% addpath(genpath('C:\Users\Experiment\treestoolbox'));
% [tree,path,~] = load_tree('C:\Users\Experiment\cameraLucida\Example_data\FR128\FR128_1_tracing.swc','r');
% tree = resample_tree(tree, 5); % resample tree every 5 microns

function [thetaMap] = DendriteBox( tree, fname )
%% Step 2: label nodes as BCT 
% 0 = T = termination pt
% 1 = C = continuation pt
% 2 = B = branch pt
[rtree, order] = sort_tree(tree,'-LO');
typeN = typeN_tree(rtree);

%% get B: built-in func
angleB = angleB_tree(rtree);
angleBCT = angleB.*(180/pi);
a = find(angleBCT > 90);
b = -(180-angleBCT(a));
angleBCT(a) = b; 

%% get T: use slope of prev node and curr node
T = find(typeN==0);
X = rtree.X;
Y = rtree.Y;
m = diff(Y)./diff(X);
thetaMap = atan(m).*(180/pi);
% fill in last node lost in diff calc
thetaMap(length(X),1) = thetaMap(end);
angleBCT(T) = thetaMap(T);


%% get C: find nearest neighbor and use slope calc
C = find(typeN==1);
dA = tree.dA;
nodeNear = zeros(length(C),1);
for i = 1:length(C)
    nodeNear(i,1) = find(dA(C(i),:));
end

nodePts_C = [nodeNear, C];
start_coor = [X(C), Y(C)];
end_coor = [X(nodeNear), Y(nodeNear)];
diffY = end_coor(:,2)-start_coor(:,2);
diffX = end_coor(:,1)-start_coor(:,1);
M = diffY./diffX;
theta = atan(M);
theta_deg = theta.*(180/pi);
angleBCT(C) = theta_deg(1:length(C));

%% Step 3: plot colormap of box-by-box theta

% reduce hsv brightness
hmap(1:256,1) = linspace(0,1,256);
hmap(:,[2 3]) = 0.7; % brightness
huemap = hsv2rgb(hmap);

figure; 
HP = plot_tree (rtree, angleBCT, [], [], [], []);
set (HP, 'edgecolor','none');
colormap(huemap);
caxis([-90 90])
colorbar;
title        ('Theta Colormap');
xlabel       ('x [\mum]');
ylabel       ('y [\mum]');
view         (2);
grid         on;
axis         image;
hcb = colorbar;
str = '$$ \theta $$';
title(hcb, str, 'Interpreter', 'latex');

img_1 = strcat(fname, '_box');
print(img_1, '-dtiff');

img_2 = strcat(img_1, '_c');
axis_cleaner;
title('');
print(img_2, '-dtiff');
close all;

end




