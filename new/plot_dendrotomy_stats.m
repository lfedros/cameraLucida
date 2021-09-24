function plot_dendrotomy_stats(neuron)



nDb = numel(neuron);

for iDb = 1:nDb
cut(iDb) = neuron(iDb).db.morph.dendrotomy{1};
cut_type{iDb} = neuron(iDb).db.morph.dendrotomy{2};
end

neuron(~cut) = [];
cut_type(~cut) = [];

%%
nDb = numel(neuron);

Dp=[]; Do =[]; Rp=[]; Ro= []; sel = []; sel_abl= [];
for iDb = 1:nDb
    
    if strcmp(cut_type{iDb},'para')
        cc(iDb, :) = [1 0 0 ];
type(iDb) = 1;
    else
        cc(iDb, :) = [0 0.5 1];
type(iDb) = 0;

    end
    
    L(iDb) = neuron(iDb).morph.L; 
    L_cut(iDb) = neuron(iDb).morph_cut.L; 
    
    if strcmp(neuron(iDb).db.animal, 'FR172') && neuron(iDb).db.neuron_id == 7 % this reconstructions is missing the apical dendrite
    apical_bit = 0.3*L(iDb);
        L(iDb) = L(iDb)+ apical_bit ; 
    L_cut(iDb) = L_cut(iDb)+ apical_bit ; 
    end

    this_fit = neuron(iDb).tuning.fit_vm;
    this_fit_cut = neuron(iDb).tuning_cut.relative.fit_vm;
    
%     minr = min(cat(1, this_fit, this_fit_cut));
%     maxr = max(cat(1, this_fit, this_fit_cut));
    
    minr = min( this_fit);
    maxr = max(this_fit);

%     this_fit = (this_fit-minr)/(maxr-minr);
%     this_fit_cut = (this_fit_cut-minr)/(maxr-minr); 
    
    Rp(iDb) = max(this_fit);
    Ro(iDb) = min(this_fit);
    
    Rp_abl(iDb) = max(this_fit_cut);
    Ro_abl(iDb) = min(this_fit_cut);
    
    sel(iDb) = (Rp(iDb) - Ro(iDb))/(Rp(iDb) + Ro(iDb));
    sel_abl(iDb) = (Rp_abl(iDb) - Ro_abl(iDb))/(Rp_abl(iDb) + Ro_abl(iDb));
    
    RoR(iDb) = Rp_abl(iDb)./Rp(iDb);%(Rp_abl(iDb)-Ro_abl(iDb))./(Rp(iDb)-Ro(iDb));
%         RoR(iDb) = (Rp_abl(iDb)-Ro_abl(iDb))./(Rp(iDb)-Ro(iDb));

    %
end

L_rel = 1 - L_cut./L;
type = logical(type);

par_lm = fitlm(L_rel(type), RoR(type));
orth_lm = fitlm(L_rel(~type), RoR(~type));

pred_p = 0:0.01:0.65;
[par_pred,par_ci] = predict(par_lm, makeVec(pred_p));
[orth_pred,orth_ci] = predict(orth_lm, makeVec(pred_p));

par_lm_lg = fitlm(L_rel(type), log10(RoR(type)));
orth_lm_lg = fitlm(L_rel(~type), log10(RoR(~type)));
% 
% pred_p = 0:0.01:0.35;
[par_pred_lg,par_ci_lg] = predict(par_lm_lg, makeVec(pred_p));
[orth_pred_lg,orth_ci_lg] = predict(orth_lm_lg, makeVec(pred_p));
%%

figure('Color', 'w');

subplot(1,2,1)
plot(L_rel(type), RoR(type), 'o', 'Color', [1 0 0], 'MarkerFaceColor', [1 0 0], 'MarkerSize', 7); hold on
plot(L_rel(~type), RoR(~type), 'o', 'Color', [0 0.5 1], 'MarkerFaceColor', [0. 0.5 1], 'MarkerSize', 7); hold on

patch([pred_p, flip(pred_p)], [par_ci(:,1); flip(par_ci(:,2))], [1 0 0], 'Edgecolor','none', 'FaceAlpha', 0.2); hold on
plot(pred_p, par_pred, '-r')
patch([pred_p, flip(pred_p)], [orth_ci(:,1); flip(orth_ci(:,2))], [0 0.5 1], 'Edgecolor','none', 'FaceAlpha', 0.2); hold on
plot(pred_p, orth_pred, '-b')

