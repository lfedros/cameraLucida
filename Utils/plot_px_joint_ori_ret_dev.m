function combo_px_map = plot_px_joint_ori_ret_dev(combo_px_map, norm_flag, angle_um)

if nargin<2
    norm_flag = 1;
end

if nargin<3
    angle_um = 0;
end

% mean image
img = combo_px_map.mimg;
x_um = combo_px_map.x_um;
y_um = combo_px_map.y_um;
% pixel signal
sig_x_um = combo_px_map.sig_x_um;
sig_y_um = combo_px_map.sig_y_um;
% isoOri line coordinates
isoOri = combo_px_map.isoOri;

%% for orientation
if angle_um
angle_axial = combo_px_map.angle_axial_um_rel; %[- pi/2 pi/2]
else
angle_axial = combo_px_map.angle_axial_rel; %[- pi/2 pi/2]
end

if ~isempty(combo_px_map.soma_pref_ori)
    soma_ori = combo_px_map.soma_pref_ori;
%             soma_ori = combo_px_map.pref_ori_norm;

else
    if norm_flag
        soma_ori = combo_px_map.pref_ori_norm;
    else
        soma_ori = combo_px_map.pref_ori;
    end
end

if norm_flag
    ori = angle(combo_px_map.sig_ori_norm)*180/(2*pi); %[-90 90]
    amp = abs(combo_px_map.sig_ori_norm);

%     dir_ori = angle(combo_px_map.sig_dir_norm)*180/(pi); %[-90 90]
%     ori_ori = unwrap_angle(dir_ori - pi/2)/2;

else
    ori = angle(combo_px_map.sig_ori)*180/(2*pi); %[-90 90]
    amp = abs(combo_px_map.sig_ori);
end

ori(ori<0) = ori(ori<0) +180; %[0 180]

d_ori = ori - soma_ori ; %[-180 180]
d_ori(d_ori>90) = d_ori(d_ori>90)-180;
d_ori(d_ori<-90) = d_ori(d_ori<-90)+180; %[-90 90]
d_ori = abs(d_ori); %[0 90]

nan_idx_ori= isnan(d_ori);
angle_axial(nan_idx_ori) = [];
d_ori(nan_idx_ori) = [];
sig_x_um(nan_idx_ori) = [];
sig_y_um(nan_idx_ori) = [];
amp(nan_idx_ori) = [];


%%
rel_angle = unwrap_angle(angle_axial);
rel_angle = abs(rel_angle);
parallel_idx= rel_angle <= pi/4;
ortho_idx = rel_angle >pi/4;

%%

bins = 0:30:90;
[parallel_count, ~, parallel_ori_bin]= histcounts(d_ori(parallel_idx), bins);

amp_para = amp(parallel_idx);
for iB = 1:numel(bins)-1
    parallel_count(iB) = sum(amp_para(parallel_ori_bin == iB));
    parallel_amp(iB) = mean(amp_para(parallel_ori_bin == iB));

end

amp_ortho = amp(ortho_idx);
[ortho_count, ~,  ortho_ori_bin]  = histcounts(d_ori(ortho_idx), bins);

for iB = 1:numel(bins)-1
    ortho_count(iB) = sum(amp_ortho(ortho_ori_bin == iB));
        ortho_amp(iB) = mean(amp_ortho(ortho_ori_bin == iB));

end

[all_count, ~,  all_ori_bin]  = histcounts(d_ori, bins);

for iB = 1:numel(bins)-1
    all_count(iB) = sum(amp(all_ori_bin == iB));
    all_amp(iB) = mean(amp(all_ori_bin == iB));
end

parallel_dist= parallel_count/sum(parallel_count);
ortho_dist = ortho_count/sum(ortho_count);
po_ratio = parallel_dist - ortho_dist;
ret_ori_bins = bins(2:end)-unique(diff(bins))/2;

all_dist = all_count/sum(all_count);

combo_px_map.all_ori = angle(sum(amp.*exp(1i*ori*2*pi/180)))*180/(2*pi);
combo_px_map.para_ori = angle(sum(amp(parallel_idx).*exp(1i*ori(parallel_idx)*2*pi/180)))*180/(2*pi);
combo_px_map.ortho_ori = angle(sum(amp(ortho_idx).*exp(1i*ori(ortho_idx)*2*pi/180)))*180/(2*pi);

