 clear;
 %% Set path to relevant code
 addpath('C:\Users\Federico\Documents\GitHub\Dbs\V1_dendrites');
 code_repo = 'C:\Users\Federico\Documents\GitHub\cameraLucida';
 addpath(genpath(code_repo));
 addpath(genpath('C:\Users\Federico\Documents\GitHub\treestoolbox'));
 cd(code_repo);
 
%% Create database of experiments

db_dendrites;
nDb = numel(db); 

%% Populate database with info

for iDb = 1:nDb
    neuron(iDb) = load_expInfo(db(iDb));
end 

%% Load the reconstructions

for iDb = 1:nDb   
    neuron(iDb).tree_um = load_morph(neuron(iDb),0);
    neuron(iDb).tree_um = tree_angular_stats(neuron(iDb).tree_um);
end

cameraLucida.tree_density3D(neuron, 1, 1, [], true);

%% Load neurons tuning to drifting gratings

for iDb = 1:nDb
     neuron(iDb).tuning = load_tuning(neuron(iDb),0);
end

cameraLucida.tree_poolTuning(neuron);


%% Map dendrites to retinotopy 

for iDb = 1:nDb
    neuron(iDb).tree_deg = load_visual_morph(neuron(iDb),0);
    neuron(iDb).tree_deg = tree_angular_stats(neuron(iDb).tree_deg);
    
%     cameraLucida.plot_treeTuning(neuron(iDb));
end


% a = struct2table(neuron);
% b = a.tuning;
% b = [b.prefOri];
% keepers = b>-20 | b<20;
% 
% neuron(~keepers) = []; nDb = numel(neuron);
%% Align trees according to preferred direction

for iDb = 1:nDb  
    neuron(iDb).tree_deg_aligned = rotate_tree(neuron(iDb).tree_deg, neuron(iDb).tuning.prefDir);
    neuron(iDb).tree_deg_aligned = tree_angular_stats(neuron(iDb).tree_deg_aligned);
end

cameraLucida.tree_poolHist(neuron);

%%
cameraLucida.plot_allTrees(neuron);


%% Compute shuffles
load_shuffles = 1;
nSh = 1000;
if load_shuffles
    load(fullfile(neuron(1).data_repo, 'Processed', 'shuffle_morph.mat'), 'shuf_morph', 'shuf_morph_idx');
    load(fullfile(neuron(1).data_repo, 'Processed', 'shuffle_ret.mat'), 'shuf_ret', 'shuf_ret_idx');nSh = 100;
    load(fullfile(neuron(1).data_repo, 'Processed', 'shuffle_dir.mat'), 'shuf_dir', ' shuf_dir_idx');
else
    [shuf_morph, shuf_morph_idx] = shuffle_morph_dev(neuron, nSh, 'morph');
    save(fullfile(neuron(1).data_repo, 'Processed', 'shuffle_morph.mat'), 'shuf_morph', 'shuf_morph_idx');
    [shuf_ret, shuf_ret_idx] = shuffle_morph_dev(neuron, nSh, 'ret');
    save(fullfile(neuron(1).data_repo, 'Processed', 'shuffle_ret.mat'), 'shuf_ret', 'shuf_ret_idx');nSh = 100;
    [shuf_dir, shuf_dir_idx] = shuffle_morph_dev(neuron, nSh, 'dir');
    save(fullfile(neuron(1).data_repo, 'Processed', 'shuffle_dir.mat'), 'shuf_dir', 'shuf_dir_idx');
end
%% Plots
plot_data_vs_shuffle(neuron, shuf_morph)
plot_data_vs_shuffle(neuron, shuf_ret)
plot_data_vs_shuffle(neuron, shuf_dir)


%% Plot ori colormap

figure;
oris = 0:30:150;
cmap = hsv_downtoned(180);
for io = 1:6
    plot([-sind(oris(io)), sind(oris(io))], [-cosd(oris(io)), cosd(oris(io))], 'Color', cmap(oris(io)+1,:));
    hold on
end
formatAxes; axis square


%% Correlate dendrite axial mean with prefOri

% figure;
for iDb = 1:nDb 
%     clf; 
    prefOri(iDb) = neuron(iDb).tuning.prefOri; % counterclockwise angle [-90 90]

%     dendriteOri(iDb) = neuron(iDb).tree_deg.circ_axial_mean*180/pi; % counterclockwise angle [-90 90]
    dendriteOri(iDb) = unwrap_angle(90 - neuron(iDb).tree_deg_aligned.circ_axial_mean*180/pi,1,1); % counterclockwise angle [-90 90]

