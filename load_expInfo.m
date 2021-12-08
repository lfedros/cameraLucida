function db = make_paths(db)

% 2020 N Ghani and LF Rossi

exp_id = [db.animal, '_', num2str(db.neuron_id)]; 
db.morph.path = fullfile(db.data_repo, exp_id, [exp_id, '_tracing.swc']);
db.retino.path = fullfile(db.data_repo, exp_id, [exp_id, '_neuRF_column_svd.mat']); 
db.visual.path = fullfile(db.data_repo, exp_id, [exp_id, '_orientationTuning.mat']); 


end