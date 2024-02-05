function sig_px = threshold_map(img, foreground, tmode, thrs, filt_scale, doPlot)

if nargin < 5
    filt_scale = 6;
end

if nargin <6
    doPlot = 0;
end

nan_idx = isnan(img);
img(nan_idx) =0;
amp_mimg = imtophat(img, strel('disk', filt_scale));
% amp_mimg = map(iD).mimg;
amp_mimg(nan_idx) = NaN;
amp_mimg = amp_mimg/nanmax(amp_mimg(:));

null_mimg = amp_mimg.*(foreground<1);
null_mimg(foreground>0) = NaN;

switch tmode
    case 'std'
        thres_mimg = nanmean(null_mimg(:)) + thrs*nanstd(null_mimg(:));

    case 'tile'

        thres_mimg = prctile(null_mimg(:), thrs);

end

sig_px = amp_mimg>thres_mimg & foreground>0;

sig_px  = bwareaopen(sig_px ,6, 4); % remove connected component with less than 6 pixels

if doPlot
figure; imagesc(sig_px )
end

end