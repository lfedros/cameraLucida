
clear; 

%% Set path to relevant code

if ispc
   code_repo = 'C:\Users\Federico\Documents\GitHub\cameraLucida';
else
code_repo = '/Users/federico/Documents/GitHub/cameraLucida';

end
cd(code_repo);
addpath(genpath(code_repo));
set_dendrite_paths(); % edit the paths pointing to the code

%% Populate database - edit build_path.m with location of data
db_V1_spines;
nDb = numel(db);

% count how many dendrites per neuron
for iDb = 1:nDb

%     [db(iDb).morph_seq] = build_path(db(iDb), 'morph_seq');
    [db(iDb).vis_seq] = build_path(db(iDb), 'vis');
    [db(iDb).ret_seq] = build_path(db(iDb), 'ret');
    [db(iDb).spine_seq] = build_path(db(iDb), 'spine_seq');
    [db(iDb).pix_map] = build_path(db(iDb), 'pix_map');
    [db(iDb).pix_resp] = build_path(db(iDb), 'pix_resp');

    neuron(iDb).db = db(iDb);

end

%% load all dendrites and register their position to the soma in microns

for iDb = 1:nDb

%    neuron(iDb).dendrite = load_dendrite_old(neuron(iDb));
      [neuron(iDb).dendrite, neuron(iDb).soma, neuron(iDb).stitch] = load_dendrite(neuron(iDb));
 
end


%% pool position and visual properties across dendrites

% for iDb = 1:nDb
% %    [neuron(iDb).spines, neuron(iDb).visual_spines] = pool_spines_old(neuron(iDb),1);
% 
%    [neuron(iDb).spines, neuron(iDb).visual_spines] = pool_spines(neuron(iDb),1);
% end


%% combine pixel maps
for iDb = 1:nDb

     [neuron(iDb).combo_px_map, neuron(iDb).px_map, neuron(iDb).signal_px, neuron(iDb).soma]  = pxmap_combo(neuron(iDb));

     
end

%% combine stats about px resps 
for iDb = 1:nDb

     [neuron(iDb).combo_resp]  = pxresp_combo(neuron(iDb));

     
end

%%
% plotSweepResp_LFR(neuron(iDb).soma.allResp, neuron(iDb).soma.time, 2);
for iDb = 1:nDb
    try
plot_soma_responses(neuron(iDb));
    end
end
%% plot soma vs aggregate spines pref ori and dir

plot_soma_vs_den_ori(neuron, 1,1);

%% compute visual position of spines

for iDb = 1:nDb

   neuron(iDb).ret = load_retino(neuron(iDb),0);
   
end

%% compare distribution of preferred orientation to retinotopic posi1tion

for iDb = 1:nDb

%    [neuron(iDb).visual_spines]  = ...
%        map_spine_retino( neuron(iDb).ret, neuron(iDb).visual_spines);

      [neuron(iDb).combo_px_map]  = ...
       map_px_retino( neuron(iDb).ret, neuron(iDb).combo_px_map, 1);
   iDb
end


%% plot d_ori vs ret_angle joint dist

for iDb = 1:nDb

%   neuron(iDb).visual_spines = plot_joint_ori_ret(neuron(iDb).visual_spines);
     neuron(iDb).combo_px_map = plot_px_joint_ori_ret_dev(neuron(iDb).combo_px_map,1,0);

end
%% pixel analysis

plot_den_ori_vs_ret_stats(neuron);
%%

for iDb = 1:nDb

     neuron(iDb).combo_px_map = clusta_syn(neuron(iDb).combo_px_map,[0 30 2],1);

end

plot_clusta(neuron);



%% ROI analysis

azi_rot = [];
ele_rot = [];
ori_bin = [];
for iDb = 1:nDb
parallel_dist(:, iDb) = neuron(iDb).visual_spines.parallel_dist;
ortho_dist(:, iDb) = neuron(iDb).visual_spines.ortho_dist;
po_ratio(:, iDb) = neuron(iDb).visual_spines.po_ratio;

angs = [0 120 240];

r_para(iDb) = circ_r(angs', parallel_dist(:, iDb));
r_ortho(iDb) = circ_r(angs', ortho_dist(:, iDb));

ret_ori_bins  =  neuron(iDb).visual_spines.ret_ori_bins;

azi_rot = cat(2, azi_rot, neuron(iDb).visual_spines.azi_rot);
ele_rot = cat(2, ele_rot, neuron(iDb).visual_spines.ele_rot);
ori_bin = cat(1, ori_bin, neuron(iDb).visual_spines.all_ori_bin);

end

ave_para_dist = mean(parallel_dist, 2);
ave_ortho_dist = mean(ortho_dist, 2);
ave_po_ratio = mean(po_ratio, 2);

%%
color = [0, 1, 0; 
         1, 1, 0;
         1  0  0]; % colors for ori_bin

figure('Color', 'w', 'Position', [418 456 822 522]);

scatter(azi_rot, ele_rot, 20, color(ori_bin,:), 'filled');
formatAxes
%%

iDb = 3;

figure; 
s = subplot(1,3,1);
imagesc(neuron(iDb).ret.map_x_um, neuron(iDb).ret.map_y_um, neuron(iDb).spines.stitch_den.img); hold on;
plot(0, 0,'*r')
axis image; colormap(s, 1-gray);
formatAxes;

am = subplot(1,3,2);
imagesc(neuron(iDb).ret.map_x_um, neuron(iDb).ret.map_y_um, neuron(iDb).ret.map_azi); axis image; colormap(am, 'jet'); hold on;
scatter(neuron(iDb).visual_spines.x_um, neuron(iDb).visual_spines.y_um, 10,  [0 0 0]);
plot(0, 0,'*k')
title('Azimuth (deg)')
formatAxes;
colorbar;


em = subplot(1,3,3);
imagesc(neuron(iDb).ret.map_x_um, neuron(iDb).ret.map_y_um, neuron(iDb).ret.map_ele); axis image; colormap(em,'jet');hold on;
plot(0,0, '*k')
scatter(neuron(iDb).visual_spines.x_um, neuron(iDb).visual_spines.y_um, 10,  [0 0 0]);
title('Elevation (deg)')
formatAxes;
colorbar;

