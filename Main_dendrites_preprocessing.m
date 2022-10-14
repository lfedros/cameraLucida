%% RUN this to load and save responses to drifting gratings (new datasets only)

clear;
addpath('C:\Users\Federico\Documents\GitHub\cameraLucida\db');
make_db_dendrite_ablation; % master database of orientation tuning recordings
% make_db_dendrite_iGluSnFR_GCaMP; % master database of orientation tuning recordings

addpath('\\zserver.cortexlab.net\Code\Neuropil Correction\');
addpath('E:\Google Drive\CarandiniLab\CarandiniLab_MATLAB\FedericoBox\2P')
nDb = numel(db);
%% load and save 2 separate mat files in the target folder: gratings and gratings_cut

for iDb = 11:nDb
    
    ops.saveDir = 'D:\OneDrive - University College London\Data\Dendrites';
    ops.doLoad = 0;
    ops.expType = '';
    [resp(iDb), dF, frameTimes, recDateExp] = poolOri(db(iDb), ops);

    ops.expType = '_abl';
    if ~isempty(db_abl(iDb).animal)
        [resp_abl(iDb), dF_abl, frameTimes_abl, recDateExp_abl] = poolOri(db_abl(iDb), ops);
    end
    %     figure;
    %     subplot(2,1,1)
    %     F0_neu = [resp(iDb).F0_neu, resp_abl(iDb).F0_neu]; plot(F0_neu)
    %         subplot(2,1,2)
    %     F0 = [resp(iDb).F0, resp_abl(iDb).F0]; plot(F0)
    
end
% plotSweepResp_LFR(resp_abl(iDb).allResp(:, :,:), resp_abl(iDb).time, 2);
% plotSweepResp_LFR(resp(iDb).allResp(:, :,:), resp(iDb).time, 2);

%% plot


maxT = max(cellfun(@max, cat(2, frameTimes_abl,frameTimes)));
maxF = max(cellfun(@max, cat(2, dF_abl,dF)));

figure;

date = unique(recDateExp, 'rows');
date_abl = unique(recDateExp_abl, 'rows');

nCol = 2; nRows = max(size(date,1), size(date_abl,1));

for iR = 1: size(date,1)
    
    session = ismember(recDateExp, date(iR,:), 'rows');
    
    thisF = cat(1, dF{session});
    whichS = find(session);
    if numel(whichS)>1
        for iS = 2:numel(whichS)
            frameTimes{whichS(iS)} = frameTimes{whichS(iS)} - ...
                frameTimes{whichS(iS)}(1) + frameTimes{whichS(iS-1)}(end)...
                +mean(diff( frameTimes{whichS(iS-1)}));
        end
    end
    thisFrameTimes = cat(2, frameTimes{session});
    
    subplot(nRows, nCol,(iR-1)*2 +1)
    plot(thisFrameTimes, gaussFilt(calcium.highpassF(thisF, 3, 0.001),2))
    xlim([50 600])
    ylim([-0.5 2])
        formatAxes;
    title(sprintf(date(iR,:)));
end


for iR = 1: size(date_abl,1)
    
    session = ismember(recDateExp_abl, date_abl(iR,:), 'rows');
    
    thisF = cat(1, dF_abl{session});
    whichS = find(session);
    if numel(whichS)>1
        for iS = 2:numel(whichS)
            frameTimes_abl{whichS(iS)} = frameTimes_abl{whichS(iS)} - ...
                frameTimes_abl{whichS(iS)}(1) + frameTimes_abl{whichS(iS-1)}(end)...
                +mean(diff( frameTimes_abl{whichS(iS-1)}));
        end
    end
    thisFrameTimes = cat(2, frameTimes_abl{session});
    
    subplot(nRows, nCol,iR*2)
    plot(thisFrameTimes, gaussFilt(calcium.highpassF(thisF, 3, 0.001),2))
    xlim([50 600])
    ylim([-0.5 2])
    formatAxes;
    title(sprintf(date_abl(iR,:)));
end



%% RUN this to load and save retinotopic mapping data

clear;
addpath('C:\Users\Federico\Documents\GitHub\Dbs\V1_dendrites');
dataRchive = 'D:\OneDrive - University College London\Data\Dendrites';

db_V1_dendrites;
db_den = db; clear db;

% noDir = ~isnan([dbRet_all.prefDir]);

nDb = numel(db_den);


for iDb = 18%nDb
    
    try
        
        %         root = 'C:\Users\Federico\Google Drive\CarandiniLab\CarandiniLab_MATLAB\Data\rvRetinotopy';
        %         saveDir = fullfile(root, db_den(iDb).morph.expRef{1});
        root ='\\zserver.cortexlab.net\Lab\Share\Naureen';
        
        saveDir = fullfile(root, sprintf('%s_%d', db_den(iDb).animal, db_den(iDb).neuron_id));
        
        grat = load(fullfile(saveDir,...
            [sprintf('%s_%d_orientationTuning',db_den(iDb).animal, db_den(iDb).neuron_id)]),...
            'responses', 'aveResp', 'seResp', 'kernelTime', 'stimDur', 'stimLabels', ...
            'aveAllResPeak', 'seAllResPeak', 'aveAllResp', 'seAllResp', 'tunePars', ...
            'allResp', 'allResPeak');
        
        allResp = squeeze(grat.allResp);
        allPeaks = squeeze(grat.allResPeak);
        
        [nStim, nRep, ~] = size(allResp);
        aveResp = squeeze(nanmean(allResp, 2));
        seResp = squeeze(nanstd(allResp, 1,2)/sqrt(nRep));
        avePeak = squeeze(mean(allPeaks, 2));
        sePeak = squeeze(std(allPeaks, 1, 2)/sqrt(nRep));
        
        time = grat.kernelTime{1};
        dirs = 0:30:330;
        
        aveOriPeak = mean(cat(2, allPeaks(1:6, :), allPeaks(7:12, :)),2);
        seOriPeak = std(cat(2, allPeaks(1:6, :), allPeaks(7:12, :)),[], 2)/sqrt(nRep*2);
        
        oris = dirs;
        oris(oris>=180) = oris(oris>=180)-180;
        
        file = sprintf('%s_%d_gratings.mat', db_den(iDb).animal, db_den(iDb).neuron_id);
        targetFolder = fullfile(dataRchive, sprintf('%s_%d', db_den(iDb).animal, db_den(iDb).neuron_id));
        
        save(fullfile(targetFolder, file),...
            'aveResp', 'seResp', 'time', 'allResp', 'allPeaks', 'avePeak',...
            'sePeak', 'dirs', 'oris', 'aveOriPeak', 'seOriPeak');
        
    catch
        
        %       load(fullfile(targetFolder,'tune.mat'));
        %       aveResp
        %       seResp
        %       time
        %       allResp
        %       allResPeak
        %       avePeak
        %       sePeak
        %       dirs
        %       oris
        %       aveOriPeak
        %       seOriPeak
        warning('%s_%d', db_den(iDb).animal, db_den(iDb).neuron_id);
    end
    
    
    
    
    
end

%% RUN this to load and save retinotopic mapping data

clear;
addpath('C:\Users\Federico\Documents\GitHub\Dbs\V1_dendrites');
dataRchive = 'D:\OneDrive - University College London\Data\Dendrites';

db_V1_dendrites;
db_den = db; clear db;

% noDir = ~isnan([dbRet_all.prefDir]);

nDb = numel(db_den);




for iDb = 49
    
    expID = db_den(iDb).retino.expID;
    
    try
        %         root = 'C:\Users\Federico\Google Drive\CarandiniLab\CarandiniLab_MATLAB\Data\rvRetinotopy';
        %         retDir = fullfile(root, db_den(iDb).morph.expRef{1});
        
        root ='\\zserver.cortexlab.net\Lab\Share\Naureen';
        retDir = fullfile(root, sprintf('%s_%d', db_den(iDb).animal, db_den(iDb).neuron_id));
        
        file = sprintf('%s_%d_neuRF_column_svd.mat', db_den(iDb).animal, db_den(iDb).neuron_id);
        %         retino = load(fullfile(retDir, file), 'retX', 'retY', 'micronsX', 'micronsY');
        retino = load(fullfile(retDir, file));
        
        
        micronsX = retino.dbVis.micronsX;
        micronsY = retino.dbVis.micronsY;
        retX = retino.dbVis.retX;
        retY = retino.dbVis.retY;
    catch
        
        root = 'D:\OneDrive - University College London\Data\2P';
        retDir = fullfile(root, db_den(iDb).retino.expRef{1}, db_den(iDb).retino.expRef{2}, num2str(db_den(iDb).retino.expRef{3}));
        file = sprintf('%s_%s_%d_fovRetinotopy.mat', db_den(iDb).retino.expRef{1}, db_den(iDb).retino.expRef{2}, db_den(iDb).retino.expRef{3});
        retino = load(fullfile(retDir, file), 'retX', 'retY', 'micronsX', 'micronsY');
        micronsX = retino.micronsX;
        micronsY = retino.micronsY;
        retX = retino.retX;
        retY = retino.retY;
        warning('%s_%d not found in Naureen/Data', db_den(iDb).animal, db_den(iDb).neuron_id);
        
    end
    
    
    
    % info = ppbox.infoPopulateTempLFR(db(expID).mouse_name, db(expID).date, db(expID).expts(db(expID).expID));
    % [micronsX, micronsY, ~] = ppbox.getPxXYZ(info);
    
    file = sprintf('%s_%d_retinotopy.mat', db_den(iDb).animal, db_den(iDb).neuron_id);
    targetFolder = fullfile(dataRchive, sprintf('%s_%d', db_den(iDb).animal, db_den(iDb).neuron_id));
    save(fullfile(targetFolder,file), 'micronsX', 'micronsY', 'retX', 'retY');
end

