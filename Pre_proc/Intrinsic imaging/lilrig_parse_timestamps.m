%% If the V's were parsed but the timestamps weren't saved
% This loads timeline, checks that the number of frames logged in timeline
% matches the frames recorded in the V's, and if so it saves the frame
% times in .timestamps file
%
% This is only used if something unusual happened in the preprocessing
% (most commonly because of a mismatch in actual and preprocessed
% experiments, e.g. experiments 1-4 were imaged but in the 'experiments'
% field of the preprocessing option there was only 2-4)
%
% If there is a larger issue e.g. timeline logged less frames than were
% actually recorded, manual inspection is necessary. In that case, run the
% next cell to load and check frame information.

animal = 'FR237'; % animal name
day = '2023-06-21'; % yyyy-mm-dd
experiments = [7]; % all experiments run that day (e.g. [1,2,3,4])

[data_path,file_exists] = lilrig_cortexlab_filename(animal,day,[],'imaging');

cam_times_blue = cell(length(experiments),1);
cam_times_purple = cell(length(experiments),1);

for curr_exp_idx = 1:length(experiments)   
    curr_exp = experiments(curr_exp_idx);
    
    % Load timeline
    timeline_filename = lilrig_cortexlab_filename(animal,day,curr_exp,'timeline');
    load(timeline_filename);
    
    timeline_cam_idx = strcmp({Timeline.hw.inputs.name}, 'pcoExposure');
    cam_samples = find(Timeline.rawDAQData(1:end-1,timeline_cam_idx) <= 2 & ...
        Timeline.rawDAQData(2:end,timeline_cam_idx) > 2) + 1;

    cam_time = Timeline.rawDAQTimestamps(cam_samples);
    
    % Load V's to check
    V_blue_fn = [data_path filesep num2str(curr_exp) filesep 'svdTemporalComponents_blue.npy'];
    V_purple_fn = [data_path filesep num2str(curr_exp) filesep 'svdTemporalComponents_purple.npy'];
    V_blue = readNPY(V_blue_fn);
    V_purple = readNPY(V_purple_fn);
    
    if length(cam_samples) ~= size(V_blue,1) + size(V_purple,1)
        error('Wrong number of recorded frames');
    end
    
    cam_times_blue{curr_exp_idx} = cam_time(1:2:end);
    cam_times_purple{curr_exp_idx} = cam_time(2:2:end);
end

frame_times_fn = 'svdTemporalComponents_blue.timestamps.npy';
for curr_exp_idx = 1:length(experiments)   
    curr_exp = experiments(curr_exp_idx);
    curr_exp_dir = [data_path filesep num2str(curr_exp)];
    
    if ~exist(curr_exp_dir,'dir')
        mkdir(curr_exp_dir);
    end
    writeNPY(cam_times_blue{curr_exp_idx},[curr_exp_dir filesep frame_times_fn]);
    disp('Saved blue timestamps')
end


frame_times_fn = 'svdTemporalComponents_purple.timestamps.npy';
for curr_exp_idx = 1:length(experiments)   
    curr_exp = experiments(curr_exp_idx);
    curr_exp_dir = [data_path filesep num2str(curr_exp)];
    
    if ~exist(curr_exp_dir,'dir')
        mkdir(curr_exp_dir);
    end
    writeNPY(cam_times_purple{curr_exp_idx},[curr_exp_dir filesep frame_times_fn]);
    disp('Saved purple timestamps')
end
