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
Dp=[]; Do =[]; Rp=[]; Ro= []; sel = []; sel_abl= []; F0 = [];

%counter of datapoints including longitudinal points
parent_db = [];
nthP = 0;
child_seq = [];

fit_pt = 0:1:360;
fit_pt_30 = 0:30:345;
fit_pt_ori = -90:1:90;

hbins = neuron(1).rot_cortex(1).ang_bins_aligned;
xybins = neuron(1).rot_cortex(1).xy_bins;

for iDb = 1:nDb
    
    for iSeq = 1:numel(neuron(iDb).morph)
        
        nthP = nthP+1;
        parent_db(nthP) = iDb;
        child_seq(nthP) = iSeq;
        
        if strcmp(cut_type{iDb},'para')
            color(nthP, :) = [1 0 0 ];
            type(nthP) = true;
        else
            color(nthP, :) = [0 0.5 1];
            type(nthP) = false;
            
        end
        
        % Dendritic length and response amplitude
        L(nthP) = neuron(iDb).morph(1).stats.L;
        L_cut(nthP) = neuron(iDb).morph(iSeq).stats.L;
        L_basal(nthP) = neuron(iDb).morph_basal(1).stats.L;
        L_basal_cut(nthP) = neuron(iDb).morph_basal(iSeq).stats.L;

        L_apical(nthP) = neuron(iDb).morph_apical(1).stats.L;
        L_apical_cut(nthP) = neuron(iDb).morph_apical(iSeq).stats.L;

        if strcmp(neuron(iDb).db.animal, 'FR172') && neuron(iDb).db.neuron_id == 7 % this reconstructions is missing the apical dendrite


        L_basal(nthP) = L(nthP);
        L_basal_cut(nthP) = L_cut(nthP);

        L_apical(nthP) = 0.3*L(nthP);
        L_apical_cut(nthP) = 0.3*L(nthP);

            apical_bit = 0.3*L(nthP);
            L(nthP) = L(nthP)+ apical_bit ;
            L_cut(nthP) = L_cut(nthP)+ apical_bit ;

        end
        
        Rp(nthP) = neuron(iDb).tuning(1).Rp;
        Ro(nthP) = neuron(iDb).tuning(1).Ro;
        Rn(nthP) = neuron(iDb).tuning(1).Rn;
        
        F0(nthP) = mean(neuron(iDb).tuning(1).F0_neu);
        
        if iSeq >1
            
            Rp_cut(nthP) = neuron(iDb).tuning(iSeq).relative.Rp;
            Ro_cut(nthP) = neuron(iDb).tuning(iSeq).relative.Ro;
            Rn_cut(nthP) = neuron(iDb).tuning(iSeq).relative.Rn;
                    F0_cut(nthP) = mean(neuron(iDb).tuning(iSeq).F0_neu);

        else
            Rp_cut(nthP) = Rp(nthP);
            Ro_cut(nthP) = Ro(nthP);
            Rn_cut(nthP) = Rn(nthP);
                                F0_cut(nthP) =F0(nthP);

        end
        
        sel(nthP) = (Rp(nthP) - Ro(nthP))/(Rp(nthP) + Ro(nthP));
        sel_abl(nthP) = (Rp_cut(nthP) - Ro_cut(nthP))/(Rp_cut(nthP) + Ro_cut(nthP));
        
        if Rp_cut(nthP)>=0 && Rp(nthP) >0
            RoR(nthP) = Rp_cut(nthP)./Rp(nthP);%
            
        elseif Rp_cut(nthP)<0 && Rp(nthP) >0
            RoR(nthP) = 10^-6; %
            
            %Rp_cut(nthP)./Rp(nthP);%
            
            
            %             RoR(iDb) = abs((Rp_abl(iDb)-Ro_abl(iDb)))./(Rp(iDb)-Ro(iDb));
        end
        
        
        
        % Orientation selectivity
        OS(nthP) = neuron(iDb).tuning(1).OS_circ;
                DS(nthP) = neuron(iDb).tuning(1).DS_circ;

                if iSeq >1

        OS_cut(nthP) =neuron(iDb).tuning(iSeq).relative.OS_circ;
                DS_cut(nthP) = neuron(iDb).tuning(iSeq).relative.DS_circ;

                else
                  OS_cut(nthP)   =OS(nthP);
                   DS_cut(nthP) = DS(nthP);

                end
        % OS(iDb) = neuron(iDb).tuning.OS_circ;
        Rp_ori(nthP) = neuron(iDb).tuning(1).Rp_ori;
        Rp_dir(nthP) = neuron(iDb).tuning(1).Rp;
        Rn_dir(nthP) = neuron(iDb).tuning(1).Rn;

        Ro_ori(nthP) = neuron(iDb).tuning(1).Ro_ori;
        Rb(nthP) = neuron(iDb).tuning(1).Rb;
        prefOri(nthP) = neuron(iDb).tuning(1).prefOri;
        prefDir(nthP) = neuron(iDb).tuning(1).prefDir;
