function plot_data_vs_shuffle(neuron, shuf)

[nSh, nDb] = size(shuf.aligned_dendriteOri);

%% compute delta deg and alignement for data
for iDb = 1:nDb 
    prefOri(iDb) = neuron(iDb).tuning.prefOri; % counterclockwise angle [-90 90]
    dendriteDelta(iDb) = unwrap_angle(pi/2 - neuron(iDb).tree_deg_aligned.circ_axial_mean,1); % counterclockwise angle [-90 90]
    
end

dendrOri = prefOri+ dendriteDelta*180/pi;
avg_delta = mean(abs(dendriteDelta))*180/pi;

[ccr, p] =circ_corrcc(prefOri*2*pi/180, dendrOri*2*pi/180);

%% compute delta deg and alignement for shuffles
shuf_dendriteDelta = shuf.aligned_dendriteOri;

for iSh = 1:nSh    
    shuf_dendrOri(iSh,:) = prefOri + shuf_dendriteDelta(iSh, :)*180/pi;
    [shuf_ccr(iSh), shuf_p(iSh)] =circ_corrcc(prefOri*2*pi/180, shuf_dendrOri(iSh,:)*2*pi/180);
end

shuf_avg_delta = mean(abs(shuf_dendriteDelta),2)*180/pi;

%% stats and empirical p-values

pc = sum(shuf_ccr>ccr)/nSh;

pd = sum(shuf_avg_delta<avg_delta)/nSh;

[shuf_delta_dist, delta_bins] = histcounts(shuf_avg_delta, 0:1:90);
shuf_delta_dist = shuf_delta_dist/sum(shuf_delta_dist);
[shuf_ccr_dist, ccr_bins] = histcounts(shuf_ccr, -1:0.05:1);
shuf_ccr_dist = shuf_ccr_dist/sum(shuf_ccr_dist);

%% Compute average density map and angular distribution for data

for iDb = 1:nDb
    rotMapTree(:,:,iDb) = neuron(iDb).tree_deg_aligned.ang_map;
    rotMapTree(:,:,iDb) =  rotMapTree(:,:,iDb)/sum(makeVec( rotMapTree(:,:,iDb)));    
    ang_density(:,iDb) = neuron(iDb).tree_deg_aligned.ang_density;
    axial_var(iDb) = neuron(iDb).tree_deg.circ_axial_var;
    axial_density(:,iDb) = neuron(iDb).tree_deg_aligned.axial_density;

end

ang_map_bins = neuron(1).tree_deg_aligned.ang_map_bins;
ax_dist_bins = neuron(1).tree_deg_aligned.ax_bins;

avg_ax_density = mean(axial_density, 2);
avg_ax_density = avg_ax_density/sum(avg_ax_density);
se_ax_density = std(axial_density, [], 2)/sqrt(size(axial_density,2));


avg_ang_density = mean(ang_density, 2);
avg_ang_density = avg_ang_density/sum(avg_ang_density);



%%


ang_bins=neuron(1).tree_deg_aligned.ang_bins - pi/72;
ax_bins = neuron(1).tree_deg_aligned.ax_bins- pi/72;
coaxial_bins = (ang_bins<=3*pi/4 & ang_bins>pi/4) | (ang_bins>=(-3*pi/4) & ang_bins<(-pi/4));
coax = sum(ang_density(coaxial_bins(1:end-1),:),1);
ortho = sum(ang_density(~coaxial_bins(1:end-1), :),1);
shuf_coax = sum(shuf.neuron_ang_density(coaxial_bins(1:end-1),:),1);
shuf_ortho = sum(shuf.neuron_ang_density(~coaxial_bins(1:end-1), :),1);

elong = coax./ortho;
shuf_elong = shuf_coax./shuf_ortho;

[p_coax, ~, stat_coax] = signrank(coax, ortho);
coax_zval =stat_coax.zval;

avg_axial_var = mean(axial_var);

