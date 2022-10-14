function stitch_map = stitch_px_map(dendrite)

%% create fov image in common reference

Ly = max(abs(cat(2, dendrite(:).fov_y_um)));
Lx = max(abs(cat(2, dendrite(:).fov_x_um)));

x_um = -Lx:0.2:Lx;
y_um = -Ly:0.2:Ly;



for iD = 1: numel(dendrite)

fov_x_um = dendrite(iD).fov_x_um(dendrite(iD).yrange(1):dendrite(iD).yrange(2));
fov_y_um = dendrite(iD).fov_y_um(dendrite(iD).xrange(1):dendrite(iD).xrange(2));


    bw = zeros(size(dendrite(iD).pixelMap.mimg));
    nBranch = numel(dendrite(iD).pixelMap.doi);
    for iB = 1:nBranch
        bw(dendrite(iD).pixelMap.doi{iB}) = 1; 
    end

     % stitch branches rois
    this_den =  bw;


% [numel(fov_x_um), numel(fov_y_um)]
% 
% size(this_den)
% 
% end
    bw = interp2(fov_x_um', fov_y_um, this_den, x_um', y_um, 'linear',NaN);
    bw(bw>0) = 1;
    branch_bw(:,:,iD) = bw;
    
    % stitch img
    
    this_den =  dendrite(iD).pixelMap.mimg;
    mimg(:,:,iD) = interp2(fov_x_um', fov_y_um, this_den, x_um', y_um, 'linear',NaN);

    % stitch pixel maps
    this_den =  dendrite(iD).pixelMap.dir;
    dir(:,:,iD) = interp2(fov_x_um', fov_y_um, this_den, x_um', y_um, 'linear',NaN);
    this_den =  dendrite(iD).pixelMap.ori;
    ori(:,:,iD) = interp2(fov_x_um', fov_y_um, this_den, x_um', y_um, 'linear',NaN);

     se = strel('disk', 20);
    this_den =  imtophat(dendrite(iD).meanImg, se);
   
    this_den =  mat2gray(this_den./max(this_den(:)), [0.02, 1]);

    img_ref(:,:,iD) = interp2(dendrite(iD).fov_x_um', dendrite(iD).fov_y_um, this_den, x_um', y_um, 'linear',NaN);


end

%%
stitch_map.mimg = nanmax(img_ref,[],3);

stitch_map.ori = nanmean(ori, 3);
stitch_map.dir = nanmean(dir, 3);
stitch_map.branch_bw = nanmax(branch_bw, [], 3);
stitch_map.ref_img = nanmax(mimg, [], 3);

soma = zeros(size(stitch_map.ref_img));
soma(y_um >-10 & y_um < 10  , x_um >-10 & x_um < 10 ) =1;

nan_idx_ori = isnan(stitch_map.ref_img) | stitch_map.branch_bw <1;
% nan_idx = isnan(stitch_map.ref_img) | stitch_map.branch_bw <1;
nan_idx_img = nan_idx_ori;
nan_idx_img(soma>0) = 0;

stitch_map.ref_img = imadjust(stitch_map.ref_img);
stitch_map.mimg = imadjust(stitch_map.mimg);
% stitch_map.mimg(nan_idx) = 0;
stitch_map.ori(nan_idx_ori) = 0;
stitch_map.dir(nan_idx_ori) = 0;
stitch_map.ref_img(nan_idx_ori) = 0;

stitch_map.mimg(nan_idx_img) = 0;

% nan_idx = (isnan(stitch_map.ref_img) | stitch_map.branch_bw <1) & soma<0;




stitch_map.x_um = x_um;
stitch_map.y_um = y_um;
%%
plot_px_map(stitch_map, 'gratings', 0.5)


%%


% figure; imagesc(stitch_map.x_um, stitch_map.y_um, stitch_map.mimg);
% axis image; hold on
% formatAxes
% colormap(1-gray);

% spines_x_um = double(cat(2, dendrite(:).X));
% spines_y_um = double(cat(2, dendrite(:).Y));
% plot(spines_x_um, spines_y_um, 'or');