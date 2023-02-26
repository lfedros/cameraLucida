function plot_clusta(neuron)

nDb = numel(neuron);

para_clust = [];
ortho_clust = [];
all_clust = [];

for iDb = 1:nDb

     para_clust(:,iDb) = neuron(iDb).combo_px_map.para_clust;
     ortho_clust(:,iDb) = neuron(iDb).combo_px_map.ortho_clust;
     all_clust(:,iDb) = neuron(iDb).combo_px_map.all_clust;
     para_num(iDb) = neuron(iDb).combo_px_map.para_num;
     ortho_num(iDb) = neuron(iDb).combo_px_map.ortho_num;
     num_ratio(iDb) = para_num(iDb)/ortho_num(iDb);
%      if num_ratio(iDb) <0.1 
%          para_clust(:,iDb) = nan(size(para_clust(:,iDb)));
%      elseif num_ratio(iDb) > 10 
%                   ortho_clust(:,iDb) = nan(size(ortho_clust(:,iDb)));
% 
%      end
     para_clust_norm(:,iDb) = para_clust(:,iDb) ./all_clust(:,iDb) ;
     ortho_clust_norm(:,iDb) = ortho_clust(:,iDb) ./all_clust(:,iDb) ;

end
clust_bins = neuron(iDb).combo_px_map.clust_bins;