end
% dendriteOri(dendriteOri>90) = dendriteOri(dendriteOri>90) -180;
dendriteOri = prefOri - dendriteOri;
dendriteOri = unwrap_angle(dendriteOri,1,1);
% dendriteOri(dendriteOri>90) = dendriteOri(dendriteOri>90) -180;
% dendriteOri(dendriteOri<-90) = dendriteOri(dendriteOri<-90) +180;

figure; 
plot(prefOri,dendriteOri,  'o');  axis image
axis([-130 130 -130 130]);

[ccr, p] =circ_corrcc(deg2rad(prefOri)*2, deg2rad(dendriteOri)*2);
[ccr, p] =circ_corrcc(prefOri*2*pi/180, dendriteOri*2*pi/180);

for iDb = 1:nDb 
    dendriteOri(iDb) = unwrap_angle(pi/2+ neuron(iDb).tree_deg_aligned.circ_axial_mean,1); % counterclockwise angle [-90 90]

end
mean(abs(dendriteOri));
shuf_dendriteOri = shuf_stats.aligned_dendriteOri;
dd = mean(abs(shuf_dendriteOri),2);

%%

for iDb = 1:nDb
    rotMapTree(:,:,iDb) = neuron(iDb).tree_deg_aligned.ang_map;
    rotMapTree(:,:,iDb) =  rotMapTree(:,:,iDb)/max(makeVec( rotMapTree(:,:,iDb)));    
    ang_density(:,iDb) = neuron(iDb).tree_deg_aligned.ang_density;
   
end
ang_map_bins = neuron(1).tree_deg_aligned.ang_map_bins;
ang_bins = neuron(1).tree_deg_aligned.ang_bins;
ang_density = mean(ang_density, 2);
ang_density = ang_density/sum(ang_density);

shuf_ang_density = mean(shuf_stats.aligned_ang_density,2);
shuf_ang_density = shuf_ang_density/sum(shuf_ang_density);

permRotMapTree = mean(shuf_stats.aligned_treeMap, 3);
permRotMapTree = bsxfun(@rdivide, permRotMapTree, sum(sum(permRotMapTree, 1),2));
permRotMapTree = permRotMapTree/sum(permRotMapTree(:));

normTree = mean(rotMapTree,3); normTree = normTree/sum(normTree(:));
permNormTree = permRotMapTree/sum(permRotMapTree(:));
enrichTree = normTree - permNormTree;

smth = 0.5;
figure; 

dth =  subplot(2,3,1);
polarhistogram('BinEdges',ang_bins,'BinCounts',  flip(ang_density,1), 'EdgeColor','r', 'DisplayStyle', 'stairs');hold on
%     set(gca, 'thetaTickLabel', [], 'RTickLabel', [], 'RTick', [0, 0.5 1]);
title ({'Pref dir aligned'; 'dendrite density'})
formatAxes;

shuh = subplot(2,3,2);
polarhistogram('BinEdges',ang_bins,'BinCounts',  flip(shuf_ang_density,1), 'EdgeColor','b', 'DisplayStyle', 'stairs');hold on
    set(gca, 'thetaTickLabel', [], 'RTickLabel', [], 'RTick', [0, 0.5 1]);
title ({'Shuffled dir aligned'; 'dendrite density'})
formatAxes;


difh =  subplot(2,3,3);
polarhistogram('BinEdges',ang_bins,'BinCounts',  flip(max(ang_density-shuf_ang_density,0),1), 'EdgeColor','k', 'DisplayStyle', 'stairs');hold on
    set(gca, 'thetaTickLabel', [], 'RTickLabel', [], 'RTick', [0, 0.5 1]);
title ('Data - Shuffled')
formatAxes;

dt =  subplot(2,3,4);
imagesc(ang_map_bins, ang_map_bins, imgaussfilt(normTree,smth)); axis image; colormap(dt, BlueWhiteRed); caxis(dt, [-0.005 0.005])  
ylabel({'Elevation (deg)'; '<-- Pref Ori -->'});
xlabel({'Azimuth (deg)'; '--> Pref Dir -->'});
formatAxes;

shu = subplot(2,3,5);
imagesc(ang_map_bins, ang_map_bins,imgaussfilt(-permNormTree, smth)); axis image; colormap(shu,BlueWhiteRed); caxis(shu, [-0.005 0.005])       
xlabel({'Azimuth (deg)'; '--> Pref Dir -->'});
formatAxes;

dif = subplot(2,3,6);
imagesc(ang_map_bins, ang_map_bins,imgaussfilt(enrichTree, 2*smth)); axis image; colormap(dif, BlueWhiteRed); caxis(dif, [-0.001 0.001])       
xlabel({'Azimuth (deg)'; '--> Pref Dir -->'});
formatAxes;



