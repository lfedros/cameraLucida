function plot_dendrotomy_stats(neuron)

%% select the datasets with dendrotomies

nDb = numel(neuron);

for iDb = 1:nDb
    cut(iDb) = neuron(iDb).db.morph.dendrotomy{1};
    cut_type{iDb} = neuron(iDb).db.morph.dendrotomy{2};
end

neuron(~cut) = [];
cut_type(~cut) = [];

nDb = numel(neuron);

%% pool the interesting stats, loggin the db ID for longitudinal data

% initialise interesting stats
Dp=[]; Do =[]; Rp=[]; Ro= []; sel = []; sel_abl= [];

%counter of datapoints including longitudinal points
parent_db = [];
nthP = 0;

fit_pt = 0:1:359;
fit_pt_30 = 0:30:345;

hbins = neuron(1).rot_cortex(1).ang_bins_aligned;

for iDb = 1:nDb
    
    for iSeq = 2:numel(neuron(iDb).morph)
        
        nthP = nthP+1;
        parent_db(nthP) = iDb;
        
        if strcmp(cut_type{iDb},'para')
            color(nthP, :) = [1 0 0 ];
            type(nthP) = 1;
        else
            color(nthP, :) = [0 0.5 1];
            type(nthP) = 0;
            
        end
        
        % Dendritic length and response amplitude
        L(nthP) = neuron(iDb).morph(1).stats.L;
        L_cut(nthP) = neuron(iDb).morph(iSeq).stats.L;
        
        if strcmp(neuron(iDb).db.animal, 'FR172') && neuron(iDb).db.neuron_id == 7 % this reconstructions is missing the apical dendrite
            apical_bit = 0.3*L(nthP);
            L(nthP) = L(nthP)+ apical_bit ;
            L_cut(nthP) = L_cut(nthP)+ apical_bit ;
        end
        
        Rp(nthP) = neuron(iDb).tuning(1).Rp;
        Ro(nthP) = neuron(iDb).tuning(1).Ro;
        Rn(nthP) = neuron(iDb).tuning(1).Rn;
        
        Rp_cut(nthP) = neuron(iDb).tuning(iSeq).relative.Rp;
        Ro_cut(nthP) = neuron(iDb).tuning(iSeq).relative.Ro;
        Rn_cut(nthP) = neuron(iDb).tuning(iSeq).relative.Rn;
        
        sel(nthP) = (Rp(nthP) - Ro(nthP))/(Rp(nthP) + Ro(nthP));
        sel_abl(nthP) = (Rp_cut(nthP) - Ro_cut(nthP))/(Rp_cut(nthP) + Ro_cut(nthP));
        
        if Rp_cut(nthP)>=0 && Rp(nthP) >0
            RoR(nthP) = Rp_cut(nthP)./Rp(nthP);%
            
        elseif Rp_cut(nthP)<0 && Rp(nthP) >0
            RoR(nthP) = Rp_cut(nthP)./Rp(nthP);%
            %             RoR(iDb) = abs((Rp_abl(iDb)-Ro_abl(iDb)))./(Rp(iDb)-Ro(iDb));
        end
        
        
        
        % Orientation selectivity
        OS(nthP) = 1- neuron(iDb).tuning(1).OS_circ;
        OS_cut(nthP) =1 -neuron(iDb).tuning(iSeq).relative.OS_circ;
        
        % OS(iDb) = neuron(iDb).tuning.OS_circ;
        DS(nthP) = neuron(iDb).tuning(1).DS;
        Rp_ori(nthP) = neuron(iDb).tuning(1).Rp_ori;
        Ro_ori(nthP) = neuron(iDb).tuning(1).Ro_ori;
        Rb(nthP) = neuron(iDb).tuning(1).Rb;
        prefOri(nthP) = neuron(iDb).tuning(1).prefOri;
        prefDir(nthP) = neuron(iDb).tuning(1).prefDir;
        
        % OS_cut(iDb) = neuron(iDb).tuning_cut.OS_circ;
        DS_cut(nthP) = neuron(iDb).tuning(iSeq).DS;
        Rp_ori_cut(nthP) = neuron(iDb).tuning(iSeq).relative.Rp;
        Ro_ori_cut(nthP) = neuron(iDb).tuning(iSeq).relative.Ro;
        Rb_cut(nthP) = neuron(iDb).tuning(iSeq).relative.Rb;
        prefOri_cut(nthP) = neuron(iDb).tuning(iSeq).prefOri;
        prefDir_cut(nthP) = neuron(iDb).tuning(iSeq).prefDir;
        dOri(nthP) = abs(unwrap_angle(prefOri(nthP) - prefOri_cut(nthP),1,1)); %[-pi/2, pi/2] -->[0, pi/2]
        dDir(nthP) = abs(unwrap_angle(prefDir(nthP) -prefDir_cut(nthP),0,1)); %[-pi, pi] -->[0, pi]
        
        % tuning curve 1deg res
        pars = neuron(iDb).tuning(1).dir_pars_vm;
        pars(1) = 180;
        vm(:, nthP) = vonMises2(pars, 0:1:359);
        top = max(vm(:, nthP));
        vm(:, nthP)= vm(:, nthP)/top;
        
        pars = neuron(iDb).tuning(iSeq).relative.dir_pars_vm;
        pars(1) = 180;
        abl_rel_vm(:, nthP) = vonMises2(pars, 0:1:359);
        abl_rel_vm(:, nthP)= abl_rel_vm(:, nthP)/top;
        
        pars = neuron(iDb).tuning(iSeq).dir_pars_vm;
        pars(1) = 180+dDir(nthP);
        abl_vm(:, nthP) = vonMises2(pars, 0:1:359);
        abl_vm(:, nthP)= abl_vm(:, nthP)/top;
        
        % tuning curve 30 deg res
        
        pars = neuron(iDb).tuning(1).dir_pars_vm;
        pars(1) = 180;
        [vm_30(:, nthP), sort_idx] = sort(vonMises2(pars, fit_pt_30), 'ascend');
        top = max(vm_30(:, nthP));
        vm_30(:, nthP)= vm_30(:, nthP)/top;
        
        pars = neuron(iDb).tuning(iSeq).relative.dir_pars_vm;
        pars(1) = 180;
        abl_rel_vm_30(:, nthP) = vonMises2(pars, fit_pt_30 );
        abl_rel_vm_30(:, nthP)= abl_rel_vm_30(sort_idx, nthP)/top;
        
        pars = neuron(iDb).tuning(iSeq).dir_pars_vm;
        pars(1) = 180+dDir(nthP);
        abl_vm_30(:, nthP) = vonMises2(pars, fit_pt_30 );
        abl_vm_30(:, nthP)= abl_vm_30(sort_idx, nthP)/top;
        
        lm = fitlm(vm_30(:, nthP), abl_rel_vm_30(:, nthP));
        
        add(nthP)= lm.Coefficients.Estimate(1);
        slope(nthP)= lm.Coefficients.Estimate(2);
        
        
        % dendrites angular dists
        
        
        centeredDist(:, nthP)= circGaussFilt(neuron(iDb).rot_cortex(1).ang_density_aligned,1);
        
        centeredDist_cut(:, nthP)= circGaussFilt(neuron(iDb).rot_cortex(iSeq).ang_density_aligned,1);
        
        trims_dist(:, nthP) = (centeredDist(:, nthP)*L(nthP) - ...
            centeredDist_cut(:, nthP)*L_cut(nthP))/L(nthP);
        
        centeredDist_cut(:, nthP)= (centeredDist_cut(:, nthP)*L_cut(nthP))/L(nthP);

    end
    
    
