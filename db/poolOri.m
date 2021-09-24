function tune = poolOri(db, ops)

if nargin <2
    
    doLoad = 0;
else
    doLoad = ops.doLoad;
end


if ~isfield(db, 'respWin')
respWin = [0 2];
else
    respWin = db.respWin;
end


if ~doLoad
nExp = numel(db.mouse_name);

allResp = [];
allResPeak = [];
aveResPeak  =[];
allAveResp = [];
recDate =[];
for iExp = 1:nExp
    
    this_db.mouse_name = db.mouse_name_s2p{iExp};
    this_db.date = db.date_s2p{iExp};
    this_db.expts = db.expts{iExp};
    this_db.expID = db.expID{iExp};
    this_db.starterID = db.starterID;
    this_db.plane = db.plane(iExp);
    
    [F, Fneu] = starter.loadF(this_db);
    
    [dF, npPars] = estimateNeuropil_LFR(F,Fneu);

    dF = gaussFilt(dF', 1)';

    dF = zscore(dF');
  
    info = ppbox.infoPopulateTempLFR(db.mouse_name{iExp}, db.date{iExp}, db.expts{iExp}(db.expID{iExp}));

    nFrames = numel(dF);
    planeFrames = db.plane(iExp):info.nPlanes:(nFrames*info.nPlanes);
    frameTimes = ppbox.getFrameTimes(info, planeFrames);
    frameRate = (1/mean(diff(frameTimes)));
    stimTimes = ppbox.getStimTimes(info);
    stimSequence = ppbox.getStimSequence_LFR(info);
    stimMatrix = ppbox.buildStimMatrix(stimSequence, stimTimes, frameTimes);
    
    if isfield(db, 'stimList')
        
        stimSet = db.stimList{iExp};
        stimLabels{iExp} = stimSequence.labels(stimSet);
        
    end
    
    
    [responses{iExp}, aveResp{iExp}, seResp{iExp}, kernelTime{iExp}, stimDur{iExp}] = ...
        getStimulusSweepsLFR(dF, stimTimes, stimMatrix,frameRate, stimSet); % responses is (nroi, nStim, nResp, nT)
    [resPeak{iExp}, aveResPeak{iExp}, seResPeak{iExp}] = ...
        Ori.gratingOnResp(responses{iExp}, kernelTime{iExp}, respWin);  % resPeak is (nroi, nStim, nResp)

%     plotSweepResp(responses{iExp}, kernelTime{iExp}, stimDur{iExp});
    
    allResp = cat(3, allResp, responses{iExp});
    try
    allAveResp = allAveResp + (aveResp{iExp}/max(makeVec(aveResp{iExp})))/nExp;
    catch
        allAveResp = (aveResp{iExp}/max(makeVec(aveResp{iExp})))/nExp;
    end
    allResPeak = cat(3, allResPeak, resPeak{iExp});
%     aveRepPeak = cat(3, aveRepPeak, mean(resPeak{iExp}, 3));
recDate = cat(1, recDate,repmat(db.date{iExp},size(resPeak{iExp}, 3),1));  
end



%%
[~,  nStim, nRep, ~] = size(allResp);

tune.allResp = squeeze(allResp);
tune.allPeaks = squeeze(allResPeak);

tune.aveResp = squeeze(nanmean(allResp, 3));
tune.seResp = squeeze(nanstd(allResp, 1,3)/sqrt(nRep));
tune.avePeak = squeeze(mean(allResPeak, 3));
tune.sePeak = squeeze(std(allResPeak, 1, 3)/sqrt(nRep));

tune.time = kernelTime{1};
tune.dirs = 0:30:330;
% toFit= makeVec(allResPeak(1, 1:end-1, :))';
% [tune.dir_pars_g, ~] = fitori(repmat(tune.dirs, 1,nRep), toFit);
% tune.fit_g = oritune(tune.dir_pars_g, 0:1:359);
%  tune.dir_pars_vm = fitTuning(repmat(tune.dirs, 1,nRep), toFit, 'vm2');
%  tune.fit_vm = vonMises2(tune.dir_pars_vm, 0:1:359);
% tune.fit_pt = 0:1:359;



% %     save(fullfile(ops.saveDir, [db.animal, '_', num2str(db.starterID)], sprintf('tune%s.mat', ops.expType)), sprintf('tune%s', ops.expType));
% 
% 
% 
% 
% % tune.ori_pars_g = fitori(repmat(tune.oris, 1,nRep), toFit);
% % tune.ori_fit_g = oritune(tune.ori_pars_g, 0:1:359);
% % tune.ori_fit_pt = (0:1:359)/2;
%     
% % tune.aveOriPeak = (tune.avePeak(1:6) + tune.avePeak(7:12))/2;

tune.aveOriPeak = mean(cat(2, tune.allPeaks(1:6, :), tune.allPeaks(7:12, :)),2);
tune.seOriPeak = std(cat(2, tune.allPeaks(1:6, :), tune.allPeaks(7:12, :)),[], 2)/sqrt(nRep*2);

tune.oris = tune.dirs;
tune.oris(tune.oris>=180) = tune.oris(tune.oris>=180)-180;
tune.recDate = recDate;
% tune.ori_pars_vm = fitTuning(repmat(tune.oris, 1,nRep), toFit, 'vm1');
% tune.ori_fit_vm = vonMises(tune.ori_pars_vm, 0:1:359);
% tune.ori_fit_pt = (0:1:359)/2;


% 
% % minR = min(tune.aveOriPeak);
% % topR = max(tune.aveOriPeak);
% % oriResp = (tune.aveOriPeak-minR)/(topR-minR);
% % tune.osi = circ_var(0:pi/3:5*pi/3, oriResp);


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
        'sePeak', 'dirs', 'oris', 'aveOriPeak', 'seOriPeak', 'recDate');

else
   dataRchive = 'D:\OneDrive - University College London\Data\Dendrites';
    targetFolder = fullfile(dataRchive, sprintf('%s_%d', db.animal,db.starterID));

      if ~isempty(ops.expType)
          
            file = sprintf('%s_%d_gratings_dendrotomy.mat', db.animal, db.starterID);
      else
    
       file = sprintf('%s_%d_gratings.mat', db.animal, db.starterID);
      end

    tune = load(fullfile(targetFolder, file),...
        'aveResp', 'seResp', 'time', 'allResp', 'allPeaks', 'avePeak',...
        'sePeak', 'dirs', 'oris', 'aveOriPeak', 'seOriPeak', 'recDate');

    end
end