%                            DS_cut(nthP) = neuron(iDb).tuning(iSeq).DS_circ;

        % OS_cut(iDb) = neuron(iDb).tuning_cut.OS_circ;
        if iSeq >1
            Rp_dir_cut(nthP) = neuron(iDb).tuning(iSeq).relative.Rp;
            Rn_dir_cut(nthP) = neuron(iDb).tuning(iSeq).relative.Rn;
            Rp_ori_cut(nthP) = neuron(iDb).tuning(iSeq).relative.Rp;
            Ro_ori_cut(nthP) = neuron(iDb).tuning(iSeq).relative.Ro;
            Rb_cut(nthP) = neuron(iDb).tuning(iSeq).relative.Rb;
        else
            Rp_dir_cut(nthP) = neuron(iDb).tuning(iSeq).Rp;
            Rn_dir_cut(nthP) = neuron(iDb).tuning(iSeq).Rn;
            Rp_ori_cut(nthP) = neuron(iDb).tuning(iSeq).Rp;
            Ro_ori_cut(nthP) = neuron(iDb).tuning(iSeq).Ro;
            Rb_cut(nthP) = neuron(iDb).tuning(iSeq).Rb;
        end
        prefOri_cut(nthP) = neuron(iDb).tuning(iSeq).prefOri;
        prefDir_cut(nthP) = neuron(iDb).tuning(iSeq).prefDir;
        dOri(nthP) = unwrap_angle(prefOri(nthP) - prefOri_cut(nthP),1,1); %[-pi/2, pi/2] -->[0, pi/2]
        dDir(nthP) = unwrap_angle(prefDir(nthP) -prefDir_cut(nthP),0,1); %[-pi, pi] -->[0, pi]
        
        
        % response to blank
        
        blank(nthP) = neuron(iDb).tuning(1).avePeak(13);
        abl_blank(nthP) = neuron(iDb).tuning(iSeq).avePeak(13);
        
        % ori tuning curve 1deg res
        pars = neuron(iDb).tuning(1).ori_pars_vm;
        pars(1) = 0;
        ori_vm(:, nthP) = mfun.vonMises(pars, fit_pt_ori*2);
        top = max(ori_vm(:, nthP));
        ori_vm(:, nthP)= ori_vm(:, nthP)/top;
        
        if iSeq >1
            pars = neuron(iDb).tuning(iSeq).relative.ori_pars_vm;
        else
            pars = neuron(iDb).tuning(iSeq).ori_pars_vm;
            
        end
        pars(1) = 0;
        abl_rel_ori_vm(:, nthP) = mfun.vonMises(pars, fit_pt_ori*2);
        abl_rel_ori_vm(:, nthP)= abl_rel_ori_vm(:, nthP)/top;
        
        pars = neuron(iDb).tuning(iSeq).ori_pars_vm;
        pars(1) = dOri(nthP);
        abl_ori_vm(:, nthP) = mfun.vonMises(pars, fit_pt_ori*2);
        abl_ori_vm(:, nthP)= abl_ori_vm(:, nthP)/top;
        
        % tuning curve 1deg res
        pars = neuron(iDb).tuning(1).dir_pars_vm;
        pars(1) = 180;
        vm(:, nthP) = mfun.vonMises2(pars, fit_pt);
        top = max(vm(:, nthP));
        vm(:, nthP)= vm(:, nthP)/top;
        
        if iSeq >1
            pars = neuron(iDb).tuning(iSeq).relative.dir_pars_vm;
        else
            pars = neuron(iDb).tuning(iSeq).dir_pars_vm;
            
        end
        pars(1) = 180;
        abl_rel_vm(:, nthP) = mfun.vonMises2(pars, fit_pt);
        abl_rel_vm(:, nthP)= abl_rel_vm(:, nthP)/top;
        
        pars = neuron(iDb).tuning(iSeq).dir_pars_vm;
        pars(1) = 180+dDir(nthP);
        abl_vm(:, nthP) = mfun.vonMises2(pars, fit_pt);
        abl_vm(:, nthP)= abl_vm(:, nthP)/top;
        
        % tuning curve 30 deg res
        
        pars = neuron(iDb).tuning(1).dir_pars_vm;
        pars(1) = 180;
        [vm_30(:, nthP), sort_idx] = sort(mfun.vonMises2(pars, fit_pt_30), 'ascend');
        top = max(vm_30(:, nthP));
        vm_30(:, nthP)= vm_30(:, nthP)/top;
        
        if iSeq >1
            pars = neuron(iDb).tuning(iSeq).relative.dir_pars_vm;
        else
            pars = neuron(iDb).tuning(iSeq).dir_pars_vm;
            
        end
        pars(1) = 180;
        abl_rel_vm_30(:, nthP) = mfun.vonMises2(pars, fit_pt_30 );
        abl_rel_vm_30(:, nthP)= abl_rel_vm_30(sort_idx, nthP)/top;
        
        pars = neuron(iDb).tuning(iSeq).dir_pars_vm;
        pars(1) = 180+dDir(nthP);
        abl_vm_30(:, nthP) = mfun.vonMises2(pars, fit_pt_30 );
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
        
        
        xy(:,:,nthP) = neuron(iDb).rot_cortex(1).xy_density;
        xy_cut(:,:,nthP) = neuron(iDb).rot_cortex(iSeq).xy_density*L_cut(nthP)/L(nthP);

        zx(:,:,nthP) = neuron(iDb).morph(1).stats.zx_density;
        zx_cut(:,:,nthP) = neuron(iDb).morph(iSeq).stats.zx_density*L_cut(nthP)/L(nthP);
        
        xy_horz(:,:,nthP) = neuron(iDb).rot_cortex(1).xy_density_horz;
        xy_horz_cut(:,:,nthP) = neuron(iDb).rot_cortex(iSeq).xy_density*L_cut(nthP)/L(nthP);
        
        
        %        xy_ret(:,:,nthP) = neuron(iDb).retino_aligned(1).stats.xy_density;
        %        xy_ret_cut(:,:,nthP) = neuron(iDb).retino_aligned(iSeq).stats.xy_density*L_cut(nthP)/L(nthP);
        
    end
    
    
end

dOri = abs(dOri);
dDir = abs(dDir);



%%
L_rel = 1 - L_cut./L;
type = logical(type);
is_cut = child_seq>1;
parent = child_seq ==1;
last_child = circshift(parent, -1);

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


ave_blank_par = mean(blank(type & is_cut));
se_blank_par = std(blank(type & is_cut))/sqrt(numel(blank(type & is_cut)));
ave_abl_blank_par = mean(abl_blank(type & is_cut));
se_abl_blank_par = std(abl_blank(type & is_cut))/sqrt(numel(abl_blank(type & is_cut)));

ave_blank_orth = mean(blank(~type & is_cut));
se_blank_orth = std(blank(~type & is_cut))/sqrt(numel(blank(~type & is_cut)));
ave_abl_blank_orth = mean(abl_blank(~type & is_cut));
se_abl_blank_orth= std(abl_blank(~type & is_cut))/sqrt(numel(abl_blank(~type & is_cut)));

ave_blank_all = mean(blank(is_cut));
se_blank_all = std(blank(is_cut))/sqrt(numel(blank(is_cut)));
ave_abl_blank_all = mean(abl_blank(is_cut));
se_abl_blank_all= std(abl_blank(is_cut))/sqrt(numel(abl_blank(is_cut)));

ave_ori_par = mean(ori_vm(:, type & is_cut),2);
se_ori_par = std(ori_vm(:, type & is_cut),[], 2)/sqrt(sum(type & is_cut));
ave_ori_orth = mean(ori_vm(:, ~type & is_cut),2);
se_ori_orth = std(ori_vm(:, ~type & is_cut),[], 2)/sqrt(sum(~type & is_cut));

ave_ori_all = mean(ori_vm(:, is_cut),2);
se_ori_all = std(ori_vm(:, is_cut),[], 2)/sqrt(sum(is_cut));
ave_ori_all_abl = mean(abl_ori_vm(:, is_cut),2);
se_ori_all_abl = std(abl_ori_vm(:, is_cut),[], 2)/sqrt(sum(is_cut));


ave_ori_par_abl = mean(abl_ori_vm(:, type & is_cut),2);
se_ori_par_abl = std(abl_ori_vm(:, type & is_cut),[], 2)/sqrt(sum(type & is_cut));
ave_ori_orth_abl = mean(abl_ori_vm(:, ~type & is_cut),2);
se_ori_orth_abl = std(abl_ori_vm(:, ~type & is_cut),[], 2)/sqrt(sum(~type & is_cut));

ave_ori_par_abl_rel = mean(abl_rel_ori_vm(:, type & is_cut),2);
se_ori_par_abl_rel = std(abl_rel_ori_vm(:, type & is_cut),[], 2)/sqrt(sum(type & is_cut));
ave_ori_orth_abl_rel = mean(abl_rel_ori_vm(:, ~type & is_cut),2);
se_ori_orth_abl_rel = std(abl_rel_ori_vm(:, ~type & is_cut),[], 2)/sqrt(sum(~type & is_cut));


ave_par = mean(vm(:, type & is_cut),2);
se_par = std(vm(:, type & is_cut),[], 2)/sqrt(sum(type & is_cut));
ave_orth = mean(vm(:, ~type & is_cut),2);
se_orth = std(vm(:, ~type & is_cut),[], 2)/sqrt(sum(~type & is_cut));

ave_par_abl = mean(abl_vm(:, type & is_cut),2);
se_par_abl = std(abl_vm(:, type & is_cut),[], 2)/sqrt(sum(type & is_cut));
ave_orth_abl = mean(abl_vm(:, ~type & is_cut),2);
se_orth_abl = std(abl_vm(:, ~type & is_cut),[], 2)/sqrt(sum(~type & is_cut));