%% Clustering analysis

% dd_all = squareform(single(pdist([sig_x_um(:), sig_y_um(:)], 'euclidean')));
% do_all = squareform(pdist(ori, 'euclidean'));
% do_all(do_all >=90) = do_all(do_all >=90) -180;
% 
% dd_ortho = dd_all(ortho_idx, ortho_idx);
% do_ortho = do_all(ortho_idx, ortho_idx);
% 
% dd_para= dd_all(parallel_idx, parallel_idx);
% do_para =do_all(parallel_idx, parallel_idx);
% 
% bins = 0:1:50;
% [~, ~, para_dist_bin]= histcounts(dd_para(:), bins);
% [~, ~, ortho_dist_bin]= histcounts(dd_ortho(:), bins);
% 
% for iB = 1:numel(bins)-1
%     para_dist_count(iB) = circ_r(do_para(para_dist_bin == iB)*pi/180);
%     ortho_dist_count(iB) = circ_r(do_ortho(ortho_dist_bin == iB)*pi/180);
% iB
% end
% 
% figure;
% plot(bins(1:end-1), para_dist_count, 'r');
% hold on
% plot(bins(1:end-1), ortho_dist_count, 'b');
% formatAxes
% axis square



%% To shuffle: rotate the retinotopic map of angles

% %% shuffle
% nSh = 1000;
% for iSh = 1:nSh
%
%     shuffle_idx = randperm(numel(rel_angle));
%     shuf_angle = rel_angle(shuffle_idx);
%
%     shuf_parallel_idx= shuf_angle <= pi/4;
%     shuf_ortho_idx = shuf_angle >pi/4;
%
%     shuf_parallel_count= histcounts(d_ori(shuf_parallel_idx), bins);
%     shuf_ortho_count= histcounts(d_ori(shuf_ortho_idx), bins);
%
%     shuf_parallel_dist(:,iSh)= shuf_parallel_count/sum(shuf_parallel_count);
%     shuf_ortho_dist(:,iSh) = shuf_ortho_count/sum(shuf_ortho_count);
% end
%
% shuf_ratio = shuf_parallel_dist - shuf_ortho_dist;
%
% shuf_parallel_top = prctile(shuf_parallel_dist, 97.5, 2);
% shuf_parallel_bot = prctile(shuf_parallel_dist, 2.5, 2);
%
% shuf_orth_top = prctile(shuf_parallel_dist, 97.5, 2);
% shuf_orth_bot = prctile(shuf_parallel_dist, 2.5, 2);
%
% shuf_ratio_top = prctile(shuf_ratio, 97.5, 2);
% shuf_ratio_bot = prctile(shuf_ratio, 2.5, 2);

%%
combo_px_map.parallel_ori_bin = parallel_ori_bin;
combo_px_map.parallel_count = parallel_count;
combo_px_map.parallel_amp = parallel_amp;
combo_px_map.ortho_count = ortho_count;
combo_px_map.ortho_amp = ortho_amp;
combo_px_map.ortho_ori_bin = ortho_ori_bin;
combo_px_map.all_count = all_count;
combo_px_map.all_amp = all_amp;

combo_px_map.all_ori_bin = all_ori_bin;

combo_px_map.parallel_dist= parallel_dist;
combo_px_map.ortho_dist = ortho_dist;
combo_px_map.po_ratio = po_ratio;
combo_px_map.ret_ori_bins =ret_ori_bins;
combo_px_map.all_dist = all_dist;
%%

color = [1, 0, 0;
    0  0.5  1]; % colors for ori_bin

figure('Color', 'w', 'Position', [418 456 822 522]);

subplot(4,5,[1 2 3 4  6 7 8 9  11 12 13 14]);
imagesc(x_um, y_um, img);
axis image; hold on;colormap(1-gray);
plot(isoOri(:,1), isoOri(:,2), '--g');
this_amp = ceil((amp/max(amp))/0.2).^2;
this_amp(this_amp ==0) = NaN;
scatter(sig_x_um, sig_y_um, this_amp, color(ortho_idx+1,:), 'filled');
formatAxes
%%
color = [1, 0, 0;
    0.6, 0, 1;
    0  0.5  1]; % colors for ori_bin

figure('Color', 'w', 'Position', [418 456 822 522]);

