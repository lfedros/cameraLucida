function combo_px_map = plot_px_joint_ori_ret(combo_px_map)


img = combo_px_map.mimg;
x_um = combo_px_map.x_um;
y_um = combo_px_map.y_um;
sig_x_um_dir = combo_px_map.sig_x_um;
sig_y_um_dir = combo_px_map.sig_y_um;
sig_x_um_ori = combo_px_map.sig_x_um;
sig_y_um_ori = combo_px_map.sig_y_um;
isoOri = combo_px_map.isoOri;

%% for direction
% angle_axial_dir = combo_px_map.angle_axial;
% soma_ori = combo_px_map.soma_ori;
% 
% ori_dir = angle(combo_px_map.sig_dir)*180/pi;
% amp_dir = abs(combo_px_map.sig_dir);
% ori_dir(ori_dir <0) = ori_dir(ori_dir <0) +360; %[0 360]
% ori_dir = ori_dir -90;
% 
% ori_dir(ori_dir>=180) = ori_dir(ori_dir>=180) -180;
% ori_dir(ori_dir<0) = ori_dir(ori_dir<0) +180;
% 
% d_ori_dir = ori_dir - soma_ori ;
% d_ori_dir(d_ori_dir>90) = d_ori_dir(d_ori_dir>90)-180;
% d_ori_dir(d_ori_dir<-90) = d_ori_dir(d_ori_dir<-90)+180;
% d_ori_dir = abs(d_ori_dir);
% 
% nan_idx_dir= isnan(d_ori_dir); 
% angle_axial_dir(nan_idx_dir) = [];
% d_ori_dir(nan_idx_dir) = [];
% sig_x_um_dir(nan_idx_dir) = [];
% sig_y_um_dir(nan_idx_dir) = [];
% amp_dir(nan_idx_dir) = [];

%% for orientation
angle_axial_ori = combo_px_map.angle_axial;
soma_ori = combo_px_map.soma_ori;

ori_ori = angle(combo_px_map.sig_ori)*180/(2*pi); %[-90 90]
amp_ori = abs(combo_px_map.sig_ori);

ori_ori(ori_ori<0) = ori_ori(ori_ori<0) +180; %[0 180]

d_ori_ori = ori_ori - soma_ori ;
d_ori_ori(d_ori_ori>90) = d_ori_ori(d_ori_ori>90)-180;
d_ori_ori(d_ori_ori<-90) = d_ori_ori(d_ori_ori<-90)+180;
d_ori_ori = abs(d_ori_ori);

nan_idx_ori= isnan(d_ori_ori); 
angle_axial_ori(nan_idx_ori) = [];
d_ori_ori(nan_idx_ori) = [];
sig_x_um_ori(nan_idx_ori) = [];
sig_y_um_ori(nan_idx_ori) = [];
amp_ori(nan_idx_ori) = [];

%%

% [~, ori_vs_dir] = max([amp_ori, amp_dir], [],2);
% idx = sub2ind(size([amp_ori, amp_dir]), 1:numel(ori_vs_dir), ori_vs_dir');
% 
% angle_axial =  [angle_axial_ori, angle_axial_dir];
% angle_axial = angle_axial(idx);
% 
% d_ori = [d_ori_ori, d_ori_dir];
% d_ori = d_ori(idx);
% 
% sig_x_um= [sig_x_um_ori, sig_x_um_dir];
% sig_x_um = sig_x_um(idx);
% 
% sig_y_um= [sig_y_um_ori, sig_y_um_dir];
% sig_y_um = sig_y_um(idx);
% 
% amp = [amp_ori, amp_dir];
% amp = amp(idx);

%%

% angle_axial= angle_axial_dir;
% d_ori= d_ori_dir;
% sig_x_um= sig_x_um_dir;
% sig_y_um= sig_y_um_dir;
% amp= amp_dir;

angle_axial= angle_axial_ori;
d_ori= d_ori_ori;
sig_x_um= sig_x_um_ori;
sig_y_um= sig_y_um_ori;
amp= amp_ori;

%%
% parallel_ori = d_ori <= 45;
% ortho_ori = d_ori > 45;

rel_angle = abs(unwrap_angle(angle_axial - deg2rad(soma_ori),1));
parallel_idx= rel_angle <= pi/4;
ortho_idx = rel_angle >pi/4;
%%
% 
% figure('Color', 'w', 'Position', [418 456 822 522]);
% 
% subplot(3,6,[1 2 3 7 8 9 13 14 15]);
% imagesc(x_um, y_um, img);
% axis image; hold on;colormap(1-gray);
% plot(isoOri(:,1), isoOri(:,2), '--g');
% scatter(sig_x_um(ortho_idx), sig_y_um(ortho_idx), double(ortho_idx(ortho_idx)), [1 0 0]);

%%



bins = [0:30:90];
[parallel_count, ~, parallel_ori_bin]= histcounts(d_ori(parallel_idx), bins);

amp_para = amp(parallel_idx);
for iB = 1:numel(bins)-1
parallel_count(iB) = sum(amp_para(parallel_ori_bin == iB));
end

amp_ortho = amp(ortho_idx);
[ortho_count, ~,  ortho_ori_bin]  = histcounts(d_ori(ortho_idx), bins);

for iB = 1:numel(bins)-1
ortho_count(iB) = sum(amp_ortho(ortho_ori_bin == iB));
end

[all_count, ~,  all_ori_bin]  = histcounts(d_ori, bins);

for iB = 1:numel(bins)-1
all_count(iB) = sum(amp(all_ori_bin == iB));
end

%%

parallel_dist= parallel_count/sum(parallel_count);
ortho_dist = ortho_count/sum(ortho_count);
po_ratio = parallel_dist - ortho_dist;
ret_ori_bins = bins(2:end)-unique(diff(bins))/2;

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
combo_px_map.ortho_count = ortho_count;
combo_px_map.ortho_ori_bin = ortho_ori_bin;
combo_px_map.all_count = all_count;
combo_px_map.all_ori_bin = all_ori_bin;

combo_px_map.parallel_dist= parallel_dist;
combo_px_map.ortho_dist = ortho_dist;
combo_px_map.po_ratio = po_ratio;
combo_px_map.ret_ori_bins =ret_ori_bins;
%%
color = [1, 0, 0;
    0.6, 0, 1;
    0  0.5  1]; % colors for ori_bin

figure('Color', 'w', 'Position', [418 456 822 522]);

subplot(3,6,[1 2 3 7 8 9 13 14 15]);
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


subplot(3,6,6);
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


subplot(3,6,12);

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

subplot(3,6,18);

hold on; axis square; xlim([0 90]); ylim([-0.5 0.5])
% patch([ret_ori_bins, flip(ret_ori_bins, 2)], [shuf_ratio_top', flip(shuf_ratio_bot,1)'], [0.8 0.8 0.8], 'EdgeColor','none');
plot(ret_ori_bins, po_ratio, 'Color', [0 0 0]);
% legend('Sh', 'D%')
set(gca, 'Xtick', [15 45 75], 'XTickLabel', {'0-30', '30-60', '60-90'})
xlabel('Delta ori (deg)')
ylabel('% para - % ortho')
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