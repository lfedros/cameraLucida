function tuning = load_tuning_longitudinal(neuron, doPlot)

if nargin < 2
    doPlot = 0;
end

%% Step1: Load the original tuning curve

vis_path = build_path(neuron.db, 'vis');

try
    resps = load(vis_path);
catch
    tuning = [];
    return;
end
dirs = -resps.dirs;
dirs = dirs+360;
dirs(dirs>=360) = dirs(dirs>=360) -360;
oris = unique(resps.oris, 'stable');
oris = -oris +180;
oris(oris>=180) =oris (oris>=180) -180;

[~, sort_dirs] = sort(dirs, 'ascend');
[~, sort_oris] = sort(unique(oris, 'stable'), 'ascend');

resps.allReps(1:12, :, :) = resps.allResp(sort_dirs, :, :);
resps.aveResp(1:12, :) = resps.aveResp(sort_dirs, :);
resps.seResp(1:12, :) = resps.seResp(sort_dirs, :);
resps.allPeaks(1:12, :) = resps.allPeaks(sort_dirs, :);
resps.avePeak(1:12) = resps.avePeak(sort_dirs);
resps.sePeak(1:12) = resps.sePeak(sort_dirs);
resps.aveOriPeak(1:6) = resps.aveOriPeak(sort_oris);
resps.seOriPeak(1:6) = resps.seOriPeak(sort_oris);

tuning{1} = retune(resps);


%% Step 2 load longitudinal responses

vis_path = build_path(neuron.db, 'vis_cut');

resps = load(vis_path);

recDate = datetime(resps.recDate);

cutDate(1) = datetime(1988, 09, 20); %LFR 0th birthday

for iSeq = 2:numel(neuron.morph_seq)
    
    expDate = neuron.morph_seq{iSeq}.date;
    cutDate(iSeq) = datetime(str2double(expDate(1:4)), str2double(expDate(6:7)), str2double(expDate(9:10)));
end

cutDate(numel(neuron.morph_seq)+1) = datetime(2088, 09, 20); %LFR 100th birthday

resps.allResp(1:12, :, :) = resps.allResp(sort_dirs, :, :);
resps.aveResp(1:12, :) = resps.aveResp(sort_dirs, :);
resps.seResp(1:12, :) = resps.seResp(sort_dirs, :);
resps.allPeaks(1:12, :) = resps.allPeaks(sort_dirs, :);
resps.avePeak(1:12) = resps.avePeak(sort_dirs);
resps.sePeak(1:12) = resps.sePeak(sort_dirs);
resps.aveOriPeak(1:6) = resps.aveOriPeak(sort_oris);
resps.seOriPeak(1:6) = resps.seOriPeak(sort_oris);


for iSeq = 2:numel(neuron.morph_seq)

    date_trials = recDate>cutDate(iSeq) & recDate <= cutDate(iSeq+1);    
    
    if sum(date_trials)>1
        
        seq_resps.recDate = resps.recDate(date_trials,:);
    seq_resps.allResp = resps.allResp(:, date_trials,:);
seq_resps.allPeaks = resps.allPeaks(:, date_trials);

tuning{iSeq} = retune(seq_resps);

fixPars.ori = tuning{1}.ori_pars_vm;
fixPars.dir = tuning{1}.dir_pars_vm;

fixPars.ori(2:end) = NaN;
fixPars.dir(2:end) = NaN;

relative= retune(resps, fixPars);

tuning{iSeq}.relative = relative;
    else
        tuning{iSeq} = {};

    
    
end
    
    
end
   

%%

if doPlot
    
    figure('Color', 'white'); 
for iSeq = 1:numel(neuron.morph_seq)%        oricolors = hsv(180);
 switch neuron.db.morph.dendrotomy{2}
       case 'para'
       line_c = [1 0 0];
       case 'orth'
           
       line_c = [0 0.5 1];

   end

if ~isempty(tuning{iSeq})
subplot(1,numel(neuron.morph_seq), iSeq)
    
plot([0 390], [0 0], '--', 'Color', [0.3 0.3 0.3]); hold on
    errorbar(0:30:390, tuning{iSeq}.avePeak([1:12,1, 13]), ...
        tuning{iSeq}.sePeak([1:12,1, 13]), 'ok'); hold on   
    if iSeq ==1
            plot(tuning{iSeq}.fit_pt, tuning{iSeq}.fit_vm, 'Color', line_c, 'LineWidth', 2)

    else
    plot(tuning{iSeq}.fit_pt, tuning{iSeq}.fit_vm, 'Color', line_c, 'LineWidth', 2)
    end

    
    formatAxes
    set(gca, 'YColor', 'none','YTick', [], 'XTick', [0:90:360, 390], 'XTickLabel', {0:90:360, 'Bk'});
    xlim([-10 , 400])
    ylim([min(tuning{1}.avePeak) - 2*mean(tuning{1}.sePeak), max(tuning{1}.avePeak) + 2*max(tuning{1}.sePeak)])
    
    
end
end
%%
end

end