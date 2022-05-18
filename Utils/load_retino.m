function ret = load_retino(neuron, doPlot)

if nargin <2
    doPlot = false;
end

%% extract retinotopy

[ret_file, ret_path] = build_path(neuron.db, 'ret');

load(fullfile(ret_path, ret_file));

% ret.valid = imgaussfilt(maps.maps.ypos.amplitude,3) + imgaussfilt(maps.maps.xpos.amplitude,3);
% ret.valid = ret.valid >0.004;
% ret.valid = imerode(ret.valid,strel('disk', 20));
% ret.valid = imdilate(ret.valid,strel('disk', 15));

ret.vessels = fliplr(maps.meanFrame);
ret.azimuth = imgaussfilt(fliplr(maps.maps.xpos.prefPhase),5);
ret.azimuth = ret.azimuth*(-135)/(2*pi); % convert to degrees
ret.elevation = imgaussfilt(fliplr(maps.maps.ypos.prefPhase),5);
ret.elevation = 38 - ret.elevation*(76)/(2*pi); % convert to degrees

[Px_y, Px_x] = size(ret.azimuth);
ret.Px_sz_x = 3550/Px_x;
ret.Px_sz_y = 3550/Px_y;

ret.x_um = (1:Px_x) * ret.Px_sz_x;
ret.y_um = flip((1:Px_y) * ret.Px_sz_y,2);

ret.soma_um(1) = ret.x_um(neuron.db.retino.somaIJ(2));
ret.soma_um(2) = ret.y_um(neuron.db.retino.somaIJ(1));

ret.soma_ele = interp2(ret.x_um', ret.y_um, ret.elevation, ret.soma_um(1), ret.soma_um(2));
ret.soma_azi = interp2(ret.x_um', ret.y_um, ret.azimuth, ret.soma_um(1), ret.soma_um(2));

ret.x_um = ret.x_um- ret.soma_um(1);
ret.y_um = -ret.y_um+ ret.soma_um(2);


%% crop and upsample ret map around soma

ret.map_x_um = neuron.spines.stitch_den.x_um + ret.soma_um(1);
ret.map_y_um = neuron.spines.stitch_den.y_um + ret.soma_um(2);

ret.map_x_um = neuron.spines.stitch_den.x_um;
ret.map_y_um = neuron.spines.stitch_den.y_um;

ret.map_ele = interp2(ret.x_um', ret.y_um, ret.elevation, ret.map_x_um', ret.map_y_um) - ret.soma_ele;
ret.map_azi = interp2(ret.x_um', ret.y_um, ret.azimuth, ret.map_x_um', ret.map_y_um) - ret.soma_azi;

ret.map_ele = imgaussfilt(ret.map_ele,5);
ret.map_azi = imgaussfilt(ret.map_azi,5);

ret.map_angle = cart2pol(ret.map_azi, ret.map_ele);
ret.map_angle_axial = atan(ret.map_ele./ret.map_azi);

% %%
% 
% spines.map_x = spines.map_x - ret.soma_um(1) ;
% spines.map_y = spines.map_y - ret.soma_um(2);
% 
% spines.azimuth = interp2(spines.map_x', spines.map_y , spines.map_azi, spines.x_um, spines.y_um);
% 
% spines.elevation = interp2(spines.map_x', spines.map_y , spines.map_ele, spines.x_um, spines.y_um);

%%

if doPlot

figure;
v = subplot(2,3,1);
imagesc(ret.x_um, ret.y_um, ret.vessels); colormap(v,'bone'); axis image; hold on;
plot(0, 0, 'or')
title('Vessels')

a = subplot(2,3,2);
imagesc(ret.x_um, ret.y_um, ret.azimuth); axis image; colormap(a, 'jet'); hold on;
plot(0, 0, 'ok')
title('Azimuth (deg)')
colorbar;

e = subplot(2,3,3);
imagesc(ret.x_um, ret.y_um,ret.elevation); axis image; colormap(e,'jet');hold on;
plot(0, 0, 'ok')
title('Elevation (deg)')
colorbar;

s = subplot(2,3,4);
imagesc(ret.map_x_um, ret.map_y_um, neuron.spines.stitch_den.img); hold on;
plot(0, 0,'*r')
axis image; colormap(s, 1-gray);

am = subplot(2,3,5);
imagesc(ret.map_x_um, ret.map_y_um, ret.map_azi); axis image; colormap(am, 'jet'); hold on;
plot(0, 0,'*k')
title('Azimuth (deg)')
colorbar;

em = subplot(2,3,6);
imagesc(ret.map_x_um, ret.map_y_um, ret.map_ele); axis image; colormap(em,'jet');hold on;
plot(0,0, '*k')
title('Elevation (deg)')
colorbar;


end



% figure;
% subplot(2,2,1)
% imagesc(spines.map_x, spines.map_y, spines.map_azi); axis image; colormap hsv; hold on
% plot(spines.x_um, spines.y_um, 'ok');
% plot(0, 0, '*k')
% axis image;
% 
% subplot(2,2,2)
% imagesc(spines.map_x, spines.map_y, spines.map_ele); axis image; colormap hsv; hold on
% plot(spines.x_um, spines.y_um, 'ok');
% plot(0, 0, '*k')
% axis image;



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