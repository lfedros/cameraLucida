function stats = tree_angular_stats(tree)

if isempty(tree)
    return;
end


X = tree.X; 
Y = tree.Y;
Z = tree.Z;
% make sure we are centered at the soma
X = X -X(1);
Y = Y -Y(1);
Z = Z -Z(1);

% measure xy map

if max(X)>50
bins = -350:5:350;
stats.xy_density = hist3([Y, X], 'Edges', {bins', bins});
stats.xy_density = stats.xy_density/sum(stats.xy_density(:));

bins_z = -300:5:300;
stats.zx_density = hist3([Z, X], 'Edges', {bins_z', bins});
stats.zx_density = stats.zx_density/sum(stats.zx_density(:));
else
  bins = -20:1:20;
stats.xy_density = hist3([Y, X], 'Edges', {bins', bins});
stats.xy_density = stats.xy_density/sum(stats.xy_density(:));  
    
end
% measure length

L  = len_tree(tree);
stats.L = sum(L); 

% convert to radial coordinates
[stats.theta, stats.rho] = cart2pol(X, Y); %[-pi pi]

stats.theta_axial = stats.theta;
stats.theta_axial(stats.theta_axial<0) = stats.theta_axial(stats.theta_axial<0)+pi; %[0 pi]
% calculate angular statistics
stats.circ_var = circ_var(stats.theta);
stats.circ_axial_var = circ_var(stats.theta_axial*2);
stats.circ_mean = circ_mean(stats.theta);
stats.circ_axial_mean = circ_mean(stats.theta_axial*2)/2;
if stats.circ_axial_mean<0
    stats.circ_axial_mean = stats.circ_axial_mean +pi; %[0 pi]
end

[stats.vm_thetaHat, stats.vm_kappa] = circ_vmpar(stats.theta_axial*2); % [von Mises parameters]
[stats.vm_fit, stats.vm_angles] = circ_vmpdf( -pi:pi/180:pi, stats.vm_thetaHat, stats.vm_kappa);
stats.vm_angles = stats.vm_angles/2;
stats.vm_thetaHat = stats.vm_thetaHat/2;

stats.theta_axial(stats.theta_axial > pi/2) = stats.theta_axial(stats.theta_axial > pi/2) -pi; 
stats.circ_axial_mean(stats.circ_axial_mean > pi/2) = stats.circ_axial_mean(stats.circ_axial_mean > pi/2) -pi; 
stats.vm_thetaHat(stats.vm_thetaHat > pi/2) = stats.vm_thetaHat(stats.vm_thetaHat > pi/2) -pi; 

% densities
stats.ang_bins = -pi:pi/36:pi;
stats.ax_bins = -pi/2:pi/36:pi/2;
stats.ang_density = histcounts(stats.theta, stats.ang_bins);
stats.ang_density = stats.ang_density/sum(stats.ang_density);
stats.axial_density = histcounts(stats.theta_axial, stats.ax_bins);
stats.axial_density = stats.axial_density/sum(stats.axial_density);
[stats.ang_map, stats.ang_map_bins]= plot_Density2D(X, Y, 1, 0.1, [20 20], false, 0);
stats.ang_map = stats.ang_map/sum(stats.ang_map(:));
% 
% figure;
% obj = CircHist(rad2deg(tree.ang_density));
%  figure; plot(tree.vm_angles, tree.vm_fit)


end