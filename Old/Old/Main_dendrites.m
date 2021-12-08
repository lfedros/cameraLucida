clear;

%% Set path to relevant code
addpath('C:\Users\Federico\Documents\GitHub\Dbs\V1_dendrites');
code_repo = 'C:\Users\Federico\Documents\GitHub\cameraLucida\new';
addpath(genpath(code_repo));
addpath(genpath('C:\Users\Federico\Documents\GitHub\treestoolbox'));
cd(code_repo);

%% Populate database
db_V1_dendrites;
nDb = numel(db);

%% Load the reconstructions

for iDb = 1:nDb
    neuron(iDb).db = db(iDb);
    neuron(iDb).morph = load_morph(db(iDb),'morph', 0);
    neuron(iDb).morph = tree_angular_stats(neuron(iDb).morph);
    
    neuron(iDb).morph_cut = load_morph(db(iDb),'morph_cut',0);
    neuron(iDb).morph_cut = tree_angular_stats(neuron(iDb).morph_cut);
end


%%
% cameraLucida.tree_density3D(neuron, 1, 1, [], true);
%% Load neurons tuning to drifting gratings

for iDb = 1:nDb
    neuron(iDb).tuning = load_tuning(neuron(iDb), 'vis', 0);
    neuron(iDb).tuning_cut = load_tuning(neuron(iDb), 'vis_cut', 0);
end

% cameraLucida.tree_poolTuning(neuron);

%% Load longitudinal data
for iDb = 1:nDb
    
        neuron(iDb).morph_seq = load_morph_longitudinal(db(iDb),0);
        if ~isempty(neuron(iDb).morph_seq)
        neuron(iDb).tuning_seq = load_tuning_longitudinal(neuron(iDb), 1);
        end
end

%% Map dendrites to retinotopy

for iDb = 1:nDb
    
    if strcmp(db(iDb).animal, 'FR175') && db(iDb).neuron_id == 7
        
        neuron(iDb).tuning.prefOri = unwrap_angle(neuron(iDb).tuning.prefDir + 90,1,1);
    end
    neuron(iDb).retino = load_visual_morph(db(iDb), neuron(iDb).morph, neuron(iDb).tuning.prefOri,0);
    neuron(iDb).retino = tree_angular_stats(neuron(iDb).retino);
    neuron(iDb).retino_aligned = rotate_tree(neuron(iDb).retino, neuron(iDb).tuning.prefDir);
    neuron(iDb).retino_aligned = tree_angular_stats(neuron(iDb).retino_aligned );
    
    neuron(iDb).retino_cut = load_visual_morph(db(iDb), neuron(iDb).morph_cut, neuron(iDb).tuning.prefOri,0);
    neuron(iDb).retino_cut = tree_angular_stats(neuron(iDb).retino_cut);
    neuron(iDb).retino_aligned_cut = rotate_tree(neuron(iDb).retino_cut, neuron(iDb).tuning.prefDir);
    neuron(iDb).retino_aligned_cut = tree_angular_stats(neuron(iDb).retino_aligned_cut );
    % pause;
    iDb
end

%%

for iDb = 1:nDb
    
    if strcmp(db(iDb).animal, 'FR175') && db(iDb).neuron_id == 7
        
        neuron(iDb).tuning.prefOri = unwrap_angle(neuron(iDb).tuning.prefDir + 90,1,1);
    end
    neuron(iDb).rot_cortex = rot_ret_stats(neuron(iDb).morph, neuron(iDb).retino, neuron(iDb).tuning);
    
    neuron(iDb).rot_cortex_cut = rot_ret_stats(neuron(iDb).morph_cut, neuron(iDb).retino, neuron(iDb).tuning);
    
    iDb
end


%%
for iDb = 1:nDb
    if ~isempty(neuron(iDb).tuning_cut)
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




