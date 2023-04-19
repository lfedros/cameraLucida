%%first run Main_dendrites_preprocessing

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
db_V1_dendrites;
nDb = numel(db);

% count how many longitudinal recordings
for iDb = 1:nDb
    [db(iDb).morph_seq] = build_path(db(iDb), 'morph_seq');
    [db(iDb).vis_seq] = build_path(db(iDb), 'vis_seq');
    [db(iDb).ret_seq] = build_path(db(iDb), 'ret_seq');
    
    neuron(iDb).db = db(iDb);

end

%% Load the reconstructions

for iDb = 1:nDb

    doPlot = 0;
    % if you want to save
    doSave = 0;
    % if you want to recompute and overwrite saved one
    reLoad = 0;

    [neuron(iDb).morph, neuron(iDb).morph_basal, neuron(iDb).morph_apical] = ...
        load_morph(db(iDb),db(iDb).morph_seq, doPlot, doSave, reLoad);

end

%% Load neurons tuning to drifting gratings

for iDb = 1:nDb
    doPlot = 0;
    % if you want to save
    doSave = 0;
    neuron(iDb).tuning = load_tuning_longitudinal_dev(db(iDb),db(iDb).vis_seq, doPlot,doSave);
    
%      plot_responses(neuron(iDb));% plot responses if needed

end

%% Map dendrites to retinotopy

for iDb = 1:nDb

    doPlot = 0;
    % if you want to save
    doSave = 0;
    % if you want to recompute and overwrite saved one
    reLoad = 0;
    
    if strcmp(db(iDb).animal, 'FR175') && db(iDb).neuron_id == 7
        
        neuron(iDb).tuning(1).prefOri = unwrap_angle(neuron(iDb).tuning(1).prefDir + 90,1,1);
    end
    neuron(iDb).retino =load_visual_morph_dev( neuron(iDb).morph, neuron(iDb).db, neuron(iDb).tuning(1).prefOri,doPlot, doSave,reLoad);
    neuron(iDb).retino_basal =load_visual_morph_dev( neuron(iDb).morph_basal, neuron(iDb).db, neuron(iDb).tuning(1).prefOri,doPlot, doSave,reLoad);
    neuron(iDb).retino_apical =load_visual_morph_dev( neuron(iDb).morph_apical, neuron(iDb).db, neuron(iDb).tuning(1).prefOri,doPlot, doSave,reLoad);
    
    fprintf('%s neuron %d completed. %d of %d \n', db(iDb).animal, db(iDb).neuron_id, iDb, nDb);
end

%% Measure some stats

for iDb = 1:nDb
    
    for iSeq = 1:numel(neuron(iDb).morph)

    neuron(iDb).morph(iSeq).stats = tree_angular_stats(neuron(iDb).morph(iSeq));
    neuron(iDb).morph_basal(iSeq).stats = tree_angular_stats(neuron(iDb).morph_basal(iSeq));
    neuron(iDb).morph_apical(iSeq).stats = tree_angular_stats(neuron(iDb).morph_apical(iSeq));
    
    neuron(iDb).retino(iSeq).stats = tree_angular_stats(neuron(iDb).retino(iSeq));
    neuron(iDb).retino_basal(iSeq).stats = tree_angular_stats(neuron(iDb).retino_basal(iSeq));
    neuron(iDb).retino_apical(iSeq).stats = tree_angular_stats(neuron(iDb).retino_apical(iSeq));

    neuron(iDb).retino_aligned(iSeq) = rotate_tree(neuron(iDb).retino(iSeq), neuron(iDb).tuning(1).prefDir);
    neuron(iDb).retino_aligned_basal(iSeq) = rotate_tree(neuron(iDb).retino_basal(iSeq), neuron(iDb).tuning(1).prefDir);
    neuron(iDb).retino_aligned_apical(iSeq) = rotate_tree(neuron(iDb).retino_apical(iSeq), neuron(iDb).tuning(1).prefDir);

    neuron(iDb).rot_cortex(iSeq) = rot_ret_stats(neuron(iDb).morph(iSeq), neuron(iDb).retino(iSeq), neuron(iDb).tuning);
    neuron(iDb).rot_cortex_basal(iSeq) = rot_ret_stats(neuron(iDb).morph_basal(iSeq), neuron(iDb).retino_basal(iSeq), neuron(iDb).tuning);
    neuron(iDb).rot_cortex_apical(iSeq) = rot_ret_stats(neuron(iDb).morph_apical(iSeq), neuron(iDb).retino_apical(iSeq), neuron(iDb).tuning);

    end
        fprintf('%s neuron %d completed. %d of %d \n', db(iDb).animal, db(iDb).neuron_id, iDb, nDb);

end


% for iDb = 1:nDb
%     
%     for iSeq = 1:numel(neuron(iDb).morph)
%     neuron(iDb).retino_aligned(iSeq).stats = tree_angular_stats(neuron(iDb).retino_aligned(iSeq) );
%     end
% end

%%
for iDb = 1:nDb
    if numel(neuron(iDb).tuning)>1
        plot_dendrotomy(neuron(iDb));
    end
end

%        plot_dendrotomy(neuron) ;
% plot_responses(neuron(41:end))

% plot_responses(neuron([22 29 20 37 40 43 47  21 27]))
% plotSweepResp_LFR(neuron(24).tuning.allResp(:, :,:), neuron(24).tuning.time, 2);
%%

 plot_dendrotomy_stats(neuron);

plot_neurons_stats(neuron, 'all');
plot_neurons_stats(neuron, 'basal');
plot_neurons_stats(neuron, 'apical');


%% Align trees according to preferred direction

for iDb = 1:nDb
    
    
    cameraLucida.plot_treeTuning(neuron(iDb));
    
end

% cameraLucida.tree_poolHist(neuron, 'rot_cortex_allo');
% cameraLucida.tree_poolHist(neuron, 'rot_cortex');
% cameraLucida.tree_poolHist(neuron, 'retino');
% cameraLucida.tree_poolHist(neuron, 'rot_cortex_vert');

%% plot all neurons on a canvas
%  sort_idx = [28,30,29,5,1,8,4,11,9,31,13,12,19,18,22,6,3,7,2,39,10,32,23,42,15,43,33,26,34,25,35,46,40,38,20,44,47,17,48,36,37,14,45,41,24];
plot_forest(neuron(sort_idx), 'canvas', 20);

