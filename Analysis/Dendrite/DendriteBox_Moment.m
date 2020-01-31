
function [theta_deg, theta_axial] = DendriteBox_Moment( tree, fname )

rtree = tree;
X = rtree.X; 
Y = rtree.Y;
dA = rtree.dA;

nodeNear = zeros(length(X), 1);
for i = 2:length(X)
    nodeNear(i,1) = find(dA(i,:)==1);
end
nodeNear(1,1) = 1;

start_coor = [X, Y];
end_coor = [X(nodeNear), Y(nodeNear)];
centerM = mean(cat(3, start_coor, end_coor), 3);
somaM = centerM(1,:);

diffY = centerM(:,2)-somaM(:,2);
diffX = centerM(:,1)-somaM(:,1);
M = diffY./diffX;
[theta_axial, ~] = cart2pol(diffX,diffY); % [rad] [-180 180]
theta_axial = theta_axial.*(180/pi); % [deg] [0 360]
theta = atan(M);
theta_deg = theta.*(180/pi); % [-90 90]

%% plot colormap of theta

% reduce hsv brightness
hmap(1:256,1) = linspace(0,1,256);
hmap(:,[2 3]) = 0.7; % brightness
huemap = hsv2rgb(hmap);

figure; 
HP = plot_tree (rtree, theta_deg, [], [], [], []);
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

img_1 = strcat(fname, '_soma_box');
print(img_1, '-dtiff');

img_2 = strcat(img_1, '_c');
axis_cleaner;
title('');
print(img_2, '-dtiff');
close all;

end




