i =0;


i = i+1;
db(i).mouse_name    = 'FR130';
db(i).date          = '2018-04-04';
db(i).expts         = [1 2 3];
db(i).expID         = 1; 
db(i).plane         = 2;
db(i).starterID     = 1;


%% load info

info = ppbox.infoPopulateTempLFR(db.mouse_name, db.date, db.expts(db.expID ));

%% load ROI traces and measure dF/F

  [F, Fneu, root] = starter.loadF(db);
    
    [dF, neuropCorrPars] = estimateNeuropil(F,Fneu);
    
    dF = (dF - neuropCorrPars.corrFactor(1))';
        
    nFrames = numel(dF);
    
    planeFrames = db.plane:info.nPlanes:(nFrames*info.nPlanes);
    
    frameTimes = ppbox.getFrameTimes(info, planeFrames);

%% load stimulus info

stimTimes = rf.getStimTimes(info);

[stimFrames, stimFrameTimes, stimPosition] = rf.getStimulusFrames(info);

load('C:\Users\Federico\Documents\GitHub\cameraLucida\+rf\TimeCourseSmooth');
tKernel = TimeCourseSmooth(:)/sum(TimeCourseSmooth);
tKernel = tKernel(2:21);


%% calculate RF
nNeurons = size(dF, 2); 
trace = dF;

RFtype = {'on', 'off'}; 

[aveResp, oneTrace] = rf.aveSparseNoiseReps(trace, ...
        frameTimes, stimFrameTimes, stimTimes); 

    for iType = 1: numel(RFtype)

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
%%

