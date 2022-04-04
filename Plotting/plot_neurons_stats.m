function plot_neurons_stats(neuron, subtree)

if nargin <2
    
    subtree = 'all';
end

nDb = numel(neuron);


for iDb = 1:nDb
    switch subtree
        
        case 'all'
            
            this_morph(iDb) = neuron(iDb).morph(1);
            this_retino(iDb)= neuron(iDb).retino(1);
            this_tuning(iDb) = neuron(iDb).tuning(1);
            this_rot_cortex(iDb) = neuron(iDb).rot_cortex(1);
            this_retino_aligned(iDb) = neuron(iDb).retino_aligned(1);
            
        case 'basal'
            
            this_morph(iDb) = neuron(iDb).morph_basal(1);
            this_retino(iDb)= neuron(iDb).retino_basal(1);
            this_tuning(iDb) = neuron(iDb).tuning(1);
            this_rot_cortex(iDb) = neuron(iDb).rot_cortex_basal(1);
            this_retino_aligned(iDb) = neuron(iDb).retino_aligned_basal(1);
            
        case 'apical'
            this_morph(iDb) = neuron(iDb).morph_apical(1);
            this_retino(iDb)= neuron(iDb).retino_apical(1);
            this_tuning(iDb) = neuron(iDb).tuning(1);
            this_rot_cortex(iDb) = neuron(iDb).rot_cortex_apical(1);
            this_retino_aligned(iDb) = neuron(iDb).retino_aligned_apical(1);
            
    end
end


switch subtree
    case 'all'
        saveTo = fullfile(neuron(1).db.data_repo, 'Results');
        if ~exist(saveTo, 'dir')
            mkdir(saveTo);
        end
        
    case 'basal'
        saveTo = fullfile(neuron(1).db.data_repo, 'Results_basal');
        if ~exist(saveTo, 'dir')
            mkdir(saveTo);
        end
    case 'apical'
        saveTo = fullfile(neuron(1).db.data_repo, 'Results_apical');
        if ~exist(saveTo, 'dir')
            mkdir(saveTo);
        end
end

%% gather data
hbins_cortex = this_rot_cortex(1).ang_bins_aligned';
hbins_cortex = cat(2, hbins_cortex, hbins_cortex(1)+2*pi);
hbins_retino = this_retino(1).stats.ang_bins;

hbins_cortex_axial = unwrap_angle(hbins_cortex, 1, 0);
hbins_retino_axial = unwrap_angle(hbins_retino, 1, 0);

oriColor = hsv_downtoned(180);
colorDb = summer(34);

for iDb = 1:nDb
    
    
    % tuning
    prefOri(iDb) = this_tuning(iDb).prefOri;
    prefDir(iDb) = this_tuning(iDb).prefDir;
    OS(iDb) = this_tuning(iDb).OS;
    DS(iDb) = this_tuning(iDb).DS;
    
    % retinotopy
    
    RF(iDb, :) = [this_retino(iDb).soma_A, this_retino(iDb).soma_E];
    
    % dendrites
    retino_aligned(:, iDb)= circGaussFilt(this_retino_aligned(iDb).stats.ang_density,1);
    
    retino(:, iDb)= circGaussFilt(this_retino(iDb).stats.ang_density,1);
    
    rot_cortex(:, iDb)= circGaussFilt(this_rot_cortex(iDb).ang_density_aligned,1);
    
    rot_cortex_allo(:, iDb)= circGaussFilt(this_rot_cortex(iDb).ang_density,1);
    
    dendrOri_ctx(iDb) = this_rot_cortex(iDb).vm_thetaHat*180/pi;
    dendrOri_ret(iDb) = this_retino(iDb).stats.vm_thetaHat*180/pi;

    morph_circAxVar(iDb) = this_morph(iDb).stats.circ_axial_var;
    morph_circVar(iDb) = this_morph(iDb).stats.circ_var;
    
    retino_circAxVar(iDb) = this_retino(iDb).stats.circ_axial_var;
    retino_circVar(iDb) = this_retino(iDb).stats.circ_var;
    
    colorID = prefOri(iDb); %[-90 90]
    colorID = colorID+90;
    color(iDb, :) = oriColor(round(colorID), :);
    
end

%% compare cortical and reinotopy circular variance of trees

figure('Color', [1 1 1]);
hold on
plot([0 1], [0 1], '--k');
scatter(morph_circAxVar, retino_circAxVar, 35,  color, 'filled');axis square
xlabel('cortical circ Var')
ylabel('retino circ Var')
xlim([0, 1])
ylim([0, 1])
formatAxes

