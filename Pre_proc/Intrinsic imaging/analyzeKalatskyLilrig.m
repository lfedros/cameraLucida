function [out, pars] = analyzeKalatskyLilrig(ExpRef)

if nargin<1
    % this is just for debugging
    ExpRef = '2021-11-01_1_AH001';
end

animal = ExpRef(end-4:end);
day = ExpRef(1:10);
experiment = ExpRef(12:end-6);

% cam_color_n = 2;
% cam_color_signal = 'blue';
% cam_color_hemo = 'purple';
%%

data_path = ['\\zaru.cortexlab.net\Subjects\' animal filesep day filesep experiment];

pfileName = fullfile(data_path ,[ExpRef, '_', 'parameters.mat']);
p = load(pfileName);
p = p.parameters.Protocol;

tlfileName = fullfile(data_path ,[ExpRef, '_', 'Timeline.mat']);
load(tlfileName);

%% Load imaging data

% Load in all things as neural (n) or hemodynamic (h), and average them

fprintf('Loading imaging svds...\n');

data_path = ['\\zaru.cortexlab.net\Subjects\' animal filesep day];
experiment_path = [data_path filesep experiment];

cam_color_signal = 'blue';
cam_color_hemo = 'purple';

tn = readNPY([experiment_path filesep 'svdTemporalComponents_' cam_color_signal '.timestamps.npy']);
Un = readUfromNPY([data_path filesep 'svdSpatialComponents_' cam_color_signal '.npy']);
Vn = readVfromNPY([experiment_path filesep 'svdTemporalComponents_' cam_color_signal '.npy']);
avg_im_n = readNPY([data_path filesep 'meanImage_' cam_color_signal '.npy']);

th = readNPY([experiment_path filesep 'svdTemporalComponents_' cam_color_hemo '.timestamps.npy']);
Uh = readUfromNPY([data_path filesep 'svdSpatialComponents_' cam_color_hemo '.npy']);
Vh = readVfromNPY([experiment_path filesep 'svdTemporalComponents_' cam_color_hemo '.npy']);
avg_im_h = readNPY([data_path filesep 'meanImage_' cam_color_hemo '.npy']);

nSV = size(Vn,1);
framerate = 1./nanmedian(diff(tn));

min_frames = min(size(Vn,2),size(Vh,2));
Vn = Vn(:,1:min_frames);
Vh = Vh(:,1:min_frames);
th = th(1:min_frames);
tn = tn(1:min_frames);

[ny, nx, nSv] = size(Uh);
nt = size(Vh, 2);

% average h and n channels, since they are the same
mov = reshape(Uh, [], nSv)*Vh + reshape(Un, [], nSv)*Vn; 
clear Uh Un Vh Vn;
mov = fliplr(reshape(mov, ny, nx, nt))/2; % flip lr since svd are inverted for some reason

% average time stamps
tt = (th+tn)/2;

%%

% these are the frame onsets
fprintf('Extracting frame times...\n');
CamFrameTimes = tt;

% these are stimulus onset/offset times, as detected from the
% photodiode signal - nStims x nRepeats cell array
stimTimes = getStimTimes(Timeline, p);

% these are indices of frames acquired during the corresponding stimuli
stimFrames = cellfun(@(x) find(CamFrameTimes>x(1) & CamFrameTimes<x(2)), stimTimes, 'UniformOutput', false);

pars = getStimPars(p);
nStims = length(pars);
for iStim = 1:nStims
    pars(iStim).xAxis = linspace(3.5,0,size(avg_im_n,1));
    pars(iStim).yAxis = linspace(0,3.5,size(avg_im_n,2));
end

out.ExpRef = ExpRef;
out.pars = pars;
out.meanFrame = fliplr(avg_im_n);

fprintf('Generating preference maps...\n');
%out.averageMov = getAverageMovies(mov2, fusiFrameTimes, stimTimes, pars);
out.maps = getPreferenceMaps(mov, CamFrameTimes, stimTimes, pars);
fprintf('Done!\n');

%h = plotPreferenceMaps(out.maps,out.pars,true,'alpha'); %args: out.maps, out.pars, plotHemo, plotType
%%

% figure;
% subplot(2,2,1)
% imagesc(out.maps.xpos.prefPhase);
% subplot(2,2,2)
% imagesc(out.maps.ypos.prefPhase);
% subplot(2,2,3)
% imagesc(out.maps.xpos.amplitude);
% subplot(2,2,4)
% imagesc(out.maps.ypos.amplitude);

