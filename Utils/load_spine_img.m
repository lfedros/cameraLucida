function rois = load_spine_img(neuron)

% load the data from each imaged dendrite
[~, spine_folder] = build_path(neuron.db, 'spine_size_seq');

nDendrites =  numel(neuron.db.spine_size_seq);

tiff_file = dir(fullfile(spine_folder, '*tif*'));

stack = img.loadFrames(fullfile(spine_folder, tiff_file.name));
stack = single(stack);

% read imageJ 'listed' ROIprops: {Index, Name, Type, Group, X, Y, Width, Height, Points, COlor, Fill, LWidth, Pos, C, Z, T}

%%

[fov_X, fov_Y] = ppbox.zoom2fov(neuron.db.morph.zoom);

px_sz_x = fov_X/size(stack, 2);
px_sz_y = fov_Y/size(stack, 1);
px_sz_z = neuron.db.morph.zStep;


for iD = 1: nDendrites

    imgJ_import = readtable(fullfile(spine_folder, neuron.db.spine_size_seq{iD}));

    head = contains(imgJ_import.Name(:), 's');

    rois(iD).name =cat(1, imgJ_import.Name(head));

%     rois(iD).head_coords =cat(2, imgJ_import.X(head), imgJ_import.Y(head), imgJ_import.Z(head));
%     rois(iD).den_coords =cat(2, imgJ_import.X(~head), imgJ_import.Y(~head), imgJ_import.Z(~head));

    rois(iD).head_X = imgJ_import.X(head)+ imgJ_import.Width(head)/2;
    rois(iD).head_Y = imgJ_import.Y(head) + imgJ_import.Height(head)/2;
    rois(iD).head_Z = imgJ_import.Z(head);

    rois(iD).den_X = imgJ_import.X(~head)+ imgJ_import.Width(~head)/2;
    rois(iD).den_Y = imgJ_import.Y(~head) + imgJ_import.Height(~head)/2;
    rois(iD).den_Z = imgJ_import.Z(~head);
    

    rois(iD).head_angle = cart2pol(-rois(iD).head_X + rois(iD).den_X, rois(iD).head_Y - rois(iD).den_Y);
    
    rois(iD).den_L = sqrt((range(rois(iD).den_X)*px_sz_x).^2 + (range(rois(iD).den_Y)*px_sz_y).^2 + (range(rois(iD).den_Z)*px_sz_z).^2);


    if contains(neuron.db.spine_size_seq{iD}, 'red') || contains(neuron.db.spine_size_seq{iD}, 'blue')
        rois(iD).den_type = 'orth';

    elseif contains(neuron.db.spine_size_seq{iD}, 'green')

        rois(iD).den_type = 'para';

    end
    rois(iD).nRoi = sum(head); 

    rois(iD).spines_per_um = rois(iD).nRoi/ rois(iD).den_L;

    x_win = -10:10;
    y_win = -10:10;
    z_win = -4:4;

   for iR = 1:rois(iD).nRoi 
   
rois(iD).type(iR) = rois(iD).den_type(1);
       x = x_win + rois(iD).head_X(iR);
       y = y_win + rois(iD).head_Y(iR);
       z = z_win + rois(iD).head_Z(iR);

   [yq, xq, zq] = ndgrid(y, x, z);

   rois(iD).stack{iR} = interpn(stack, yq, xq, zq);
  

   rois(iD).img(:,:,iR)= max(rois(iD).stack{iR}, [],3);

    
   % highpass a bit
   se = strel('disk', 4); % spine is 5 pixels wide, hardcoded. NEEDS CONVERSION TO MICRONS

   rois(iD).img(:,:,iR) =  imtophat(rois(iD).img(:,:,iR), se);

   % normalise to dendrite branch fluorescence
   den_X_rel = rois(iD).den_X(iR) - rois(iD).head_X(iR) + numel(x_win)/2;
   den_Y_rel = rois(iD).den_Y(iR) - rois(iD).head_Y(iR) + numel(y_win)/2;

   rois(iD).den_fluo(iR) = max(makeVec(interpn(rois(iD).img(:,:,iR), ...
       den_Y_rel-2:den_Y_rel+2, den_X_rel-2:den_X_rel+2)));

%    rois(iD).den_fluo(iR) = mean(makeVec(interpn(stack, ...
%        rois(iD).den_Y(iR)-1:rois(iD).den_Y(iR)+1, rois(iD).den_X(iR)-1:rois(iD).den_X(iR)+1, rois(iD).den_Z(iR)-1:rois(iD).den_Z(iR)+1)));

   rois(iD).img(:,:,iR)= rois(iD).img(:,:,iR)/rois(iD).den_fluo(iR);

   % rotate to align
   rois(iD).img_rot(:,:,iR) = imrotate(rois(iD).img(:,:,iR), -rad2deg(rois(iD).head_angle(iR)) -90, 'bilinear', 'crop');
   end

   rois(iD).img_rot_crop = rois(iD).img_rot(4:end-3,4:end-3,:);

   rois(iD).profile_H = flip(squeeze(rois(iD).img_rot_crop(:, ceil(size(rois(iD).img_rot_crop,2)/2), :)),1);

   rois(iD).profile_H_units = y_win(4:end-3);

   for iR = 1:rois(iD).nRoi 

   [~,peak(iR)] = max(rois(iD).img_rot_crop(7:10,ceil(size(rois(iD).img_rot_crop,2)/2), iR),[],1);
      rois(iD).profile_W(:,iR) = squeeze(rois(iD).img_rot_crop(6+peak(iR), 3:end-2,iR));
   end

   rois(iD).peak = max(rois(iD).profile_W,[], 1);

%    rois(iD).profile_W = squeeze(rois(iD).img_rot_crop(ceil(size(rois(iD).img_rot_crop,1)/2), 3:end-2,:));

   rois(iD).profile_W_units = x_win(6:end-5);

   rois(iD).mimg = mean(rois(iD).img_rot_crop,3, 'omitnan');
end
%%
figure; 

for iD = 1: nDendrites
    switch rois(iD).den_type
        case 'orth'
            color = [0 0.5 1];
        case 'para'
            color = [1 0 0 ];
    end
subplot(nDendrites,3, (iD-1)*3 + 1)
imagesc(rois(iD).mimg); title(rois(iD).den_type);
caxis([0 1]); axis image; colormap(1-gray); colorbar;
formatAxes
subplot(nDendrites,3,(iD-1)*3 + 2)
plot( rois(iD).profile_H_units, rois(iD).profile_H, 'Color', [0.2 0.2 0.2],'LineWidth', 0.5); hold on;
plot( rois(iD).profile_H_units, mean(rois(iD).profile_H,2, 'omitnan'),'Color', color, 'LineWidth', 2); hold on;
axis square
ylim([0 1])

formatAxes
subplot(nDendrites,3,(iD-1)*3 + 3)
plot( rois(iD).profile_W_units, rois(iD).profile_W, 'Color', [0.2 0.2 0.2], 'LineWidth', 0.5); hold on;
plot( rois(iD).profile_W_units, mean(rois(iD).profile_W, 2, 'omitnan'),'Color', color, 'LineWidth', 2); hold on;
ylim([0 1])
axis square
formatAxes
end




%
