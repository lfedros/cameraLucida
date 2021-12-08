function [shuf_neuron, shuf_stats, shuf_idx] = shuffle_morph(neuron, nSh)
% shuffle dendritic reconstructions

%% set up and initialise
if nargin <2
    nSh = 1000;
end

nDb = numel(neuron);
shuf_idx = [];

for iSh = 1:nSh
    shuf_idx(iSh, :) = randperm(nDb);
end

shuf_neuron = repmat(neuron,nSh,1);

%% shuffle

for iDb = 1: nDb
    
    for iSh = 1:nSh
%     shuf_neuron(iSh, iDb).tree_um = neuron(shuf_idx(iSh, iDb)).tree_um;
% %     shuf_neuron(iSh, iDb).tuning.prefDir= neuron(shuf_idx(iSh, iDb)).tuning.prefDir;
%     shuf_neuron(iSh, iDb).tree_deg = load_visual_morph(shuf_neuron(iSh, iDb),0);
%     shuf_neuron(iSh, iDb).tree_deg = tree_angular_stats(shuf_neuron(iSh, iDb).tree_deg);
%     shuf_neuron(iSh, iDb).tree_deg_aligned = rotate_tree(shuf_neuron(iSh, iDb).tree_deg, shuf_neuron(iSh, iDb).tuning.prefDir);   
%     shuf_neuron(iSh, iDb).tree_deg_aligned = tree_angular_stats(shuf_neuron(iSh, iDb).tree_deg_aligned);
%     
    shuf_neuron = neuron(iDb);
    shuf_neuron.tree_um = neuron(shuf_idx(iSh, iDb)).tree_um;
    
    shuf_neuron.tree_deg = load_visual_morph(shuf_neuron,0);
    shuf_neuron.tree_deg = tree_angular_stats(shuf_neuron.tree_deg);
    shuf_neuron.tree_deg_aligned = rotate_tree(shuf_neuron.tree_deg, shuf_neuron.tuning.prefDir);   
    shuf_neuron.tree_deg_aligned = tree_angular_stats(shuf_neuron.tree_deg_aligned);
   
    shuf_stats.dendriteOri(iSh, iDb) =  shuf_neuron.tree_deg.circ_mean;      
    shuf_stats.aligned_dendriteOri(iSh, iDb) =  unwrap_angle(pi/2+shuf_neuron.tree_deg_aligned.circ_axial_mean, 1);       
    shuf_stats.aligned_treeMap (:,:,iDb, iSh) = shuf_neuron.tree_deg_aligned.ang_map;
    
    shuf_stats.aligned_ang_density (:,iDb, iSh) = shuf_neuron.tree_deg_aligned.ang_density;
    shuf_stats.aligned_axial_density(:,iDb, iSh) = shuf_neuron.tree_deg.axial_aligned_density;
    
    end
    
    iDb
end

save(fullfile(neuron(1).data_repo, 'Processed', 'shuffle_morph.mat'), 'shuf_stats', 'shuf_idx', '-v7.3');

end