axis square
ylim([-0.1 1.8])
xlim([-.05 0.65])
formatAxes
xlabel('Fraction dendrites cut')
ylabel('Rp cut/Rp')




subplot(1,2,2)
plot(L_rel(type), log10(RoR(type)), 'o', 'Color', [1 0 0], 'MarkerFaceColor', [1 0 0], 'MarkerSize', 6); hold on
plot(L_rel(~type), log10(RoR(~type)), 'o', 'Color', [0 0.5 1], 'MarkerFaceColor', [0. 0.5 1], 'MarkerSize', 6); hold on

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
set(gca, 'YTickLabel', [10^-3 10^-2 10^-1 10^0 10]);

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




%% Compute and plot some stats
for iDb = 1:nDb
toFit= makeVec(neuron(iDb).tuning.avePeak(1:end-1))';
OS(iDb) = circ_var(neuron(iDb).tuning.oris*2*pi/180, (toFit-min(toFit)));
toFit= makeVec(neuron(iDb).tuning_cut.avePeak(1:end-1))';
OS_cut(iDb) = circ_var(neuron(iDb).tuning_cut.oris*2*pi/180, (toFit-min(toFit)));

    
Rp(iDb) = neuron(iDb).tuning.Rp;
Rn(iDb) = neuron(iDb).tuning.Rn;
Ro(iDb) = neuron(iDb).tuning.Ro;
% OS(iDb) = neuron(iDb).tuning.OS_circ;
DS(iDb) = neuron(iDb).tuning.DS;
Rp_ori(iDb) = neuron(iDb).tuning.Rp_ori;
Ro_ori(iDb) = neuron(iDb).tuning.Ro_ori;
Rb(iDb) = neuron(iDb).tuning.Rb;
prefOri(iDb) = neuron(iDb).tuning.prefOri;
prefDir(iDb) = neuron(iDb).tuning.prefDir;

Rp_cut(iDb) = neuron(iDb).tuning_cut.relative.Rp;
Rn_cut(iDb) = neuron(iDb).tuning_cut.relative.Rn;
Ro_cut(iDb) = neuron(iDb).tuning_cut.relative.Ro;
% OS_cut(iDb) = neuron(iDb).tuning_cut.OS_circ;
DS_cut(iDb) = neuron(iDb).tuning_cut.DS;
Rp_ori_cut(iDb) = neuron(iDb).tuning_cut.relative.Rp;
Ro_ori_cut(iDb) = neuron(iDb).tuning_cut.relative.Ro;
Rb_cut(iDb) = neuron(iDb).tuning_cut.relative.Rb;
prefOri_cut(iDb) = neuron(iDb).tuning_cut.prefOri;
prefDir_cut(iDb) = neuron(iDb).tuning_cut.prefDir;


end

dOri = abs(unwrap_angle(prefOri - prefOri_cut,1,1)); %[-pi/2, pi/2] -->[0, pi/2]
dDir = abs(unwrap_angle(prefDir -prefDir_cut,0,1)); %[-pi, pi] -->[0, pi]


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
fit_pt = 0:1:359;

for iDb = 1:nDb

        pars = neuron(iDb).tuning.dir_pars_vm;
        pars(1) = 180;
        vm(:, iDb) = vonMises2(pars, 0:1:359);
        top = max(vm(:, iDb));
        vm(:, iDb)= vm(:, iDb)/top;
        
        pars = neuron(iDb).tuning_cut.relative.dir_pars_vm;
        pars(1) = 180;
        abl_rel_vm(:, iDb) = vonMises2(pars, 0:1:359);
        abl_rel_vm(:, iDb)= abl_rel_vm(:, iDb)/top;

        pars = neuron(iDb).tuning_cut.dir_pars_vm;
        pars(1) = 180+dDir(iDb);
        abl_vm(:, iDb) = vonMises2(pars, 0:1:359);
        abl_vm(:, iDb)= abl_vm(:, iDb)/top;


end

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


%%
hbins = neuron(1).rot_cortex.ang_bins_aligned;

for iDb = 1:nDb

centeredDist(:, iDb)= circGaussFilt(neuron(iDb).rot_cortex.ang_density_aligned,1);

centeredDist_cut(:, iDb)= circGaussFilt(neuron(iDb).rot_cortex_cut.ang_density_aligned,1);

trims_dist(:, iDb) = (centeredDist(:, iDb)*neuron(iDb).morph.L - ...
                        centeredDist_cut(:, iDb)*neuron(iDb).morph_cut.L)/neuron(iDb).morph.L;

