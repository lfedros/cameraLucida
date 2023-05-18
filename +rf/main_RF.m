clear;

i =0;

%
% i = i+1;
% db(i).mouse_name    = 'FR130';
% db(i).date          = '2018-04-04';
% db(i).expts         = [1 2 3];
% db(i).expID         = 1;
% db(i).plane         = 2;
% db(i).starterID     = 1;


i = i+1;
db(i).mouse_name    = 'FR225';
db(i).date          = '2022-09-11';
db(i).expts         = [4];
db(i).expID         =1;
db(i).plane         = 5;
db(i).starterID     = 4;

% i = i+1;
% db(i).mouse_name    = 'FR237';
% db(i).date          = '2023-05-09';
% db(i).expts         = [2];
% db(i).expID         =1;
% db(i).plane         = 4;
% db(i).starterID     = 5;


%%
addpath('\\zserver.cortexlab.net\Code\Stimulus');
addpath('\\zserver.cortexlab.net\Data\xfiles');
addpath('\\zserver.cortexlab.net\Code\Neuropil Correction');
addpath('\\zserver.cortexlab.net\Code\Spikes');
%% load info

info = ppbox.infoPopulateTempLFR(db.mouse_name, db.date, db.expts(db.expID ));

%% load ROI traces and measure dF/F

[F, Fneu, root] = starter.loadF(db);

[dF, neuropCorrPars] = estimateNeuropil(F,Fneu);

dF = (dF - neuropCorrPars.corrFactor(1))';

nFrames = numel(dF);

planeFrames = db.plane:info.nPlanes:(nFrames*info.nPlanes);

frameTimes = ppbox.getFrameTimes(info, planeFrames);

nNeurons = size(dF, 2);

%% load stimulus info

stimTimes = rf.getStimTimes(info);

[stimFrames, stimFrameTimes, stimPosition] = rf.getStimulusFrames(info);

[nPx_x, nPx_y, nsf] = size(stimFrames);
%% interpolate stimulus and imaging at same rate
load('C:\Users\Federico\Documents\GitHub\cameraLucida\+rf\TimeCourseSmooth'); % 10Hz
tKernel = TimeCourseSmooth(:)/sum(TimeCourseSmooth);
tKernel = tKernel(2:21);

%calculate rates
stimFrameRate = mean(unique(diff(stimFrameTimes)));
frameRate = mean(unique(diff(frameTimes)));

% interpolate at 10Hz
newFrameTimes = min(stimFrameTimes):0.1:max(stimFrameTimes);

stimFrames = reshape(stimFrames, nPx_x*nPx_y, nsf);
stimFrames = interp2(stimFrameTimes',1:(nPx_x*nPx_y), stimFrames, newFrameTimes', 1:(nPx_x*nPx_y));
stimFrames = reshape(stimFrames, nPx_x, nPx_y, []);

stimFrames(isnan(stimFrames)) = 0;

stimFrameTimes =newFrameTimes;
%% calculate RF

trace = dF;

% RFtype = {'on', 'off', 'onoff'};
RFtype = {'on', 'off'};

[aveResp, oneTrace] = rf.aveSparseNoiseReps(trace, ...
    frameTimes, stimFrameTimes, stimTimes);

for iType = 2: numel(RFtype)

    stim = rf.stim4typeRF(stimFrames, RFtype{iType}); % convert the stimulus for on, off, or any RF

    [staRF(:,:,:, iType), receptiveField(:,:,:,:, iType), rfTimes] = ...
        rf.staRF_dev(aveResp, stim, stimFrameTimes, tKernel);


    % cross-valitation to pick best smoothing constraint
    [psRF(:,:,:, iType), expVar(:,iType), lambda(:, iType), predResp(:, :, iType), const(:, iType)] =...
        rf.runPsinvSmoothRF_dev(aveResp, stim, tKernel);

    for iN = 1:nNeurons
        figure;
        rf.plot_RFregress(aveResp(:, iN) ,receptiveField(:,:,:,iN, iType), staRF(:,:,iN, iType),...
            psRF(:,:,iN, iType),RFtype{iType},expVar(iN, iType), predResp(:, iN, iType));
    end
end
%% new methods


trace = dF;

RFtype = {'on', 'off'};

[aveResp, oneTrace] = rf.aveSparseNoiseReps(trace, ...
    frameTimes, stimFrameTimes, stimTimes);

for iType = 1: numel(RFtype)

   [sRF, tRF, rfTimes, stRF] = ...
        rf.sta_stRF(aveResp, stim, stimFrameTimes, 10);
end

