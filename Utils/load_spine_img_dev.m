function rois = load_spine_img_dev(neuron, doSave)

if nargin <2
    doSave  = 0; 
end


% load the data from each imaged dendrite
[~, spine_folder] = build_path(neuron.db, 'spine_size_seq');
% needs to be FRXXX_Y_2022_08_03_10_Roiset
nDendrites =  numel(neuron.db.spine_size_seq);

% read imageJ 'listed' ROIprops: {Index, Name, Type, Group, X, Y, Width, Height, Points, COlor, Fill, LWidth, Pos, C, Z, T}

rois = struct;
for iD = 1: nDendrites
    
    %% Load the data and extract useful info
    
    %     tiff_file = dir(fullfile(spine_folder, '*tif*'));
    idx = strfind(neuron.db.spine_size_seq{iD}, 'RoiSet');
    
    tiff_file = [neuron.db.spine_size_seq{iD}(1:idx-1), 'zStackMean_R.tif'];
    
    stack = img.loadFrames(fullfile(spine_folder, tiff_file));
    
    stack = single(stack);
    
    [fov_X, fov_Y] = ppbox.zoom2fov(neuron.db.morph.zoom);
    
    px_sz_x = fov_X/size(stack, 2);
    px_sz_y = fov_Y/size(stack, 1);
    px_sz_z = neuron.db.morph.zStep;
    
    imgJ_import = readtable(fullfile(spine_folder, neuron.db.spine_size_seq{iD}));
    
    head = contains(imgJ_import.Name(:), 's','IgnoreCase',true);
    
    rois(iD).name =cat(1, imgJ_import.Name(head));
    
    %     rois(iD).head_coords =cat(2, imgJ_import.X(head), imgJ_import.Y(head), imgJ_import.Z(head));
    %     rois(iD).den_coords =cat(2, imgJ_import.X(~head), imgJ_import.Y(~head), imgJ_import.Z(~head));
    
    rois(iD).head_X = imgJ_import.X(head)+ imgJ_import.Width(head)/2;
    rois(iD).head_Y = imgJ_import.Y(head) + imgJ_import.Height(head)/2;
    rois(iD).head_Z = imgJ_import.Pos(head); % Z does not work always
    
    rois(iD).den_X = imgJ_import.X(~head)+ imgJ_import.Width(~head)/2;
    rois(iD).den_Y = imgJ_import.Y(~head) + imgJ_import.Height(~head)/2;
    rois(iD).den_Z = imgJ_import.Pos(~head);
    
    rangeZ(1) = min(imgJ_import.Pos)-1;
    rangeZ(2) = max(imgJ_import.Pos)+1;
        
    rois(iD).head_angle = cart2pol(-rois(iD).head_X + rois(iD).den_X, rois(iD).head_Y - rois(iD).den_Y);
    
    if contains(neuron.db.spine_size_seq{iD}, 'red') || contains(neuron.db.spine_size_seq{iD}, 'blue')
        rois(iD).den_type = 'orth';
        
    elseif contains(neuron.db.spine_size_seq{iD}, 'green')
        
        rois(iD).den_type = 'para';
        
    end
    rois(iD).nRoi = sum(head);
    
    spine_sz = round(1/px_sz_x);
    
    x_win = -4*spine_sz:4*spine_sz; % window 4 spine size wide
    y_win = -4*spine_sz:4*spine_sz;
    z_win = -spine_sz:spine_sz;
    
    se = strel('disk', round(spine_sz*3)); % highpass filter at the scale of spines
    
    rois(iD).stack_mImg = max(imgaussfilt3(stack(:,:,rangeZ(1):rangeZ(2)), round([spine_sz/3,spine_sz/3, 1])), [], 3);

    rois(iD).stack_mImg = imtophat(rois(iD).stack_mImg, se);
%     
%     rois(iD).stack_mImg = imgaussfilt(rois(iD).stack_mImg, spine_sz/3);
%     
    se = strel('disk', round(spine_sz)); % highpass filter at the scale of spines

    %% Calculate spine density
    
    %calculate pairwise distance between spine origin on dendrites
    pd = pdist([rois(iD).den_X, rois(iD).den_Y, rois(iD).den_Z]);
    Z = squareform(pd);
    % find the maximum distance, this must correspond to the pari of
    % extremes of a dendrite, provided the dendrite does not curve by
    % >=90deg
    Zc = max(Z, [], 2);
    [~, ext]= max(Zc);
    
    %sort the points using the distance from one of the extremes
    [~, rois(iD).order] = sort(Z(:, ext), 'ascend');
    
    rois(iD).extremes = [rois(iD).order(1), rois(iD).order(end)];
    
    if rois(iD).den_X(rois(iD).extremes(1)) > rois(iD).den_X(rois(iD).extremes(2))
        rois(iD).extremes = [rois(iD).order(end), rois(iD).order(1)];
    end
