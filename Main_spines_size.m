clear; 

%% Set path to relevant code

if ispc
   code_repo = 'C:\Users\Federico\Documents\GitHub\cameraLucida';
else
code_repo = '/Users/lfedros/Documents/GitHub/cameraLucida';

end
cd(code_repo);
addpath(genpath(code_repo));
set_dendrite_paths(); % edit the paths pointing to the code

%% Populate database - edit build_path.m with location of data
db_V1_spines_size;
nDb = numel(db);

% count how many dendrites per neuron
for iDb = 1:nDb


        [db(iDb).spine_size_seq] = build_path(db(iDb), 'spine_size_seq');

    neuron(iDb).db = db(iDb);

end

%% load the ROIs for each spine

for iDb = 1:nDb

   neuron(iDb).spines = load_spine_img_dev(neuron(iDb));
 
end

%% Pool data across neurons

spine_peak = [];
spine_dens = [];
spine_type = [];
den_type = [];
spine_dist_p =[];
spine_dist_o =[];
cum_dist_p = [];
cum_dist_o=[];

dist_bins = 0:0.1:1.5;
cum_bins = 0:0.01:1.5;

for iDb = 1:nDb
spine_peak{iDb} = cat(2, neuron(iDb).spines(:).peak)';
spine_type{iDb} = cat(2, neuron(iDb).spines(:).type)';


spine_dist_p(:, iDb) = histcounts(spine_peak{iDb}(spine_type{iDb}== 'p'), dist_bins);
spine_dist_p(:, iDb) = spine_dist_p(:, iDb)/sum(spine_dist_p(:, iDb));

spine_dist_o(:, iDb) = histcounts(spine_peak{iDb}(spine_type{iDb} == 'o'), dist_bins);
spine_dist_o(:, iDb) = spine_dist_o(:, iDb)/sum(spine_dist_o(:, iDb));

ave_o(iDb) = nanmean(spine_peak{iDb}(spine_type{iDb} == 'o'));
ave_p(iDb) = nanmean(spine_peak{iDb}(spine_type{iDb} == 'p'));

cum_dist_p(:, iDb) = histcounts(spine_peak{iDb}(spine_type{iDb}== 'p'), cum_bins);
cum_dist_p(:, iDb) = cumsum(cum_dist_p(:, iDb))/sum(cum_dist_p(:, iDb));

cum_dist_o(:, iDb) = histcounts(spine_peak{iDb}(spine_type{iDb} == 'o'), cum_bins);
cum_dist_o(:, iDb) = cumsum(cum_dist_o(:, iDb))/sum(cum_dist_o(:, iDb));


