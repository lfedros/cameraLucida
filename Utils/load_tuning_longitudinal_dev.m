function tuning = load_tuning_longitudinal_dev(db, target, doPlot, doSave)

if nargin < 3
    doPlot = 0;
end

if nargin < 4
    doSave= 0;
end


%%

[vis_file, vis_path] = build_path(db, 'vis');

if iscell(target)
    n_trees = numel(target); % data with pruning have longitudinal imaging 
                             % saved in different files

else
    n_trees = 1; % data without pruning have 1 file
    target = {target};

end

if n_trees>1
        prune_flag = 1;
else
    prune_flag =0;
end

for iS = 1:numel(target)
    idx = strfind(target{iS}, '_tuning');
    expDate = target{iS}(idx-10:idx-1);
    morph_Date(iS) = datetime(str2double(expDate(1:4)), str2double(expDate(6:7)), str2double(expDate(9:10)));
    load_saved(iS) = exist(fullfile(vis_path,target{iS}), 'file');
end

morph_Date(iS+1) = datetime(2088, 09, 20); %LFR 100th birthday

%% If the data were already processed, and requested, load them

if ~doSave && prod(load_saved)~=0
    for iSeq = 1:n_trees
        tuning(iSeq) = load(fullfile(vis_path, target{iSeq}));
    end
    return;
end

%%  Load the original tuning curve

% if data for baseline recs don't exist, return
if exist(fullfile(vis_path, vis_file), 'file')
    resps = load(fullfile(vis_path, vis_file));
else
    tuning = [];
    return;
end

% tuning{1} = retune(resps, [], 'global');
tuning(1) = retune(resps, [], 'date');

%% Load longitudinalresponses after pruning

if prune_flag
    
    [vis_file, vis_path] =  build_path(db, 'vis_cut');
    
    resps = load(fullfile(vis_path, vis_file));
    
    recDate = datetime(resps.recDate);   
    
    for iSeq = 2:n_trees
        
        date_trials = recDate>morph_Date(iSeq) & recDate <= morph_Date(iSeq+1);
        
        if sum(date_trials)>1
            
            seq_resps = resps;
            seq_resps.recDate = seq_resps.recDate(date_trials,:);
            seq_resps.allResp = seq_resps.allResp(:, date_trials,:);
            seq_resps.allPeaks = seq_resps.allPeaks(:, date_trials);
            
            % zscore with std computed from data before pruning
            tuning(iSeq) = retune(seq_resps, [], tuning(1).z_std); 
%             % zscore each 'pruned state' independently
%             tuning(iSeq) = retune(seq_resps, [], 'date');
            
            fixPars.ori = tuning(1).ori_pars_vm;
            fixPars.dir = tuning(1).dir_pars_vm;
            
            fixPars.ori(2:end) = NaN;
            fixPars.dir(2:end) = NaN;
            
            % fit tunign with parse fixed from baseline
            relative= retune(seq_resps, fixPars, tuning(1).z_std);
%             relative= retune(seq_resps, fixPars, 'date');
            
            tuning(iSeq).relative = relative;
        else
            tuning(iSeq) = [];
            
        end
        
        
    end
    
end


%%
if doSave
    
    for iSeq = 1:n_trees
        tree_tuning = tuning(iSeq);
        save(fullfile(vis_path, target{iSeq}), '-struct', 'tree_tuning');
    end
    
end
%%

if doPlot
    
    figure('Color', 'white');
    for iSeq = 1:numel(target)%        oricolors = hsv(180);

        if isempty(db.morph.dendrotomy{2})
        
                            line_c = [0 0 0];

        else
        switch db.morph.dendrotomy{2}
            case 'para'
                line_c = [1 0 0];
            case 'orth'
                
                line_c = [0 0.5 1];

        end
        end
        
        if ~isempty(tuning(iSeq))
            subplot(1,numel(target), iSeq)
            
            plot([0 390], [0 0], '--', 'Color', [0.3 0.3 0.3]); hold on
            errorbar(0:30:390, tuning(iSeq).avePeak([1:12,1, 13]), ...
                tuning(iSeq).sePeak([1:12,1, 13]), 'ok'); hold on
            if iSeq ==1
                plot(tuning(iSeq).fit_pt, tuning(iSeq).fit_vm, 'Color', line_c, 'LineWidth', 2)
                
            else
                plot(tuning(iSeq).fit_pt, tuning(iSeq).relative.fit_vm, 'Color', line_c, 'LineWidth', 2)
            end
            
            
            formatAxes
            set(gca, 'YColor', 'none','YTick', [], 'XTick', [0:90:360, 390], 'XTickLabel', {0:90:360, 'Bk'});
            xlim([-10 , 400])
            ylim([min(tuning(1).avePeak) - 2*mean(tuning(1).sePeak), max(tuning(1).avePeak) + 2*max(tuning(1).sePeak)])
            
            
        end
    end
    %%
end

end