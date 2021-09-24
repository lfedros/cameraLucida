function path = build_path(db, type)

% 2020 N Ghani and LF Rossi

%%
if ispc
    data_repo = 'D:\OneDrive - University College London\Data\Dendrites';
else
    data_repo = '/Users/lfedros/OneDrive - University College London/Data/Dendrites';
end

%%
db_tag = [db.animal, '_', num2str(db.neuron_id)];

switch type
    case 'morph'
        path = fullfile(data_repo, db_tag, [db_tag, '_tracing.swc']);
    case 'morph_cut'
        path = fullfile(data_repo, db_tag, [db_tag, '_tracing_cut.swc']);
    case 'morph_seq'
        path{1} = fullfile(data_repo, db_tag, [db_tag, '_tracing.swc']);
        files = dir(fullfile(data_repo, db_tag, [db_tag, '_tracing_cut_*.swc']));
        path = cat(2, path, cellfun(@fullfile, {files.folder}, {files.name}, 'UniformOutput', false));    
    case 'ret'
        path = fullfile(data_repo, db_tag, [db_tag, '_retinotopy.mat']);
    case 'vis'
        path = fullfile(data_repo, db_tag, [db_tag, '_gratings.mat']);
    case 'vis_cut'
        path = fullfile(data_repo, db_tag, [db_tag, '_gratings_dendrotomy.mat']);
%     case 'vis_seq'
%         files = dir(fullfile(data_repo, db_tag, [db_tag, '_gratings_dendrotomy_*.mat']));
%         path = {files.name}; 
end

end