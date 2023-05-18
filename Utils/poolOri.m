function [tune, dF, frameTimes, recDateExp] = poolOri(db, ops)

% whether to recompute from suite2P output (doLoad =0) or load already processed data (doLoad =1)
if nargin <2
    
    doLoad = 0;
else
    doLoad = ops.doLoad;
end

% this is the window after stimulus onset used to measure the response
if ~isfield(db, 'respWin')
    respWin = [0 2];
else
    respWin = db.respWin;
end

if ~doLoad % recompute from suite2P output
    
    nExp = numel(db.mouse_name); % number of longitudinal experiments
    
    % initialise the variables that we are going to pool across experiments
    allResp = [];
    allResPeak = [];
    aveResPeak  =[];
    allAveResp = [];
    recDate =[];
    F0_date = [];
    F0_neu_date = [];
    for iExp = 1:nExp
        
        % extract info from db file
        this_db.mouse_name = db.mouse_name_s2p{iExp};
        this_db.date = db.date_s2p{iExp};
        this_db.expts = db.expts{iExp};
        this_db.expID = db.expID{iExp};
        this_db.starterID = db.starterID;
        this_db.plane = db.plane(iExp);
        
        %% load fluorescence trace and neuropil
        [F, Fneu] = starter.loadF(this_db);
        
        % neuropil correction (equivalent to dF)
        [dF{iExp}, npPars] = estimateNeuropil_LFR(F,Fneu);
        % estimate F0 from lower quantile of data binned based on neuropil
