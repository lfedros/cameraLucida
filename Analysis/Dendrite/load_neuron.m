function neuron = load_neuron(db, doPlot)

% 2020 N Ghani and LF Rossi

if nargin < 2
doPlot = 0; 
end

exp_id = [db.animal, '_', num2str(db.neuron_id)]; 
neuron.morph_path = fullfile(db.data_repo, exp_id, [exp_id, '_tracing.swc']);
neuron.retino_path = fullfile(db.data_repo, exp_id, [exp_id, '_neuRF_column_svd.mat']); 
neuron.tuning_path = fullfile(db.data_repo, exp_id, [exp_id, '_orientationTuning.mat']); 

%% Step 1: load swc reconstruction

[neuron.tree_um,~,~] = load_tree(db.morph_path,'r'); % [pixels]

%% Step 2: scale reconstruction to um and center to the soma

load(db.retino_path, 'dbMorph');
neuron.tuning = load_tuning(db, doPlot)

[fov_x, fov_y] = ppbox.zoom2fov(dbMorph.zoom, [], dbMorph.date);

% center dendritic tree
neuron.X = neuron.X -neuron.X(1); % [px]
neuron.Y = neuron.Y -neuron.Y(1); % [px]
neuron.Y = neuron.Y* ( fov_y/512 ); % [um]
neuron.X = neuron.X* ( fov_x/512 ); % [um]
neuron.Z = neuron.Z* dbMorph.zStep; 

neuron = resample_tree( neuron, 1); % resample with uniform spacing

%% Step 3: plot, if requested

if doPlot
    figure('Color', 'w')
    hold on;
    plot_tree_lines(neuron);
    xlabel('ML[um] ');
    ylabel('RC[um] ');
    formatAxes
end


end





