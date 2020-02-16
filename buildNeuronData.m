%% Automated code to build neuronData.mat used in all following analysis
%  uses outputs of Overall_DataAnalysis.m as inputs to build struct
%
%  See also: OVERALL_DATAANALYSIS

%  2020 N Ghani and LF Rossi
%% NEURONDATA.MAT contains the following fields:
%		[1]  AE              = visual space tree                 [struct]
%		[2]  colorID         = preferred orientation color       [HEX code]
%		[3]  db              = prefOri and prefDir info          [struct]
%       [4]  dbMorph         = cortical space info               [struct]
%       [5]  dbVis           = visual space info                 [struct]
%       [6]  tunePars        = ori tune parameters               [double]
%       [7]  XY              = cortical space tree               [struct]
%       [8]  peaks_VM        = von Mises peaks                   [double]
%       [9]  thetaBox        = contains theta values             [struct]
%       [10] name            = folder name                       [string]
%       [11] avgAng          = avg angle in polar histogram      [double]
%       [12] OT_std          = ori tune std dev                  [double]
%       [13] VM_std          = von Mises std dev                 [double]
%       [14] somaCortex      = soma position - XY                [double]
%       [15] retX            = retinotopy    - X                 [double]  
%       [16] retY            = retinotopy    - Y                 [double]
%       [17] fovx            = field of view - X                 [double]
%       [18] fovy            = field of view - Y                 [double]
%

%% Step 1: enter path of single neuron
addpath(genpath('/home/naureeng/cameraLucida')); 
addpath(genpath('/home/naureeng/cameraLucida/Dependencies'));

% specify folder name:
folder_name = 'FR150_1';
ind = 18;

%% Step 2: add to struct
%% [1/18]
load( strcat(folder_name, '_AE.mat') );
neuronData(ind).AE = tree1;
%% [2/18]
load( strcat(folder_name, '_colorID.mat') );
neuronData(ind).colorID = colorID;
%% [5/18]
load( strcat(folder_name, '_neuRF_column_svd.mat') );
neuronData(ind).db = db;
neuronData(ind).dbMorph = dbMorph;
neuronData(ind).dbVis = dbVis;
%% [6/18]
load( strcat(folder_name, '_orientationTuning.mat') );
neuronData(ind).tunePars = tunePars;
%% [7/18]
load( strcat(folder_name, '_XY.mat') );
neuronData(ind).tree = tree;
%% [8/18]
load('peaks_VM.mat');
neuronData(ind).peaks_VM = peaks;
%% [9/18]
load( 'thetaBox.mat' );
neuronData(ind).thetaBox = thetaBox;
%% [10/18]
neuronData(ind).name = folder_name;
%% [11/18]
load( strcat(folder_name, '_V_soma_avgAng.mat') );
neuronData(ind).avgAng = avgAng;
%% [12/18]
load( strcat(folder_name, '_OT_std.mat') );
neuronData(ind).OT_std = OT_std;
%% [13/18]
load( strcat(folder_name, '_VM_std.mat') );
neuronData(ind).VM_std = VM_std;
%% [18/18]
neuronData(ind).somaCortex = dbVis.starterYX;
neuronData(ind).retX = dbVis.retX;
neuronData(ind).retY = dbVis.retY;
neuronData(ind).fovx = dbVis.fovx;
neuronData(ind).fovy = dbVis.fovy;

%% clear all but neuronData
clearvars -except neuronData