%%
    rois(iD).den_angle = cart2pol(rois(iD).den_X(rois(iD).extremes(2))-rois(iD).den_X(rois(iD).extremes(1)),...
                            rois(iD).den_Y(rois(iD).extremes(2))-rois(iD).den_Y(rois(iD).extremes(1)));

    L1 = sqrt((rois(iD).den_X(rois(iD).extremes(2))-rois(iD).den_X(rois(iD).extremes(1))).^2 +...
        (rois(iD).den_Y(rois(iD).extremes(2))-rois(iD).den_Y(rois(iD).extremes(1))).^2);

    x_vec = linspace(rois(iD).den_X(rois(iD).extremes(1)), rois(iD).den_X(rois(iD).extremes(2)), ...
        L1);

    y_vec = linspace(rois(iD).den_Y(rois(iD).extremes(1)), rois(iD).den_Y(rois(iD).extremes(2)),...
        L1);
    % use the range of x and y to define the line
    x_c = mean(x_vec);
    y_c = mean(y_vec);
    
%     [x_grid, y_grid] = meshgrid(x_vec, y_vec);
    
    shifts = -100:100;

    y_shift =  shifts *cos(-rois(iD).den_angle);
    x_shift = shifts*sin(-rois(iD).den_angle);

    x_vec = x_vec(:) + x_shift;
    y_vec = y_vec(:) + y_shift;

    rois(iD).rot_mImg = interp2(rois(iD).stack_mImg, x_vec(:), y_vec(:));


 rois(iD).rot_head_X =  rois(iD).head_X -rois(iD).den_X(rois(iD).extremes(1));
  rois(iD).rot_head_Y =  rois(iD).head_Y -rois(iD).den_Y(rois(iD).extremes(1));

R = [cos(rois(iD).den_angle) sin(rois(iD).den_angle);...
    -sin(rois(iD).den_angle) cos(rois(iD).den_angle)];

rc = R*[rois(iD).rot_head_X(:)'; rois(iD).rot_head_Y(:)'];

rois(iD).rot_head_X = rc(1,:) +tan(-rois(iD).den_angle)./rc(2,:) ;
rois(iD).rot_head_Y= rc(2,:) + 101;

% for iS = 1:rois(iD).nRoi
%     [~, idx] = min(abs(x_vec(:) - rois(iD).head_X(iS)));
%     rois(iD).rot_head_X(iS) = x_vec(idx);
%     [~, idx] = min(abs(y_vec(:) - rois(iD).head_Y(iS)));
%     rois(iD).rot_head_Y(iS) = y_vec(idx);
% end

    rois(iD).rot_mImg = reshape(rois(iD).rot_mImg, size(x_vec))';
% figure; imagesc(rois(iD).stack_mImg); axis image
% figure; imagesc(rois(iD).rot_mImg); axis image; hold on
% plot(rois(iD).rot_head_X, rois(iD).rot_head_Y, 'or');
    %calculate total dendritic length by summing pairwise distances of
    %neighboring points
    %%
    rois(iD).den_L =0;
    
    for iR = 2:rois(iD).nRoi
       
       rois(iD).den_L = rois(iD).den_L + Z(rois(iD).order(iR-1), rois(iD).order(iR));  
       
    end
    
    rois(iD).spines_per_um = rois(iD).nRoi/ (rois(iD).den_L*px_sz_x);

    %     rois(iD).den_L = sqrt((range(rois(iD).den_X)*px_sz_x).^2 + (range(rois(iD).den_Y)*px_sz_y).^2 + (range(rois(iD).den_Z)*px_sz_z).^2);
    
    %% For each ROI, extract img, rotate to align, normalise to dendrite fluo, measure profiles
    
    for iR = 1:rois(iD).nRoi
        
        rois(iD).type(iR) = rois(iD).den_type(1);
        x = x_win + rois(iD).head_X(iR);
        y = y_win + rois(iD).head_Y(iR);
        z = z_win + rois(iD).head_Z(iR);
        
        [yq, xq, zq] = ndgrid(y, x, z);
        
        rois(iD).stack{iR} = interpn(stack, yq, xq, zq); % volume centered on spine head
        
        rois(iD).img(:,:,iR)= max(rois(iD).stack{iR}, [],3);
        
        % highpass a bit
        nonnanimg = rois(iD).img(:,:,iR);
        nonnanimg(isnan(nonnanimg)) = median(nonnanimg(:), 'omitnan');
        rois(iD).img(:,:,iR) = nonnanimg;
        rois(iD).img_filt(:,:,iR) =  imtophat(nonnanimg, se);
