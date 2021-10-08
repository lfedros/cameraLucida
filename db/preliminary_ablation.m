clear;
addpath('C:\Users\Federico\Documents\GitHub\cameraLucida\db');
make_db_dendrite_ablation;

nDb = numel(db);
%%

for iDb = 1:nDb
    
    ops.saveDir = 'D:\OneDrive - University College London\Data\Dendrites';
    ops.doLoad = 0;
    ops.expType = '';
    resp(iDb) = poolOri(db(iDb), ops);
    ops.expType = '_abl';
    if ~isempty(db_abl(iDb).animal)
    resp_abl(iDb) = poolOri(db_abl(iDb), ops);
    end
%     figure;
%     subplot(2,1,1)
%     F0_neu = [resp(iDb).F0_neu, resp_abl(iDb).F0_neu]; plot(F0_neu)
%         subplot(2,1,2)
%     F0 = [resp(iDb).F0, resp_abl(iDb).F0]; plot(F0)

end
% plotSweepResp_LFR(resp_abl(iDb).allResp(:, :,:), resp_abl(iDb).time, 2);
% plotSweepResp_LFR(resp(iDb).allResp(:, :,:), resp(iDb).time, 2);

%%

cd('C:\Users\Federico\Documents\GitHub\cameraLucida\new')

for iDb = 1:nDb
        tune(iDb) = retune(resp(iDb));
        fixPars.dir = nan(1,4);
        fixPars.ori = nan(1,3);
 
        fixPars.dir(1) = tune(iDb).dir_pars_vm(1);
        fixPars.ori(1) = tune(iDb).ori_pars_vm(1);

        tune_abl(iDb) = retune(resp_abl(iDb), fixPars);
        

    
end


%%

ncut = [db_abl.ncut_dendrites];
oricut = ncut(2:2:end);ncut = ncut(1:2:end); 

[~, sort_cut] = sort(ncut, 'ascend');
nStim = numel(tune(1).dirs);

% sort_cut = sort_cut([6, 8, 13, 15]);
% sort_cut = sort_cut([9:12]);

toPlot = numel(sort_cut);
figure('color', 'w', 'Position', [238 112 1621 866]);
for iPl = 1:toPlot
    
    iDb = sort_cut(iPl);
    
    if oricut(iDb) == 1
        color = [1 0 0];
    else
        color = [0 0.5 1];

    end
    for iStim = 1: nStim
        
        subplot(toPlot, nStim+5 , (iPl-1)*(nStim+5) + iStim)
        shadePlot(tune(iDb).time, tune(iDb).aveResp(iStim,:), tune(iDb).seResp(iStim,:), [0 0 0]); hold on
        shadePlot(tune(iDb).time, tune_abl(iDb).aveResp(iStim,:), tune_abl(iDb).seResp(iStim,:), color); hold on
        
        xlim([min(tune(iDb).time),max(tune(iDb).time)])
        ylim([min(tune(iDb).aveResp(:)), max(max(tune(iDb).aveResp(:)),2)])
        %         ylim([-0.5 5])
        set(gca, 'Xtick', [], 'YTick', [],'visible', 'off')
        formatAxes
    end
    hold on
    plot([-1, -1], [1, 2] , 'k')
    
    subplot(toPlot, nStim+5, (iPl-1)*(nStim+5) + [nStim+1: nStim+3])
    
    errorbar(0:30:390, [tune(iDb).avePeak(1:12), tune(iDb).avePeak([1, 13])], ...
        [tune(iDb).sePeak(1:12), tune(iDb).sePeak([1, 13])], 'ok'); hold on   
    plot(tune(iDb).fit_pt, tune(iDb).fit_vm, '-k', 'LineWidth', 2)
    
    errorbar(0:30:390, [tune_abl(iDb).avePeak(1:12), tune_abl(iDb).avePeak([1, 13])], ...
        [tune_abl(iDb).sePeak(1:12), tune_abl(iDb).sePeak([1, 13])], 'o', 'Color', color); hold on
    plot(tune(iDb).fit_pt, tune_abl(iDb).fit_vm, '-','Color', color,  'LineWidth', 2)
    
    formatAxes
    set(gca, 'YColor', 'none','YTick', [], 'XTick', [0:90:360, 390], 'XTickLabel', {0:90:360, 'Bk'});
    xlim([-10 , 400])
    ylim([min(tune(iDb).avePeak) - mean(tune(iDb).sePeak), max(tune(iDb).avePeak) + max(tune(iDb).sePeak)])
    
    
    subplot(toPlot, nStim+5, (iPl-1)*(nStim+5) + [nStim+4: nStim+5])
    
    errorbar(0:30:210, [tune(iDb).aveOriPeak([1:6, 1]); tune(iDb).avePeak([13])], ...
        [tune(iDb).seOriPeak([1:6, 1]); tune(iDb).sePeak([13])], 'ok'); hold on   
    plot(tune(iDb).ori_fit_pt, tune(iDb).ori_fit_vm, '-k', 'LineWidth', 2)
    
    errorbar(0:30:210, [tune_abl(iDb).aveOriPeak([1:6, 1]); tune_abl(iDb).avePeak([13])], ...
        [tune_abl(iDb).seOriPeak([1:6, 1]); tune_abl(iDb).sePeak([13])], 'o', 'Color', color); hold on
    plot(tune(iDb).ori_fit_pt, tune_abl(iDb).ori_fit_vm, '-','Color', color,  'LineWidth', 2)
    
    formatAxes
    set(gca, 'YColor', 'none','YTick', [], 'XTick', [0:90:180, 210], 'XTickLabel', {0:90:180, 'Bk'});
    xlim([-10 , 220])
    ylim([min(tune(iDb).avePeak) - mean(tune(iDb).sePeak), max(tune(iDb).avePeak) + max(tune(iDb).sePeak)])
   
