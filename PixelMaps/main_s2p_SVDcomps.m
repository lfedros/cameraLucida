%% CODE to GENERATE SVD COMPRESSION from S2P REGISTERED MOVIES
clear;
%% database of the recording
i = 0;

i = i+1;
db(i).mouse_name    = 'FR230'; % animal name
db(i).date          = '2022-12-01'; % date of the recording
db(i).expts         = [4]; % all the experiments in the recording
db(i).nplanes       = 4;
db(i).s2p_version = 'matlab';
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
clear;
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

% i = i+1;
% db(i).mouse_name    = 'FR230'; % animal name
% db(i).date          = '2022-12-01'; % date of the recording
% db(i).expts         = [4]; % all the experiments in the recording
% db(i).expID         = 1; % the experiment you want to compute pixel map of
% db(i).expType  = 'gratings';
% db(i).nplanes       = 4;
% db(i).s2p_version = 'matlab';
% db(i).root_folder ='D:\OneDrive - University College London\Data\2P\';

%% Use SVD compressed recording to make pixel maps

for iExp = 1:numel(db)
    % pxmap
    [px_map, px_rr]= svd2pxmap(db, 1, db(i).expType);
    % run if you want to generate sta movie, otherwise comment out for
    % speed
    sta_mov= svd2mov_sta(db, 2, db(i).expType);

end

%manually select the dendrites of interest
px_map.doi = draw.freePolyROI(px_map.mimg);

% save px_map
% add here your preferred way of saving px_map, rr, (sta_mov)



%% some test code

% pref_dir = angle(px_map.dir(:)); 

% resps = px_map.all_st.resp_sS*px_map.all_st.resp_sT;

% [~, dir_sort] = sort(pref_dir, 'ascend'); 
% 
% pref_amp = abs(px_map.dir); 
% 
% amp_thres = prctile(pref_amp, 99.8); 
% 
% amp_sg = pref_amp>amp_thres;
% 
% 
% resps = resps(dir_sort(amp_sg),:);
resps = px_rr.all_st.stim_resp;

[max_resp, dir_sort] = max(resps, [],2);

[ ~,dir_sort] = sort(dir_sort, 'ascend');

max_thres = prctile(max_resp, 95);

max_sg = max_resp >max_thres;

resps = resps(dir_sort(max_sg), :); 

resps = bsxfun(@minus, resps, min(resps, [], 2));
resps = bsxfun(@rdivide, resps, max(resps, [], 2));

figure; 
imagesc(resps)

figure;

for iSt = 1:numel(rr.st)
resps = px_rr.st(iSt).stim_resp;

[max_resp, dir_sort] = max(px_rr.all_st.stim_resp, [],2);

[ ~,dir_sort] = sort(dir_sort, 'ascend');

max_thres = prctile(max_resp, 95);

max_sg = max_resp >max_thres;

resps = resps(dir_sort(max_sg), :); 

resps = bsxfun(@minus, resps, min(resps, [], 2));
resps = bsxfun(@rdivide, resps, max(resps, [], 2));

subplot(1,numel(rr.st), iSt);
imagesc(resps)

end