bin_groups = repmat(clust_bins', 1, nDb*2);
ori_group = repmat([repmat({'p'}, 1,nDb), repmat({'o'}, 1,nDb)], numel(clust_bins),1);
group{1} = bin_groups(:);
group{2} = ori_group(:);
data = makeVec([para_clust, ortho_clust]);
pc = anovan(data, group ,'varnames', {'um', 'P vs O'});

ave_para_dist = nanmedian(para_clust,2);
ave_ortho_dist = nanmedian(ortho_clust,2);
ave_all_dist = nanmedian(all_clust,2);

ave_para_clust = nanmean(para_clust,1);
ave_ortho_clust = nanmean(ortho_clust,1);
ave_all_clust = nanmean(all_clust,1);

mad_para_clust = mad(para_clust,0,2);
mad_ortho_clust = mad(ortho_clust,0,2);
mad_all_clust = mad(all_clust,0,2);

ave_para_clust_norm = nanmedian(para_clust_norm,2);
ave_ortho_clust_norm = nanmedian(ortho_clust_norm,2);

ratio_clust = para_clust./ortho_clust;
ave_ratio_clust = nanmedian(ratio_clust,2);

%%
figure;

subplot(1,4,1)
plot(clust_bins, all_clust, 'Color', [0 0 0], 'LineWidth', 0.5);hold on
plot(clust_bins, ave_all_dist, 'Color', [0 0 0], 'LineWidth', 2)
ylim([0 0.6])
xlabel('px distance (um)')
ylabel('pref ori similarity')
formatAxes;

subplot(1,4,2)
plot(clust_bins, para_clust, 'Color', [1 0 0 ], 'LineWidth', 0.5); hold on
plot(clust_bins, ave_para_dist, 'Color', [1 0 0 ], 'LineWidth', 2); 
ylim([0 0.6])
xlabel('px distance (um)')
formatAxes;

subplot(1,4,3)
plot(clust_bins, ortho_clust, 'Color', [0 0.5 1], 'LineWidth', 0.5);hold on
plot(clust_bins, ave_ortho_dist, 'Color', [0 0.5 1], 'LineWidth', 2);
ylim([0 0.6])
xlabel('px distance (um)')
formatAxes;

subplot(1,4,4)
plot(clust_bins, ratio_clust, 'Color', [0 0 0], 'LineWidth', 0.5); hold on
plot(clust_bins, ave_ratio_clust, 'Color', [0 0 0], 'LineWidth', 2); 
ylim([0 2])
xlabel('px distance (um)')
ylabel('para/ortho')
formatAxes;

%%
figure; 

subplot(2,2,[1 3])
plot(clust_bins, ave_all_dist, 'Color', [0 0 0], 'LineWidth', 2);hold on
plot(clust_bins, ave_para_dist, 'Color', [1 0 0 ], 'LineWidth', 2); 
plot(clust_bins, ave_ortho_dist, 'Color', [0 0.5 1], 'LineWidth', 2);
% shadePlot(clust_bins, ave_all_clust, mad_all_clust, [0 0 0]);hold on
% shadePlot(clust_bins, ave_para_clust, mad_para_clust,[1 0 0 ]); 
% shadePlot(clust_bins, ave_ortho_clust, mad_ortho_clust, [0 0.5 1]);
ylim([0.25 0.45])
xlabel('px distance (um)')
ylabel('pref ori similarity')
formatAxes;

subplot(2,2,2)
plot([0.2 0.4], [0.2 0.4], '--', 'Color', [.7 .7 .7]); hold on
plot(ave_para_dist(:), ave_ortho_dist(:), 'o', 'Color', [0 0 0], 'MarkerFaceColor', [1 1 1], 'MarkerSize', 8); hold on
ylim([0.25 0.4])
xlim([0.25 0.4])
axis square
xlabel('para s_ori vs dist')
ylabel('ortho s_ori vs dist')
formatAxes;

subplot(2,2,4)
plot([0.2 0.4], [0.2 0.4], '--', 'Color', [.7 .7 .7]); hold on
plot(para_clust(5, :), ortho_clust(5, :), 'o', 'Color', [0 0 0], 'MarkerFaceColor', [1 1 1], 'MarkerSize', 8); hold on
ylim([0.1 0.5])
xlim([0.1 0.5])
xlabel('para ori sim')
ylabel('ortho ori sim')
axis square
formatAxes;

%%

figure;

subplot(1,3,2)
plot(clust_bins, ortho_clust_norm, 'Color', [0 0.5 1], 'LineWidth', 0.5);hold on
plot(clust_bins, ave_ortho_clust_norm, 'Color', [0 0.5 1], 'LineWidth', 2);
ylim([0.5 1.5])
formatAxes;
subplot(1,3, 1)
plot(clust_bins, para_clust_norm, 'Color', [1 0 0], 'LineWidth', 0.5);hold on
plot(clust_bins, ave_para_clust_norm, 'Color', [1 0 0], 'LineWidth', 2)
ylim([0.5 1.5])
formatAxes;
subplot(1,3,3)
plot(clust_bins, ave_para_clust_norm, 'Color', [1 0 0 ], 'LineWidth', 2); hold on
plot(clust_bins, ave_ortho_clust_norm, 'Color', [0 0.5 1], 'LineWidth', 2);
ylim([0.5 1.5])
formatAxes;
%%

para_clust = [];
ortho_clust = [];
all_clust = [];

for iDb = 1:nDb

     para_clust = cat(2, para_clust, neuron(iDb).combo_px_map.oned_para_clust);
     ortho_clust = cat(2, ortho_clust,neuron(iDb).combo_px_map.oned_ortho_clust);
     all_clust = cat(2, all_clust,neuron(iDb).combo_px_map.oned_all_clust);

end
clust_bins = neuron(iDb).combo_px_map.clust_bins;

ave_para_dist = nanmedian(para_clust,2);
ave_ortho_dist = nanmedian(ortho_clust,2);
ave_all_dist = nanmedian(all_clust,2);
ratio_clust = para_clust./ortho_clust;
ave_ratio_clust = nanmedian(ratio_clust,2);

figure;
subplot(1,5,2)
plot(clust_bins, para_clust, 'Color', [1 0 0 ], 'LineWidth', 0.5); hold on
plot(clust_bins, ave_para_dist, 'Color', [1 0 0 ], 'LineWidth', 2); 
ylim([0 0.6])
formatAxes
subplot(1,5,3)
plot(clust_bins, ortho_clust, 'Color', [0 0.5 1], 'LineWidth', 0.5);hold on
plot(clust_bins, ave_ortho_dist, 'Color', [0 0.5 1], 'LineWidth', 2);
ylim([0 0.6])
formatAxes
subplot(1,5,1)
plot(clust_bins, all_clust, 'Color', [0 0 0], 'LineWidth', 0.5);hold on
plot(clust_bins, ave_all_dist, 'Color', [0 0 0], 'LineWidth', 2)
ylim([0 0.6])
formatAxes;
subplot(1,5,4)
plot(clust_bins, ave_all_dist, 'Color', [0 0 0], 'LineWidth', 2);hold on
plot(clust_bins, ave_para_dist, 'Color', [1 0 0 ], 'LineWidth', 2); 
plot(clust_bins, ave_ortho_dist, 'Color', [0 0.5 1], 'LineWidth', 2);
ylim([0.25 0.45])
formatAxes;
subplot(1,5,5)
plot(clust_bins, ratio_clust, 'Color', [0 0 0], 'LineWidth', 0.5); hold on
plot(clust_bins, ave_ratio_clust, 'Color', [0 0 0], 'LineWidth', 2); 
ylim([0 2])
formatAxes;


end