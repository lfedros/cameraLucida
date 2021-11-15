%%first run Main_dendrites_preprocessing

clear;

%% Set path to relevant code

if ispc
   code_repo = 'C:\Users\Federico\Documents\GitHub\cameraLucida\new';
else
code_repo = '/Users/lfedros/Documents/GitHub/cameraLucida/new';

end
cd(code_repo);
addpath(genpath(code_repo));
set_dendrite_paths();

%% Populate database
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
    
    neuron(iDb).morph = load_morph(db(iDb),db(iDb).morph_seq, 0, 0);
    
end

%% Load neurons tuning to drifting gratings

for iDb = 1:nDb
    
    neuron(iDb).tuning = load_tuning_longitudinal_dev(db(iDb),db(iDb).vis_seq, 0,0);
    
    % plot_responses(neuron(iDb)); plot responses if needed

end

%% Map dendrites to retinotopy

for iDb = 1:nDb
    
    if strcmp(db(iDb).animal, 'FR175') && db(iDb).neuron_id == 7
        
        neuron(iDb).tuning(1).prefOri = unwrap_angle(neuron(iDb).tuning(1).prefDir + 90,1,1);
    end
    neuron(iDb).retino =load_visual_morph_dev( neuron(iDb), neuron(iDb).tuning(1).prefOri,0, 0);

end

%% Measure some stats

for iDb = 1:nDb
    
    for iSeq = 1:numel(neuron(iDb).morph)

    neuron(iDb).morph(iSeq).stats = tree_angular_stats(neuron(iDb).morph(iSeq));

    
    neuron(iDb).retino(iSeq).stats = tree_angular_stats(neuron(iDb).retino(iSeq));


    neuron(iDb).retino_aligned(iSeq) = rotate_tree(neuron(iDb).retino(iSeq), neuron(iDb).tuning(1).prefDir);
           

    neuron(iDb).rot_cortex(iSeq) = rot_ret_stats(neuron(iDb).morph(iSeq), neuron(iDb).retino(iSeq), neuron(iDb).tuning);
    end
    
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
% plot_responses(neuron([44 41 38 35 34 31 32 33 45]))
% plotSweepResp_LFR(neuron(24).tuning.allResp(:, :,:), neuron(24).tuning.time, 2);
%%

plot_dendrotomy_stats(neuron);

plot_neurons_stats(neuron);


%% Align trees according to preferred direction

for iDb = 1:nDb
    
    
    cameraLucida.plot_treeTuning(neuron(iDb));
    
end

% cameraLucida.tree_poolHist(neuron, 'rot_cortex_allo');
% cameraLucida.tree_poolHist(neuron, 'rot_cortex');
% cameraLucida.tree_poolHist(neuron, 'retino');
% cameraLucida.tree_poolHist(neuron, 'rot_cortex_vert');

%%
cameraLucida.plot_allTrees(neuron);
%%
plot_forest(neuron, 'canvas', 20);