%         rois(iD).img_filt(:,:,iR) =  imgaussfilt(nonnanimg, spine_sz/4);

        % normalise to dendrite branch fluorescence
        den_X_rel = rois(iD).den_X(iR) - rois(iD).head_X(iR) + numel(x_win)/2; % coordinate of the dendrite in the roi centered on the spine
        den_Y_rel = rois(iD).den_Y(iR) - rois(iD).head_Y(iR) + numel(y_win)/2;
        
        rois(iD).den_fluo(iR) = max(makeVec(interpn(rois(iD).img_filt(:,:,iR), ...
            den_Y_rel-round(spine_sz/2):den_Y_rel+round(spine_sz/2), den_X_rel-round(spine_sz/2):den_X_rel+round(spine_sz/2)))); % change
        
        %    rois(iD).den_fluo(iR) = mean(makeVec(interpn(stack, ...
        %        rois(iD).den_Y(iR)-1:rois(iD).den_Y(iR)+1, rois(iD).den_X(iR)-1:rois(iD).den_X(iR)+1, rois(iD).den_Z(iR)-1:rois(iD).den_Z(iR)+1)));
        
        rois(iD).img_filt(:,:,iR)= rois(iD).img_filt(:,:,iR)/rois(iD).den_fluo(iR);
        
        % rotate to align
        rois(iD).img_rot(:,:,iR) = imrotate(rois(iD).img_filt(:,:,iR), -rad2deg(rois(iD).head_angle(iR)) -90, 'bilinear', 'crop');
        rois(iD).img_raw_rot(:,:,iR) = imrotate(rois(iD).img(:,:,iR), -rad2deg(rois(iD).head_angle(iR)) -90, 'bilinear', 'crop');

    end

        rois(iD).img_rot_crop = rois(iD).img_rot(2*spine_sz:end-(2*spine_sz-1),2*spine_sz:end-(2*spine_sz-1),:); % crop width to 2 spine size
        rois(iD).img_raw_rot_crop = rois(iD).img_raw_rot(2*spine_sz:end-(2*spine_sz-1),2*spine_sz:end-(2*spine_sz-1),:); % crop width to 2 spine size

        %%

%         peak = zeros(rois(iD).nRoi,2);
% 
%         for iR = 1:rois(iD).nRoi
%      crop = rois(iD).img_rot_crop(round(spine_sz/2):round(3*spine_sz/2),round(spine_sz/2):round(3*spine_sz/2), iR);
%      [~,idx] = max(crop(:));
%      [peak(iR,1), peak(iR,2)] =ind2sub(size(crop),idx);
%      peak(iR,:) = peak(iR,:) + round(spine_sz/2)-1;
% 
%  rois(iD).profile_H = flip(squeeze(rois(iD).img_rot_crop(:, peak(iR,2), :)),1); % Take slice trough spine head
%     rois(iD).profile_W(:,iR) = squeeze(rois(iD).img_rot_crop(peak(iR, 1), round(spine_sz/2):end-(round(spine_sz/2)-1),iR));
% 
%         end


%%
%     rois(iD).profile_H = flip(squeeze(rois(iD).img_rot_crop(:, ceil(size(rois(iD).img_rot_crop,2)/2), :)),1); % Take slice trough spine head
    
%     rois(iD).profile_H_units = y_win(2*spine_sz:end-(2*spine_sz-1));
    
    [nR, nC, ~] = size(rois(iD).img_rot_crop);
    peak = zeros(rois(iD).nRoi,1);
    for iR = 1:rois(iD).nRoi
        
        crosshair_row = round(nR/2-spine_sz/2):round(nR/2+ spine_sz/2);
        crosshair_col =  round(nC/2-spine_sz/2):round(nC/2+ spine_sz/2);

        [~, idx] =max(rois(iD).img_rot_crop(crosshair_row, crosshair_col), [], 'all');
        [peak_i(iR), peak_j(iR)] = ind2sub([numel(crosshair_row),numel(crosshair_col)], idx);

        peak_i(iR) = peak_i(iR) + crosshair_row(1) -1;
        peak_j(iR) = peak_j(iR) + crosshair_col(1) -1;

        rois(iD).profile_H(:,iR)  = flip(squeeze(rois(iD).img_rot_crop(:, peak_j(iR), iR)),1); % Take slice trough spine head

        rois(iD).profile_W(:,iR) = squeeze(rois(iD).img_rot_crop(peak_i(iR), round(spine_sz/2):end-(round(spine_sz/2)-1),iR));
        
    end
        
    %%
    % at this point W is 2 spine size
    rois(iD).peak = max(rois(iD).profile_W,[], 1);

    rois(iD).d_peak = (rois(iD).peak.*rois(iD).den_fluo - min(rois(iD).profile_W,[], 1).*rois(iD).den_fluo)./...
        (rois(iD).den_fluo);

    rois(iD).profile_H_units = y_win(2*spine_sz:end-(2*spine_sz-1));