ave_par_abl_rel = mean(abl_rel_vm(:, type & is_cut),2);
se_par_abl_rel = std(abl_rel_vm(:, type & is_cut),[], 2)/sqrt(sum(type & is_cut));
ave_orth_abl_rel = mean(abl_rel_vm(:, ~type & is_cut),2);
se_orth_abl_rel = std(abl_rel_vm(:, ~type & is_cut),[], 2)/sqrt(sum(~type & is_cut));

ave_par_30 = mean(vm_30(:, type & is_cut),2);
se_par_30 = std(vm_30(:, type & is_cut),[], 2)/sqrt(sum(type & is_cut));
ave_orth_30 = mean(vm_30(:, ~type & is_cut),2);
se_orth_30 = std(vm_30(:, ~type & is_cut),[], 2)/sqrt(sum(~type & is_cut));
ave_30 = mean(vm_30(:, is_cut),2);
se_30 = std(vm_30(:, is_cut),[], 2)/sqrt(sum(is_cut));


ave_par_abl_30 = mean(abl_vm_30(:, type & is_cut),2);
se_par_abl_30 = std(abl_vm_30(:, type & is_cut),[], 2)/sqrt(sum(type & is_cut));
ave_orth_abl_30 = mean(abl_vm_30(:, ~type & is_cut),2);
se_orth_abl_30 = std(abl_vm_30(:, ~type & is_cut),[], 2)/sqrt(sum(~type & is_cut));
ave_abl_30 = mean(abl_vm_30(:, type & is_cut),2);
se_abl_30 = std(abl_vm_30(:,is_cut),[], 2)/sqrt(sum(is_cut));

ave_par_abl_rel_30 = mean(abl_rel_vm_30(:, type & is_cut),2);
se_par_abl_rel_30 = std(abl_rel_vm_30(:, type & is_cut),[], 2)/sqrt(sum(type & is_cut));
ave_orth_abl_rel_30 = mean(abl_rel_vm_30(:, ~type),2);
se_orth_abl_rel_30 = std(abl_rel_vm_30(:, ~type & is_cut),[], 2)/sqrt(sum(~type & is_cut));
ave_abl_rel_30 = mean(abl_rel_vm_30(:, is_cut),2);
se_abl_rel_30 = std(abl_rel_vm_30(:,is_cut),[], 2)/sqrt(sum(is_cut));


trims_dist(trims_dist<0) = 0;

ave_par_dist = mean(centeredDist(:, type & is_cut),2);
ave_par_trim = mean(trims_dist(:, type & is_cut),2);
ave_par_dist_cut = mean(centeredDist_cut(:, type & is_cut),2);

se_par_dist = std(centeredDist(:, type & is_cut),[],2)/sqrt(sum(type & is_cut));
se_par_trim = std(trims_dist(:, type & is_cut),[],2);
se_par_dist_cut = std(centeredDist_cut(:, type & is_cut),[],2)/sqrt(sum(type & is_cut));

ave_orth_dist = mean(centeredDist(:, ~type & is_cut),2);
ave_orth_trim = mean(trims_dist(:, ~type & is_cut),2);
ave_orth_dist_cut = mean(centeredDist_cut(:, ~type & is_cut),2);
se_orth_dist = std(centeredDist(:, ~type & is_cut),[],2)/sqrt(sum(~type & is_cut));
se_orth_trim = std(trims_dist(:, ~type & is_cut),[],2);
se_orth_dist_cut = std(centeredDist_cut(:, ~type & is_cut),[],2)/sqrt(sum(~type & is_cut));

ave_zx = mean(zx(:,:, parent),3);
z_top = max(ave_zx(:));
ave_zx = ave_zx/z_top;
ave_abl_zx = mean(zx_cut(:,:, last_child),3)/z_top;
ave_z = mean(ave_zx,2);
se_z = squeeze(std(mean(zx(:,:, parent),2), [], 3))/sqrt(sum(parent));
ave_abl_z = mean(ave_abl_zx,2);
se_abl_z = squeeze(std(mean(zx_cut(:,:, last_child),2), [], 3))/sqrt(sum(last_child));


ave_par_xy = mean(xy(:,:, type & is_cut),3);
par_top = max(ave_par_xy(:));
ave_par_xy = ave_par_xy/par_top;
ave_par_abl_xy = mean(xy_cut(:,:, type & is_cut),3)/par_top;

ave_orth_xy = mean(xy_horz(:,:, ~type & is_cut),3);
orth_top = max(ave_orth_xy(:));
ave_orth_xy = ave_orth_xy/orth_top;
ave_orth_abl_xy = mean(xy_horz_cut(:,:, ~type & is_cut),3)/orth_top;


%%
figure('Color', 'w','Position', [536 178 797 300])

subplot(1,3,1)
plot([0 max(L_basal(parent))+100], [0 max(L_basal(parent))+100], '--', 'Color', [0.2 0.2 0.2]);
hold on;
scatter(L_basal(parent), L_apical(parent), 40,[0.2 0.2 0.2], 'MarkerFaceColor', [0.2 0.2 0.2],'MarkerEdgeAlpha', 0.2, 'MarkerFaceAlpha', 0.2);
axis square; 
xlim([0 max(L_basal(parent))+100]); 
ylim([0 max(L_basal(parent))+100]);
formatAxes
xlabel('L basal (mm)')
ylabel('L apical (mm)')
set(gca, 'XTick', [0 5000], 'XTickLabel', [0 5], 'YTick', [0 5000], 'YTickLabel', [0 5])

subplot(1,3,2)
plot([0 max(L_basal(parent))+100], [0 max(L_basal(parent))+100], '--', 'Color', [0.2 0.2 0.2]);
hold on;
scatter(L_basal(parent)./L(parent), L_basal_cut(last_child)./L(parent), 40,[1 0, 1], 'MarkerFaceColor', [1 0 1],'MarkerEdgeAlpha', 0.2, 'MarkerFaceAlpha', 0.2);
axis square;
xlim([0 1]); 
ylim([0 1]);
formatAxes
xlabel('% basal')
ylabel('% basal after pruning')

%% plot the pooled dendriti trees

figure('Color', 'w');


gamma = 0.3;

orth_d = ave_orth_xy - ave_orth_abl_xy;
par_d = ave_par_xy - ave_par_abl_xy;
orth_d(orth_d<0) =0;
par_d(par_d<0) =0;

orth_rgb = repmat(ave_orth_abl_xy.^gamma, 1,1,3);
zero_idx = find(orth_rgb ==0);
orth_rgb(:,:,1) = ave_orth_abl_xy.^gamma+ orth_d.^gamma;
orth_rgb(:,:,2) = ave_orth_abl_xy.^gamma + 0.5*orth_d.^gamma;
orth_rgb(:,:,3) = ave_orth_abl_xy.^gamma;
orth_top = max(orth_rgb(:));
orth_rgb = 1 - orth_rgb/orth_top;
% orth_rgb(zero_idx) = 1;


