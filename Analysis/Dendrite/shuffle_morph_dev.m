function [ shuf_stats, shuf_idx] = shuffle_morph_dev(neuron, nSh, shuf_type)
% shuffle dendritic reconstructions

%% set up and initialise
if nargin <2
    nSh = 1000;
end

nDb = numel(neuron);
shuf_idx = zeros(nSh, nDb);

for iDb = 1: nDb
    prefDir(iDb) = neuron(iDb).tuning.prefDir;
end
prefOri = prefDir;
prefOri(prefDir>180) = prefDir(prefDir>180)-180;

for iSh = 1:nSh
    for iDb = 1: nDb
        
        bounds =  [prefOri(iDb)-45, prefOri(iDb)+45];
        bounds(bounds<0) = bounds(bounds<0)+180;
        bounds(bounds>=180) = bounds(bounds>=180)-180;
        bounds = sort(bounds,'ascend');
        prefOrth =find(prefOri <bounds(1) | prefOri >=bounds(2));

        oppositeOri(iSh, iDb) = prefOrth(randi(numel(prefOrth)));

    end
end

for iSh = 1:nSh
    shuf_idx(iSh, :) = randperm(nDb);
end
shuf_ang = rand(nSh, nDb)*360;
%% shuffle
shuf_stats = struct;
mapSize = numel(neuron(1).tree_deg.ang_map_bins);
angBinsL = numel(neuron(1).tree_deg.ang_bins)-1;
axBinsL = numel(neuron(1).tree_deg.ax_bins)-1;

shuf_stats.aligned_treeMap = zeros(mapSize, mapSize, nSh);
shuf_stats.aligned_ang_density = zeros(angBinsL, nSh);
shuf_stats.aligned_axial_density = zeros(axBinsL , nSh);
shuf_stats.neuron_ang_density = zeros(angBinsL, nDb);
shuf_stats.neuron_axial_density = zeros(axBinsL , nDb);
for iSh = 1:nSh
    for iDb = 1: nDb
        shuf_neuron = neuron(iDb);
        
        switch shuf_type
            case 'morph'
%                 shuf_neuron.tree_um = neuron(shuf_idx(iSh, iDb)).tree_um;
                                shuf_neuron.tree_um = neuron(oppositeOri(iSh, iDb)).tree_um;

%                 shuf_neuron.tree_um = rotate_tree(shuf_neuron.tree_um, shuf_ang(iSh, iDb));
            case 'ret'
                shuf_neuron.tree_um = neuron(shuf_idx(iSh, iDb)).tree_um;
                shuf_neuron.tuning.prefDir= neuron(shuf_idx(iSh, iDb)).tuning.prefDir;

            case 'dir'
                shuf_neuron.tuning.prefDir= neuron(shuf_idx(iSh, iDb)).tuning.prefDir;
        end
             
        shuf_neuron.tree_deg = load_visual_morph(shuf_neuron,0);
        shuf_neuron.tree_deg = tree_angular_stats(shuf_neuron.tree_deg);
        shuf_neuron.tree_deg_aligned = rotate_tree(shuf_neuron.tree_deg, shuf_neuron.tuning.prefDir);
        shuf_neuron.tree_deg_aligned = tree_angular_stats(shuf_neuron.tree_deg_aligned);
        
        shuf_stats.dendriteOri(iSh, iDb) =  shuf_neuron.tree_deg.circ_mean;
        shuf_stats.aligned_dendriteOri(iSh, iDb) =  unwrap_angle(pi/2-shuf_neuron.tree_deg_aligned.circ_axial_mean, 1);
        
        shuf_neuron.tree_deg_aligned.ang_map = shuf_neuron.tree_deg_aligned.ang_map/max(shuf_neuron.tree_deg_aligned.ang_map(:));
        shuf_stats.aligned_treeMap (:,:,iSh) = shuf_stats.aligned_treeMap (:,:,iSh) +...
                     shuf_neuron.tree_deg_aligned.ang_map/nDb;   
        
                 ang_bins = shuf_neuron.tree_deg_aligned.ang_bins;
                 coaxial_bins = (ang_bins<=3*pi/4 & ang_bins>pi/4) | (ang_bins>=(-3*pi/4) & ang_bins<(-pi/4));
                 shuf_stats.coax(iSh, iDb) = sum(shuf_neuron.tree_deg_aligned.ang_density(coaxial_bins(1:end-1)));
                 shuf_stats.ortho(iSh, iDb) = sum(shuf_neuron.tree_deg_aligned.ang_density(~coaxial_bins(1:end-1)));
                 
               shuf_stats.axial_var(iSh, iDb) =shuf_neuron.tree_deg_aligned.circ_axial_var;
               
        shuf_stats.aligned_ang_density (:,iSh) = shuf_stats.aligned_ang_density (:,iSh) +...
                     shuf_neuron.tree_deg_aligned.ang_density'/nDb;
        
        shuf_stats.aligned_axial_density(:,iSh) = shuf_stats.aligned_axial_density(:,iSh) +...
            shuf_neuron.tree_deg_aligned.axial_density'/nDb;
        
        shuf_stats.neuron_ang_density (:,iDb) = shuf_stats.neuron_ang_density (:,iDb) +...
            shuf_neuron.tree_deg_aligned.ang_density'/nSh;
        
        shuf_stats.neuron_axial_density(:,iDb) = shuf_stats.neuron_axial_density(:,iDb) +...
            shuf_neuron.tree_deg_aligned.axial_density'/nSh;
    end
    
    disp(iSh);
end


end