print(fullfile(saveTo, 'circ_var_cortex_vs_ret') ,  '-dpng');


%% plot distribution of pref ori and pref dirs

ori_edges = -90:30:90;
ori_bin_centre = ori_edges(1:end-1) + unique(diff(ori_edges))/2;
ori_dist = histcounts(prefOri, ori_edges);

dir_edges = 0:30:360;
dir_bin_centre = dir_edges(1:end-1) + unique(diff(dir_edges))/2;
dir_dist = histcounts(prefDir, dir_edges);

figure('Color', [1 1 1]);
subplot(1,2,1)
bar(dir_edges(1:end-1), dir_dist, 'k');
xlabel('pref dir');
ylabel('neuron count');
formatAxes

subplot(1, 2, 2)
bar(ori_edges(1:end-1), ori_dist, 'k');
xlabel('pref ori');
ylabel('neuron count');
formatAxes

print(fullfile(saveTo, 'ori_dir_dists') ,  '-dpng');

%%

% figure;
%
% scatter(RF(:,1), RF(:,2), 35,  color, 'filled');axis square
%
% figure('Position', [388 110 1248 868], 'Color', [1 1 1]);
% for iDb = 1:nDb
%
% this_tree = neuron(iDb).retino;
%
% % this_tree = resample_tree(this_tree, 0.5); % downsample
%
% this_tree.X = this_tree.X + RF(iDb, 1);
% this_tree.Y = this_tree.Y + RF(iDb, 2);
%
%
% plot_tree_lines(this_tree, color(iDb,:), [], [], '-2l', [-pi/2 pi/2], 'hsv_downtoned'); hold on
% hold on;
% iDb
% end
% axis image
% formatAxes
% xlabel('Azimuth');
% ylabel('Elevation');
% xlim([-145 10])
% ylim([-45 45])
%
% print(fullfile(saveTo, 'all_neurons_ret_in_ret') ,  '-dpng');
% %%
% figure('Position', [388 110 1248 868], 'Color', [1 1 1]);
% for iDb = 1:nDb
%
% this_tree.X = neuron(iDb).morph.X;
% this_tree.Y = neuron(iDb).morph.Y;
% this_tree.Z = neuron(iDb).morph.Z;
% this_tree.dA = neuron(iDb).morph.dA;
% this_tree.D = neuron(iDb).morph.D;
% this_tree.R = neuron(iDb).morph.R;
% this_tree.rnames = neuron(iDb).morph.rnames;
%
% this_tree = resample_tree(this_tree, 5); % downsample
%
% this_tree.X = this_tree.X/20 + RF(iDb, 1);
% this_tree.Y = -this_tree.Y/20 + RF(iDb, 2);
%
%
% plot_tree_lines(this_tree, color(iDb,:), [], [], '-2l', [-pi/2 pi/2], 'hsv_downtoned'); hold on
% hold on;
% iDb
% end
% axis image
% formatAxes
% xlabel('Azimuth (deg)');
% ylabel('Elevation (deg)');
% xlim([-145 10])
% ylim([-45 45])
%
% saveTo = fullfile(neuron(1).db.data_repo, 'Results');
%
%     print(fullfile(saveTo, 'all_neurons_morph_in_ret') ,  '-dpng');

%% does ori correlate with dendrOri in cortex

[r_cc, r_p] = circ_corrcc(prefOri*2*pi/180, dendrOri_ctx*2*pi/180);

delta = dendrOri_ctx - prefOri; 
up = delta>90;
down = delta <-90;

dendrOri_ctx(up) = dendrOri_ctx(up) - 180;
dendrOri_ctx(down) = dendrOri_ctx(down) + 180;

figure( 'Color', [1 1 1], 'Position', [441 573 363 224]);
plot([-90 90], [-90 90], '--k'); hold on;
scatter (prefOri, dendrOri_ctx, 45, color, 'filled'); axis square
xlim([-100 100])
ylim([-180 180])
xlabel('pref ori (deg)')
ylabel('dendrite ori(deg)')
title(sprintf('ctx cR = %02f, p = %02f', r_cc, r_p));
formatAxes

print(fullfile(saveTo, 'dendrori_ctx_vs_ori') ,  '-dpng');

%% does ori correlate with dendrOri in retinotopy

[r_cc, r_p] = circ_corrcc(prefOri*2*pi/180, dendrOri_ret*2*pi/180);

delta = dendrOri_ret - prefOri; 
up = delta>90;
down = delta <-90;

dendrOri_ret(up) = dendrOri_ret(up) - 180;
dendrOri_ret(down) = dendrOri_ret(down) + 180;