end

L_rel = 1 - L_cut./L;
type = logical(type);

par_lm = fitlm(L_rel(type), RoR(type), 'Intercept', false);
orth_lm = fitlm(L_rel(~type), RoR(~type),'Intercept', false);

pred_p = 0:0.01:0.65;
[par_pred,par_ci] = predict(par_lm, makeVec(pred_p));
[orth_pred,orth_ci] = predict(orth_lm, makeVec(pred_p));

par_lm_lg = fitlm(L_rel(type), log10(RoR(type)),'Intercept', false);
orth_lm_lg = fitlm(L_rel(~type), log10(RoR(~type)),'Intercept', false);
%
% pred_p = 0:0.01:0.35;
[par_pred_lg,par_ci_lg] = predict(par_lm_lg, makeVec(pred_p));
[orth_pred_lg,orth_ci_lg] = predict(orth_lm_lg, makeVec(pred_p));



dOS = OS_cut./OS;

ave_par = mean(vm(:, type),2);
se_par = std(vm(:, type),[], 2)/sqrt(sum(type));
ave_orth = mean(vm(:, ~type),2);
se_orth = std(vm(:, ~type),[], 2)/sqrt(sum(~type));

ave_par_abl = mean(abl_vm(:, type),2);
se_par_abl = std(abl_vm(:, type),[], 2)/sqrt(sum(type));
ave_orth_abl = mean(abl_vm(:, ~type),2);
se_orth_abl = std(abl_vm(:, ~type),[], 2)/sqrt(sum(~type));

