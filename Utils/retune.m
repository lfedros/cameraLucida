function tune = retune(tune, fixPars, normalisation)

if nargin <2 || isempty(fixPars)
    
    fixPars.dir = nan(1,4);
    fixPars.ori = nan(1,3);
    
end

if nargin <3
    normalisation = 'global';
end

addpath('C:\Users\Federico\Google Drive\CarandiniLab\CarandiniLab_MATLAB\FedericoBox\Tuning');
[nStim, nRep, ~] = size(tune.allResp);

%% turn angles from clockwise to counterclockwise


dirs = -tune.dirs;
dirs = dirs+360;
dirs(dirs>=360) = dirs(dirs>=360) -360;
oris = unique(tune.oris, 'stable');
oris = -oris +180;
oris(oris>=180) =oris (oris>=180) -180;

[~, sort_dirs] = sort(dirs, 'ascend');
[~, sort_oris] = sort(unique(oris, 'stable'), 'ascend');

tune.allReps(1:12, :, :) = tune.allResp(sort_dirs, :, :);
tune.aveResp(1:12, :) = tune.aveResp(sort_dirs, :);
tune.seResp(1:12, :) = tune.seResp(sort_dirs, :);
tune.allPeaks(1:12, :) = tune.allPeaks(sort_dirs, :);
tune.avePeak(1:12) = tune.avePeak(sort_dirs);
tune.sePeak(1:12) = tune.sePeak(sort_dirs);
tune.aveOriPeak(1:6) = tune.aveOriPeak(sort_oris);
tune.seOriPeak(1:6) = tune.seOriPeak(sort_oris);



%% zscore according to recording blanks

if ~isnumeric(normalisation)
    
    switch normalisation
        
        case 'date'
            
            if isfield(tune, 'recDate')
                
                sessions = unique(tune.recDate, 'rows');
                
                nSes = size(sessions,1);
                
                for iS = 1:nSes
                    
                    s_trials = ismember(tune.recDate, sessions(iS,:), 'rows');
                    z_std(iS) = std(makeVec(tune.allResp(:, s_trials, :)));
                    n_trials(iS) = sum(s_trials);
%                     z_std(iS) = z_std(iS)/sqrt(n_trials(iS));
                    tune.allResp(:, s_trials, :) = tune.allResp(:, s_trials, :)./z_std(iS);
                    tune.allPeaks(:, s_trials) = tune.allPeaks(:, s_trials)./z_std(iS);
                    
                end
                
                z_std = z_std*n_trials'/sum(n_trials);
            else
                  z_std = nanstd(makeVec(tune.allResp(13,:, :)));
                    tune.allResp= tune.allResp./z_std;
                    tune.allPeaks = tune.allPeaks./z_std;
            end
            
        case 'global'
            z_std = std(makeVec(tune.allResp(:, :, :)));
            tune.allResp= tune.allResp./z_std;
            tune.allPeaks = tune.allPeaks./z_std;
    end
else
    z_std = normalisation;
    tune.allResp = tune.allResp./z_std;
    tune.allPeaks = tune.allPeaks./z_std;
end

nRep = size(tune.allResp,2);
tune.aveResp = squeeze(mean(tune.allResp, 2));
tune.seResp = squeeze(std(tune.allResp, [], 2))/sqrt(nRep);
tune.avePeak = squeeze(mean(tune.allPeaks,2));
tune.sePeak = squeeze(std(tune.allPeaks,[], 2))/sqrt(nRep);

tune.aveOriPeak = mean(cat(2, tune.allPeaks(1:6, :), tune.allPeaks(7:12, :)),2);
tune.seOriPeak = std(cat(2, tune.allPeaks(1:6, :), tune.allPeaks(7:12, :)),[], 2)/sqrt(nRep*2);
%%
tune.dirs = 0:30:330;

