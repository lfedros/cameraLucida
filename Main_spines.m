
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
db_V1_spines;
nDb = numel(db);

% count how many dendrites per neuron
for iDb = 1:nDb

%     [db(iDb).morph_seq] = build_path(db(iDb), 'morph_seq');
%     [db(iDb).vis_seq] = build_path(db(iDb), 'vis_seq');
    [db(iDb).ret_seq] = build_path(db(iDb), 'ret_seq');
        [db(iDb).spine_seq] = build_path(db(iDb), 'spine_seq');

    neuron(iDb).db = db(iDb);

end

%% load all dendrites and register their position to the soma in microns

for iDb = 1:nDb

   neuron(iDb).dendrite = load_dendrite(neuron(iDb));
 
end

%% pool position and visual properties across dendrites

for iDb = 1:nDb

   [neuron(iDb).spines, neuron(iDb).visual_spines] = pool_spines(neuron(iDb),1);
end

%% compute visual position of spines

for iDb = 1:nDb

   neuron(iDb).ret = load_retino(neuron(iDb),1);
   
end
%% compare distribution of preferred orientation to retinotopic position

for iDb = 1:nDb

   neuron(iDb).visual_spines = map_spine_retino(neuron(iDb).visual_spines, neuron(iDb).ret);
   
end


%% plot d_ori vs ret_angle joint dist

for iDb = 1:nDb

  neuron(iDb).visual_spines = plot_joint_ori_ret(neuron(iDb).visual_spines);
   
end



%%

load('D:\OneDrive - University College London\Data\Dendrites\FR212_2\FR212_2022-04-01_6_dendrite.mat');

figure; imagesc(meanImg); hold on; plot(centreMass(:,2), centreMass(:,1), 'or');

nSpines = numel(xpixs);

mapImg = zeros(size(meanImg));

for iSp = 1:nSpines

    spineIdx{iSp} = sub2ind(size(meanImg), ypixs{iSp}, xpixs{iSp});
    mapImg(spineIdx{iSp}) = iSp;

end

figure; imagesc(mapImg); colormap jet