ave_par_abl_rel = mean(abl_rel_vm(:, type),2);
se_par_abl_rel = std(abl_rel_vm(:, type),[], 2)/sqrt(sum(type));
ave_orth_abl_rel = mean(abl_rel_vm(:, ~type),2);
se_orth_abl_rel = std(abl_rel_vm(:, ~type),[], 2)/sqrt(sum(~type));

ave_par_30 = mean(vm_30(:, type),2);
se_par_30 = std(vm_30(:, type),[], 2)/sqrt(sum(type));
ave_orth_30 = mean(vm_30(:, ~type),2);
se_orth_30 = std(vm_30(:, ~type),[], 2)/sqrt(sum(~type));

ave_par_abl_30 = mean(abl_vm_30(:, type),2);
se_par_abl_30 = std(abl_vm_30(:, type),[], 2)/sqrt(sum(type));
ave_orth_abl_30 = mean(abl_vm_30(:, ~type),2);
se_orth_abl_30 = std(abl_vm_30(:, ~type),[], 2)/sqrt(sum(~type));

ave_par_abl_rel_30 = mean(abl_rel_vm_30(:, type),2);
se_par_abl_rel_30 = std(abl_rel_vm_30(:, type),[], 2)/sqrt(sum(type));
ave_orth_abl_rel_30 = mean(abl_rel_vm_30(:, ~type),2);
se_orth_abl_rel_30 = std(abl_rel_vm_30(:, ~type),[], 2)/sqrt(sum(~type));



trims_dist(trims_dist<0) = 0;

ave_par_dist = mean(centeredDist(:, type),2);
ave_par_trim = mean(trims_dist(:, type),2);
ave_par_dist_cut = mean(centeredDist_cut(:, type),2);

se_par_dist = std(centeredDist(:, type),[],2)/sqrt(sum(type));
se_par_trim = std(trims_dist(:, type),[],2);
se_par_dist_cut = std(centeredDist_cut(:, type),[],2)/sqrt(sum(type));

ave_orth_dist = mean(centeredDist(:, ~type),2);
ave_orth_trim = mean(trims_dist(:, ~type),2);
ave_orth_dist_cut = mean(centeredDist_cut(:, ~type),2);
se_orth_dist = std(centeredDist(:, ~type),[],2)/sqrt(sum(~type));
se_orth_trim = std(trims_dist(:, ~type),[],2);
se_orth_dist_cut = std(centeredDist_cut(:, ~type),[],2)/sqrt(sum(~type));

%%

figure('Color', 'w');

subplot(1,2,1)

[x, y, y_se, lm] = intervalReg(L_rel(type), RoR(type), 0:0.1:1);
shadePlot(x, y, y_se,[1 0 0]);  hold on

plot(L_rel(type), RoR(type), 'o', 'Color', [1 0 0], 'MarkerFaceColor', [1 0 0], 'MarkerSize', 7); hold on

[x, y, y_se, lm] = intervalReg(L_rel(~type), RoR(~type), 0:0.1:1);
shadePlot(x, y, y_se,[0 0.5 1]);  hold on
plot(L_rel(~type), RoR(~type), 'o', 'Color', [0 0.5 1], 'MarkerFaceColor', [0. 0.5 1], 'MarkerSize', 7); hold on


for iDb = 1:nDb
    if sum(parent_db==iDb)>1
        plot(L_rel(parent_db==iDb), RoR(parent_db==iDb), '-', 'Color', mean(color((parent_db==iDb),:)), ...
            'LineWidth', 0.5); hold on
    end
end

% patch([pred_p, flip(pred_p)], [par_ci(:,1); flip(par_ci(:,2))], [1 0 0], 'Edgecolor','none', 'FaceAlpha', 0.2); hold on
% plot(pred_p, par_pred, '-r')
% patch([pred_p, flip(pred_p)], [orth_ci(:,1); flip(orth_ci(:,2))], [0 0.5 1], 'Edgecolor','none', 'FaceAlpha', 0.2); hold on
% plot(pred_p, orth_pred, '-b')