par_rgb = repmat(ave_par_abl_xy.^gamma, 1,1,3);
zero_idx = find(orth_rgb ==0);
par_rgb(:,:,1) = ave_par_abl_xy.^gamma;
par_rgb(:,:,2) = ave_par_abl_xy.^gamma + par_d.^gamma;
par_rgb(:,:,3) = ave_par_abl_xy.^gamma + par_d.^gamma;
par_top = max(par_rgb(:));
par_rgb = 1- par_rgb/par_top;
% par_rgb(zero_idx) = 1;

subplot(2,4,4)
image(xybins, xybins,orth_rgb); axis image
formatAxes
xlabel('\mum')

subplot(2, 4,8)
image(xybins, xybins,par_rgb); axis image
formatAxes
xlabel('\mum')

o = subplot(2,4, 1);
imagesc(xybins, xybins,(ave_orth_xy.^gamma)/orth_top); axis image
colormap(o, 1-gray); caxis([0, 1])
formatAxes
xlabel('\mum')
ylabel('\mum')

oc = subplot(2,4, 2);
imagesc(xybins, xybins,(ave_orth_abl_xy.^gamma)/orth_top); axis image
colormap(oc, 1-gray); caxis([0, 1])
formatAxes
xlabel('\mum')

od = subplot(2,4, 3);
imagesc(xybins, xybins,1-(orth_d.^gamma)/orth_top); axis image
colormap(od, gBlues); caxis([0, 1])
formatAxes
xlabel('\mum')

p = subplot(2,4, 5);
imagesc(xybins, xybins,(ave_par_xy.^gamma)/par_top); axis image
colormap(p, 1-gray); caxis([0, 1])
formatAxes
xlabel('\mum')
ylabel('\mum')

pc = subplot(2,4, 6);
imagesc(xybins, xybins,(ave_par_abl_xy.^gamma)/par_top); axis image
colormap(pc, 1-gray); caxis([0, 1])
formatAxes
xlabel('\mum')

pd = subplot(2,4, 7);
imagesc(xybins, xybins,(par_d.^gamma)/par_top); axis image
colormap(pd, WhiteRed); caxis([0, 1])
formatAxes
xlabel('\mum')

saveTo = fullfile(neuron(1).db.data_repo, 'Results');
    print(fullfile(saveTo,'Pool_neurons_pruning') , '-dpdf', '-painters');

    %%

    gamma = 0.3;

z_d = ave_zx - ave_abl_zx;
z_d(z_d<0) =0;



z_rgb = repmat(ave_abl_zx.^gamma, 1,1,3);
zero_idx = find(z_rgb ==0);
z_rgb(:,:,1) = ave_abl_zx.^gamma;
z_rgb(:,:,2) = ave_abl_zx.^gamma + z_d.^gamma;
z_rgb(:,:,3) = ave_abl_zx.^gamma;
z_top = max(z_rgb(:));
z_rgb = 1- z_rgb/z_top;



zxbins = -300:5:300;

z_top = max(ave_zx(:).^gamma);

figure('Color', 'w','Position', [536 178 797 745]);
% p = subplot(1,3, 1);
% imagesc(zxbins, xybins,(ave_zx.^gamma)/par_top); axis image
% colormap(p, 1-gray); caxis([0, 1])
% formatAxes
% xlabel('\mum')
% ylabel('\mum')

ax1 = subplot(2,3, 1);
image(xybins,zxbins, z_rgb); axis square
formatAxes
xlabel('\mum');
ylabel('\mum');
ylim([-300, 200])
xlim([-250, 250])


ax2 = subplot(2,3, 2);
shadePlot(zxbins, ave_z, se_z, [0.2 0.2 0.2]); hold on
shadePlot(zxbins, ave_abl_z, se_abl_z, [1 0 1]); hold on
view([90 -90])
ax2.XDir = 'reverse';
formatAxes
ylabel('Dendrite density')
xlabel('\mum')
axis square
xlim([-300, 200])

ax3 = subplot(2,3, 4);

shadePlot(fit_pt_ori, ave_ori_all,se_ori_all, [0 0 0]); hold on;
shadePlot([120 130], [ave_blank_all, ave_blank_all],[se_blank_all, se_blank_all], [0 0 0]); hold on
shadePlot(fit_pt_ori, ave_ori_all_abl,se_ori_all_abl, [1 0 1]); hold on;
shadePlot([120 130], [ave_abl_blank_all, ave_abl_blank_all],[se_abl_blank_all, se_abl_blank_all], [1 0 1]); hold on;
formatAxes
set(gca, 'YTick', [0 1],'XTick',  [-90:90:90, 125], 'XTickLabel', {-90:90:90, 'bsl'});
xlim([-100 135])
ylim([-0.2 1.2])
xlabel('\Delta pref orientation')
ylabel('Normalised Tuning ')
axis square

ax4 = subplot(2,3, 5);

% linear tuning curves

hold on;
all_lm = fitlm(ave_30, ave_abl_rel_30);

pred_pp = -.1:0.01:1;
[all_pred,all_ci] = predict(all_lm, makeVec(pred_pp));
% 
plot(vm_30(:, is_cut), abl_rel_vm_30(:, is_cut), '-', 'Color', [1 0 1 0.2], 'Linewidth', 0.5); hold on;

plot(pred_pp, all_pred, '-', 'Color', [1 0 1]); hold on;

plot(ave_30, ave_abl_rel_30, 'o', 'Color', [1 0 1], 'MarkerFaceColor', [1 0 1], 'MarkerSize', 6); hold on


plot([-0.1 1], [-0.1 1], '--', 'Color', [0.3 0.3 0.3])
xlim([-.2 1.1])
ylim([-.2 1.1])
xlabel('Bsl response')
ylabel('Post-dendrotomy')

axis square;
formatAxes

ax5 = subplot(2,3, 6);

% slope vs dendrites cut
sigm = @(pars, x) pars(4)./(1+ pars(3).*exp(pars(1).*(x - pars(2))));
pars0 = [1 0 1 2];
parsup = [Inf 0 1 2];
parslow = [0 0 1 2];

all_lm = lsqcurvefit(sigm, pars0, L_rel, slope, parslow, parsup);

x_pred = 0:0.1:0.6;
plot(x_pred, sigm(all_lm, x_pred), 'Color', [1 0 1], 'LineWidth', 2); hold on

scatter(L_rel, slope, 40,[1 0, 1], 'MarkerFaceColor', [1 0 1],'MarkerEdgeAlpha', 0.2, 'MarkerFaceAlpha', 0.2); hold on;


for iDb = 1:nDb
    if sum(parent_db==iDb)>1
        plot(L_rel(parent_db==iDb), slope(parent_db==iDb), '-', 'Color', [1 0 1 0.2], ...
            'LineWidth', 0.5); hold on
    end
end

xlim([-0.05 0.65]);
ylim([-0.4 1.2]);
xlabel('Fraction dendrites cut')
ylabel('Multiplicative scaling')
formatAxes
axis square

%% plot Rpp vs Lcut

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
    print(fullfile(saveTo,'RP_vs_dendrotomy') , '-dpdf', '-painters');

%%
%
% chosen_par = oricut==1 & ncut>=2;
% chosen_orth = oricut==0 & ncut>=2;
%
% ranksum(sel(chosen_par) -sel_abl((chosen_par)),sel(chosen_orth) -sel_abl((chosen_orth)))
%
% ranksum(Rp_abl((chosen_par)),Rp_abl((chosen_orth)))
% ranksum(Ro_abl((chosen_par)),Ro_abl((chosen_orth)))






