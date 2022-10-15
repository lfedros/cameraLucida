%% CODE to GENERATE SVD COMPRESSION from S2P REGISTERED MOVIES
clear;
%% database of the recording
i = 0;

i = i+1;
db(i).mouse_name    = 'FR213'; % animal name
db(i).date          = '2022-06-15'; % date of the recording
db(i).expts         = [4]; % all the experiments in the recording
db(i).nplanes       = 1;
db(i).s2p_version = 'python';
db(i).root_folder ='D:\OneDrive - University College London\Data\2P\';

%% Set path to relevant code

if ispc
    code_repo = 'C:\Users\Federico\Documents\GitHub\cameraLucida';
else
    code_repo = '/Users/lfedros/Documents/GitHub/cameraLucida';

end
cd(code_repo);
addpath(genpath(code_repo));
set_dendrite_paths(); % edit the paths pointing to the code, contains which packages to download

%% Use the .bin registered file from suite2p to compute SVD decomposition of each recording
for iExp = 1:numel(db)
    %takes a while to run (few mins per db)
    add_SVDcomps(db(iExp))
end

%% USE SVD COMPRESSED MOVIES TO GENERATE STAs MOVIE and TUNING PIXEL MAPS
clear;

%% Set path to relevant code

if ispc
    code_repo = 'C:\Users\Federico\Documents\GitHub\cameraLucida';
else
    code_repo = '/Users/lfedros/Documents/GitHub/cameraLucida';

end
cd(code_repo);
addpath(genpath(code_repo));
set_dendrite_paths(); % edit the paths pointing to the code, contains which packages to download
%% database of the recording
i = 0;

i = i+1;
db(i).mouse_name    = 'FR213'; % animal name
db(i).date          = '2022-06-15'; % date of the recording
db(i).expts         = [4]; % all the experiments in the recording
db(i).expID         = 1; % the experiment you want to compute pixel map of
db(i).expType  = 'gratings';
db(i).nplanes       = 1;
db(i).s2p_version = 'python';
db(i).root_folder ='D:\OneDrive - University College London\Data\2P\';

%% Use SVD compressed recording to make pixel maps

for iExp = 1:numel(db)
    % pxmap
    px_map= svd2pxmap(db, 1, db(i).expType);
    % run if you want to generate sta movie, otherwise comment out for
    % speed
    sta_mov= svd2mov_sta(db, 1, db(i).expType);

end

%manually select the dendrites of interest
px_map.doi = draw.freePolyROI(px_map.mimg);

% save px_map