figure; plot(coax, shuf_coax, 'o'); axis square; hold on; plot([0 1], [0,1]);
%%
for iDb = 1:nDb
    
    rel_ang_density(:,iDb) = max(neuron(iDb).tree_deg_aligned.ang_density - shuf.neuron_ang_density(:, iDb)',0);
    rel_ang_density(:,iDb) = rel_ang_density(:,iDb);%/sum(rel_ang_density(:,iDb));
    rel_axial_density(:,iDb) = max(neuron(iDb).tree_deg_aligned.axial_density - shuf.neuron_axial_density(:, iDb)',0);
    rel_axial_density(:,iDb) = rel_axial_density(:,iDb)/sum(rel_axial_density(:,iDb));
    rel_dendriteOri(iDb) = angle(sum(rel_axial_density(:,iDb).*exp(1i*(ax_bins(1:end-1)'+pi/72)*2)))/2;
    rel_axial_var(iDb) = circ_var(ax_bins(1:end-1)'+pi/72, rel_axial_density(:,iDb));


end

avg_rel_ang_density = mean(rel_ang_density,2);
avg_rel_ax_density = mean(rel_axial_density,2);

rel_dendriteOri = unwrap_angle(pi/2 - rel_dendriteOri,1)*180/pi;
rel_dendriteOri = prefOri+ rel_dendriteOri;

cmap = hsv(180);
cori = prefOri+90;
cori(cori>180) = cori(cori>180) -180;

[rel_ccr, rel_p] =circ_corrcc(prefOri*2*pi/180, rel_dendriteOri*2*pi/180);

coaxial_bins = (ang_bins<=3*pi/4 & ang_bins>pi/4) | (ang_bins>=(-3*pi/4) & ang_bins<(-pi/4));
rel_coax = sum(rel_ang_density(coaxial_bins(1:end-1),:),1);
rel_ortho = sum(rel_ang_density(~coaxial_bins(1:end-1), :),1);

[p_coax_rel, ~, stat_coax_rel] = signrank(rel_coax, rel_ortho);
coax_zval_rel =stat_coax_rel.zval;


%% Compute average density map and angular distribution for shuffles
for iSh = 1:nSh
    
    [shuf_p_coax(iSh), ~, shuf_stat_coax(iSh)] = signrank(shuf.coax(iSh, :), shuf.ortho(iSh, :));

end
shuf_coax_zval = [shuf_stat_coax(:).zval];
p_zval = sum(shuf_coax_zval>coax_zval)/nSh;

shuf_ang_density = mean(shuf.aligned_ang_density,2);
shuf_ang_density = shuf_ang_density/sum(shuf_ang_density);

shuf_ax_density = mean(shuf.aligned_axial_density,2);
shuf_ax_density = shuf_ax_density/sum(shuf_ax_density);
shuf_se_ax_density = std(shuf.aligned_axial_density, [], 2)/sqrt(size(shuf.aligned_axial_density,2));

for iSh = 1:size(shuf.aligned_treeMap,3)
    shuf.aligned_treeMap = shuf.aligned_treeMap/sum(makeVec(shuf.aligned_treeMap(:,:,iSh)));
end

shuf_rotMapTree = mean(shuf.aligned_treeMap, 3);
% permRotMapTree = bsxfun(@rdivide, permRotMapTree, sum(sum(permRotMapTree, 1),2));
shuf_rotMapTree = shuf_rotMapTree/sum(shuf_rotMapTree(:));
shuf_avg_axial_var = mean(shuf.axial_var, 2);

p_var = sum(shuf_avg_axial_var<avg_axial_var)/nSh;

%%

figure; 
shadePlot(ax_dist_bins(1:end-1), shuf_ax_density, shuf_se_ax_density, [0 0 0]); hold on
shadePlot(ax_dist_bins(1:end-1),avg_ax_density,se_ax_density, [1, 0, 0])
%% Take difference

avg_rotMapTree = mean(rotMapTree,3); avg_rotMapTree = avg_rotMapTree/sum(avg_rotMapTree(:));
shuf_rotMapTree = shuf_rotMapTree/sum(shuf_rotMapTree(:));
enrichTree = avg_rotMapTree - shuf_rotMapTree;

enrich_ang_density = max(avg_ang_density-shuf_ang_density,0);

% %% fit ellipse to density map
% options=optimset('Display','off');
% 
% pars0 = [0.1, 0, 3, 0, 5, pi/2];
% 
% % parsUP = [inf, pars0(2) + 1, pars0(3) + 1, pars0(4) + 1, pars0(5) + 1, pi/4];
% % 
% % parsLW = [0, pars0(2) - 1, pars0(3) - 1, pars0(4) - 1, pars0(5) - 1, -pi/4];
% %% pars = [Amp, x0, wx, y0, wy, fi]
% coords = [ang_map_bins;ang_map_bins]';
% rotPars = lsqcurvefit(@Ret.gaussian2DRot, pars0, coords,avg_rotMapTree,[],[], options);
% rotGaussRF = Ret.gaussian2DRot(rotPars, coords);


%% plot
cmap = hsv_downtoned(180);
cori = prefOri+90;
cori(cori>180) = cori(cori>180) -180;

figure('Color', 'white'); 
subplot(2,3,1)
scatter(-prefOri,-dendrOri, 50, cmap(round(cori), :), 'filled', 'MarkerEdgeCOlor', 'k');  axis image; hold on
plot([-90 90], [-90 90], '--r');
axis([-135 135 -135 135]);
title(sprintf('ccr = %0.3f, p = %0.3f', ccr,p))
xlabel('Pref ori (deg)');
ylabel('Dendrite ori (deg)');
formatAxes


subplot(2,3,2)
histContour(ccr_bins(1:end-1), shuf_ccr_dist,'k'); hold on
plot([ccr, ccr], [0 max(shuf_ccr_dist)], '--r'); axis square
title(sprintf('p = %0.3f', pc))
xlim([-0.5 0.5])
xlabel('circ r');
ylabel('Shuffle dist');
formatAxes

subplot(2,3,3)
histContour(delta_bins(1:end-1), shuf_delta_dist,'k'); hold on
plot([avg_delta, avg_delta], [0 max(shuf_delta_dist)], '--r'); axis square
title(sprintf('p = %0.3f', pd))
xlim([10 50])
xlabel('Dendrite ori error (deg)');
ylabel('Shuffle dist');
formatAxes

subplot(2,3,4)
scatter(ones(1, nDb), coax, 50, cmap(round(cori), :), 'filled', 'MarkerEdgeCOlor', 'k'); hold on; axis square
scatter(ones(1, nDb)*2, ortho, 50, cmap(round(cori), :), 'filled', 'MarkerEdgeCOlor', 'k'); hold on; axis square
for iDb = 1:nDb
plot([1 2], [coax(iDb), ortho(iDb)], '-', 'Color', cmap(round(cori(iDb)), :))
end
xlim([0 3])
set(gca, 'XTick', [ 1 2], 'XTickLabel', {'coax', 'ortho'})
title(sprintf('signrank p = %0.3f', p_coax))
ylabel('Fraction of dendrites');
formatAxes

subplot(2,3,5)
[shuf_zval_dist, zval_bins] = histcounts(shuf_coax_zval, 0:0.2:4);
histContour(zval_bins(1:end-1), shuf_zval_dist,'k'); hold on
plot([coax_zval, coax_zval], [0 max(shuf_zval_dist)], '--r'); axis square
title(sprintf('p = %0.3f', p_zval))
xlim([0 4])
xlabel('Z statistic');
ylabel('Shuffle dist');
formatAxes

subplot(2,3,6)
[shuf_var_dist, var_bins] = histcounts(shuf_avg_axial_var, 0.5:0.01:0.8);
histContour(var_bins(1:end-1), shuf_var_dist,'k'); hold on
plot([avg_axial_var, avg_axial_var], [0 max(shuf_var_dist)], '--r'); axis square
title(sprintf('p = %0.3f', p_var))
xlim([0 1])
xlabel('Shuffle dist');
ylabel('Axial variance');
formatAxes
%%
figure('Color', 'white'); 

subplot(1,4,1)
polarhistogram('BinEdges',ang_bins,'BinCounts',  flip(avg_rel_ang_density,1), 'EdgeColor','r', 'DisplayStyle', 'stairs');hold on
set(gca, 'thetaTickLabel', [], 'RTickLabel', [], 'RTick', [0, 0.5 1]);
rlim([0 max([avg_rel_ang_density])])
title ({'Data - shuffle'})
formatAxes;

subplot(1,4,2)
scatter(-prefOri,-rel_dendriteOri, 50, cmap(round(cori), :), 'filled', 'MarkerEdgeCOlor', 'k');  axis image; hold on
plot([-90 90], [-90 90], '--r');
axis([-135 135 -135 135]);
title(sprintf('ccr = %0.3f, p = %0.3f', rel_ccr,rel_p))
xlabel('Pref ori (deg)');
ylabel('Dendrite - shuffle ori (deg)');
formatAxes

subplot(1,4,3)
scatter(ones(1, nDb), rel_coax, 50, cmap(round(cori), :), 'filled', 'MarkerEdgeCOlor', 'k'); hold on; axis square
scatter(ones(1, nDb)*2, rel_ortho, 50, cmap(round(cori), :), 'filled', 'MarkerEdgeCOlor', 'k'); hold on; axis square
for iDb = 1:nDb
plot([1 2], [rel_coax(iDb), rel_ortho(iDb)], '-', 'Color', cmap(round(cori(iDb)), :))
end
xlim([0 3])
set(gca, 'XTick', [ 1 2], 'XTickLabel', {'coax', 'ortho'})
title(sprintf('signrank p = %0.3f', p_coax_rel))
ylabel('Dendrite fraction');
formatAxes

subplot(1,4,4)

scatter(rel_coax, rel_ortho,50, cmap(round(cori), :), 'filled', 'MarkerEdgeCOlor', 'k'); hold on; axis square
xlim([0 0.6])
ylim([0 0.6])
% set(gca, 'XTick', [ 1 2], 'XTickLabel', {'coax', 'ortho'})
title(sprintf('signrank p = %0.3f', p_coax_rel))
ylabel('Ortho');
xlabel('Coax');
formatAxes
%%
smth = 0.5;
figure('Color', 'white'); 

dth =  subplot(2,3,1);
polarhistogram('BinEdges',ang_bins,'BinCounts',  flip(avg_ang_density,1), 'EdgeColor','r', 'DisplayStyle', 'stairs');hold on
set(gca, 'thetaTickLabel', [], 'RTickLabel', [], 'RTick', [0, 0.5 1]);
rlim([0 max([avg_ang_density; shuf_ang_density])])
title ({'Dir aligned', 'dendrite density'})
formatAxes;

shuh = subplot(2,3,2);
polarhistogram('BinEdges',ang_bins,'BinCounts',  flip(shuf_ang_density,1), 'EdgeColor','b', 'DisplayStyle', 'stairs');hold on
set(gca, 'thetaTickLabel', [], 'RTickLabel', [], 'RTick', [0, 0.5 1]);
rlim([0 max([avg_ang_density; shuf_ang_density])])
title ({'Shuffle', 'density'})
formatAxes;


difh =  subplot(2,3,3);
polarhistogram('BinEdges',ang_bins,'BinCounts',  flip(enrich_ang_density,1), 'EdgeColor','k', 'DisplayStyle', 'stairs');hold on
set(gca, 'thetaTickLabel', [], 'RTickLabel', [], 'RTick', [0, 0.5 1]);
rlim([0 max([avg_ang_density; shuf_ang_density])])
title ('Data - Shuffled')
formatAxes;

dt =  subplot(2,3,4);
imagesc(ang_map_bins, ang_map_bins, imgaussfilt(avg_rotMapTree,smth)); axis image; colormap(dt, BlueWhiteRed); caxis(dt, [-0.005 0.005])  
ylabel({'Elevation (deg)'; '<-- Pref Ori -->'});
xlabel({'Azimuth (deg)'; '--> Pref Dir -->'});
% colorbar
formatAxes;

shu = subplot(2,3,5);
imagesc(ang_map_bins, ang_map_bins,imgaussfilt(-shuf_rotMapTree, smth)); axis image; colormap(shu,BlueWhiteRed); caxis(shu, [-0.005 0.005])       
xlabel({'Azimuth (deg)'; '--> Pref Dir -->'});
% colorbar
formatAxes;

dif = subplot(2,3,6);
imagesc(ang_map_bins, ang_map_bins,imgaussfilt(enrichTree, 2*smth)); axis image; colormap(dif, BlueWhiteRed); caxis(dif, [-0.001 0.001])       
xlabel({'Azimuth (deg)'; '--> Pref Dir -->'});
% colorbar
formatAxes;

%%
figure;
dt =  subplot(2,3,2);
imagesc(ang_map_bins, ang_map_bins, imgaussfilt(avg_rotMapTree,smth)); axis image; colormap(dt, BlueWhiteRed); caxis(dt, [-0.005 0.005])  
hold on;
cc = cameraLucida.findContour(imgaussfilt(avg_rotMapTree, smth),[0.5, 0.75, 0.9]);
contour(ang_map_bins, ang_map_bins, imgaussfilt(avg_rotMapTree,smth),[cc], 'Color', 'k');
ylabel({'Elevation (deg)'; '<-- Pref Ori -->'});
xlabel({'Azimuth (deg)'; '--> Pref Dir -->'});
% colorbar
formatAxes;

shu = subplot(2,3,4);
imagesc(ang_map_bins, ang_map_bins,imgaussfilt(-shuf_rotMapTree, smth)); axis image; colormap(shu,BlueWhiteRed); caxis(shu, [-0.005 0.005])       
xlabel({'Azimuth (deg)'; '--> Pref Dir -->'});
% colorbar
formatAxes;

dif = subplot(2,3,5);
imagesc(ang_map_bins, ang_map_bins,imgaussfilt(enrichTree, 2*smth)); axis image; colormap(dif, BlueWhiteRed); caxis(dif, [-0.001 0.001])       
xlabel({'Azimuth (deg)'; '--> Pref Dir -->'});
% colorbar
formatAxes;

subplot(2,3,6);
plot([-0.05 1], [-0.05, 1], '--', 'Color', [0.5 0.5 0.5], 'LineWidth', 0.5); hold on
scatter(rel_coax, rel_ortho,50, cmap(round(cori), :), 'filled', 'MarkerEdgeCOlor', 'k'); hold on; axis square
xlim([-0.05 0.6])
ylim([-0.05 0.6])
% set(gca, 'XTick', [ 1 2], 'XTickLabel', {'coax', 'ortho'})
title(sprintf('signrank p = %0.3f', p_coax_rel))
ylabel('Ortho');
xlabel('Coax');
formatAxes

subplot(2,3,3);
plot([-0.05 1], [-0.05, 1], '--', 'Color', [0.5 0.5 0.5], 'LineWidth', 0.5); hold on
scatter(coax, ortho,50, cmap(round(cori), :), 'filled', 'MarkerEdgeCOlor', 'k'); hold on; axis square
xlim([-0.05 0.6])
ylim([-0.05 0.6])
% set(gca, 'XTick', [ 1 2], 'XTickLabel', {'coax', 'ortho'})
title(sprintf('signrank p = %0.3f', p_coax_rel))
ylabel('Ortho');
xlabel('Coax');
formatAxes

%%

figure; 
scatter(elong, shuf_elong, 50, cmap(round(cori), :), 'filled', 'MarkerEdgeCOlor', 'k');axis square; 
hold on;
plot([0 12], [0 12], '--r')

%%

nDb = numel(neuron);
%%
for iDb = 1:nDb
    osi(iDb) = neuron(iDb).tuning.osi;
    ax_var(iDb) = neuron(iDb).tree_deg.circ_axial_var;
end

lm = fitlm( 1-ax_var, 1-osi);

figure;
% plot(ax_var, osi,'ok'); axis square; hold on
h = plot(lm, 'Marker', 'o');axis square
axis([0 1 0 1])
xlabel('dendrites axial selectivity')
ylabel('OSI')
legend('location', 'northeastoutside');
formatAxes

%%
end