%% plot the tuning curve stats

figure('Position', [470 558 1221 420], 'Color', 'w');

subplot(2, 4, 5)

[~,p_dOri] = ttest2(dOri(type & is_cut), dOri(~type & is_cut));
scatter(ones(1, sum(type & is_cut)), dOri(type & is_cut),40,[1 0 0], 'MarkerFaceColor', [1 0 0],'MarkerEdgeAlpha', 0.2, 'MarkerFaceAlpha', 0.2);hold on
scatter(2*ones(1, sum(~type & is_cut)), dOri(~type & is_cut), 40,[0 0.5 1], 'MarkerFaceColor', [0 0.5 1],'MarkerEdgeAlpha', 0.2, 'MarkerFaceAlpha', 0.2);hold on
xlim([0 3])
formatAxes
axis square
title(sprintf('dOri, p = %03f', p_dOri), 'Fontsize', 10);
xlabel('Pre')
ylabel('Post')

subplot(2, 4, 6)
[~,p_dDir] = ttest2(dDir(type & is_cut), dDir(~type & is_cut));
scatter(ones(1, sum(type & is_cut)), dDir(type & is_cut),40,[1 0 0], 'MarkerFaceColor', [1 0 0],'MarkerEdgeAlpha', 0.2, 'MarkerFaceAlpha', 0.2);hold on
scatter(2*ones(1, sum(~type & is_cut)), dDir(~type & is_cut), 40,[0 0.5 1], 'MarkerFaceColor', [0 0.5 1],'MarkerEdgeAlpha', 0.2, 'MarkerFaceAlpha', 0.2);hold on
xlim([0 3])
formatAxes
axis square
title(sprintf('dDir, p = %03f', p_dDir), 'Fontsize', 10);
xlabel('Pre')

subplot(2, 4, 1)
[~,p_pRp] = ttest(Rp(type & is_cut), Rp_cut(type & is_cut));
[~,p_oRp] = ttest(Rp(~type & is_cut), Rp_cut(~type & is_cut));
scatter(Rp(type & is_cut), Rp_cut(type & is_cut), 40,[1 0 0], 'MarkerFaceColor', [1 0 0],'MarkerEdgeAlpha', 0.2, 'MarkerFaceAlpha', 0.2);hold on
scatter(Rp(~type & is_cut), Rp_cut(~type & is_cut),  40,[0 0.5 1], 'MarkerFaceColor', [0 0.5 1],'MarkerEdgeAlpha', 0.2, 'MarkerFaceAlpha', 0.2);hold on
plot([-1 5], [-1 5], '--k')
formatAxes
xlim([-1 4]);
ylim([-1 4]);
axis square
title(sprintf('p_pRp = %03f\np_oRp = %03f', p_pRp, p_oRp), 'Fontsize', 10);
xlabel('Pre')

subplot(2, 4, 3)
[~,p_pRo] = ttest(Ro(type & is_cut), Ro_cut(type & is_cut));
[~,p_oRo] = ttest(Ro(~type & is_cut), Ro_cut(~type & is_cut));
scatter(Ro(type & is_cut), Ro_cut(type & is_cut), 40,[1 0 0], 'MarkerFaceColor', [1 0 0],'MarkerEdgeAlpha', 0.2, 'MarkerFaceAlpha', 0.2);hold on
scatter(Ro(~type & is_cut), Ro_cut(~type & is_cut),  40,[0 0.5 1], 'MarkerFaceColor', [0 0.5 1],'MarkerEdgeAlpha', 0.2, 'MarkerFaceAlpha', 0.2);hold on
plot([-1 1], [-1 1], '--k')
formatAxes
xlim([-0.5 0.5]);
ylim([-0.5 0.5]);
axis square
title(sprintf('p_pRo = %03f\np_oRo = %03f', p_pRo, p_oRo), 'Fontsize', 10);
xlabel('Pre')

subplot(2, 4, 4)
[~,p_pRb] = ttest(Rb(type & is_cut), Rb_cut(type & is_cut));
[~,p_oRb] = ttest(Rb(~type & is_cut), Rb_cut(~type & is_cut));
scatter(Rb(type & is_cut), Rb_cut(type & is_cut), 40,[1 0 0], 'MarkerFaceColor', [1 0 0],'MarkerEdgeAlpha', 0.2, 'MarkerFaceAlpha', 0.2);hold on
scatter(Rb(~type & is_cut), Rb_cut(~type & is_cut), 40,[0 0.5 1], 'MarkerFaceColor', [0 0.5 1],'MarkerEdgeAlpha', 0.2, 'MarkerFaceAlpha', 0.2);hold on
plot([-1 1], [-1 1], '--k')
formatAxes
xlim([-0.5 0.5]);
ylim([-0.5 0.5]);
axis square
title(sprintf('p_pRb = %03f\np_oRb = %03f', p_pRb, p_oRb), 'Fontsize', 10);
xlabel('Pre')

subplot(2, 4, 2)
[~,p_pRn] = ttest(Rn_dir(type & is_cut), Rn_dir_cut(type & is_cut));
[~,p_oRn] = ttest(Rn_dir(~type & is_cut), Rn_dir_cut(~type & is_cut));
scatter(Rn_dir(type & is_cut), Rn_dir_cut(type & is_cut), 40,[1 0 0], 'MarkerFaceColor', [1 0 0],'MarkerEdgeAlpha', 0.2, 'MarkerFaceAlpha', 0.2);hold on
scatter(Rn_dir(~type & is_cut), Rn_dir_cut(~type & is_cut), 40,[0 0.5 1], 'MarkerFaceColor', [0 0.5 1],'MarkerEdgeAlpha', 0.2, 'MarkerFaceAlpha', 0.2);hold on
plot([-3 3], [-3 3], '--k')
formatAxes
xlim([-1 2]);
ylim([-1 2]);
axis square
title(sprintf('p_pRn = %03f\np_oRn = %03f', p_pRn, p_oRn), 'Fontsize', 10);
xlabel('Pre')

subplot(2, 4, 7)
[~,p_pDS] = ttest(DS(type & is_cut), DS_cut(type & is_cut));
[~,p_oDS] = ttest(DS(~type & is_cut), DS_cut(~type & is_cut));
scatter(DS(type & is_cut), DS_cut(type & is_cut),40,[1 0 0], 'MarkerFaceColor', [1 0 0],'MarkerEdgeAlpha', 0.2, 'MarkerFaceAlpha', 0.2);hold on
scatter(DS(~type & is_cut), DS_cut(~type & is_cut), 40,[0 0.5 1], 'MarkerFaceColor', [0 0.5 1],'MarkerEdgeAlpha', 0.2, 'MarkerFaceAlpha', 0.2);hold on
plot([0 2], [0 2], '--k')
xlim([-0.1 1.1]);
ylim([-0.1 1.1]);
formatAxes
axis square
title(sprintf('p_pDS = %03f\np_oDS = %03f', p_pDS, p_oDS), 'Fontsize', 10);
xlabel('Pre')


