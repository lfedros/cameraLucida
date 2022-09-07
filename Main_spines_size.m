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

%%

spine_peak = [];
spine_dens = [];
spine_type = [];
den_type = [];


for iDb = 1:nDb
spine_peak = cat(1, spine_peak, cat(2, neuron(iDb).spines(:).peak)');
spine_type = cat(1, spine_type, cat(2, neuron(iDb).spines(:).type)');
spine_dens = cat(1, spine_dens, [neuron(iDb).spines(:).spines_per_um]');
den_type = cat(1, den_type, neuron(iDb).spines(:).den_type);
end

%%

dist_bins = 0:0.1:1.5;
cum_bins = 0:0.01:1.5;

spine_dist_p = histcounts(spine_peak(spine_type== 'p'), dist_bins);
spine_dist_p = spine_dist_p/sum(spine_dist_p);

spine_dist_o = histcounts(spine_peak(spine_type == 'o'), dist_bins);
spine_dist_o = spine_dist_o/sum(spine_dist_o);


cum_dist_p = histcounts(spine_peak(spine_type== 'p'), cum_bins);
cum_dist_p = cumsum(cum_dist_p)/sum(cum_dist_p);

cum_dist_o = histcounts(spine_peak(spine_type == 'o'), cum_bins);
cum_dist_o = cumsum(cum_dist_o)/sum(cum_dist_o);

den_lab = zeros(size(den_type,1),1);
den_lab(den_type(:,1) =='p') = 1; 

figure;

[~, pks] = kstest2(spine_peak(spine_type== 'p'), spine_peak(spine_type== 'o'));

subplot(1,3,1)
bar(dist_bins(1:end-1), spine_dist_p, 'EdgeColor', 'none', 'FaceColor', [1 0 0], 'FaceAlpha', 0.5); hold on
bar(dist_bins(1:end-1), spine_dist_o, 'EdgeColor', 'none', 'FaceColor', [0 0.5 1], 'FaceAlpha', 0.5); hold on
title(sprintf('%d spines \n %d den, N= %d', numel(spine_peak), numel(den_lab), numel(neuron)));
axis square
formatAxes
ylabel('probability')
xlabel(['Spine head F'])

subplot(1,3,2)
stairs(cum_bins(1:end-1), cum_dist_p, 'Color',[1 0 0]); hold on
stairs(cum_bins(1:end-1), cum_dist_o, 'Color',[0 0.5 1]); hold on
title(sprintf('p = %02f', pks));
axis square
formatAxes
ylabel('Cumulative p')
xlabel('Spine head fluo')



prs = ranksum(spine_dens(den_lab==0), spine_dens(den_lab==1));
subplot(1,3,3)
plot(den_lab(den_lab==0), spine_dens(den_lab==0), 'o', 'MarkerFaceColor', [0 0.5 1]); hold on;
plot(den_lab(den_lab==1), spine_dens(den_lab==1), 'o', 'MarkerFaceColor', [1 0 0]); hold on;
xlim([-1, 2])
ylim([0, 0.7])
axis square
title(sprintf('p = %02f', prs));
formatAxes
set(gca, 'XTick', [0 1],'XTickLabel', {'ortho', 'para'})
ylabel('spines per um')