spine_dens = cat(1, spine_dens, [neuron(iDb).spines(:).spines_per_um]');
den_type = cat(1, den_type, neuron(iDb).spines(:).den_type);

dens_p(iDb) = mean([neuron(iDb).spines((strcmp({neuron(iDb).spines(:).den_type},'para'))).spines_per_um]);
dens_o(iDb) = mean([neuron(iDb).spines((strcmp({neuron(iDb).spines(:).den_type},'orth'))).spines_per_um]);

end

all_peak = cat(1, spine_peak{:});
all_type = cat(1, spine_type{:});
%%

all_spine_dist_p = histcounts(all_peak(all_type== 'p'), dist_bins);
all_spine_dist_p = all_spine_dist_p/sum(all_spine_dist_p);

all_spine_dist_o = histcounts(all_peak(all_type == 'o'), dist_bins);
all_spine_dist_o = all_spine_dist_o/sum(all_spine_dist_o);

all_cum_dist_p = histcounts(all_peak(all_type== 'p'), cum_bins);
all_cum_dist_p = cumsum(all_cum_dist_p)/sum(all_cum_dist_p);

all_cum_dist_o = histcounts(all_peak(all_type == 'o'), cum_bins);
all_cum_dist_o = cumsum(all_cum_dist_o)/sum(all_cum_dist_o);

den_lab = zeros(size(den_type,1),1);
den_lab(den_type(:,1) =='p') = 1; 

%%

figure('Position', [220 393 1196 420], 'color', 'w', 'PaperOrientation', 'landscape');

[~, pks] = kstest2(all_peak(all_type== 'p'), all_peak(all_type== 'o'));

subplot(2, 4,1)

plot(dist_bins(1:end-1), spine_dist_p, 'Color', [1 0 0], 'LineWidth', 0.5); hold on
plot(dist_bins(1:end-1), spine_dist_o, 'Color', [0 0.5 1], 'LineWidth', 0.5); hold on
plot(dist_bins(1:end-1), all_spine_dist_p, 'Color', [1 0 0], 'LineWidth', 2); hold on
plot(dist_bins(1:end-1), all_spine_dist_o, 'Color', [0 0.5 1], 'LineWidth', 2); hold on
title(sprintf('%d spines \n %d den, N= %d', numel(all_peak), numel(den_lab), numel(neuron)));
axis square
formatAxes
ylabel('probability')
xlabel(['Spine head F'])

subplot(2, 4, 2)
plot(cum_bins(1:end-1), cum_dist_p, 'Color', [1 0 0], 'LineWidth', 0.5); hold on
plot(cum_bins(1:end-1), cum_dist_o, 'Color', [0 0.5 1], 'LineWidth', 0.5); hold on
plot(cum_bins(1:end-1), all_cum_dist_p, 'Color', [1 0 0], 'LineWidth', 2); hold on
plot(cum_bins(1:end-1), all_cum_dist_o, 'Color', [0 0.5 1], 'LineWidth', 2); hold on
title(sprintf('%d spines \n %d den, N= %d', numel(all_peak), numel(den_lab), numel(neuron)));
axis square
formatAxes
ylabel('Cumulative p')
xlabel('Spine head fluo')

prs = signrank(ave_p, ave_o);
subplot(2, 4, 7)
plot(ave_p, ave_o, 'o', 'Color', [0.1 0.1 0.1], 'MarkerFaceColor', [0.1 0.1 0.1]); hold on;
plot([0 2], [0 2], '--', 'Color', [0.5 0.5 0.5])
xlim([0, 1.5])
ylim([0, 1.5])
axis square
title(sprintf('p = %02f', prs));
formatAxes
set(gca, 'XTick', [0 1],'YTick', [0 1])
xlabel('mean spine size p')
ylabel('mean spine size o')


subplot(2, 4,5)

bar(dist_bins(1:end-1), all_spine_dist_p, 'EdgeColor', 'none', 'FaceColor', [1 0 0], 'FaceAlpha', 0.5); hold on
bar(dist_bins(1:end-1), all_spine_dist_o, 'EdgeColor', 'none', 'FaceColor', [0 0.5 1], 'FaceAlpha', 0.5); hold on
title(sprintf('%d spines \n %d den, N= %d', numel(all_peak), numel(den_lab), numel(neuron)));
axis square
formatAxes
ylabel('probability')
xlabel(['Spine head F'])

subplot(2, 4,6)
stairs(cum_bins(1:end-1), all_cum_dist_p, 'Color',[1 0 0]); hold on
stairs(cum_bins(1:end-1), all_cum_dist_o, 'Color',[0 0.5 1]); hold on
title(sprintf('p = %02f', pks));
axis square
formatAxes
ylabel('Cumulative p')
xlabel('Spine head fluo')

prs = signrank(dens_p, dens_o);
subplot(2, 4,8)
plot(dens_p, dens_o, 'o', 'Color', [0.1 0.1 0.1], 'MarkerFaceColor', [0.1 0.1 0.1]); hold on;
plot([0 2], [0 2], '--', 'Color', [0.5 0.5 0.5])
xlim([0, 1])
ylim([0, 1])
axis square
title(sprintf('p = %02f', prs));
formatAxes
set(gca, 'XTick', [0 1],'YTick', [0 1])
xlabel('soine density p')
ylabel('spine density o')

prs = ranksum(spine_dens(den_lab==0), spine_dens(den_lab==1));
subplot(2, 4,4)
plot(den_lab(den_lab==0), spine_dens(den_lab==0), 'o', 'MarkerFaceColor', [0 0.5 1]); hold on;
plot(den_lab(den_lab==1), spine_dens(den_lab==1), 'o', 'MarkerFaceColor', [1 0 0]); hold on;
xlim([-1, 2])
ylim([0, 0.7])
axis square
title(sprintf('p = %02f', prs));
formatAxes
set(gca, 'XTick', [0 1],'XTickLabel', {'ortho', 'para'})
ylabel('spines per um')

print(fullfile(db(1).data_repo,'Results', 'Spine Size Stats'), '-painters','-dpdf', '-bestfit');
% 
