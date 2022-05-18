function [spines, vis_spines] = pool_spines(neuron, doPlot)

if nargin < 2
    doPlot = 0;
end


%% load spines data and reformat


spines.x_um = double(cat(2, neuron.dendrite(:).X));
spines.y_um = double(cat(2, neuron.dendrite(:).Y));
spines.tune_pars = cat(1,neuron.dendrite(:).Fitpars);
% spines.anova_p  = double(cat(1, neuron.dendrite(:).anovaStat));
% spines.anova_t = spines.anova_p<0.05;
nSpines = numel(spines.x_um);
spines.exp_ref = [];
spines.anova_t =[];
for iD = 1:numel(neuron.dendrite)
        anova_t =zeros(numel(neuron.dendrite(iD).xpixs),1);
        anova_t(neuron.dendrite(iD).SigInd) = 1;
    spines.anova_t = cat(1, spines.anova_t, anova_t);

    for iS = 1: numel(neuron.dendrite(iD).X)
        spines.exp_ref = cat(1, spines.exp_ref, neuron.db.spine_seq{iD}(1:end-13));
    
%     spines.anova_t = cat(1, spines.anova_t, ismember(iS, neuron.dendrite(iD).SigInd));
   
    end
end
spines.anova_t = logical(spines.anova_t);

spines.stitch_den = stitch_dendrite(neuron.dendrite);

%%

vis_spines.x_um = spines.x_um(spines.anova_t);
vis_spines.y_um = spines.y_um(spines.anova_t);
vis_spines.tune_pars = spines.tune_pars(spines.anova_t,:);
vis_spines.exp_ref = spines.exp_ref(spines.anova_t,:);

nSpines = sum(spines.anova_t);

vis_spines.tuning = [];
vis_spines.tun_dirs = 0:359;

for iS = 1:nSpines

   this_tun = mfun.vonMises2(vis_spines.tune_pars(iS,:), vis_spines.tun_dirs);

%     pk(iS) = max(this_tun);
% 
% 
%     if pk(iS)>0
%         this_tun = this_tun/pk(iS);
%     else
%         this_tun= (this_tun+abs(min(this_tun)))...
%             /max(this_tun+abs(min(this_tun))) ;
%     end

    vis_spines.tuning(:, iS) = (this_tun-min(this_tun))/(max(this_tun)-min(this_tun));
end

vis_spines.soma_tuning = nanmean(vis_spines.tuning, 2);
vis_spines.soma_pars = mfun.fitTuning(vis_spines.tun_dirs,vis_spines.soma_tuning, 'vm2');

vis_spines.pref_dir = vis_spines.tune_pars(:,1); %[0 360]
[~, vis_spines.sort_idx] = sort(vis_spines.pref_dir, 'ascend');
vis_spines.ori = vis_spines.pref_dir-90; %[-90, 270]
vis_spines.ori(vis_spines.ori>180) = vis_spines.ori(vis_spines.ori>180)-180; %[-90 90]
vis_spines.ori(vis_spines.ori<0) = vis_spines.ori(vis_spines.ori<0)+180; %[0 180]

vis_spines.soma_ori = rad2deg(circ_mean(vis_spines.ori*2*pi/180))/2;

vis_spines.d_ori = vis_spines.ori - vis_spines.soma_ori;
vis_spines.d_ori(vis_spines.d_ori>90) = vis_spines.d_ori(vis_spines.d_ori>90)-180;
vis_spines.d_ori(vis_spines.d_ori<-90) = vis_spines.d_ori(vis_spines.d_ori<-90)+180;
vis_spines.d_ori = abs(vis_spines.d_ori);
vis_spines.stitch_den = spines.stitch_den;
%% to add

% fit tuning of the soma
% compute and plot tuning relative to the soma
% plot spatial distribution of significant spines in color

%%

if doPlot

    figure; 
    subplot(2,2,1)
    plot(vis_spines.tun_dirs, vis_spines.tuning, 'Color', [0.5, 0.5, 0.5]);hold on
    plot(vis_spines.tun_dirs,vis_spines.soma_tuning, 'k', 'Linewidth', 2)
    formatAxes
    xlabel('D stimulus direction')
    ylabel('Tuning')
    xlim([-10 370])
    ylim([-0.3 1.1])
    title('iGluSnFR3 spines and soma')
    subplot(2,2,3)

    to_plot = vis_spines.tuning(:, vis_spines.sort_idx);
    imagesc(to_plot');caxis([0 1]);

    subplot(2,2,2)
    histogram(vis_spines.d_ori, [0:30:90]);
%     figure;
%     subplot(1,2,1)
%     tun_color = hsv(180);
%     scatter(spines.x_um, spines.y_um, tun_color(ceil(spines.ori), :)); hold on
%     scatter(0 , 0, tun_color(round(spines.soma_ori), :))
%     subplot(1,2,2)
%     histogram(spines.ori, [0:30:180]);


end


end