rois(iD).profile_H_units = rois(iD).profile_H_units*px_sz_x;
    
    rois(iD).profile_W_units = x_win(2*spine_sz:end-(2*spine_sz-1));
    rois(iD).profile_W_units = rois(iD).profile_W_units(round(spine_sz/2):end-(round(spine_sz/2)-1));

rois(iD).profile_W_units = rois(iD).profile_W_units*px_sz_x;

    rois(iD).mimg = mean(rois(iD).img_rot_crop,3, 'omitnan');

   
end

%% Plot

% summary for each dendrite
for iD = 1: nDendrites
    
        figure('Position', [149 57 1186 742],'color', 'w', 'PaperOrientation', 'landscape');
        plot_single_spine(rois(iD).img_rot_crop)
%                 plot_single_spine(rois(iD).img_raw_rot_crop,1)

        if doSave
    print(fullfile(spine_folder, [neuron.db.spine_size_seq{iD}(1:end-4), '_all_spines_img.pdf']), '-painters','-dpdf', '-bestfit');
        end
    figure('Position', [149 57 1186 742],'color', 'w', 'PaperOrientation', 'landscape');
    
    switch rois(iD).den_type
        case 'orth'
            color = [0 0.5 1];
        case 'para'
            color = [1 0 0 ];
    end
    
    subplot(1,6, [1 2])
    imgg = mat2gray(rois(iD).rot_mImg);
    
%     imggr = imrotate(imgg, rois(iD).den_angle*180/pi);
    
vals = imgg(round(max(min(rois(iD).rot_head_X), 1)):round(min(max(rois(iD).rot_head_X), size(imgg,1))), round(max(min(rois(iD).rot_head_Y),1)):round(min(max(rois(iD).rot_head_Y),size(imgg,2))));
mini = prctile(vals(:), 20);
maxi = prctile(vals(:), 95);

    imagesc(imgg); axis image; hold on
    caxis([mini maxi]);
%     caxis([0 0.05])

    colormap(1-gray);
    scatter(rois(iD).rot_head_X, rois(iD).rot_head_Y, 3, color);
    xlim([min(rois(iD).rot_head_X)-3, max(rois(iD).rot_head_X)+3]);
    ylim([min(rois(iD).rot_head_Y)-3, max(rois(iD).rot_head_Y)+3]);
    formatAxes
    
    subplot(1,6, 3)
    imagesc(rois(iD).mimg); title(rois(iD).den_type);
    caxis([0 1]); axis image; colormap(1-gray); colorbar;
    formatAxes
    
    subplot(1,6,4)
    plot( rois(iD).profile_H_units, rois(iD).profile_H, 'Color', [0.2 0.2 0.2],'LineWidth', 0.5); hold on;
    plot( rois(iD).profile_H_units, mean(rois(iD).profile_H,2, 'omitnan'),'Color', color, 'LineWidth', 2); hold on;
    axis square
    ylim([0 1])
    
    formatAxes
    subplot(1,6,5)
    plot( rois(iD).profile_W_units, rois(iD).profile_W, 'Color', [0.2 0.2 0.2], 'LineWidth', 0.5); hold on;
    plot( rois(iD).profile_W_units, mean(rois(iD).profile_W, 2, 'omitnan'),'Color', color, 'LineWidth', 2); hold on;
    ylim([0 1])
    axis square
    formatAxes

    subplot(1,6,6)
    dist_bins = 0:0.1:1.5;
    all_spine_dist = histcounts( rois(iD).d_peak, dist_bins);
    bar(dist_bins(1:end-1), all_spine_dist, 'EdgeColor', color, 'FaceColor', color, 'FaceAlpha', 0.5); hold on
    axis square
    formatAxes
    ylabel('probability')
    xlabel(['Spine head F'])
    
    if doSave
    print(fullfile(spine_folder, [neuron.db.spine_size_seq{iD}(1:end-4), '.pdf']), '-painters','-dpdf', '-bestfit');
    end
end




% combined summary across all dendrites
figure('Position', [149 57 1186 742], 'color', 'w', 'PaperOrientation', 'landscape');

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

if doSave
print(fullfile(spine_folder, 'Dendrites summary'), '-painters','-dpdf');
end


%
