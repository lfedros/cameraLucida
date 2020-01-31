%% Dependencies: 
%  Trees ToolBox by Hermann Cuntz [Hausser Lab]

%  Modify DendriteMorpho to weight length 

function [thetaMap, thetaRadialMap] = DendriteMorpho_w( tree, fname )

%% Step 2: group nodes to branches
[rtree, order] = sort_tree(tree,'-LO');
[sect, vec] = dissect_tree(rtree);

nodeDist = abs(sect(:,2)-sect(:,1));
[a,b] = find(nodeDist==0);
nodeDist(a) = [];
start_nodes = sect(:,1);
start_nodes(a) = [];
end_nodes = sect(:,2);
end_nodes(a) = [];

X = rtree.X;
Y = rtree.Y;
start_coor = [X(start_nodes), Y(start_nodes)];
end_coor = [X(end_nodes), Y(end_nodes)];
% centerM = mean(cat(3, start_coor, end_coor), 3);
% [theta_axial, rho] = cart2pol(centerM(:,1),centerM(:,2));

diffY = end_coor(:,2)-start_coor(:,2);
diffX = end_coor(:,1)-start_coor(:,1);
M = diffY./diffX;
[theta_axial, rho] = cart2pol(diffX,diffY); % [rad]
theta_axial = theta_axial.*(180/pi); % [deg]
theta = atan(M);
theta_deg = theta.*(180/pi);

%% Step 3: plot point pairs

X_pairs = [start_coor(:,1) end_coor(:,1)];
Y_pairs = [start_coor(:,2) end_coor(:,2)];
figure; 
hold on;
for i = 1:length(X_pairs)
    plot(X_pairs(i,:),Y_pairs(i,:), 'k');
end

%% Step 4: obtain correct segment points

% continuous segments followed by one-point segments
% classify "sect" as continuous OR one-point segment with 1 OR 2 
sect_corr = [start_nodes , end_nodes];
sect_classify = ones(length(sect_corr),1);

for i = 2:length(sect_corr)
    if sect_corr(i,1) == sect_corr(i-1,2)
        sect_classify(i) = 1;
    else
        sect_classify(i) = 2;
    end
end

%% Step 5: built thetaMap with first-pass

% zero out branch pts 
B = B_tree(tree);
[val, ~] = find(B==1);
thetaMap = zeros(length(X),1);
thetaRadialMap = zeros(length(X),1);

% assign values to continuous segments (sect_classify = 1)
cont_ind = find(sect_classify==1);
nodePts = [start_nodes, end_nodes];

for i = 1:length(cont_ind)
    thetaMap(start_nodes(cont_ind(i)):end_nodes(cont_ind(i)), 1) = theta_deg(cont_ind(i));
    thetaRadialMap(start_nodes(cont_ind(i)):end_nodes(cont_ind(i)), 1) = theta_axial(cont_ind(i));
end

% assign values to single-point segments (sect_classify = 2)
single_ind = find(sect_classify==2);

for j = 1:length(single_ind)
    thetaMap(end_nodes(single_ind(j),1)) = theta_deg(single_ind(j));
    thetaRadialMap(end_nodes(single_ind(j),1)) = theta_axial(single_ind(j));
end

% find segments not assigned
val_fix = find(thetaMap==0);

%% Step 6: correct thetaMap with second-pass
zeroLocations = thetaMap == 0;
regions = regionprops(zeroLocations, thetaMap, 'PixelIdxList');

for i = 1:length(regions)
    s1 = min(regions(i).PixelIdxList); % start node of segment
    e1 = max(regions(i).PixelIdxList); % end node of segment
    p = polyfit(X(s1:e1), Y(s1:e1), 1); % linear fit
    theta = atan(p(1)).*(180/pi); % inverse tangent of slope, conv to degrees
    thetaMap(s1:e1) = theta;
    [theta_axial, ~] = cart2pol(1,p(1)); % [rad]
    thetaRadialMap(s1:e1) = theta_axial.*(180/pi);    
end

% warnings come up in segments that have 1-2 points

%% Step 7: plot colormap of theta

% reduce hsv brightness
hmap(1:256,1) = linspace(0,1,256);
hmap(:,[2 3]) = 0.7; % brightness
huemap = hsv2rgb(hmap);

figure; 
HP = plot_tree (rtree, thetaMap, [], [], [], []);
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

img_1 = strcat(fname, '_seg');
print(img_1, '-dtiff');

img_2 = strcat(img_1, '_c');
axis_cleaner;
title('');
print(img_2, '-dtiff');
close all;

end