axis square
ylim([-0.1 1.8])
xlim([-.05 0.65])
formatAxes
xlabel('Fraction dendrites cut')
ylabel('Rp cut/Rp')


subplot(1,2,2)
plot(L_rel(type), log10(RoR(type)), 'o', 'Color', [1 0 0], 'MarkerFaceColor', [1 0 0], 'MarkerSize', 6); hold on
plot(L_rel(~type), log10(RoR(~type)), 'o', 'Color', [0 0.5 1], 'MarkerFaceColor', [0. 0.5 1], 'MarkerSize', 6); hold on


for iDb = 1:nDb
    if sum(parent_db==iDb)>1
        plot(L_rel(parent_db==iDb), log10(RoR(parent_db==iDb)), '-', 'Color', mean(color((parent_db==iDb),:)), ...
            'LineWidth', 0.5); hold on
    end
end

patch([pred_p, flip(pred_p)], [par_ci_lg(:,1); flip(par_ci_lg(:,2))], [1 0 0], 'Edgecolor','none', 'FaceAlpha', 0.2); hold on
plot(pred_p, par_pred_lg, '-r')
patch([pred_p, flip(pred_p)], [orth_ci_lg(:,1); flip(orth_ci_lg(:,2))], [0 0.5 1], 'Edgecolor','none', 'FaceAlpha', 0.2); hold on
plot(pred_p, orth_pred_lg, '-b')

axis square
ylim([-3 1])
xlim([-.05 0.65])
formatAxes
xlabel('Fraction dendrites cut')
ylabel('Scaling of optimal response', 'Interpreter', 'none')
% set(gca, 'YTickLabel', [2^-6 2^-4 2^-2 2^-1 0 2]);
set(gca,'YTick', [-3 -2 -1 0 1],  'YTickLabel', [10^-3 10^-2 10^-1 10^0 10]);

% set(gca, 'Yscale', 'log');
saveTo = fullfile(neuron(1).db.data_repo, 'Results');
print(fullfile(saveTo,'RP_vs_dendrotomy') ,  '-dpng');
%%
%
% chosen_par = oricut==1 & ncut>=2;
% chosen_orth = oricut==0 & ncut>=2;
%
% ranksum(sel(chosen_par) -sel_abl((chosen_par)),sel(chosen_orth) -sel_abl((chosen_orth)))
%
% ranksum(Rp_abl((chosen_par)),Rp_abl((chosen_orth)))
% ranksum(Ro_abl((chosen_par)),Ro_abl((chosen_orth)))






%%
figure('Position', [470 558 1221 420], 'Color', 'w');

subplot(1, 7, 1)
p_dOri = ranksum(dOri(type), dOri(~type));
plot(1, dOri(type), 'o', 'Color', [1 0 0], 'MarkerSize', 7); hold on;
plot(2, dOri(~type), 'o', 'Color', [0 0.5 1],  'MarkerSize', 7);
xlim([0 3])
formatAxes
axis square
title(sprintf('dOri, p = %03f', p_dOri));
xlabel('Pre')
ylabel('Post')

subplot(1, 7, 2)
p_dDir = ranksum(dDir(type), dDir(~type));
plot(1, dDir(type),'o', 'Color', [1 0 0], 'MarkerSize', 7); hold on;
plot(2, dDir(~type), 'o', 'Color', [0 0.5 1],  'MarkerSize', 7);
xlim([0 3])
formatAxes
axis square
title(sprintf('dDir, p = %03f', p_dDir));
xlabel('Pre')

subplot(1, 7, 3)
p_pRp = signrank(Rp(type), Rp_cut(type));
p_oRp = signrank(Rp(~type), Rp_cut(~type));
plot(Rp(type), Rp_cut(type), 'o', 'Color', [1 0 0], 'MarkerSize', 7); hold on;
plot(Rp(~type), Rp_cut(~type), 'o', 'Color', [0 0.5 1],  'MarkerSize', 7);
plot([-1 5], [-1 5], '--k')
formatAxes
xlim([-1 4]);
ylim([-1 4]);
axis square
title(sprintf('p_pRp = %03f\np_oRp = %03f', p_pRp, p_oRp));
xlabel('Pre')

