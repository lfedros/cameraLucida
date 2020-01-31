% Align theta values to that of orientation axis

prefOri = -18.5;
% [rtree, order] = sort_tree(tree,'-LO');
%% process somaBox
load('thetaBox.mat');
% theta_deg = theta.thetaRadialMap_V;
% theta_axial = theta.thetaMap_V;
theta_deg = thetaBox.theta_deg;
theta_axial = thetaBox.theta_axial;

% radial data
%theta_axial = thetaBox.theta_axial;
thetaNew = theta_axial + prefOri;
thetaNew( thetaNew > 90 ) = thetaNew( thetaNew > 90 ) - 180;
thetaNew( thetaNew < -90) = thetaNew( thetaNew < -90) + 180;

% circular data
%theta_deg = thetaBox.theta_deg;
thetaNew2 = theta_deg + prefOri;
thetaNew2( thetaNew2 > 180 ) = thetaNew2( thetaNew2 > 180 ) - 360;
thetaNew2( thetaNew2 < -180) = thetaNew2( thetaNew2 < -180) + 360;


%% Step : plot colormap of theta

% reduce hsv brightness
hmap(1:256,1) = linspace(0,1,256);
hmap(:,[2 3]) = 0.7; % brightness
huemap = hsv2rgb(hmap);

figure; 
HP = plot_tree (tree, thetaNew , [], [], [], []);
set (HP, 'edgecolor','none');
colormap(huemap);
caxis([-90 90])
colorbar;
xlabel       ('x [\mum]');
ylabel       ('y [\mum]');
view         (2);
grid         on;
axis         image;

print(strcat(file_name,'_thetaSeg_axial_orialign'), '-dtiff');
axis_cleaner;
print(strcat(file_name,'_thetaSeg_axial_orialign_c'), '-dtiff');