subplot(4,5,[1 2 3 4  6 7 8 9  11 12 13 14]);
imagesc(x_um, y_um, img);
axis image; hold on;colormap(1-gray);
plot(isoOri(:,1), isoOri(:,2), '--g');
this_amp = ceil((amp_para/max(amp))/0.2).^2;
this_amp(this_amp ==0) = NaN;
scatter(sig_x_um(parallel_idx), sig_y_um(parallel_idx), this_amp, color(parallel_ori_bin,:), 'filled');
this_amp = ceil((amp_ortho/max(amp))/0.2).^2;
this_amp(this_amp ==0) = NaN;
scatter(sig_x_um(ortho_idx), sig_y_um(ortho_idx), this_amp, color(ortho_ori_bin,:), 'filled');
formatAxes


subplot(4, 5, 5);
% patch([ret_ori_bins, flip(ret_ori_bins, 2)], [shuf_orth_top', flip(shuf_orth_bot,1)'],[0.8 0.8 0.8], 'EdgeColor','none');
% plot(spines.ret_ori_bins, spines.ortho_dist, 'Color', [0 0.5 1]);
hold on; axis square; xlim([0 90]); ylim([0 0.8])
plot(ret_ori_bins, parallel_dist, 'Color', [1 0 0]);
% legend('Sh', sprintf('n=%d', sum(spines.parallel_count)))
title(sprintf('n=%d', sum(parallel_count)))
set(gca, 'Xtick', [15 45 75], 'XTickLabel', {'0-30', '30-60', '60-90'})
% xlabel('Delta ori (deg)')
ylabel('% para spines')
formatAxes


subplot(4,5,10);

hold on; axis square; xlim([0 90]); ylim([0 0.8])
% plot(spines.ret_ori_bins, spines.parallel_dist, 'Color', [1 0 0]);
% patch([ret_ori_bins, flip(ret_ori_bins, 2)], [shuf_orth_top', flip(shuf_orth_bot,1)'], [0.8 0.8 0.8], 'EdgeColor','none');
plot(ret_ori_bins, ortho_dist, 'Color', [0 0.5 1]);
% legend('Sh', sprintf('n=%d', sum(spines.ortho_count)))
title(sprintf('n=%d', sum(ortho_count)))
set(gca, 'Xtick', [15 45 75], 'XTickLabel', {'0-30', '30-60', '60-90'})
% xlabel('Delta ori (deg)')
ylabel('% ortho spines')
formatAxes

subplot(4,5,15);

hold on; axis square; xlim([0 90]); ylim([-0.5 0.5])
% patch([ret_ori_bins, flip(ret_ori_bins, 2)], [shuf_ratio_top', flip(shuf_ratio_bot,1)'], [0.8 0.8 0.8], 'EdgeColor','none');
plot(ret_ori_bins, po_ratio, 'Color', [0 0 0]);
% legend('Sh', 'D%')
set(gca, 'Xtick', [15 45 75], 'XTickLabel', {'0-30', '30-60', '60-90'})
xlabel('Delta ori (deg)')
ylabel('% para - % ortho')
formatAxes

subplot(4,5,20);

hold on; axis square; xlim([0 90]); ylim([0 0.8])
% patch([ret_ori_bins, flip(ret_ori_bins, 2)], [shuf_ratio_top', flip(shuf_ratio_bot,1)'], [0.8 0.8 0.8], 'EdgeColor','none');
plot(ret_ori_bins, all_dist, 'Color', [0 0 0]);
% legend('Sh', 'D%')
set(gca, 'Xtick', [15 45 75], 'XTickLabel', {'0-30', '30-60', '60-90'})
xlabel('Delta ori (deg)')
ylabel('% all')
formatAxes



% subplot(3,6,[ 4 10 16] );
%
% to_plot = tuning_rel(:, sort_idx_rel(parallel_idx));
% imagesc(to_plot');caxis([-0 1]); colormap(1-gray);
% set(gca, 'Xtick', [0 180 360])
% formatAxes
% title('Parallel')
%
% subplot(3,6,[ 5 11 17] );
% to_plot = tuning_rel(:, sort_idx_rel(ortho_idx));
% imagesc(to_plot');caxis([-0 1]); colormap(1-gray);
% set(gca, 'Xtick', [0 180 360])
% formatAxes
% title('Ortho')

end