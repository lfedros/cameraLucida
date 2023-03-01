function combo_r = pxresp_combo(neuron)


nDendrites = numel(neuron.dendrite);
[~, spine_folder] = build_path(neuron.db);

dendrite = neuron.dendrite;

for iD = 1:nDendrites
%%
    bw = zeros(size(dendrite(iD).pixelMap.mimg));
    nBranch = numel(dendrite(iD).pixelMap.doi);
    for iB = 1:nBranch
        bw(dendrite(iD).pixelMap.doi{iB}) = 1; 
    end

    se = strel('disk', 20);
    this_den = dendrite(iD).meanImg(dendrite(iD).xrange(1):dendrite(iD).xrange(2), dendrite(iD).yrange(1):dendrite(iD).yrange(2));
    this_den =  imtophat(this_den, se);
    mimg =  mat2gray(this_den./max(this_den(:)), [0.02, 1]);


    amp_dir = abs(dendrite(iD).pixelMap.all_st.dir);
    amp_ori = abs(dendrite(iD).pixelMap.all_st.ori);

     % - threshold pixels based on intensity image
    thrs = 95; % threshold for significance, perctile of background
    filt_scale = 3;
    sig_mimg =threshold_map(mimg, bw, 'tile', thrs, filt_scale);

    filt_scale = 6;
    % - threshold pixels based on amplitude of direction tuning
    sig_dir = threshold_map(amp_dir, bw, 'tile', 99, filt_scale);

    filt_scale = 6;
    % - threshold pixels based on amplitude of orientation tuning
    sig_ori = threshold_map(amp_ori, bw, 'tile', 99, filt_scale);

    % - find pixels with no signal (amp = 0) and remove them
    
    sig_zero_amp = amp_ori ==0 | amp_dir ==0;

    % - combine all significant pixels
    sig_px = (sig_ori | sig_dir | sig_mimg) & ~sig_zero_amp;
    sig_px = (sig_ori | sig_dir)  & ~sig_zero_amp;

    %     figure; imagesc(sig_px)

    % remove noise (unconnected components smaller than 6 px)
    signal(iD).bw= bwareaopen(sig_px,6);
    %      figure; imagesc(signal(iD).bw)


%%

    load(fullfile(spine_folder, neuron.db.pix_resp{iD}));

    %%


%%
end




end