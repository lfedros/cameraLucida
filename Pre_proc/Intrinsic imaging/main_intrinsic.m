%%
clear;
addpath(genpath('C:\Users\Federico\Documents\GitHub\cameraLucida\Pre_proc\Intrinsic imaging'));

%% build exp ref
% ExpRef = '2022-02-10_5_FR206'; % anaesthesia, 1.45h
% ExpRef = '2021-12-20_1_FR206';% awake, 1.45h
ExpRef = '2021-12-13_7_FR206'; % anaesthesia, 45min
%% compute the maps
maps = analyzeKalatskyBscope(ExpRef);
h = plotPreferenceMaps(maps .maps, maps.pars, true, 'alpha');

%% save
video_file = dat.expFilePath(ExpRef, 'intrinsic', 'master');
save_to = [video_file(1:end-4), '_maps.mat'];
save(save_to, 'maps');


%% analyse previous maps
clear;
addpath(genpath('C:\Users\Federico\Documents\GitHub\fusiBox'));
addpath('C:\Users\Federico\Documents\GitHub\EyeTracking');

ExpRef = '2022-02-10_5_FR206'; % anaesthesia, 1.45h
%% load intrinsic maps
video_file = dat.expFilePath(ExpRef, 'intrinsic', 'master');
save_to = [video_file(1:end-4), '_maps.mat'];
load(save_to, 'maps');

%% load image to align

twoP_vasculature = [];

%% Select points for alignment

wifi_vasculature = maps.meanFrame;
clear input_points base_points
cpselect(wifi_vasculature, wifi_vasculature); % don't forget to export input_points/base_points to workspace

%% Do the alignment

mytform = cp2tform(input_points, base_points, 'nonreflective similarity');

registered = imtransform(photo2, mytform,'FillValues',1,...
    'XData', [1 size(photo1,2)],...
    'YData', [1 size(photo1,1)]);
registered(registered>1) = 1;

% show the results of the alignment
figure; clf; ax = gridplot(1,3);
axes(ax(1)); image( photo1 ); axis image
axes(ax(2)); imagesc( registered ); axis image
axes(ax(3)); image( photo2 ); axis image
title(ax(1),'Cam 1');
title(ax(2),'Cam 2, realigned');
title(ax(3),'Cam 2');
set(ax,'nextplot','add')
plot( ax(1), base_points(:,1), base_points(:,2), 'ro' );
plot( ax(2), base_points(:,1), base_points(:,2), 'ro' );
colormap bone

if strcmpi(animal,'M111108_AB')
    save(fullfile(DIRS.datafiles,sprintf('alignment-%s-%d-%d',animal,iseries,iexp)),...
        'input_points','base_points','photo1','photo2','registered');
else
    save(fullfile(DIRS.datafiles,sprintf('alignment-%s-%d-%d-RF%s',animal,iseries,iexp,RF)),...
        'input_points','base_points','photo1','photo2','registered');
end

%%














figure; 


norm_map = maps.maps.blank.amplitude;
norm_map(norm_map == Inf) = NaN;
norm_map(isnan(norm_map)) = nanmax(norm_map(:));
norm_map = imgaussfilt(norm_map,2)/max(norm_map(:));

maps.maps.ypos.amplitude = imgaussfilt(maps.maps.ypos.amplitude)./...
    norm_map;
maps.maps.ypos.amplitude = imgaussfilt(maps.maps.ypos.amplitude)./...
      norm_map;

h = plotPreferenceMaps(maps .maps, maps.pars, true, 'alpha');

%%
figure;

subplot(1,2,1)
imagesc(out.maps.xpos.amplitude)