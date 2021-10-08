function [file, folder] = build_path(db, type)

% 2020 N Ghani and LF Rossi

%%
if ispc
    data_repo = 'D:\OneDrive - University College London\Data\Dendrites';
else
    data_repo = '/Users/lfedros/OneDrive - University College London/Data/Dendrites';
end

%%
db_tag = [db.animal, '_', num2str(db.neuron_id)];
folder = fullfile(data_repo, db_tag);

if nargin>1
    switch type
        case 'morph'
            file = [db_tag, '_tracing.swc'];
            %             path = fullfile(folder, file);
            
        case 'morph_cut'
            file = [db_tag, '_tracing_cut.swc'];
            %             path = fullfile(folder, file);
            
        case 'morph_seq'
            file = dir(fullfile(folder, [db_tag, '*tracing.swc']));
            file = cat(1, file, dir(fullfile(folder, [db_tag, '*tracing_cut.swc'])));
            file = {file.name};
            for iF = 1:numel(file)
                file{iF} = [file{iF}(1:end-4),'_microns.swc'];
            end
        case 'ret'
            file = [db_tag, '_retinotopy.mat'];
            %             path = fullfile(folder, file);
        case 'vis'
            file = [db_tag, '_gratings.mat'];
            %             path = fullfile(folder, file);
        case 'vis_cut'
            file = [db_tag, '_gratings_dendrotomy.mat'];
            %             path = fullfile(folder, file);
        case 'vis_seq'
            file = dir(fullfile(folder, [db_tag, '*tracing.swc']));
            file = cat(1, file, dir(fullfile(folder, [db_tag, '*tracing_cut.swc'])));
            file = {file.name};
            for iF = 1:numel(file)
                idx = strfind(file{iF}, 'tracing.');
                if ~isempty(idx)
                    file{iF} = [file{iF}(1:idx-1),'tuning.mat'];
                else
                    idx = strfind(file{iF}, 'tracing_cut');
                    file{iF} = [file{iF}(1:idx-1),'tuning_cut.mat'];
            
                end
            end
            case 'ret_seq'
            file = dir(fullfile(folder, [db_tag, '*tracing.swc']));
            file = cat(1, file, dir(fullfile(folder, [db_tag, '*tracing_cut.swc'])));
            file = {file.name};
            for iF = 1:numel(file)
                idx = strfind(file{iF}, 'tracing.');
                if ~isempty(idx)
                    file{iF} = [file{iF}(1:idx-1),'tracing_deg.mat'];
                else
                    idx = strfind(file{iF}, 'tracing_cut');
                    file{iF} = [file{iF}(1:idx-1),'tuning_cut_deg.mat'];
            
                end
            end
    end
else
    file = [];
    path = [];
end
end