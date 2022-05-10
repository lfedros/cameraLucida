function spines = map_spine_retino(neuron)

%% extract retinotopy

[ret_file, ret_path] = build_path(neuron.db, 'ret');

load(fullfile(ret_path, ret_file));

ret.vessels = fliplr(maps.meanFrame);
ret.azimuth = imgaussfilt(fliplr(maps.maps.xpos.prefPhase),1);
ret.azimuth = ret.azimuth*(-135)/(2*pi); % convert to degrees
ret.elevation = imgaussfilt(fliplr(maps.maps.ypos.prefPhase),1);
ret.elevation = 38 - ret.elevation*(76)/(2*pi); % convert to degrees

[Px_y, Px_x] = size(ret.azimuth);
ret.Px_sz_x = 3550/Px_x;
ret.Px_sz_y = 3550/Px_y;

ret.x_um = (1:Px_x) * ret.Px_sz_x;
ret.y_um = flip((1:Px_y) * ret.Px_sz_y,2);

ret.soma_um(1) = ret.x_um(neuron.db.retino.somaYX(2));
ret.soma_um(2) = ret.y_um(neuron.db.retino.somaYX(1));

ret.soma_ele = interp2(ret.x_um', ret.y_um, ret.elevation, ret.soma_um(1), ret.soma_um(2));
ret.soma_azi = interp2(ret.x_um', ret.y_um, ret.azimuth, ret.soma_um(1), ret.soma_um(2));

%%

% if doPlot

figure;
v = subplot(1,3,1);
imagesc(ret.x_um, ret.y_um, ret.vessels); colormap(v,'bone'); axis image; hold on; axis xy
plot(ret.soma_um(1), ret.soma_um(2), 'or')
title('Vessels')
colorbar;
a = subplot(1,3,2);
imagesc(ret.azimuth); axis image; colormap(a, 'hsv'); hold on;
plot(neuron.db.retino.somaYX(2), neuron.db.retino.somaYX(1), 'or')
title('Azimuth (deg)')
colorbar;
e = subplot(1,3,3);
imagesc(ret.elevation); axis image; colormap(e,'hsv');hold on;
plot(neuron.db.retino.somaYX(2), neuron.db.retino.somaYX(1), 'or')
title('Elevation (deg)')
colorbar;

% end

%% crop and upsample ret map around soma

crop_size = max(max(abs(spines.x_um)), max(abs(spines.y_um))) +5;

spines.map_x = ret.soma_um(1)- crop_size : ret.Px_sz_x/10: ret.soma_um(1)+ crop_size;
spines.map_y = ret.soma_um(2)- crop_size : ret.Px_sz_y/10: ret.soma_um(2)+ crop_size;

spines.map_ele = interp2(ret.x_um', ret.y_um, ret.elevation, spines.map_x', spines.map_y) - ret.soma_ele;
spines.map_azi = interp2(ret.x_um', ret.y_um, ret.azimuth, spines.map_x', spines.map_y) - ret.soma_azi;

spines.map_ele = imgaussfilt(spines.map_ele,5);
spines.map_azi = imgaussfilt(spines.map_azi,5);

%%

spines.map_x = spines.map_x - ret.soma_um(1) ;
spines.map_y = spines.map_y - ret.soma_um(2);

spines.azimuth = interp2(spines.map_x', spines.map_y , spines.map_azi, spines.x_um, spines.y_um);

spines.elevation = interp2(spines.map_x', spines.map_y , spines.map_ele, spines.x_um, spines.y_um);

%%

figure;
subplot(2,2,1)
imagesc(spines.map_x, spines.map_y, spines.map_azi); axis image; colormap hsv; hold on
plot(spines.x_um, spines.y_um, 'ok');
plot(0, 0, '*k')
axis image;

subplot(2,2,2)
imagesc(spines.map_x, spines.map_y, spines.map_ele); axis image; colormap hsv; hold on
plot(spines.x_um, spines.y_um, 'ok');
plot(0, 0, '*k')
axis image;



% %%
% theta = spines.soma_ori;
% R = [cosd(theta) sind(theta); -sind(theta) cosd(theta)]; % clockwise rotation
% coords = [spines.azimuth, spines.elevation];
% rot_coords = R*coords';
% 
% spines.azimuth_rot = rot_coords(1,:);
% spines.elevation_rot = rot_coords(2,:);
% 
% %%
% figure;
% imagesc(rad2deg(atan(spines.map_ele./spines.map_azi)))
% 
% %%
% spines.alpha = rad2deg(atan(spines.elevation./spines.azimuth));
% spines.d_alpha = spines.alpha- spines.soma_ori;
% spines.d_alpha = unwrap_angle(spines.d_alpha , 1, 1);
% spines.d_alpha = abs(spines.d_alpha);
% 
% [~,~,spines.d_alpha_bin] = histcounts(spines.d_alpha, [0:30:90]);
% 
% bins = 0:3;
% 
% for iB = 1:numel(bins)
% 
%     spines.spine_dist(iB) =  mean(spines.d_ori(spines.d_alpha_bin==bins(iB)));
%     spines.spine_count(iB) = sum(spines.d_alpha_bin==bins(iB));
%     %     spines.spine_density(iB) = mean(spines.density(spines.d_alpha_bin==bins(iB)));
% 
% end





end