subplot(2, 4, 8)
[~,p_pOS] = ttest(OS(type & is_cut), OS_cut(type & is_cut));
[~, p_oOS] = ttest(OS(~type & is_cut), OS_cut(~type & is_cut));
scatter(OS(type & is_cut), OS_cut(type & is_cut), 40,[1 0 0], 'MarkerFaceColor', [1 0 0],'MarkerEdgeAlpha', 0.2, 'MarkerFaceAlpha', 0.2);hold on
scatter(OS(~type & is_cut), OS_cut(~type & is_cut),  40,[0 0.5 1], 'MarkerFaceColor', [0 0.5 1],'MarkerEdgeAlpha', 0.2, 'MarkerFaceAlpha', 0.2);hold on
plot([0 2], [0 2], '--k')
xlim([-0.1 1.1]);
ylim([-0.1 1.1]);
formatAxes
axis square
title(sprintf('p_pOS = %03f\np_oOS = %03f', p_pOS, p_oOS), 'Fontsize', 10);
xlabel('Pre')


print(fullfile(saveTo,'dendrotomy_average_tuning') ,  '-dpng');
    print(fullfile(saveTo,'dendrotomy_average_tuning') , '-dpdf', '-painters');

anova_DS = cat(2, DS(type & is_cut), DS(~type & is_cut));
anova_DScut = cat(2, DS_cut(type & is_cut), DS_cut(~type & is_cut));
anova_all = cat(2, anova_DS, anova_DScut);
para_or_orth = cat(2,ones(1, sum(type & is_cut)), ones(1, sum(~type & is_cut))*2);
para_or_orth = cat(2, para_or_orth, para_or_orth);
pre_or_post = cat(2, ones(1, numel(anova_DS)), ones(1, numel(anova_DScut))*2);

[p, tbl] = anovan(anova_all, {para_or_orth, pre_or_post }, 'model', 'full', 'varnames', {'DS p vs o', 'cut'});


anova_OS = cat(2, OS(type & is_cut), OS(~type & is_cut));
anova_OScut = cat(2, OS_cut(type & is_cut), OS_cut(~type & is_cut));
anova_all = cat(2, anova_OS, anova_OScut);
para_or_orth = cat(2,ones(1, sum(type & is_cut)), ones(1, sum(~type & is_cut))*2);
para_or_orth = cat(2, para_or_orth, para_or_orth);
pre_or_post = cat(2, ones(1, numel(anova_OS)), ones(1, numel(anova_OScut))*2);

[p, tbl] = anovan(anova_all, {para_or_orth, pre_or_post }, 'model', 'full', 'varnames', {'OS p vs o', 'cut'});

anova_B = cat(2, Rb(type & is_cut), Rb(~type & is_cut));
anova_B_cut = cat(2, Rb_cut(type & is_cut), Rb_cut(~type & is_cut));
anova_all = cat(2, anova_B, anova_B_cut);