figure( 'Color', [1 1 1], 'Position', [441 573 363 224]);
plot([-90 90], [-90 90], '--k'); hold on;
scatter (prefOri, dendrOri_ret, 45, color, 'filled'); axis square
xlim([-100 100])
ylim([-180 180])
xlabel('pref ori (deg)')
ylabel('dendrite ori(deg)')
title(sprintf('ret cR = %02f, p = %02f', r_cc, r_p));
formatAxes

print(fullfile(saveTo, 'dendrori_ret_vs_ori') ,  '-dpng');


%% split neurons in vertical and horz preferring

vert = prefOri < -45 | prefOri >=45;
horz = prefOri >= -45 & prefOri <45;

ave_retino_aligned = mean(retino_aligned,2);
se_retino_aligned = std(retino_aligned,[],2)/sqrt(nDb);
dir_retino_aligned = circ_mean(hbins_retino_axial(1:end-1)*2, ave_retino_aligned');
dir_retino_aligned = dir_retino_aligned/2;

ave_retino = mean(retino,2);
se_retino = std(retino,[],2)/sqrt(nDb);
dir_retino= circ_mean(hbins_retino_axial(1:end-1)*2, ave_retino');
dir_retino =dir_retino/2;

ave_rot_cortex = mean(rot_cortex,2);
se_rot_cortex = std(rot_cortex,[],2)/sqrt(nDb);
dir_rot_cortex = circ_mean(hbins_cortex_axial(1:end-1)*2, ave_rot_cortex');
dir_rot_cortex =dir_rot_cortex/2;

ave_rot_cortex_allo = mean(rot_cortex_allo,2);
se_rot_cortex_allo = std(rot_cortex_allo,[],2)/sqrt(nDb);
dir_rot_cortex_allo = circ_mean(hbins_cortex_axial(1:end-1)*2, ave_rot_cortex_allo');
dir_rot_cortex_allo = dir_rot_cortex_allo/2;

ave_vert_retino_aligned = mean(retino_aligned(:, vert),2);
se_vert_retino_aligned = std(retino_aligned(:, vert),[],2)/sqrt(nDb);
ave_horz_retino_aligned = mean(retino_aligned(:, horz),2);
se_horz_retino_aligned = std(retino_aligned(:, horz),[],2)/sqrt(nDb);

dir_vert_retino_aligned = circ_mean(hbins_retino_axial(1:end-1)*2, ave_vert_retino_aligned');
dir_vert_retino_aligned = dir_vert_retino_aligned/2;
dir_horz_retino_aligned = circ_mean(hbins_retino_axial(1:end-1)*2, ave_horz_retino_aligned');
dir_horz_retino_aligned = dir_horz_retino_aligned/2;

ave_vert_retino = mean(retino(:, vert),2);
se_vert_retino = std(retino(:, vert),[],2)/sqrt(nDb);
ave_horz_retino  = mean(retino (:, horz),2);
se_horz_retino  = std(retino (:, horz),[],2)/sqrt(nDb);

dir_vert_retino = circ_mean(hbins_retino_axial(1:end-1)*2, ave_vert_retino');
dir_vert_retino = dir_vert_retino/2;
dir_horz_retino = circ_mean(hbins_retino_axial(1:end-1)*2, ave_horz_retino');
dir_horz_retino = dir_horz_retino/2;

ave_vert_rot_cortex = mean(rot_cortex (:, vert),2);
se_vert_rot_cortex = std(rot_cortex (:, vert),[],2)/sqrt(nDb);
ave_horz_rot_cortex  = mean(rot_cortex (:, horz),2);
se_horz_rot_cortex  = std(rot_cortex (:, horz),[],2)/sqrt(nDb);

dir_vert_rot_cortex = circ_mean(hbins_cortex_axial(1:end-1)*2, ave_vert_rot_cortex');
dir_vert_rot_cortex= dir_vert_rot_cortex/2;
dir_horz_rot_cortex = circ_mean(hbins_cortex_axial(1:end-1)*2, ave_horz_rot_cortex');
dir_horz_rot_cortex= dir_horz_rot_cortex/2;

ave_vert_rot_cortex_allo = mean(rot_cortex_allo (:, vert),2);
se_vert_rot_cortex_allo = std(rot_cortex_allo (:, vert),[],2)/sqrt(nDb);
ave_horz_rot_cortex_allo  = mean(rot_cortex_allo (:, horz),2);
se_horz_rot_cortex_allo  = std(rot_cortex_allo (:, horz),[],2)/sqrt(nDb);

dir_vert_rot_cortex_allo = circ_mean(hbins_cortex_axial(1:end-1)*2, ave_vert_rot_cortex_allo');
dir_vert_rot_cortex_allo= dir_vert_rot_cortex_allo/2;
dir_horz_rot_cortex_allo = circ_mean(hbins_cortex_axial(1:end-1)*2, ave_horz_rot_cortex_allo');
dir_horz_rot_cortex_allo= dir_horz_rot_cortex_allo/2;

%%
figure('Color', [1 1 1], 'Position', [232 258 981 539]);


subplot(1, 4,1)
polarhistogram('BinEdges', hbins_retino, ...
    'BinCounts', ave_retino_aligned,  'DisplayStyle', 'stairs', 'EdgeColor', [0 0 0]);
hold on;

polarplot([dir_retino_aligned dir_retino_aligned+pi],...
    [max(ave_retino_aligned) max(ave_retino_aligned)], 'Color', [1 0 0]);


formatAxes
set(gca, 'RTick', [], 'ThetaTick', [0 90 180 270]);
set(gca, 'RTick', [], 'ThetaTick', [0 90 180 270]);
set(gca,  'ThetaZeroLocation', 'top');
title('retino_aligned', 'interpreter', 'none')

subplot(1, 4,2)
polarhistogram('BinEdges', hbins_retino, ...
    'BinCounts', ave_retino,  'DisplayStyle', 'stairs', 'EdgeColor', [0 0 0]);
hold on;
polarplot([dir_retino dir_retino+pi],...
    [max(ave_retino) max(ave_retino)], 'Color', [1 0 0]);
formatAxes
set(gca, 'RTick', [], 'ThetaTick', [0 90 180 270]);
set(gca, 'RTick', [], 'ThetaTick', [0 90 180 270]);
set(gca,  'ThetaZeroLocation', 'top');
title('retino', 'interpreter', 'none')


subplot(1, 4,3)
polarhistogram('BinEdges', hbins_cortex, ...
    'BinCounts', ave_rot_cortex,  'DisplayStyle', 'stairs', 'EdgeColor', [0 0 0]);
hold on;
polarplot([dir_rot_cortex dir_rot_cortex+pi],...
    [max(ave_rot_cortex) max(ave_rot_cortex)], 'Color', [1 0 0]);
formatAxes
set(gca, 'RTick', [], 'ThetaTick', [0 90 180 270]);
set(gca, 'RTick', [], 'ThetaTick', [0 90 180 270]);
set(gca,  'ThetaZeroLocation', 'top');
title('rot_cortex', 'interpreter', 'none')

subplot(1, 4,4)
polarhistogram('BinEdges', hbins_cortex, ...
    'BinCounts', ave_rot_cortex_allo,  'DisplayStyle', 'stairs', 'EdgeColor', [0 0 0]);
hold on;
polarplot([dir_rot_cortex_allo dir_rot_cortex_allo+pi],...
    [max(ave_rot_cortex_allo) max(ave_rot_cortex_allo)], 'Color', [1 0 0]);
formatAxes
set(gca, 'RTick', [], 'ThetaTick', [0 90 180 270]);
set(gca, 'RTick', [], 'ThetaTick', [0 90 180 270]);
set(gca,  'ThetaZeroLocation', 'top');
title('rot_cortex_allo', 'interpreter', 'none')

print(fullfile(saveTo, 'dendrite_vis_dist') ,  '-dpng');

%%
figure('Color', [1 1 1]);

subplot(4,2,1)
polarhistogram('BinEdges', hbins_retino, ...
    'BinCounts', ave_vert_retino_aligned,  'DisplayStyle', 'stairs', 'EdgeColor', [0 0 0]);
hold on;

polarplot([dir_vert_retino_aligned dir_vert_retino_aligned+pi],...
    [max(ave_vert_retino_aligned) max(ave_vert_retino_aligned)], 'Color', [1 0 0]);


formatAxes
set(gca, 'RTick', [], 'ThetaTick', [0 90 180 270]);
set(gca, 'RTick', [], 'ThetaTick', [0 90 180 270]);
set(gca,  'ThetaZeroLocation', 'top');
title('retino_aligned, vert')

subplot(4,2,2)
polarhistogram('BinEdges', hbins_retino, ...
    'BinCounts', ave_horz_retino_aligned,  'DisplayStyle', 'stairs', 'EdgeColor', [0 0 0]);
hold on;

polarplot([dir_horz_retino_aligned dir_horz_retino_aligned+pi],...
    [max(ave_horz_retino_aligned) max(ave_horz_retino_aligned)], 'Color', [1 0 0]);

formatAxes
set(gca, 'RTick', [], 'ThetaTick', [0 90 180 270]);
set(gca, 'RTick', [], 'ThetaTick', [0 90 180 270]);
set(gca,  'ThetaZeroLocation', 'top');
title('retino_aligned, horz')

subplot(4,2,3)
polarhistogram('BinEdges', hbins_retino, ...
    'BinCounts', ave_vert_retino,  'DisplayStyle', 'stairs', 'EdgeColor', [0 0 0]);
hold on;

polarplot([dir_vert_retino dir_vert_retino+pi],...
    [max(ave_vert_retino) max(ave_vert_retino)], 'Color', [1 0 0]);
formatAxes
set(gca, 'RTick', [], 'ThetaTick', [0 90 180 270]);
set(gca, 'RTick', [], 'ThetaTick', [0 90 180 270]);
set(gca,  'ThetaZeroLocation', 'top');
title('retino, vert')

subplot(4,2,4)
polarhistogram('BinEdges', hbins_retino, ...
    'BinCounts', ave_horz_retino,  'DisplayStyle', 'stairs', 'EdgeColor', [0 0 0]);
hold on;
polarplot([dir_horz_retino dir_horz_retino+pi],...
    [max(ave_horz_retino) max(ave_horz_retino)], 'Color', [1 0 0]);
formatAxes
set(gca, 'RTick', [], 'ThetaTick', [0 90 180 270]);
set(gca, 'RTick', [], 'ThetaTick', [0 90 180 270]);
set(gca,  'ThetaZeroLocation', 'top');
title('retino, horz')

subplot(4,2,5)
polarhistogram('BinEdges', hbins_cortex, ...
    'BinCounts', ave_vert_rot_cortex,  'DisplayStyle', 'stairs', 'EdgeColor', [0 0 0]);
hold on;

polarplot([dir_vert_rot_cortex dir_vert_rot_cortex+pi],...
    [max(ave_vert_rot_cortex) max(ave_vert_rot_cortex)], 'Color', [1 0 0]);
formatAxes
set(gca, 'RTick', [], 'ThetaTick', [0 90 180 270]);
set(gca, 'RTick', [], 'ThetaTick', [0 90 180 270]);
set(gca,  'ThetaZeroLocation', 'top');
title('rot_cort_aligned, vert')

subplot(4,2,6)
polarhistogram('BinEdges', hbins_cortex, ...
    'BinCounts', ave_horz_rot_cortex,  'DisplayStyle', 'stairs', 'EdgeColor', [0 0 0]);
hold on;
polarplot([dir_horz_rot_cortex dir_horz_rot_cortex+pi],...
    [max(ave_horz_rot_cortex) max(ave_horz_rot_cortex)], 'Color', [1 0 0]);
formatAxes
set(gca, 'RTick', [], 'ThetaTick', [0 90 180 270]);
set(gca, 'RTick', [], 'ThetaTick', [0 90 180 270]);
set(gca,  'ThetaZeroLocation', 'top');
title('rot_cort_aligned, horz')

subplot(4,2,7)
polarhistogram('BinEdges', hbins_cortex, ...
    'BinCounts', ave_vert_rot_cortex_allo,  'DisplayStyle', 'stairs', 'EdgeColor', [0 0 0]);
hold on;
polarplot([dir_vert_rot_cortex_allo dir_vert_rot_cortex_allo+pi],...
    [max(ave_vert_rot_cortex_allo) max(ave_vert_rot_cortex_allo)], 'Color', [1 0 0]);
formatAxes
set(gca, 'RTick', [], 'ThetaTick', [0 90 180 270]);
set(gca, 'RTick', [], 'ThetaTick', [0 90 180 270]);
set(gca,  'ThetaZeroLocation', 'top');
title('rot_cort, vert')

subplot(4,2,8)
polarhistogram('BinEdges',hbins_cortex, ...
    'BinCounts', ave_horz_rot_cortex_allo,  'DisplayStyle', 'stairs', 'EdgeColor', [0 0 0]);
hold on;
polarplot([dir_horz_rot_cortex_allo dir_horz_rot_cortex_allo+pi],...
    [max(ave_horz_rot_cortex_allo) max(ave_horz_rot_cortex_allo)], 'Color', [1 0 0]);
formatAxes
set(gca, 'RTick', [], 'ThetaTick', [0 90 180 270]);
set(gca, 'RTick', [], 'ThetaTick', [0 90 180 270]);
set(gca,  'ThetaZeroLocation', 'top');
title('rot_cort, horz')

end