end


%%
Dp=[]; Do =[]; Rp=[]; Ro= []; sel = []; sel_abl= [];
for iDb = 1:nDb
    
    if oricut(iDb) == 1
    color (iDb, :,:) = [1 0 0 ];
    else
    color (iDb, :,:) = [0 0.5 1];
    end
        
    
%     this_fit = tune(iDb).ori_fit_vm;
%     this_fit_abl = tune_abl(iDb).ori_fit_vm;
    
    this_fit = tune(iDb).fit_vm;
    this_fit_abl = tune_abl(iDb).fit_vm;
    
    minr = min(cat(1, this_fit, this_fit_abl));
    maxr = max(cat(1, this_fit, this_fit_abl));

    this_fit = (this_fit-minr)/(maxr-minr);
    this_fit_abl = (this_fit_abl-minr)/(maxr-minr);
%     
%     Dp(iDb,1) = round(tune(iDb).dir_pars_vm(1));
%     if Dp(iDb,1) <0
%         Dp(iDb,1) = 360+ Dp(iDb,1);
%     end
    
    
%     Do(iDb,1) =Dp(iDb) -90;
%     Do(iDb,2) =Dp(iDb) +90;
%     Do(iDb, Do(iDb,:)>=360) = Do(iDb, Do(iDb,:)>=360)-360;
%     Do(iDb, Do(iDb,:)<0) = Do(iDb, Do(iDb,:)<0)+360;
%     
%     int = 30;
%     idxp = makeVec(bsxfun(@plus,Dp(iDb,:),[-int:1:int]'));
%     idxp(idxp>360) = idxp(idxp>360)-360;
%     idxp(idxp<=0) = idxp(idxp<=0)+360;
%     
%     idxo = makeVec(bsxfun(@plus,Do(iDb,:),[-int:1:int]'));
%     idxo(idxo>360) = idxo(idxo>360)-360;
%     idxo(idxo<=0) = idxo(idxo<=0)+360;
%     
%     Rp(iDb) = mean(this_fit(idxp));
%     Ro(iDb) = mean(this_fit(idxo));
%     
%     Rp_abl(iDb) = mean(this_fit_abl(idxp));
%     Ro_abl(iDb) = mean(this_fit_abl(idxo));

Rp(iDb) = max(this_fit);
Ro(iDb) = min(this_fit);

Rp_abl(iDb) = max(this_fit_abl);
Ro_abl(iDb) = min(this_fit_abl);
    
    sel(iDb) = (Rp(iDb) - Ro(iDb))/(Rp(iDb) + Ro(iDb));
    sel_abl(iDb) = (Rp_abl(iDb) - Ro_abl(iDb))/(Rp_abl(iDb) + Ro_abl(iDb));
%  
%       sel(iDb) = tune(iDb).dir_pars_vm(5);
%     sel_abl(iDb) = tune_abl(iDb).dir_pars_vm(5); 
    
%         sel(iDb) = 1 - circ_var((0:1:359)/2*pi, this_fit);
%         sel_abl(iDb) = 1 - circ_var((0:1:359)/2*pi, this_fit_abl);
        
%                  sel(iDb) = 1-circ_var([(0:30:330)*pi/180], tune(iDb).avePeak(1:12)/sum(tune(iDb).avePeak(1:12)));
%         sel_abl(iDb) = 1-circ_var([(0:30:330)*pi/180], tune_abl(iDb).avePeak(1:12)/sum(tune_abl(iDb).avePeak(1:12)));   
% 
%          sel(iDb) = 1-circ_var([(0:60:330)*pi/180, (0:60:330)*pi/180], tune(iDb).avePeak(1:12)/sum(tune(iDb).avePeak(1:12)));
%         sel_abl(iDb) = 1-circ_var([(0:60:330)*pi/180, (0:60:330)*pi/180], tune_abl(iDb).avePeak(1:12)/sum(tune_abl(iDb).avePeak(1:12)));   
end

%%

chosen_par = oricut==1 & ncut>=2;
chosen_orth = oricut==0 & ncut>=2;

ranksum(sel(chosen_par) -sel_abl((chosen_par)),sel(chosen_orth) -sel_abl((chosen_orth)))

ranksum(Rp_abl((chosen_par)),Rp_abl((chosen_orth)))
ranksum(Ro_abl((chosen_par)),Ro_abl((chosen_orth)))

%%
fit_pt = 0:1:359;
p = 0; o= 0;
for iDb = 1:nDb

    if chosen_par(iDb) == 1
        p = p+1;
        pars = tune(iDb).dir_pars_vm;
        pars(1) = 180;
        par_vm(:, p) = vonMises2(pars, 0:1:359);
        top = max(par_vm(:, p));
        par_vm(:, p)= par_vm(:, p)/top;
        
        pars = tune_abl(iDb).dir_pars_vm;
        pars(1) = 180;
        par_abl_vm(:, p) = vonMises2(pars, 0:1:359);
        par_abl_vm(:, p)= par_abl_vm(:, p)/top;

        
    elseif chosen_orth(iDb) == 1 
        o = o+1;
        pars = tune(iDb).dir_pars_vm;
        pars(1) = 180;
        orth_vm(:, o) = vonMises2(pars, 0:1:359);
         top = max(orth_vm(:, o));
        orth_vm(:, o)= orth_vm(:, o)/top;
        
        pars = tune_abl(iDb).dir_pars_vm;
        pars(1) = 180;
        orth_abl_vm(:, o) = vonMises2(pars, 0:1:359);
        orth_abl_vm(:, o) = orth_abl_vm(:, o)/top;
    end
end

ave_par = mean(par_vm,2);
se_par = std(par_vm,[], 2)/sqrt(size(par_vm, 2));
ave_orth = mean(par_vm,2);
se_orth = std(orth_vm,[], 2)/sqrt(size(orth_vm, 2));

ave_par_abl = mean(par_abl_vm,2);
se_par_abl = std(par_abl_vm,[], 2)/sqrt(size(par_abl_vm, 2));
ave_orth_abl = mean(orth_abl_vm,2);
se_orth_abl = std(orth_abl_vm,[], 2)/sqrt(size(orth_abl_vm, 2));
%%
figure;
subplot(1,2,1)
shadePlot(fit_pt, ave_par,se_par, [0 0 0]); hold on;
shadePlot(fit_pt, ave_par_abl, se_par_abl, [1 0 0 ]); hold on;
formatAxes
set(gca, 'YColor', 'none','YTick', [], 'XTick', [0:90:360], 'XTickLabel', {0:90:360});
xlim([-10 , 370])
ylim([-0.2 1.2])
xlabel('\Delta pref direction')

subplot(1,2,2)
shadePlot(fit_pt, ave_orth,se_orth, [0 0 0]); hold on;
shadePlot(fit_pt, ave_orth_abl,se_orth_abl, [0 0.5 1]); hold on;
formatAxes
set(gca, 'YColor', 'none','YTick', [], 'XTick', [0:90:360], 'XTickLabel', {0:90:360});
xlim([-10 , 370])
ylim([-0.2 1.2])
xlabel('\Delta pref direction')

%     ylim([min(tune(iDb).avePeak) - mean(tune(iDb).sePeak), max(tune(iDb).avePeak) + max(tune(iDb).sePeak)])
  

%%
base_size = 20;

figure('color', 'w');
subplot(1,3,1)
scatter(Rp, Rp_abl, ncut*base_size, color); hold on
plot([0,1], [0,1], '--r');
axis square
xlim([-0.1 1.1])
ylim([-0.1 1.1])
xlabel('Rp')
ylabel('Rp abl')
title('Preferred Response')
formatAxes

subplot(1,3,2)
scatter(Ro, Ro_abl, ncut*base_size, color); hold on
plot([0,1], [0,1], '--r');
axis square
xlim([-0.1 1.1])
ylim([-0.1 1.1])
xlabel('Ro')
ylabel('Ro abl')
title('Ortho Response')
formatAxes

% subplot(1,3,3)
% scatter(sel, sel_abl, ncut*base_size, color); hold on
% plot([0,1], [0,1], '--r');
% axis square
% % xlim([-0.1 1.1])
% % ylim([-1.1 1.1])
% xlabel('Sel')
% ylabel('Sel abl')
% title('Selectivity')
% formatAxes

%%
edges = -1:0.1:1;
par_dist = histcounts(Rp(chosen_par) - Rp_abl(chosen_par), edges);
par_dist = par_dist/sum(par_dist);
orth_dist = histcounts(Rp(chosen_orth) - Rp_abl(chosen_orth), edges);
orth_dist = orth_dist/sum(orth_dist);

% par_dist = gaussFilt(par_dist'/sum(par_dist),0.5);
% orth_dist = gaussFilt(orth_dist'/sum(orth_dist),0.5);

figure;
histContour(edges(1:end-1), par_dist, [1 0 0],1)
% bar(edges(1:end-1), par_dist)

hold on;
histContour(edges(1:end-1), orth_dist, [0 0.5 1], 1)
% bar(edges(1:end-1), orth_dist)

formatAxes
ylabel('Fraction of neurons');
xlabel(' Rp- Rp_abl')
xlim([-1 1])
ylim([0 0.4])
%% Step 2: scale reconstruction to um and center to the soma
 code_repo = 'C:\Users\Federico\Documents\GitHub\cameraLucida';
 addpath(genpath(code_repo));
 addpath(genpath('C:\Users\Federico\Documents\GitHub\treestoolbox'));
 cd(code_repo);

morph_path = 'C:\Users\Federico\Google Drive\CarandiniLab\CarandiniLab_MATLAB\Data\Dendrites\FR171\Neuron5.swc';
morph_path_abl = 'C:\Users\Federico\Google Drive\CarandiniLab\CarandiniLab_MATLAB\Data\Dendrites\FR171\Neuron5_cut.swc';

[tree,~,~] = load_tree(morph_path,'r'); % [pixels]
[tree_abl,~,~] = load_tree(morph_path_abl,'r'); % [pixels]

[fov_x, fov_y] = ppbox.zoom2fov(1.2);

% center dendritic tree
tree.X = tree.X -tree.X(1); % [px]
tree.Y = tree.Y -tree.Y(1); % [px]
tree.Y = -tree.Y* ( fov_y/512 ); % [um]
tree.X = tree.X* ( fov_x/512 ); % [um]
tree.Z = -tree.Z; % [um]

tree_abl.X = tree_abl.X -tree_abl.X(1); % [px]
tree_abl.Y = tree_abl.Y -tree_abl.Y(1); % [px]
tree_abl.Y = -tree_abl.Y* ( fov_y/512 ); % [um]
tree_abl.X = tree_abl.X* ( fov_x/512 ); % [um]
tree_abl.Z = -tree_abl.Z; % [um]

tree = resample_tree( tree, 1); % resample with uniform spacing
tree_abl = resample_tree( tree_abl, 1); % resample with uniform spacing

    figure('Color', 'w')
    hold on;
    plot_tree_lines(tree, [1 0 0 ],[],[],'-3l');
    plot_tree_lines(tree_abl, [],[],[],'-3l');

    xlabel('ML[um] ');
    ylabel('RC[um] ');
    formatAxes

    %% Step 2: scale reconstruction to um and center to the soma
 code_repo = 'C:\Users\Federico\Documents\GitHub\cameraLucida';
 addpath(genpath(code_repo));
 addpath(genpath('C:\Users\Federico\Documents\GitHub\treestoolbox'));
 cd(code_repo);

morph_path = 'D:\OneDrive - University College London\Data\Dendrites\FR175_4\FR175_4_tracing.swc';
morph_path_abl = 'D:\OneDrive - University College London\Data\Dendrites\FR175_4\FR175_4_tracing_cut.swc';

[tree,~,~] = load_tree(morph_path,'r'); % [pixels]
[tree_abl,~,~] = load_tree(morph_path_abl,'r'); % [pixels]

[fov_x, fov_y] = ppbox.zoom2fov(1.5);

% center dendritic tree
tree.X = tree.X -tree.X(1); % [px]
tree.Y = tree.Y -tree.Y(1); % [px]
tree.Y = -tree.Y* ( fov_y/512 )*0.5; % [um]
tree.X = tree.X* ( fov_x/512 )*0.5; % [um]
tree.Z = -tree.Z; % [um]

tree_abl.X = tree_abl.X -tree_abl.X(1); % [px]
tree_abl.Y = tree_abl.Y -tree_abl.Y(1); % [px]
tree_abl.Y = -tree_abl.Y* ( fov_y/512 )*0.5; % [um]
tree_abl.X = tree_abl.X* ( fov_x/512 )*0.5; % [um]
tree_abl.Z = -tree_abl.Z; % [um]

tree = resample_tree( tree, 1); % resample with uniform spacing
tree_abl = resample_tree( tree_abl, 1); % resample with uniform spacing

    figure('Color', 'w')
    hold on;
    plot_tree_lines(tree, [0 0.5 1 ],[],[],'-3l');
    plot_tree_lines(tree_abl, [],[],[],'-3l');

    xlabel('ML[um] ');
    ylabel('RC[um] ');
    formatAxes