%         F0(iExp) = npPars.corrFactor(2)*npPars.lowCell(1) + npPars.corrFactor(1);
                F0(iExp) = npPars.corrFactor(2)*npPars.fitNeuro(1) + npPars.corrFactor(1);

        % compute dF/F0
        dF{iExp} = dF{iExp}/F0(iExp);
        % smooth a bit
        dF{iExp} = gaussFilt(dF{iExp}', 1);
        Fneu = gaussFilt(Fneu', 1);
        
        %% load stimulus info
        info = ppbox.infoPopulateTempLFR(db.mouse_name{iExp}, db.date{iExp}, db.expts{iExp}(db.expID{iExp}));
        nFrames = numel(dF{iExp});
        planeFrames = db.plane(iExp):info.nPlanes:(nFrames*info.nPlanes);
        frameTimes{iExp} = ppbox.getFrameTimes(info, planeFrames);
        frameRate = (1/mean(diff(frameTimes{iExp})));
        stimTimes = ppbox.getStimTimes(info);
        stimSequence = ppbox.getStimSequence_LFR(info);
        if strcmp(this_db.date, '2022-09-14') && strcmp(this_db.mouse_name, 'FR225')
                stimSequence.seq= stimSequence.seq(1:87*5);
        end


        if stimTimes.onset(1) <frameTimes{iExp}(1)

            nMissing = ceil((frameTimes{iExp} (1)-stimTimes.onset(1))*frameRate);

            frameTimes{iExp} = cat(2, flip(frameTimes{iExp} (1) - (1:nMissing)/frameRate), frameTimes{iExp} );

            dF{iExp}  = cat(1, NaN(nMissing, 1),  dF{iExp} );

            warning('Your recording started late');

        elseif stimTimes.onset(end) > frameTimes{iExp}(end)
            warning('Your recording ended early');
        end


        stimMatrix = ppbox.buildStimMatrix(stimSequence, stimTimes, frameTimes{iExp});
        % select a subset of stimuli if specified in the db
        if isfield(db, 'stimList')
            stimSet = db.stimList{iExp};
            stimLabels{iExp} = stimSequence.labels(stimSet);
        end
       

        %% compute stimulus triggered responses
        % STA of neuropil
        [~, aveRespNeu] = ...
            getStimulusSweepsLFR(Fneu, stimTimes, stimMatrix,frameRate, stimSet); % responses is (nroi, nStim, nResp, nT)
        % this is the average response of neuropil across stimuli
        F0_neu(iExp) = max(mean(squeeze(aveRespNeu), 1));
        
        %STA of neuron
        [responses{iExp}, aveResp{iExp}, seResp{iExp}, kernelTime{iExp}, stimDur{iExp}] = ...
            getStimulusSweepsLFR(dF{iExp}, stimTimes, stimMatrix,frameRate, stimSet); % responses is (nroi, nStim, nResp, nT)
        % measure response in respWindow
        [resPeak{iExp}, aveResPeak{iExp}, seResPeak{iExp}] = ...
            Ori.gratingOnResp(responses{iExp}, kernelTime{iExp}, respWin);  % resPeak is (nroi, nStim, nResp)
        %     plotSweepResp(responses{iExp}, kernelTime{iExp}, stimDur{iExp});
        
        % pool across experiments
        allResp = cat(3, allResp, responses{iExp});
        allResPeak = cat(3, allResPeak, resPeak{iExp});
        recDate = cat(1, recDate,repmat(db.date{iExp},size(resPeak{iExp}, 3),1));
        F0_date = cat(1, F0_date,repmat(F0(iExp),size(resPeak{iExp}, 3),1));
        F0_neu_date = cat(1, F0_neu_date,repmat(F0_neu(iExp),size(resPeak{iExp}, 3),1));
        recDateExp(iExp, :) = db.date{iExp};
    end
    
    
    
    %% assign outputs
    [~,  nStim, nRep, ~] = size(allResp);
    
    tune.db = db;
    %     tune.dF = dF{iExp};
    tune.allResp = squeeze(allResp);
    tune.allPeaks = squeeze(allResPeak);
    tune.aveResp = squeeze(nanmean(allResp, 3));
    tune.seResp = squeeze(nanstd(allResp, 1,3)/sqrt(nRep));
    tune.avePeak = squeeze(mean(allResPeak, 3));
    tune.sePeak = squeeze(std(allResPeak, 1, 3)/sqrt(nRep));
    tune.time = kernelTime{1};
    tune.dirs = 0:30:330; % hardcoded
    tune.aveOriPeak = mean(cat(2, tune.allPeaks(1:6, :), tune.allPeaks(7:12, :)),2);
    tune.seOriPeak = std(cat(2, tune.allPeaks(1:6, :), tune.allPeaks(7:12, :)),[], 2)/sqrt(nRep*2);   
    tune.oris = tune.dirs;
    tune.oris(tune.oris>=180) = tune.oris(tune.oris>=180)-180;
    tune.recDate = recDate;
    tune.F0 = F0_date;
    tune.F0_neu = F0_neu_date;
    
    
    aveResp = tune.aveResp;
    seResp = tune.seResp;
    time = tune. time;
    allResp = tune.allResp;
    allPeaks = tune.allPeaks;
    avePeak = tune.avePeak;
    sePeak =tune.sePeak;
    dirs =tune.dirs ;
    oris =tune.oris;
    aveOriPeak =tune.aveOriPeak;
    seOriPeak =tune.seOriPeak;
    
    %% save
    dataRchive = 'D:\OneDrive - University College London\Data\Dendrites';
    targetFolder = fullfile(dataRchive, sprintf('%s_%d', db.animal,db.starterID));
    if ~exist(targetFolder, 'dir')
        mkdir(targetFolder);
    end
    
    
    if ~isempty(ops.expType)
        
        file = sprintf('%s_%d_gratings_dendrotomy.mat', db.animal, db.starterID);
    else
        
        file = sprintf('%s_%d_gratings.mat', db.animal, db.starterID);
    end
    
    
    save(fullfile(targetFolder, file),...
        'aveResp', 'seResp', 'time', 'allResp', 'allPeaks', 'avePeak',...
        'sePeak', 'dirs', 'oris', 'aveOriPeak', 'seOriPeak', 'recDate', 'F0', 'F0_neu');
    
else % or load alrady processed data
    dataRchive = 'D:\OneDrive - University College London\Data\Dendrites';
    targetFolder = fullfile(dataRchive, sprintf('%s_%d', db.animal,db.starterID));
    
    if ~isempty(ops.expType)
        
        file = sprintf('%s_%d_gratings_dendrotomy.mat', db.animal, db.starterID);
    else
        
        file = sprintf('%s_%d_gratings.mat', db.animal, db.starterID);
    end
    
    tune = load(fullfile(targetFolder, file),...
        'aveResp', 'seResp', 'time', 'allResp', 'allPeaks', 'avePeak',...
        'sePeak', 'dirs', 'oris', 'aveOriPeak', 'seOriPeak', 'recDate', 'F0', 'F0_neu');
    
end
end

