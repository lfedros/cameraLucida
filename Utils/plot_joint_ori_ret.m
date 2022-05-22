function spines = plot_joint_ori_ret(spines)


% parallel_ori = spines.d_ori <= 45;
% ortho_ori = spines.d_ori > 45;

spines.rel_angle = abs(unwrap_angle(spines.angle_axial - deg2rad(spines.soma_ori),1));

spines.parallel_idx= spines.rel_angle <= pi/4;
spines.ortho_idx = spines.rel_angle >pi/4;


bins = [0:30:90];
[spines.parallel_count, ~, spines.parallel_ori_bin]= histcounts(spines.d_ori(spines.parallel_idx), bins);
[spines.ortho_count, ~,  spines.ortho_ori_bin]  = histcounts(spines.d_ori(spines.ortho_idx), bins);
[spines.all_count, ~,  spines.all_ori_bin]  = histcounts(spines.d_ori, bins);

spines.parallel_dist= spines.parallel_count/sum(spines.parallel_count);
spines.ortho_dist = spines.ortho_count/sum(spines.ortho_count);
spines.po_ratio = spines.parallel_dist - spines.ortho_dist;
spines.ret_ori_bins = bins(2:end)-unique(diff(bins))/2;

%% shuffle
nSh = 1000;
for iSh = 1:nSh

shuffle_idx = randperm(numel(spines.rel_angle));
shuf_angle = spines.rel_angle(shuffle_idx);

shuf_parallel_idx= shuf_angle <= pi/4;
shuf_ortho_idx = shuf_angle >pi/4;

shuf_parallel_count= histcounts(spines.d_ori(shuf_parallel_idx), bins);
shuf_ortho_count= histcounts(spines.d_ori(shuf_ortho_idx), bins);

shuf_parallel_dist(:,iSh)= shuf_parallel_count/sum(shuf_parallel_count);
shuf_ortho_dist(:,iSh) = shuf_ortho_count/sum(shuf_ortho_count);
end

shuf_ratio = shuf_parallel_dist - shuf_ortho_dist;

shuf_parallel_top = prctile(shuf_parallel_dist, 97.5, 2);
shuf_parallel_bot = prctile(shuf_parallel_dist, 2.5, 2);

shuf_orth_top = prctile(shuf_parallel_dist, 97.5, 2);
shuf_orth_bot = prctile(shuf_parallel_dist, 2.5, 2);

shuf_ratio_top = prctile(shuf_ratio, 97.5, 2);
shuf_ratio_bot = prctile(shuf_ratio, 2.5, 2);

%%

color = [1, 0, 0; 
         0.6, 0, 1;
         0  0.5  1]; % colors for ori_bin

figure('Color', 'w', 'Position', [418 456 822 522]);
subplot(3,4,[1 2 3 5 6 7 9 10 11]); 
imagesc(spines.stitch_den.x_um, spines.stitch_den.y_um, spines.stitch_den.img);
axis image; hold on;colormap(1-gray);
plot(spines.isoOri(:,1), spines.isoOri(:,2), '--g');
scatter(spines.x_um(spines.parallel_idx), spines.y_um(spines.parallel_idx), 20,color(spines.parallel_ori_bin,:), 'filled');
scatter(spines.x_um(spines.ortho_idx), spines.y_um(spines.ortho_idx), 20, color(spines.ortho_ori_bin,:), 'filled');
formatAxes


subplot(3,4,4); 
patch([spines.ret_ori_bins, flip(spines.ret_ori_bins, 2)], [shuf_orth_top', flip(shuf_orth_bot,1)'],[0.8 0.8 0.8], 'EdgeColor','none');
% plot(spines.ret_ori_bins, spines.ortho_dist, 'Color', [0 0.5 1]);
hold on; axis square; xlim([0 90]); ylim([0 0.8])
plot(spines.ret_ori_bins, spines.parallel_dist, 'Color', [1 0 0]);
% legend('Sh', sprintf('n=%d', sum(spines.parallel_count)))
title(sprintf('n=%d', sum(spines.parallel_count)))
set(gca, 'Xtick', [15 45 75], 'XTickLabel', {'0-30', '30-60', '60-90'})
% xlabel('Delta ori (deg)')
ylabel('% para spines')
formatAxes


subplot(3,4,8); 

hold on; axis square; xlim([0 90]); ylim([0 0.8])
% plot(spines.ret_ori_bins, spines.parallel_dist, 'Color', [1 0 0]);
patch([spines.ret_ori_bins, flip(spines.ret_ori_bins, 2)], [shuf_orth_top', flip(shuf_orth_bot,1)'], [0.8 0.8 0.8], 'EdgeColor','none');
plot(spines.ret_ori_bins, spines.ortho_dist, 'Color', [0 0.5 1]);
% legend('Sh', sprintf('n=%d', sum(spines.ortho_count)))
title(sprintf('n=%d', sum(spines.ortho_count)))
set(gca, 'Xtick', [15 45 75], 'XTickLabel', {'0-30', '30-60', '60-90'})
% xlabel('Delta ori (deg)')
ylabel('% ortho spines')
formatAxes

subplot(3,4,12); 

hold on; axis square; xlim([0 90]); ylim([-0.5 0.5])
patch([spines.ret_ori_bins, flip(spines.ret_ori_bins, 2)], [shuf_ratio_top', flip(shuf_ratio_bot,1)'], [0.8 0.8 0.8], 'EdgeColor','none');
plot(spines.ret_ori_bins, spines.po_ratio, 'Color', [0 0 0]);
% legend('Sh', 'D%')
set(gca, 'Xtick', [15 45 75], 'XTickLabel', {'0-30', '30-60', '60-90'})
xlabel('Delta ori (deg)')
ylabel('% para - % ortho')
formatAxes

end