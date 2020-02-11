% OVERALL_DATAANALYSIS 	analysis pipeline for a single neuron
% 
%		INPUTS:
%		[1] Neuron Reconstruction [.swc]
%		[2] Orientation Tuning Response [.mat]
%		[3] Neuron Receptive Field [.mat]
%
%       OUTPUTS:
%       [1] Orientation Tuning Curve [.tif]
%       [2] Retinotopic Tree [.tif]
%       [3] Dendritic Histogram in Visual Space [.mat]
%
% See also: ORITUNE_FIGURE, RETINOMAP

% 2020 N Ghani and LF Rossi

%% Step 1: enter path of single neuron
addpath(genpath('/home/naureeng/cameraLucida')); 
addpath(genpath('/home/naureeng/cameraLucida/Dependencies'));

% specify folder name:
folder_name = 'FR068_1';
starterID = folder_name(end);

%% Step 2: plot orientation tuning curve
colorID = load( strcat( folder_name, '_colorID.mat' ) );
[tunePars, xval] = OriTune_Figure(folder_name, colorID);
% close;

%% Step 3: plot retinotopic tree
load( strcat( folder_name, '_neuRF_column_svd.mat' ) );
[tree, tree1, retX, retY] = RetinoMap( folder_name, dbVis ); 
% close;

%% Step 4: compute dendritic histogram in visual space
file_name_vis = strcat(folder_name, '_V');
fname_V = strcat(file_name_vis, '_soma');
[thetaBox] = DendriteBox_Moment( tree1, file_name_vis );

%% Step 5: plot dendritic histogram in visual space
load( strcat( folder_name, '_neuRF_column_svd.mat' ) ); % get db (prefDir)
PolarPlot( thetaBox.theta_deg  , fname_V, db, 'box', colorID ); % [-180 180]
ThetaPlot( thetaBox.theta_axial, fname_V, db, 'box', colorID ); % [-90 90]

%% Step 6: plot dendritic histogram in visual space ON cortical space neuron
PlotCorticalView( tree, thetaBox.theta_deg , fname_V, 'box' ); % box-by-box 

%% Step 7: plot dendritic histogram in visual space with von Mises fit 
[VM_std, OT_std] = histFinal( thetaBox.theta_deg, db, colorID, tunePars, folder_name );
% close;

%% Step 8: analysis complete