para_or_orth = cat(2,ones(1, sum(type & is_cut)), ones(1, sum(~type & is_cut))*2);
pre_or_post = table([0 1]', 'VariableNames', {'bsl_cut'});
t = table(para_or_orth', anova_B', anova_B_cut', 'VariableNames',  {'po', 'bsl', 'cut'});
rm = fitrm(t, 'bsl-cut ~ po', 'WithinDesign', pre_or_post);
ranovatable = ranova(rm)

para_or_orth = cat(2, para_or_orth, para_or_orth);
pre_or_post = cat(2, ones(1, numel(anova_OS)), ones(1, numel(anova_OScut))*2);
[p, tbl] = anovan(anova_all, {para_or_orth, pre_or_post }, 'model', 'full', 'varnames', {'po', 'cut'});

anova_0 = cat(2, Ro(type & is_cut), Ro(~type & is_cut));
anova_0_cut = cat(2, Ro_cut(type & is_cut), Ro_cut(~type & is_cut));
anova_all = cat(2, anova_0, anova_0_cut);
para_or_orth = cat(2,ones(1, sum(type & is_cut)), ones(1, sum(~type & is_cut))*2);
pre_or_post = table([0 1]', 'VariableNames', {'bsl_cut'});
t = table(para_or_orth', anova_0', anova_0_cut', 'VariableNames',  {'po', 'bsl', 'cut'});
rm = fitrm(t, 'bsl-cut ~ po', 'WithinDesign', pre_or_post);
ranovatable = ranova(rm)

para_or_orth = cat(2, para_or_orth, para_or_orth);
pre_or_post = cat(2, ones(1, numel(anova_OS)), ones(1, numel(anova_OScut))*2);
[p, tbl] = anovan(anova_all, {para_or_orth, pre_or_post }, 'model', 'full', 'varnames', {'po', 'cut'});

%% Plot average trees, angular hist, tuning across neurons

figure('Position',  [483 93 877 889], 'Color', 'w');

subplot(4,4,5)
image(xybins, xybins,orth_rgb); axis image
xlim([-250 250])
ylim([-250 250])
formatAxes
xlabel('\mum')

subplot(4, 4, 1)
image(xybins, xybins,par_rgb); axis image
xlim([-250 250])
ylim([-250 250])
formatAxes
xlabel('\mum')

subplot(4,4,2)
polarhistogram('BinEdges', cat(2, hbins', hbins(1)+2*pi), ...
    'BinCounts', ave_par_dist,  'EdgeColor','none','FaceColor', [1 0 0], 'FaceAlpha', 1);
hold on;
% polarhistogram('BinEdges', cat(2, hbins', hbins(1)+2*pi), ...
%     'BinCounts', ave_par_trim,  'DisplayStyle', 'stairs', 'EdgeColor', [1 0 0]);

polarhistogram('BinEdges', cat(2, hbins', hbins(1)+2*pi), ...
    'BinCounts', ave_par_dist_cut,  'EdgeColor', 'none', 'FaceColor', [0 0 0], 'FaceAlpha', 1);


formatAxes
set(gca, 'RTick', [], 'ThetaTick', [0 90 180 270]);
set(gca, 'RTick', [], 'ThetaTick', [0 90 180 270]);

set(gca,  'ThetaZeroLocation', 'top');

subplot(4,4,6)
polarhistogram('BinEdges', cat(2, hbins', hbins(1)+2*pi), ...
    'BinCounts', ave_orth_dist,  'EdgeColor', 'none', 'FaceColor', [0 0.5 1], 'FaceAlpha', 1);
hold on;
% polarhistogram('BinEdges', cat(2, hbins', hbins(1)+2*pi), ...
%     'BinCounts', ave_orth_trim,  'DisplayStyle', 'stairs', 'EdgeColor', [0. 0.5 1]);

polarhistogram('BinEdges', cat(2, hbins', hbins(1)+2*pi), ...
    'BinCounts', ave_orth_dist_cut,  'EdgeColor', 'none', 'FaceColor', [0 0 0], 'FaceAlpha', 1);

set(gca, 'RTick', [], 'ThetaTick', [0 90 180 270]);
formatAxes
set(gca,  'ThetaZeroLocation', 'top');

subplot(4,4,3)
shadePlot(fit_pt, ave_par,se_par, [0 0 0]); hold on;
shadePlot(fit_pt, ave_par_abl, se_par_abl, [1 0 0 ]); hold on;
formatAxes
set(gca, 'YTick', [0 1], 'XTick', [0:90:360], 'XTickLabel', {0:90:360});
xlim([-10 , 370])
ylim([-0.2 1.2])
xlabel('\Delta pref direction')
ylabel('Normalised Tuning ')

subplot(4,4,7)
shadePlot(fit_pt, ave_orth,se_orth, [0 0 0]); hold on;
shadePlot(fit_pt, ave_orth_abl,se_orth_abl, [0 0.5 1]); hold on;
formatAxes
% set(gca, 'YColor', 'none','YTick', [], 'XTick', [0:90:360], 'XTickLabel', {0:90:360});
set(gca, 'YTick', [0 1], 'XTick', [0:90:360], 'XTickLabel', {0:90:360});
xlim([-10 , 370])
ylim([-0.2 1.2])
xlabel('\Delta pref direction')
ylabel('Normalised Tuning ')

subplot(4,4,4)
shadePlot(fit_pt, ave_par,se_par, [0 0 0]); hold on;
shadePlot(fit_pt, ave_par_abl_rel, se_par_abl_rel, [1 0 0 ]); hold on;
formatAxes
set(gca, 'YTick', [0 1],'XTick', [0:90:360], 'XTickLabel', {0:90:360});
xlim([-10 , 370])
ylim([-0.2 1.2])
xlabel('\Delta pref direction')
ylabel('Tuning locked')

subplot(4,4,8)
shadePlot(fit_pt, ave_orth,se_orth, [0 0 0]); hold on;
shadePlot(fit_pt, ave_orth_abl_rel,se_orth_abl_rel, [0 0.5 1]); hold on;
formatAxes
% set(gca, 'YColor', 'none','YTick', [], 'XTick', [0:90:360], 'XTickLabel', {0:90:360});
set(gca, 'YTick', [0 1],'XTick', [0:90:360], 'XTickLabel', {0:90:360});
xlim([-10 , 370])
ylim([-0.2 1.2])
xlabel('\Delta pref direction')
ylabel(' Tuning locked')

subplot(4,4,11)
shadePlot(fit_pt_ori, ave_ori_par,se_ori_par, [0 0 0]); hold on;
shadePlot([120 130], [ave_blank_par, ave_blank_par],[se_blank_par, se_blank_par], [0 0 0]); hold on

shadePlot(fit_pt_ori, ave_ori_par_abl, se_ori_par_abl, [1 0 0 ]); hold on;
shadePlot([120 130], [ave_abl_blank_par, ave_abl_blank_par],[se_abl_blank_par, se_abl_blank_par], [1 0 0 ]); hold on;

formatAxes
set(gca, 'YTick', [0 1],'XTick',  [-90:90:90, 125], 'XTickLabel', {-90:90:90, 'bsl'});
xlim([-100 135])
ylim([-0.2 1.2])
xlabel('\Delta pref orientation')
ylabel('Normalised Tuning ')

subplot(4,4,15)
shadePlot(fit_pt_ori, ave_ori_orth,se_ori_orth, [0 0 0]); hold on;
shadePlot([120 130], [ave_blank_orth, ave_blank_orth],[se_blank_orth, se_blank_orth], [0 0 0]); hold on
shadePlot(fit_pt_ori, ave_ori_orth_abl,se_ori_orth_abl, [0 0.5 1]); hold on;
shadePlot([120 130], [ave_abl_blank_orth, ave_abl_blank_orth],[se_abl_blank_orth, se_abl_blank_orth], [0 0.5 1]); hold on;

formatAxes
% set(gca, 'YColor', 'none','YTick', [], 'XTick', [0:90:360], 'XTickLabel', {0:90:360});
set(gca, 'YTick', [0 1],'XTick',  [-90:90:90, 125], 'XTickLabel', {-90:90:90, 'bsl'});
xlim([-100 135])
ylim([-0.2 1.2])
xlabel('\Delta pref orientation')
ylabel('Normalised Tuning ')

subplot(4,4,12)
shadePlot(fit_pt_ori, ave_ori_par,se_ori_par, [0 0 0]); hold on;
shadePlot([120 130], [ave_blank_par, ave_blank_par],[se_blank_par, se_blank_par], [0 0 0]); hold on
shadePlot(fit_pt_ori, ave_ori_par_abl_rel, se_ori_par_abl_rel, [1 0 0 ]); hold on;
shadePlot([120 130], [ave_abl_blank_par, ave_abl_blank_par],[se_abl_blank_par, se_abl_blank_par], [1 0 0 ]); hold on;
formatAxes
set(gca, 'YTick', [0 1],'XTick',  [-90:90:90, 125], 'XTickLabel', {-90:90:90, 'bsl'});
xlim([-100 135])
ylim([-0.2 1.2])
xlabel('\Delta pref orientation')
ylabel('Tuning locked')

subplot(4,4,16)
shadePlot(fit_pt_ori, ave_ori_orth,se_ori_orth, [0 0 0]); hold on;
shadePlot([120 130], [ave_blank_orth, ave_blank_orth],[se_blank_orth, se_blank_orth], [0 0 0]); hold on
shadePlot(fit_pt_ori, ave_ori_orth_abl_rel,se_ori_orth_abl_rel, [0 0.5 1]); hold on;
shadePlot([120 130], [ave_abl_blank_orth, ave_abl_blank_orth],[se_abl_blank_orth, se_abl_blank_orth], [0 0.5 1]); hold on;
formatAxes
% set(gca, 'YColor', 'none','YTick', [], 'XTick', [0:90:360], 'XTickLabel', {0:90:360});
set(gca, 'YTick', [0 1],'XTick',  [-90:90:90, 125], 'XTickLabel', {-90:90:90, 'bsl'});
xlim([-100 135])
ylim([-0.2 1.2])
xlabel('\Delta pref orientation')
ylabel(' Tuning locked')


print(fullfile(saveTo,'dendrotomy_stats') ,  '-dpng');
    print(fullfile(saveTo,'dendrotomy_stats') , '-dpdf', '-painters');

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
ave_par_abl_30 = median(abl_vm_30(:, type & is_cut),2);
ave_orth_abl_30 = median(abl_vm_30(:, ~type & is_cut),2);
ave_abl_30 = median(abl_vm_30(:, type & is_cut),2);

ave_par_abl_rel_30 = median(abl_rel_vm_30(:, type & is_cut),2);
ave_orth_abl_rel_30 = median(abl_rel_vm_30(:, ~type),2);
ave_abl_rel_30 = median(abl_rel_vm_30(:, is_cut),2);


ave_par_30 = median(vm_30(:, type & is_cut),2);
ave_orth_30 = median(vm_30(:, ~type & is_cut),2);

figure('Color', 'w', 'Position', [423 515 1002 320]);

subplot(1,3,1)
hold on;
par_lm = fitlm(ave_par_30, ave_par_abl_rel_30);
orth_lm = fitlm(ave_orth_30, ave_orth_abl_rel_30);

pred_p = -.1:0.01:1;
[par_pred,par_ci] = predict(par_lm, makeVec(pred_p));
[orth_pred,orth_ci] = predict(orth_lm, makeVec(pred_p));
% 
plot(vm_30(:, type & is_cut), abl_rel_vm_30(:, type & is_cut), '-', 'Color', [1 0 0 0.2], 'Linewidth', 0.5); hold on;
plot(vm_30(:, ~type & is_cut), abl_rel_vm_30(:, ~type & is_cut), '-', 'Color', [0 0.5 1 0.2], 'Linewidth', 0.5); hold on;

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
% [x, y, y_se, lm] = intervalReg(L_rel(type), slope(type), 0:0.1:1);
% shadePlot(x, y, y_se,[1 0 0]);  hold on
% [x, y, y_se, lm] = intervalReg(L_rel(~type), slope(~type), 0:0.1:1);
% shadePlot(x, y, y_se,[0 0.5 1]);

sigm = @(pars, x) pars(4)./(1+ pars(3).*exp(pars(1).*(x - pars(2))));
pars0 = [1 0 1 2];
parsup = [Inf 0 1 2];
parslow = [0 0 1 2];

par_lm = lsqcurvefit(sigm, pars0, L_rel(type), slope(type), parslow, parsup);
orth_lm = lsqcurvefit(sigm, pars0,L_rel(~type), slope(~type), parslow, parsup);

x_pred = 0:0.1:0.6;
plot(x_pred, sigm(par_lm, x_pred), 'r', 'LineWidth', 2); hold on
plot(x_pred, sigm(orth_lm, x_pred), 'Color', [0 0.5 1], 'LineWidth', 2); hold on

scatter(L_rel(type ), slope(type ), 40,[1 0, 0], 'MarkerFaceColor', [1 0 0],'MarkerEdgeAlpha', 0.2, 'MarkerFaceAlpha', 0.2); hold on;
scatter(L_rel(~type ),slope(~type ), 40, [0 0.5 1], 'MarkerFaceColor', [0 0.5 1], 'MarkerEdgeAlpha', 0.2, 'MarkerFaceAlpha', 0.2);


for iDb = 1:nDb
    if sum(parent_db==iDb)>1
        plot(L_rel(parent_db==iDb), slope(parent_db==iDb), '-', 'Color', [mean(color((parent_db==iDb),:)), 0.2], ...
            'LineWidth', 0.5); hold on
    end
end

% plot([0 2], [0 2], '--k')
xlim([-0.05 0.65]);
ylim([-0.4 1.2]);
xlabel('Fraction dendrites cut')
ylabel('Multiplicative scaling')
formatAxes
axis square

subplot(1, 3, 3)
[x, y, y_se, lm] = intervalReg(L_rel(type & is_cut), add(type & is_cut), 0:0.1:1);
shadePlot(x, y, y_se,[1 0 0]);  hold on
[x, y, y_se, lm] = intervalReg(L_rel(~type & is_cut), add(~type & is_cut), 0:0.1:1);
shadePlot(x, y, y_se,[0 0.5 1]);
plot(L_rel(type & is_cut), add(type & is_cut), 'o', 'Color', [1 0 0], 'MarkerSize', 7); hold on;
plot(L_rel(~type & is_cut),add(~type & is_cut), 'o', 'Color', [0 0.5 1],  'MarkerSize', 7);
% plot([0 2], [0 2], '--k')
xlim([-0.1 0.6]);
% ylim([-0.1 0.6]);
xlabel('Fraction dendrites cut')
ylabel('Additive scaling')
formatAxes
axis square



[~, ~, L_rel_g] = histcounts(L_rel, [0:0.1:0.6]);

[p, tbl] = anovan(slope, {type+1,  L_rel_g}, 'model', 'linear', 'varnames', {'po', 'L_cut'});


print(fullfile(saveTo,'Mult_or_Add') ,  '-dpng');
    print(fullfile(saveTo,'Mult_or_Add') , '-dpdf', '-painters');
%%

figure('Position', [418 293 983 550], 'Color', 'w');
plot(L_rel(type & is_cut), F0_cut(type & is_cut), 'o', 'Color', [1 0 0], 'MarkerSize', 7); hold on;
plot(L_rel(~type & is_cut), F0_cut(~type & is_cut), 'o', 'Color', [0 0.5 1],  'MarkerSize', 7);

for iDb = 1:nDb
    if sum(parent_db==iDb)>1
        plot(L_rel(parent_db==iDb), F0_cut(parent_db==iDb), '-', 'Color', [mean(color((parent_db==iDb),:)), 0.2], ...
            'LineWidth', 0.5); hold on
    end
end
xlabel('Fraction dendrites cut')
ylabel('F0')
formatAxes
[p, tbl] = anovan(F0_cut, {type+1,  L_rel_g}, 'model', 'linear', 'varnames', {'po', 'L_cut'});
title(sprintf('anova po = %02f, anova Lcut = %02f', p(1), p(2)))
axis square


%%
figure('Position', [418 293 983 550], 'Color', 'w');



subplot(1, 3, 1)
[x, y, y_se, lm] = intervalReg(L_rel(type & is_cut), log10(dOS(type & is_cut)), 0:0.1:1);
shadePlot(x, y, y_se,[1 0 0]);  hold on
[x, y, y_se, lm] = intervalReg(L_rel(~type & is_cut), log10(dOS(~type & is_cut)), 0:0.1:1);
shadePlot(x, y, y_se,[0 0.5 1]);
plot(L_rel(type & is_cut), log10(dOS(type & is_cut)), 'o', 'Color', [1 0 0], 'MarkerSize', 7); hold on;
plot(L_rel(~type & is_cut), log10(dOS(~type & is_cut)), 'o', 'Color', [0 0.5 1],  'MarkerSize', 7);
% plot([0 2], [0 2], '--k')
xlim([-0.1 0.6]);
% ylim([-0.1 0.6]);
xlabel('Fraction dendrites cut')
ylabel('log10 dOS')
formatAxes
axis square

subplot(1, 3, 2)
[x, y, y_se, lm] = intervalReg(L_rel(type & is_cut), dOri(type & is_cut), 0:0.1:1);
shadePlot(x, y, y_se,[1 0 0]);  hold on
[x, y, y_se, lm] = intervalReg(L_rel(~type & is_cut), dOri(~type & is_cut), 0:0.1:1);
shadePlot(x, y, y_se,[0 0.5 1]);
plot(L_rel(type & is_cut), dOri(type & is_cut), 'o', 'Color', [1 0 0], 'MarkerSize', 7); hold on;
plot(L_rel(~type & is_cut), dOri(~type & is_cut), 'o', 'Color', [0 0.5 1],  'MarkerSize', 7);
% plot([0 2], [0 2], '--k')
xlim([-0.1 0.6]);
% ylim([-0.1 0.6]);
xlabel('Fraction dendrites cut')
ylabel('dOri')
formatAxes
axis square

subplot(1, 3, 3)
[x, y, y_se, lm] = intervalReg(L_rel(type & is_cut), dDir(type & is_cut), 0:0.1:1);
shadePlot(x, y, y_se,[1 0 0]);  hold on
[x, y, y_se, lm] = intervalReg(L_rel(~type & is_cut), dDir(~type & is_cut), 0:0.1:1);
shadePlot(x, y, y_se,[0 0.5 1]);
plot(L_rel(type & is_cut), dDir(type & is_cut), 'o', 'Color', [1 0 0], 'MarkerSize', 7); hold on;
plot(L_rel(~type & is_cut), dDir(~type & is_cut), 'o', 'Color', [0 0.5 1],  'MarkerSize', 7);
% plot([0 2], [0 2], '--k')
xlim([-0.1 0.6]);
% ylim([-0.1 0.6]);
xlabel('Fraction dendrites cut')
ylabel('dDir')
formatAxes
axis square

print(fullfile(saveTo,'Mult_or_Add_stats') ,  '-dpng');
    print(fullfile(saveTo,'Mult_or_Add_stats') , '-dpdf', '-painters');

end