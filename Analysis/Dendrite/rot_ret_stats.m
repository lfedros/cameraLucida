function rot_tree = rot_ret_stats(morph, retino, tuning)
%ori in degrees

if isempty(retino) || isempty(morph)
    rot_tree =[];
    return;
end

% morph = neuron.morph;
retX = retino.retX;
retY = retino.retY;
micronsSomaX = retino.micronsSomaX;
micronsSomaY = retino.micronsSomaY;
% ori_deg = tuning.dir_pars_vm(1) + 90;
ori_deg =tuning.prefOri;
ori_deg = unwrap_angle(ori_deg, 0,1);
rot_tree = retino;


%%

b = robustfit(retino.isoOri(:,1), retino.isoOri(:,2), [], [], 'off');
isoOri_ang = rad2deg(atan(b));

coords = [morph.X, morph.Y];
coords(coords(1,:)<20 | coords(2,:)<20, :) = [];

R = [cosd(isoOri_ang) sind(isoOri_ang); -sind(isoOri_ang) cosd(isoOri_ang)];
rot_coords = R*coords';

rotX = rot_coords(1,:)';
rotY = rot_coords(2,:)';
    

rot_tree.X = rotX;
rot_tree.Y = rotY;

bins = -350:5:350;
rot_tree.xy_density = hist3([rotY, rotX], 'Edges', {bins', bins});
rot_tree.xy_density = rot_tree.xy_density/sum(rot_tree.xy_density(:));

%%
b = robustfit(retino.isoHoriz(:,1), retino.isoHoriz(:,2), [], [], 'off');
isoHoriz_ang = rad2deg(atan(b));

coords = [morph.X, morph.Y];
coords(coords(1,:)<20 | coords(2,:)<20, :) = [];

R = [cosd(isoHoriz_ang) sind(isoHoriz_ang); -sind(isoHoriz_ang) cosd(isoHoriz_ang)];
rot_coords = R*coords';

rotX = rot_coords(1,:)';
rotY = rot_coords(2,:)';
    

% rot_tree.X = rotX;
% rot_tree.Y = rotY;

bins = -350:5:350;
rot_tree.xy_density_horz = hist3([rotY, rotX], 'Edges', {bins', bins});
rot_tree.xy_density_horz = rot_tree.xy_density/sum(rot_tree.xy_density(:));
%% compute logical map of theta in cortex

theta_ax = -90:5:85;

theta = -180:5:175;

[nx, ny] = size(retX);

tol = pi/18;
[angleRet, ~] = cart2pol(retX, retY); %[-pi, pi]
aMap = reshape(angleRet,nx,ny);

ori = ori_deg*pi/180;
opOri = ori + pi; %[0 2*pi];
opOri(opOri>pi) = opOri(opOri> pi) - 2*pi;%[-pi pi]

oriMap = (aMap-ori)>= -tol & (aMap-ori)<= tol;
oriOpMap =  (aMap-opOri)>= -tol & (aMap-opOri)<= tol;

ax_map = oriMap | oriOpMap;
theta_map = oriMap;

ang_density_alignedOp = nan(numel(theta), 1);
ang_density_aligned = nan(numel(theta), 1);

coords = [morph.X, morph.Y];
coords(coords(1,:)<20 | coords(2,:)<20, :) = [];

% figure;
for it = 1:numel(theta)
    %% rotate tree by deg bin clockwise
    R = [cosd(theta(it)) sind(theta(it)); -sind(theta(it)) cosd(theta(it))];
    rot_coords = R*coords';
    rotX = rot_coords(1,:)';
    rotY = rot_coords(2,:)';
    
    %% 2D histogram of tree
    
    xy = hist3([rotY, rotX], 'Edges', {flip(micronsSomaY,2), micronsSomaX});
    xy = flip(xy, 1);
    %% measure dot product between mask and three
    
    theta_count = xy.*(retino.oriDoubleWedge);
    theta_count_vert = xy.*(retino.verticalDoubleWedge);
    theta_count_horiz = xy.*(retino.horizDoubleWedge);

    ang_density_aligned(it,:)= sum(theta_count(:));
        ang_density_aligned_vert(it,:)= sum(theta_count_vert(:));
    ang_density_aligned_horiz(it,:)= sum(theta_count_horiz(:));

%     clf;
% subplot(1,3,1)
% imagesc(retino.oriDoubleWedge); axis image
% subplot(1, 3,2);
% imagesc(xy); axis image; caxis([0 10]);
% subplot(1,3,3)
% imagesc(theta_count); axis image;  caxis([0 10]);
% title(num2str(theta(it)))
% pause;


    %% repeat for every bin
end

coords = [morph.X, morph.Y];
coords(coords(1,:)<20 | coords(2,:)<20, :) = [];

for it = 1:numel(theta_ax)
    %% rotate tree by deg bin clockwise
    
    R = [cosd(theta_ax(it)) -sind(theta_ax(it)); sind(theta_ax(it)) cosd(theta_ax(it))];
    rot_coords = R*coords';
    rotX = rot_coords(1,:)';
    rotY = rot_coords(2,:)';
    
    %% 2D histogram of tree
    
    xy = hist3([rotY, rotX], 'Edges', {flip(micronsSomaY,2), micronsSomaX});
    
    %% measure dot product between mask and three
    
    % theta_count = xy.*ax_map;
    theta_count = flip(xy,1).*retino.oriDoubleWedge;
    theta_count_vert = flip(xy,1).*(retino.verticalDoubleWedge);
    theta_count_horiz = flip(xy,1).*(retino.horizDoubleWedge);

    axial_density_aligned(it,:)= sum(theta_count(:));
        axial_density_aligned_vert(it,:)= sum(theta_count_vert(:));
    axial_density_aligned_horiz(it,:)= sum(theta_count_horiz(:));

end

%% ori aligned
rot_tree.ang_bins= unwrap_angle(theta' + ori_deg,0,1)*pi/180;
rot_tree.ax_bins= unwrap_angle(theta_ax' + ori_deg,1,1)*pi/180;

rot_tree.ang_bins_aligned= theta'*pi/180;
rot_tree.ax_bins_aligned= theta_ax'*pi/180;

[rot_tree.ang_bins, sorting] = sort(rot_tree.ang_bins, 'ascend');
[rot_tree.ax_bins, sorting_ax] = sort(rot_tree.ax_bins, 'ascend');


rot_tree.axial_L = sum(axial_density_aligned);
rot_tree.ang_L = sum(ang_density_aligned);

rot_tree.axial_density_aligned = axial_density_aligned/sum(axial_density_aligned);
rot_tree.ang_density_aligned = ang_density_aligned/sum(ang_density_aligned);

rot_tree.axial_density = rot_tree.axial_density_aligned(sorting_ax);
rot_tree.ang_density = rot_tree.ang_density_aligned(sorting);
%%
[rot_tree.vm_thetaHat, rot_tree.vm_kappa] = circ_vmpar(rot_tree.ax_bins*2, rot_tree.axial_density); % [von Mises parameters]
[rot_tree.vm_fit, rot_tree.vm_angles] = circ_vmpdf( -pi:pi/180:pi, rot_tree.vm_thetaHat, rot_tree.vm_kappa);
rot_tree.vm_angles = rot_tree.vm_angles/2;
rot_tree.vm_thetaHat = rot_tree.vm_thetaHat/2;

[rot_tree.vm_thetaHat_aligned, rot_tree.vm_kappa_aligned] = circ_vmpar(rot_tree.ax_bins_aligned*2, rot_tree.axial_density_aligned); % [von Mises parameters]
[rot_tree.vm_fit_aligned, rot_tree.vm_angles_aligned] = circ_vmpdf( -pi:pi/180:pi, rot_tree.vm_thetaHat_aligned, rot_tree.vm_kappa_aligned);
rot_tree.vm_angles_aligned = rot_tree.vm_angles_aligned/2;
rot_tree.vm_thetaHat_aligned = rot_tree.vm_thetaHat_aligned/2;

rot_tree.vm_thetaHat(rot_tree.vm_thetaHat > pi/2) = rot_tree.vm_thetaHat(rot_tree.vm_thetaHat > pi/2) -pi;

%% vertical aligned

rot_tree.ang_bins_vert= unwrap_angle(theta' -90,0,1)*pi/180;
rot_tree.ax_bins_vert= unwrap_angle(theta_ax' -90,1,1)*pi/180;

rot_tree.ang_bins_aligned_vert= theta'*pi/180;
rot_tree.ax_bins_aligned_vert= theta_ax'*pi/180;

[rot_tree.ang_bins_vert, sorting] = sort(rot_tree.ang_bins_vert, 'ascend');
[rot_tree.ax_bins_vert, sorting_ax] = sort(rot_tree.ax_bins_vert, 'ascend');

rot_tree.axial_density_aligned_vert = axial_density_aligned_vert/sum(axial_density_aligned_vert);
rot_tree.ang_density_aligned_vert = ang_density_aligned_vert/sum(ang_density_aligned_vert);

rot_tree.axial_density_vert = rot_tree.axial_density_aligned_vert(sorting_ax);
rot_tree.ang_density_vert = rot_tree.ang_density_aligned_vert(sorting);
%%
[rot_tree.vm_thetaHat_vert, rot_tree.vm_kappa_vert] = circ_vmpar(rot_tree.ax_bins_vert*2, rot_tree.axial_density_vert); % [von Mises parameters]
[rot_tree.vm_fit_vert, rot_tree.vm_angles_vert] = circ_vmpdf( -pi:pi/180:pi, rot_tree.vm_thetaHat_vert, rot_tree.vm_kappa_vert);
rot_tree.vm_angles_vert = rot_tree.vm_angles_vert/2;
rot_tree.vm_thetaHat_vert = rot_tree.vm_thetaHat_vert/2;

[rot_tree.vm_thetaHat_aligned_vert, rot_tree.vm_kappa_aligned_vert] = circ_vmpar(rot_tree.ax_bins_aligned_vert*2, rot_tree.axial_density_aligned_vert); % [von Mises parameters]
[rot_tree.vm_fit_aligned_vert, rot_tree.vm_angles_aligned_vert] = circ_vmpdf( -pi:pi/180:pi, rot_tree.vm_thetaHat_aligned_vert, rot_tree.vm_kappa_aligned_vert);
rot_tree.vm_angles_aligned_vert = rot_tree.vm_angles_aligned_vert/2;
rot_tree.vm_thetaHat_aligned_vert = rot_tree.vm_thetaHat_aligned_vert/2;

rot_tree.vm_thetaHat_vert(rot_tree.vm_thetaHat_vert > pi/2) = rot_tree.vm_thetaHat_vert(rot_tree.vm_thetaHat_vert > pi/2) -pi;

%% horizontal aligned
end