end

trims_dist(trims_dist<0) = 0; 

ave_par_dist = mean(centeredDist(:, type),2);
ave_par_trim = mean(trims_dist(:, type),2);
se_par_dist = std(centeredDist(:, type),[],2)/sqrt(sum(type));
se_par_trim = std(trims_dist(:, type),[],2);

ave_orth_dist = mean(centeredDist(:, ~type),2);
ave_orth_trim = mean(trims_dist(:, ~type),2);
se_orth_dist = std(centeredDist(:, ~type),[],2)/sqrt(sum(~type));
se_orth_trim = std(trims_dist(:, ~type),[],2);




%%
figure('Position',  [680 193 742 785], 'Color', 'w');
subplot(3,2,1)
polarhistogram('BinEdges', cat(2, hbins', hbins(1)+2*pi), ...
    'BinCounts', ave_par_dist,  'DisplayStyle', 'stairs', 'EdgeColor', [0 0 0]);
hold on;
polarhistogram('BinEdges', cat(2, hbins', hbins(1)+2*pi), ...
    'BinCounts', ave_par_trim,  'DisplayStyle', 'stairs', 'EdgeColor', [1 0 0]);
formatAxes
set(gca, 'RTick', [], 'ThetaTick', [0 90 180 270]);
set(gca, 'RTick', [], 'ThetaTick', [0 90 180 270]);

set(gca,  'ThetaZeroLocation', 'top');

subplot(3,2,2)
polarhistogram('BinEdges', cat(2, hbins', hbins(1)+2*pi), ...
    'BinCounts', ave_orth_dist,  'DisplayStyle', 'stairs', 'EdgeColor', [0 0 0]);
hold on;
polarhistogram('BinEdges', cat(2, hbins', hbins(1)+2*pi), ...
    'BinCounts', ave_orth_trim,  'DisplayStyle', 'stairs', 'EdgeColor', [0. 0.5 1]);
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
fit_pt = 0:30:345;
clear vm abl_rel_vm abl_vm
for iDb = 1:nDb

        pars = neuron(iDb).tuning.dir_pars_vm;
        pars(1) = 180;
        vm(:, iDb) = vonMises2(pars, fit_pt );
        top = max(vm(:, iDb));
        vm(:, iDb)= vm(:, iDb)/top;
        
        pars = neuron(iDb).tuning_cut.relative.dir_pars_vm;
        pars(1) = 180;
        abl_rel_vm(:, iDb) = vonMises2(pars, fit_pt );
        abl_rel_vm(:, iDb)= abl_rel_vm(:, iDb)/top;

        pars = neuron(iDb).tuning_cut.dir_pars_vm;
        pars(1) = 180+dDir(iDb);
        abl_vm(:, iDb) = vonMises2(pars, fit_pt );
        abl_vm(:, iDb)= abl_vm(:, iDb)/top;


end

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

%%

figure; 

[sort_par, sort_par_idx] = sort(ave_par, 'ascend');
sort_par_abl_rel = ave_par_abl_rel(sort_par_idx);

[sort_orth, sort_orth_idx]= sort(ave_orth, 'ascend');
sort_orth_abl_rel = ave_orth_abl_rel(sort_orth_idx);

par_lm = fitlm(sort_par, sort_par_abl_rel);
orth_lm = fitlm(sort_orth, sort_orth_abl_rel);

pred_p = -.1:0.01:1;
[par_pred,par_ci] = predict(par_lm, makeVec(pred_p));
[orth_pred,orth_ci] = predict(orth_lm, makeVec(pred_p));

plot(pred_p, par_pred, '-', 'Color', [1 0 0 ]); hold on;
plot(pred_p, orth_pred, '-', 'Color', [0 0.5 1]); hold on;

plot(sort_par, sort_par_abl_rel, 'o', 'Color', [1 0 0], 'MarkerFaceColor', [1 0 0], 'MarkerSize', 6); hold on
plot(sort_orth, sort_orth_abl_rel, 'o', 'Color', [0 0.5 1], 'MarkerFaceColor', [0 0.5 1], 'MarkerSize', 6); hold on


plot([-0.1 1], [-0.1 1], '--', 'Color', [0.3 0.3 0.3])
xlim([-.2 1.1])
ylim([-.2 1.1])
xlabel('Bsl response')
ylabel('Post-dendrotomy')

axis square; 
formatAxes

print(fullfile(saveTo,'Mult_or_Add') ,  '-dpng');

end