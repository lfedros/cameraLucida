%% Step 1: load paths + resample tree

addpath(genpath('/home/naureeng/cameraLucida')); 
addpath(genpath('/home/naureeng/cameraLucida/Dependencies/treestoolbox'));

% we will work in directory of [SWC] files, update:
folder_name = 'FR140';
file_name = 'FR140_1';
colorID = 18;

%% oriTune
[tunePars, xval] = OriTune_Figure(folder_name, 1 , colorID);
close;

%%
folder_path = fullfile( '/home/naureeng/cameraLucida/' , folder_name );
file_path = fullfile(folder_path, strcat(file_name, '_tracing.swc') );
cd(folder_path);
% [tree,path,~] = load_tree( file_path, 'r' );
% tree = resample_tree(tree, 1); % resample tree every 5 microns
retino_path = fullfile('/home/naureeng/cameraLucida/Retinotopy/', strcat(folder_name, '_1_neuRF_column_svd.mat')); 
load(retino_path);

% %% Step 2: Segment-by-Segment Analysis
% [thetaMap, thetaRadialMap] = DendriteMorpho( tree, file_name );
% PolarPlot( thetaRadialMap, file_name, db, 'seg' );
% ThetaPlot( thetaMap, file_name, db, 'seg' );
% 
% %% Step 3: Box-by-Box Analysis
% [angleBCT] = DendriteBox( tree, file_name );
% [angleBCTRadialMap] = RadialBox( tree ); 
% 
% % remove NaNs
% [ind] = isnan(angleBCT);
% angleBCT(ind) = 0;
% 
% [ind] = isnan(angleBCTRadialMap);
% angleBCTRadialMap(ind) = 0;
% PolarPlot( angleBCTRadialMap, file_name, db, 'box', colorID ); 
% ThetaPlot( angleBCT, file_name, db, 'box', colorID );

%% Step 4: Retinotopy 
[tree, tree1, retX, retY] = RetinoMap( file_path, retino_path, file_name); % tree  = cortical space coordinates; tree1 = visual space coordinates
%%
file_name_vis = strcat(file_name, '_V');
%%
XY_tree = strcat(file_name, '_XY');
AE_tree = strcat(file_name, '_AE');
save( XY_tree, 'tree' );
save( AE_tree, 'tree1' ); 

% %%
% % [visual space theta, visual space view]
% [thetaMap_V, thetaRadialMap_V] = DendriteMorpho( tree1 , file_name_vis );  % tree1 for segment-by-segment
% [angleBCT_V] = DendriteBox( tree1, file_name_vis );                        % tree1 for box-by-box 
% 
% % save theta data
% [ind] = isnan(thetaMap_V);
% thetaMap_V(ind) = 0;
% 
% [ind] = isnan(thetaRadialMap_V);
% thetaRadialMap_V(ind) = 0;
% 
% theta.thetaMap_V = thetaMap_V;
% theta.thetaRadialMap_V = thetaRadialMap_V;
% 
% % remove NaNs + save
% [ind] = isnan(angleBCT_V);
% angleBCT_V(ind) = 0;
% theta.angleBCT_V = angleBCT_V;
% 
% % get radial data [2nd set]
% angleBCTRadialMap_V = RadialBox( tree1 ); 
% [ind_2] = isnan(angleBCTRadialMap_V);
% angleBCTRadialMap_V(ind_2) = 0; 
% theta.angleBCTRadialMap_V = angleBCTRadialMap_V;
% 
% % [visual space theta, cortical space view]
% PlotCorticalView( tree, thetaMap_V, file_name_vis, 'seg' ); % segment-by-segment
% PlotCorticalView( tree, angleBCT_V, file_name_vis, 'box' ); % box-by-box 
% 
% %% Step 5: Do Circular Stats
% 
% % axial data
% thetaMap_V_ang = theta.thetaMap_V.*(pi/180);
% stats_thetaMap_V = circ_stats( thetaMap_V_ang ); 
% save('stats_thetaMap_V', 'stats_thetaMap_V');
% 
% angleBCT_V_ang = theta.angleBCT_V.*(pi/180);
% stats_angleBCT_V = circ_stats( angleBCT_V_ang ); 
% save('stats_angleBCT_V', 'stats_angleBCT_V');
% 
% % radial data
% thetaRadialMap_V_ang = theta.thetaRadialMap_V.*(pi/180);
% stats_thetaRadialMap_V_ang = circ_stats( thetaRadialMap_V_ang );
% save('stats_thetaRadialMap_V_ang','stats_thetaRadialMap_V_ang');
% 
% angleBCTRadialMap_V_ang = theta.angleBCTRadialMap_V.*(pi/180);
% stats_angleBCTRadialMap_V = circ_stats( angleBCTRadialMap_V_ang ); 
% save('stats_angleBCTRadialMap_V', 'stats_angleBCTRadialMap_V');
% 
% 
% save('theta','theta');
% 
% %% Visual Space Theta
% load('theta.mat');
% 
% PolarPlot( thetaRadialMap_V, file_name_vis, db, 'seg' );
% ThetaPlot( thetaMap_V, file_name_vis, db, 'seg' );
% PolarPlot( angleBCTRadialMap_V, file_name_vis, db, 'box' ); 
% ThetaPlot( angleBCT_V, file_name_vis, db, 'box' );

%% Dendrite Box-by-Box : Soma Analysis
[theta_axial, theta_deg] = DendriteBox_Moment( tree1, file_name_vis );
%%
fname_V = strcat(file_name_vis, '_soma');
%%
% remove NaN
[ind] = isnan(theta_deg);
theta_deg(ind) = 0;

[ind] = isnan(theta_axial);
theta_axial(ind) = 0;

% built thetaBox strucut
thetaBox.theta_deg = theta_deg;
thetaBox.theta_axial = theta_axial;
save('thetaBox','thetaBox');

% NOTE: in PolarPlot.m , for this section of the code:
% use obj1 = CircHist(thetaMap, (-5:10:360-5),  'areAxialData', true );


PolarPlot( theta_deg , fname_V, db, 'box' , colorID ); % circular data [-180 180]
%%
ThetaPlot( theta_axial, fname_V, db, 'box', colorID ) % axial data  [-90 90]
%%
PlotCorticalView( tree, theta_axial , fname_V, 'box' ); % box-by-box 

%% histFinal
histFinal( folder_name, colorID, tunePars );
close;

