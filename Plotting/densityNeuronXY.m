function [] = densityNeuronXY( neuronData, ind )

% DENSITYNEURON	density plot of average of neurons
% 
%		INPUTS:
%		[1] neuronData = neuron reconstructions [struct]
%		[2] ind        = indices [mat]
%
%       OUTPUTS:
%       [1] density plot [.tif]
%
% See also: DENSITYPLOT

% 2020 N Ghani and LF Rossi

%% Step 1: add paths
addpath('/home/naureeng/cameraLucida/Dependencies/treestoolbox'); 
cd('/home/naureeng/cameraLucida/');

%% Step 2: super-impose neurons
n = length(neuronData); % number of cells

% parameters for plot_Density2D
spaceBin = 20;
sigma = 0.1;
mlims = [400, 400];
NaNbkg = 0;

xy_tree = cell(n,1);
for i = 1 : n
    tree = neuronData(i).XY; % load tree
    db = neuronData(ind(i)).db; % load db
    prefOri = db.prefDir; % get prefOri
    tree_rot = rot_tree( tree, [0 0 prefOri] ); % rotate tree in z-axis
    [xy, xbins, ybins] = plot_Density2D( tree_rot.X, -tree_rot.Y, spaceBin, sigma, mlims, NaNbkg, 0);
    hold on;
    xy_tree{i,1} = xy / sum( xy(:) ); % sum normalisation
end

%% Step 3: average all neurons
XY = cat( 3, xy_tree{:} );
xy = mean(XY,3);

%% Step 4: update appearance of plot to be publication-ready
xyProf = imgaussfilt( xy, sigma );
xyProf = xyProf/ sum( xyProf(:) );
cmap = BlueWhiteRed_burnLFR( 1001, 1 );
cmapRed = cmap(502:1001, :);
cmap = cmapRed;

figure;
colormap ( cmap );
imagesc( xbins, ybins, xyProf ); axis image
scale = caxis/2;
caxis( scale );
xlabel(' X [microns] ');
ylabel(' Y [microns] ');
formatAxes
caxis([0 0.04]);
colorbar;
set(gca, 'fontname', 'Te X Gyre Heros'); % due to Linux compatability issue with Helvetica font

end
