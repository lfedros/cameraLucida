function sig_px = threshold_map(img, foreground, tmode, thrs)

nan_idx = isnan(img);
img(nan_idx) =0;
amp_mimg = imtophat(img, strel('disk', 2));
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


end