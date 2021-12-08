function tuning = load_tuning(neuron, type, doPlot)

if nargin < 2
    doPlot = 0;
end

%% Step1: Load tuning curve

vis_path = build_path(neuron.db, type);

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


resps.allResp(1:12, :, :) = resps.allResp(sort_dirs, :, :);
resps.aveResp(1:12, :) = resps.aveResp(sort_dirs, :);
resps.seResp(1:12, :) = resps.seResp(sort_dirs, :);
resps.allPeaks(1:12, :) = resps.allPeaks(sort_dirs, :);
resps.avePeak(1:12) = resps.avePeak(sort_dirs);
resps.sePeak(1:12) = resps.sePeak(sort_dirs);
resps.aveOriPeak(1:6) = resps.aveOriPeak(sort_oris);
resps.seOriPeak(1:6) = resps.seOriPeak(sort_oris);

% %% zscore according to recording blanks
% 
% if isfield(resps, 'recDate')
% 
% sessions = unique(resps.recDate, 'rows');
% 
% nSes = size(sessions,1); 
% 
% for iS = 1:nSes
%     
%     s_trials = ismember(resps.recDate, sessions(iS,:), 'rows');
%     z_std = std(makeVec(resps.allResp(13, s_trials, :)));
%     resps.allResp(:, s_trials, :) = resps.allResp(:, s_trials, :)./z_std;
%     resps.allPeaks(:, s_trials) = resps.allPeaks(:, s_trials)./z_std;
% 
% end
% 
% nRep = size(resps.allResp,2);
% resps.aveResp = squeeze(mean(resps.allResp, 2));
% resps.seResp = squeeze(std(resps.allResp, [], 2))/sqrt(nRep);
% resps.avePeak = squeeze(mean(resps.allPeaks,2));
% resps.sePeak = squeeze(std(resps.allPeaks,[], 2))/sqrt(nRep);
% 
% resps.aveOriPeak = mean(cat(2, resps.allPeaks(1:6, :), resps.allPeaks(7:12, :)),2);
% resps.seOriPeak = std(cat(2, resps.allPeaks(1:6, :), resps.allPeaks(7:12, :)),[], 2)/sqrt(nRep*2);
% end
%%

tuning = retune(resps, [], 'global');
% tuning = retune(resps, [], 'date');

if strcmp(type, 'vis_cut')

    tuning = retune(resps, [], neuron.tuning.z_std);
%     tuning = retune(resps, [], 'date');

    
fixPars.ori = neuron.tuning.ori_pars_vm;
fixPars.dir = neuron.tuning.dir_pars_vm;

fixPars.ori(2:end) = NaN;
fixPars.dir(2:end) = NaN;

relative= retune(resps, fixPars, neuron.tuning.z_std);
% relative= retune(resps, fixPars, 'date');

tuning.relative = relative;
else
% tuning = retune(resps, [], 'global');
% tuning = retune(resps, [], 'date');

end

if doPlot
    
%        oricolors = hsv(180);
%     color  = oricolors(round(unwrap_angle(unwrap_angle(tunePars(1),0,1)+180,1,1)), 1:3);
color = [0 0 0];
plot_tuning(tuning, color);
end
%%


end