toFit= makeVec(tune.allPeaks(1:end-1, :))';
[tune.dir_pars_g, ~] = fitori(repmat(tune.dirs, 1,nRep), toFit);
tune.fit_g = oritune(tune.dir_pars_g, 0:1:359);
tune.dir_pars_vm = mfun.fitTuning(repmat(tune.dirs, 1,nRep), toFit, 'vm2', fixPars.dir);
tune.fit_vm = mfun.vonMises2(tune.dir_pars_vm, 0:1:359);
tune.fit_vm_12 = mfun.vonMises2(tune.dir_pars_vm, 0:30:330);
tune.fit_pt = 0:1:359;
tune.prefDir = tune.dir_pars_vm(1);



% tune.ori_pars_g = fitori(repmat(tune.oris, 1,nRep), toFit);
% tune.ori_fit_g = oritune(tune.ori_pars_g, 0:1:359);
% tune.ori_fit_pt = (0:1:359)/2;

% tune.aveOriPeak = (tune.avePeak(1:6) + tune.avePeak(7:12))/2;

tune.avePeak = mean(tune.allPeaks,2);
tune.sePeak = std(tune.allPeaks,[], 2)/sqrt(nRep);

tune.aveOriPeak = mean(cat(2, tune.allPeaks(1:6, :), tune.allPeaks(7:12, :)),2);
tune.seOriPeak = std(cat(2, tune.allPeaks(1:6, :), tune.allPeaks(7:12, :)),[], 2)/sqrt(nRep*2);

tune.oris = tune.dirs; %[0 360]
tune.oris(tune.oris>=180) = tune.oris(tune.oris>=180)-180; %[0 180]
tune.oris = tune.oris - 90; %[-90 90]
% tune.oris(tune.oris<0) = tune.oris(tune.oris<0) + 180; %[0 180]

tune.ori_pars_vm = mfun.fitTuning(repmat(tune.oris*2, 1,nRep), toFit, 'vm1', fixPars.ori);
tune.ori_fit_vm = mfun.vonMises(tune.ori_pars_vm, -180:1:179);
tune.ori_fit_pt = (-180:1:179)/2;
tune.prefOri = tune.ori_pars_vm(1)/2;
tune.prefOri = unwrap_angle(tune.prefOri, 1,1);


% measure parameters: prefDir, prefOri, Rp, Rn, Ro, Rb, DS, OS


tune.Ro = min(tune.ori_fit_vm);

pp = findpeaks(tune.fit_vm, 'SortStr', 'descend');
if numel(pp) ==2
    [tune.Rp, tune.Rn] = vecdeal(pp);
elseif numel(pp)==1
    [tune.Rp, tune.Rn] = vecdeal([pp, tune.Ro]);
elseif numel(pp)==0
    [tune.Rp, tune.Rn] = vecdeal([max(tune.fit_vm), tune.Ro]);
else
    warning('Weird tuning curve');
end

% tune.Rb = tune.avePeak(13);
tune.Rb = tune.avePeak(13);
tune.DS = (tune.Rp-tune.Rn)/(tune.Rp+abs(tune.Rn));

tune.Rp_ori = max(tune.ori_fit_vm);
tune.Ro_ori = min(tune.ori_fit_vm);
tune.OS = (tune.Rp_ori-tune.Ro_ori)/(tune.Rp_ori+abs(tune.Ro_ori));
% tune.OS_circ = circ_var(repmat(tune.oris*2*pi/180, 1,nRep), (toFit-min(toFit)));

bsl = min(tune.fit_vm_12);

if bsl>=0
    
    tune.OS_circ = circ_var(tune.oris*2*pi/180, tune.fit_vm_12');
elseif sum(tune.fit_vm_12<0) <12
    tune.OS_circ = circ_var(tune.oris*2*pi/180, tune.fit_vm_12' - min(tune.fit_vm_12));
else
        tune.OS_circ = circ_var(tune.oris*2*pi/180, abs(tune.fit_vm_12'));
end

tune.z_std = z_std;
if isnan(fixPars.dir)
tune.relative = [];
end
% minR = min(tune.aveOriPeak);
% topR = max(tune.aveOriPeak);
% oriResp = (tune.aveOriPeak-minR)/(topR-minR);
% tune.osi = circ_var(0:pi/3:5*pi/3, oriResp);


end

