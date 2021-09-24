function tree = tree_angular_stats(tree)

if isempty(tree)
    return;
end


X = tree.X; 
Y = tree.Y;

% make sure we are centered at the soma
X = X -X(1);
Y = Y -Y(1);

% measure length

L  = len_tree(tree);
tree.L = sum(L); 

% convert to radial coordinates
[tree.theta, tree.rho] = cart2pol(X, Y); %[-pi pi]

tree.theta_axial = tree.theta;
tree.theta_axial(tree.theta_axial<0) = tree.theta_axial(tree.theta_axial<0)+pi; %[0 pi]
% calculate angular statistics
tree.circ_var = circ_var(tree.theta);
tree.circ_axial_var = circ_var(tree.theta_axial*2);
tree.circ_mean = circ_mean(tree.theta);
tree.circ_axial_mean = circ_mean(tree.theta_axial*2)/2;
if tree.circ_axial_mean<0
    tree.circ_axial_mean = tree.circ_axial_mean +pi; %[0 pi]
end

[tree.vm_thetaHat, tree.vm_kappa] = circ_vmpar(tree.theta_axial*2); % [von Mises parameters]
[tree.vm_fit, tree.vm_angles] = circ_vmpdf( -pi:pi/180:pi, tree.vm_thetaHat, tree.vm_kappa);
tree.vm_angles = tree.vm_angles/2;
tree.vm_thetaHat = tree.vm_thetaHat/2;

tree.theta_axial(tree.theta_axial > pi/2) = tree.theta_axial(tree.theta_axial > pi/2) -pi; 
tree.circ_axial_mean(tree.circ_axial_mean > pi/2) = tree.circ_axial_mean(tree.circ_axial_mean > pi/2) -pi; 
tree.vm_thetaHat(tree.vm_thetaHat > pi/2) = tree.vm_thetaHat(tree.vm_thetaHat > pi/2) -pi; 

% densities
tree.ang_bins = -pi:pi/36:pi;
tree.ax_bins = -pi/2:pi/36:pi/2;
tree.ang_density = histcounts(tree.theta, tree.ang_bins);
tree.ang_density = tree.ang_density/sum(tree.ang_density);
tree.axial_density = histcounts(tree.theta_axial, tree.ax_bins);
tree.axial_density = tree.axial_density/sum(tree.axial_density);
[tree.ang_map, tree.ang_map_bins]= plot_Density2D(X, Y, 1, 0.1, [20 20], false, 0);
tree.ang_map = tree.ang_map/sum(tree.ang_map(:));
% 
% figure;
% obj = CircHist(rad2deg(tree.ang_density));
%  figure; plot(tree.vm_angles, tree.vm_fit)


end