subplot(1, 7, 4)
p_pRo = signrank(Ro(type), Ro_cut(type));
p_oRo = signrank(Ro(~type), Ro_cut(~type));
plot(Ro(type), Ro_cut(type), 'o', 'Color', [1 0 0], 'MarkerSize', 7); hold on;
plot(Ro(~type), Ro_cut(~type), 'o', 'Color', [0 0.5 1],  'MarkerSize', 7);
plot([-1 1], [-1 1], '--k')
formatAxes
xlim([-0.5 0.5]);
ylim([-0.5 0.5]);
axis square
title(sprintf('p_pRo = %03f\np_oRo = %03f', p_pRo, p_oRo));
xlabel('Pre')

subplot(1, 7, 5)
p_pRb = signrank(Rb(type), Rb_cut(type));
p_oRb = signrank(Rb(~type), Rb_cut(~type));
plot(Rb(type), Rb_cut(type), 'o', 'Color', [1 0 0], 'MarkerSize', 7); hold on;
plot(Rb(~type), Rb_cut(~type), 'o', 'Color', [0 0.5 1],  'MarkerSize', 7);
plot([-1 1], [-1 1], '--k')
formatAxes
xlim([-1 1]);
ylim([-1 1]);
axis square
title(sprintf('p_pRb = %03f\np_oRb = %03f', p_pRb, p_oRb));
xlabel('Pre')

subplot(1, 7, 6)
p_pDS = signrank(DS(type), DS_cut(type));
p_oDS = signrank(DS(~type), DS_cut(~type));
plot(DS(type), DS_cut(type), 'o', 'Color', [1 0 0], 'MarkerSize', 7);hold on;
plot(DS(~type), DS_cut(~type), 'o', 'Color', [0 0.5 1],  'MarkerSize', 7);
plot([0 2], [0 2], '--k')
xlim([-0.1 1.1]);
ylim([-0.1 1.1]);
formatAxes
axis square
title(sprintf('p_pDS = %03f\np_oDS = %03f', p_pDS, p_oDS));xlabel('Pre')


subplot(1, 7, 7)
p_pOS = signrank(OS(type), OS_cut(type));
p_oOS = signrank(OS(~type), OS_cut(~type));
plot(OS(type), OS_cut(type), 'o', 'Color', [1 0 0], 'MarkerSize', 7); hold on;
plot(OS(~type), OS_cut(~type), 'o', 'Color', [0 0.5 1],  'MarkerSize', 7);
plot([0 2], [0 2], '--k')
xlim([-0.1 1.1]);
ylim([-0.1 1.1]);
formatAxes
axis square
title(sprintf('p_pOS = %03f\np_oOS = %03f', p_pOS, p_oOS));xlabel('Pre')
xlabel('Pre')


print(fullfile(saveTo,'dendrotomy_average_tuning') ,  '-dpng');



