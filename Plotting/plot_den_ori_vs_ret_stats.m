function plot_den_ori_vs_ret_stats(neuron)

nDb = numel(neuron);

azi_rot = [];
ele_rot = [];
ori_bin = [];
for iDb = 1:nDb
parallel_dist(:, iDb) = neuron(iDb).combo_px_map.parallel_dist;
ortho_dist(:, iDb) = neuron(iDb).combo_px_map.ortho_dist;
po_ratio(:, iDb) = neuron(iDb).combo_px_map.po_ratio;
all_dist(:,iDb) =neuron(iDb).combo_px_map.all_dist;

angs = [0 120 240];

% r_para(iDb) = circ_r(angs', parallel_dist(:, iDb));
% r_ortho(iDb) = circ_r(angs', ortho_dist(:, iDb));

ret_ori_bins  =  neuron(iDb).combo_px_map.ret_ori_bins;

azi_rot = cat(2, azi_rot, neuron(iDb).combo_px_map.azi_rot);
ele_rot = cat(2, ele_rot, neuron(iDb).combo_px_map.ele_rot);
ori_bin = cat(1, ori_bin, neuron(iDb).combo_px_map.all_ori_bin);

all_ori(iDb) = neuron(iDb).combo_px_map.all_ori;
para_ori(iDb) = neuron(iDb).combo_px_map.para_ori;
ortho_ori(iDb) = neuron(iDb).combo_px_map.ortho_ori;
% soma_ori = neuron(iDb).combo_px_map.soma;
if ~isempty(neuron(iDb).combo_px_map.soma_pref_ori)
    soma_ori(iDb) = neuron(iDb).combo_px_map.soma_pref_ori;
%             soma_ori = combo_px_map.pref_ori_norm;

else
%     if norm_flag
        soma_ori(iDb) = neuron(iDb).combo_px_map.pref_ori_norm;
%     else
%         soma_ori = combo_px_map.pref_ori;
%     end
end

end

soma_ori = unwrap_angle(soma_ori, 1, 1);
all_ori = unwrap_angle(all_ori, 1, 1);
para_ori = unwrap_angle(para_ori, 1, 1);
ortho_ori = unwrap_angle(ortho_ori, 1, 1);

d_para = para_ori-soma_ori;
d_para(d_para>90) = d_para(d_para>90)-180;
d_para(d_para<-90) = d_para(d_para<-90)+180; %[-90 90]
d_para = abs(d_para); %[0 90]

d_ortho = ortho_ori-soma_ori;
d_ortho(d_ortho>90) = d_ortho(d_ortho>90)-180;
d_ortho(d_ortho<-90) = d_ortho(d_ortho<-90)+180; %[-90 90]
d_ortho = abs(d_ortho); %[0 90]

d_all = all_ori-soma_ori;
d_all(d_all>90) = d_all(d_all>90)-180;
d_all(d_all<-90) =d_all(d_all<-90)+180; %[-90 90]
d_all = abs(d_all); %[0 90]

ave_para_dist = nanmean(parallel_dist, 2);
ave_ortho_dist = nanmean(ortho_dist, 2);
ave_po_ratio = nanmean(po_ratio, 2);
ave_all_dist = nanmean(all_dist, 2);
%%
figure('Color', 'w', 'Position', [423 344 972 420]);

subplot(2,4,2); 
hold on; axis square; xlim([0 90]); ylim([0.1 0.6])
plot(ret_ori_bins, parallel_dist, 'Color', [1 0 0],'LineWidth', 0.5);
plot(ret_ori_bins,ave_para_dist, 'Color', [0.5 0 0], 'LineWidth', 2);
set(gca, 'Xtick', [15 45 75], 'XTickLabel', {'0-30', '30-60', '60-90'})
xlabel('Delta ori (deg)')
ylabel('% para spines')
p = anova1(parallel_dist', [], 'off');
title(sprintf('p = %.4f', p));
formatAxes


subplot(2,4,3); 

hold on; axis square; xlim([0 90]); ylim([0.1 0.6])
plot(ret_ori_bins, ortho_dist, 'Color', [0 0.5 1], 'LineWidth', 0.5);
plot(ret_ori_bins, ave_ortho_dist, 'Color', [0 0.25 0.5], 'LineWidth', 2);
set(gca, 'Xtick', [15 45 75], 'XTickLabel', {'0-30', '30-60', '60-90'})
xlabel('Delta ori (deg)')
ylabel('% ortho spines')
p = anova1(ortho_dist', [], 'off');
title(sprintf('p = %.4f', p))
formatAxes

subplot(2,4,4); 

hold on; axis square; xlim([0 90]); ylim([-0.2 0.2]);
plot(ret_ori_bins, po_ratio, 'Color', [0.5 0.5 0.5], 'LineWidth', 0.5);
plot(ret_ori_bins, ave_po_ratio, 'Color', [0 0 0], 'LineWidth', 2);
set(gca, 'Xtick', [15 45 75], 'XTickLabel', {'0-30', '30-60', '60-90'})
xlabel('Delta ori (deg)')
ylabel('% para - ortho')
p = anova1(po_ratio', [], 'off');
title(sprintf('p = %.6f', p))
formatAxes

subplot(2,4,1); 

hold on; axis square; xlim([0 90]); ylim([0.1 0.6]);
plot(ret_ori_bins, all_dist, 'Color', [0.5 0.5 0.5], 'LineWidth', 0.5);
plot(ret_ori_bins, ave_all_dist, 'Color', [0 0 0], 'LineWidth', 2);
set(gca, 'Xtick', [15 45 75], 'XTickLabel', {'0-30', '30-60', '60-90'})
xlabel('Delta ori (deg)')
ylabel('% all spines')
p = anova1(all_dist', [], 'off');
title(sprintf('p = %.6f', p))
formatAxes

subplot(2,4,5)
hold on;
plot([-90 90], [-90 90], '--', 'Color', [0 0 0]);
plot(soma_ori, all_ori, 'o', 'MarkerFaceColor', [0.7 0.7 0.7], 'MarkerEdgeColor', [0 0 0], 'MarkerSize', 7);
axis square
     xlim([-90 90])
    ylim([-90 90])
formatAxes
xlabel('Soma pref ori')
ylabel('Input pref ori')
[r, pr] = circ_corrcc(soma_ori*2*pi/180, all_ori*2*pi/180);
title(sprintf('rcc = %03f',r));
% title(sprintf('rcc = %03f, p = %03f', r, pr));

subplot(2,4,6)
hold on;
plot([-90 90], [-90 90], '--', 'Color', [0 0 0]);
plot(soma_ori, para_ori, 'o', 'MarkerFaceColor', [0.7 0.7 0.7], 'MarkerEdgeColor', [0 0 0], 'MarkerSize', 7);
axis square
    xlim([-90 90])
    ylim([-90 90])
formatAxes
xlabel('Soma pref ori')
ylabel('Input pref ori')
[r, pr] = circ_corrcc(soma_ori*2*pi/180, para_ori*2*pi/180);
title(sprintf('rcc = %03f', r));
% title(sprintf('rcc = %03f, p = %03f', r, pr));

subplot(2,4,7)
hold on;
plot([-90 90], [-90 90], '--', 'Color', [0 0 0]);
plot(soma_ori, ortho_ori, 'o', 'MarkerFaceColor', [0.7 0.7 0.7], 'MarkerEdgeColor', [0 0 0], 'MarkerSize', 7);
axis square
    xlim([-90 90])
    ylim([-90 90])
formatAxes
xlabel('Soma pref ori')
ylabel('Input pref ori')
[r, pr] = circ_corrcc(soma_ori*2*pi/180, ortho_ori*2*pi/180);
title(sprintf('rcc = %03f', r));

subplot(2, 4, 8)
hold on;
plot([0 90], [0 90], '--', 'Color', [0 0 0]);
plot(d_para, d_ortho, 'o', 'MarkerFaceColor', [0.7 0.7 0.7], 'MarkerEdgeColor', [0 0 0], 'MarkerSize', 7);
axis square
    xlim([-10 100])
    ylim([-10 100])
formatAxes
xlabel('d_para')
ylabel('d_ortho')


end