%%
figure('Position',  [680 193 742 785], 'Color', 'w');
subplot(3,2,1)
polarhistogram('BinEdges', cat(2, hbins', hbins(1)+2*pi), ...
    'BinCounts', ave_par_dist,  'DisplayStyle', 'stairs', 'EdgeColor', [0 0 0]);
hold on;
% polarhistogram('BinEdges', cat(2, hbins', hbins(1)+2*pi), ...
%     'BinCounts', ave_par_trim,  'DisplayStyle', 'stairs', 'EdgeColor', [1 0 0]);

polarhistogram('BinEdges', cat(2, hbins', hbins(1)+2*pi), ...
    'BinCounts', ave_par_dist_cut,  'DisplayStyle', 'stairs', 'EdgeColor', [1 0 0]);


formatAxes
set(gca, 'RTick', [], 'ThetaTick', [0 90 180 270]);
set(gca, 'RTick', [], 'ThetaTick', [0 90 180 270]);

set(gca,  'ThetaZeroLocation', 'top');

subplot(3,2,2)
polarhistogram('BinEdges', cat(2, hbins', hbins(1)+2*pi), ...
    'BinCounts', ave_orth_dist,  'DisplayStyle', 'stairs', 'EdgeColor', [0 0 0]);
hold on;
% polarhistogram('BinEdges', cat(2, hbins', hbins(1)+2*pi), ...
%     'BinCounts', ave_orth_trim,  'DisplayStyle', 'stairs', 'EdgeColor', [0. 0.5 1]);

polarhistogram('BinEdges', cat(2, hbins', hbins(1)+2*pi), ...
    'BinCounts', ave_orth_dist_cut,  'DisplayStyle', 'stairs', 'EdgeColor', [1 0 0]);

set(gca, 'RTick', [], 'ThetaTick', [0 90 180 270]);
formatAxes
set(gca,  'ThetaZeroLocation', 'top');

subplot(3,2,5)
shadePlot(fit_pt, ave_par,se_par, [0 0 0]); hold on;
shadePlot(fit_pt, ave_par_abl, se_par_abl, [1 0 0 ]); hold on;
formatAxes
set(gca, 'YTick', [0 1], 'XTick', [0:90:360], 'XTickLabel', {0:90:360});
xlim([-10 , 370])
ylim([-0.2 1.2])
xlabel('\Delta pref direction')
ylabel('Normalised Tuning ')

subplot(3,2,6)
shadePlot(fit_pt, ave_orth,se_orth, [0 0 0]); hold on;
shadePlot(fit_pt, ave_orth_abl,se_orth_abl, [0 0.5 1]); hold on;
formatAxes
set(gca, 'YColor', 'none','YTick', [], 'XTick', [0:90:360], 'XTickLabel', {0:90:360});
xlim([-10 , 370])
ylim([-0.2 1.2])
xlabel('\Delta pref direction')

subplot(3,2,3)
shadePlot(fit_pt, ave_par,se_par, [0 0 0]); hold on;
shadePlot(fit_pt, ave_par_abl_rel, se_par_abl_rel, [1 0 0 ]); hold on;
formatAxes
set(gca, 'YTick', [0 1],'XTick', [0:90:360], 'XTickLabel', {0:90:360});
xlim([-10 , 370])
ylim([-0.2 1.2])
xlabel('\Delta pref direction')
ylabel('Normalised Tuning (locked)')

subplot(3,2,4)
shadePlot(fit_pt, ave_orth,se_orth, [0 0 0]); hold on;
shadePlot(fit_pt, ave_orth_abl_rel,se_orth_abl_rel, [0 0.5 1]); hold on;
formatAxes
set(gca, 'YColor', 'none','YTick', [], 'XTick', [0:90:360], 'XTickLabel', {0:90:360});
xlim([-10 , 370])
ylim([-0.2 1.2])
xlabel('\Delta pref direction')


print(fullfile(saveTo,'dendrotomy_stats') ,  '-dpng');

% figure;
% subplot(1,2,1)
% shadePlot( hbins, ave_par_dist, se_par_dist,[0 0 0],  'polar')
% hold on;
% shadePlot(hbins, ave_par_trim, se_par_trim, [1 0 0], 'polar')
%
% subplot(1,2,2)
% shadePlot(hbins, ave_orth_dist, se_orth_dist,[0 0 0],  'polar')
% hold on;
% shadePlot(hbins, ave_orth_trim, se_orth_trim, [1 0 0], 'polar')



%%
figure;

subplot(1,3,1)
par_lm = fitlm(ave_par_30, ave_par_abl_rel_30);
orth_lm = fitlm(ave_orth_30, ave_orth_abl_rel_30);

pred_p = -.1:0.01:1;
[par_pred,par_ci] = predict(par_lm, makeVec(pred_p));
[orth_pred,orth_ci] = predict(orth_lm, makeVec(pred_p));

plot(vm_30(:, type), abl_rel_vm_30(:, type), '-', 'Color', [1 0 0 0.2], 'Linewidth', 0.1); hold on;
plot(vm_30(:, ~type), abl_rel_vm_30(:, ~type), '-', 'Color', [0 0.5 1 0.2], 'Linewidth', 0.1); hold on;

plot(pred_p, par_pred, '-', 'Color', [1 0 0 ]); hold on;
plot(pred_p, orth_pred, '-', 'Color', [0 0.5 1]); hold on;

plot(ave_par_30, ave_par_abl_rel_30, 'o', 'Color', [1 0 0], 'MarkerFaceColor', [1 0 0], 'MarkerSize', 6); hold on
plot(ave_orth_30, ave_orth_abl_rel_30, 'o', 'Color', [0 0.5 1], 'MarkerFaceColor', [0 0.5 1], 'MarkerSize', 6); hold on


plot([-0.1 1], [-0.1 1], '--', 'Color', [0.3 0.3 0.3])
xlim([-.2 1.1])
ylim([-.2 1.1])
xlabel('Bsl response')
ylabel('Post-dendrotomy')

axis square;
formatAxes

subplot(1, 3, 2)
[x, y, y_se, lm] = intervalReg(L_rel(type), slope(type), 0:0.1:1);
shadePlot(x, y, y_se,[1 0 0]);  hold on
[x, y, y_se, lm] = intervalReg(L_rel(~type), slope(~type), 0:0.1:1);
shadePlot(x, y, y_se,[0 0.5 1]);  
plot(L_rel(type), slope(type), 'o', 'Color', [1 0 0], 'MarkerSize', 7); hold on;
plot(L_rel(~type),slope(~type), 'o', 'Color', [0 0.5 1],  'MarkerSize', 7);
% plot([0 2], [0 2], '--k')
xlim([-0.1 0.6]);
ylim([-0.5 2.4]);
xlabel('Fraction dendrites cut')
ylabel('Multiplicative scaling')
formatAxes
axis square

subplot(1, 3, 3)
[x, y, y_se, lm] = intervalReg(L_rel(type), add(type), 0:0.1:1);
shadePlot(x, y, y_se,[1 0 0]);  hold on
[x, y, y_se, lm] = intervalReg(L_rel(~type), add(~type), 0:0.1:1);
shadePlot(x, y, y_se,[0 0.5 1]);  
plot(L_rel(type), add(type), 'o', 'Color', [1 0 0], 'MarkerSize', 7); hold on;
plot(L_rel(~type),add(~type), 'o', 'Color', [0 0.5 1],  'MarkerSize', 7);
% plot([0 2], [0 2], '--k')
xlim([-0.1 0.6]);
% ylim([-0.1 0.6]);
xlabel('Fraction dendrites cut')
ylabel('Additive scaling')
formatAxes
axis square




print(fullfile(saveTo,'Mult_or_Add') ,  '-dpng');

%%
figure('Position', [418 293 983 550], 'Color', 'w');



subplot(1, 3, 1)
[x, y, y_se, lm] = intervalReg(L_rel(type), log10(dOS(type)), 0:0.1:1);
shadePlot(x, y, y_se,[1 0 0]);  hold on
[x, y, y_se, lm] = intervalReg(L_rel(~type), log10(dOS(~type)), 0:0.1:1);
shadePlot(x, y, y_se,[0 0.5 1]);  
plot(L_rel(type), log10(dOS(type)), 'o', 'Color', [1 0 0], 'MarkerSize', 7); hold on;
plot(L_rel(~type), log10(dOS(~type)), 'o', 'Color', [0 0.5 1],  'MarkerSize', 7);
% plot([0 2], [0 2], '--k')
xlim([-0.1 0.6]);
% ylim([-0.1 0.6]);
xlabel('Fraction dendrites cut')
ylabel('log10 dOS')
formatAxes
axis square

subplot(1, 3, 2)
[x, y, y_se, lm] = intervalReg(L_rel(type), dOri(type), 0:0.1:1);
shadePlot(x, y, y_se,[1 0 0]);  hold on
[x, y, y_se, lm] = intervalReg(L_rel(~type), dOri(~type), 0:0.1:1);
shadePlot(x, y, y_se,[0 0.5 1]); 
plot(L_rel(type), dOri(type), 'o', 'Color', [1 0 0], 'MarkerSize', 7); hold on;
plot(L_rel(~type), dOri(~type), 'o', 'Color', [0 0.5 1],  'MarkerSize', 7);
% plot([0 2], [0 2], '--k')
xlim([-0.1 0.6]);
% ylim([-0.1 0.6]);
xlabel('Fraction dendrites cut')
ylabel('dOri')
formatAxes
axis square

subplot(1, 3, 3)
[x, y, y_se, lm] = intervalReg(L_rel(type), dDir(type), 0:0.1:1);
shadePlot(x, y, y_se,[1 0 0]);  hold on
[x, y, y_se, lm] = intervalReg(L_rel(~type), dDir(~type), 0:0.1:1);
shadePlot(x, y, y_se,[0 0.5 1]); 
plot(L_rel(type), dDir(type), 'o', 'Color', [1 0 0], 'MarkerSize', 7); hold on;
plot(L_rel(~type), dDir(~type), 'o', 'Color', [0 0.5 1],  'MarkerSize', 7);
% plot([0 2], [0 2], '--k')
xlim([-0.1 0.6]);
% ylim([-0.1 0.6]);
xlabel('Fraction dendrites cut')
ylabel('dDir')
formatAxes
axis square

print(fullfile(saveTo,'Mult_or_Add_stats') ,  '-dpng');

end