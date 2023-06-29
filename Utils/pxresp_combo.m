function px_resp = pxresp_combo(neuron)


nDendrites = numel(neuron.dendrite);
[~, spine_folder] = build_path(neuron.db);

dendrite = neuron.dendrite;
signal_px = neuron.signal_px;

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
trial_stim_resps = px_rr.trial_stim_resp;

% some 'more aggressive' smoothing of responses
[nY, nX] = size(dendrite(iD).pixelMap.mimg); 

trial_stim_resps = reshape(trial_stim_resps, nY, nX, []);
% trial_stim_resps = imgaussfilt(trial_stim_resps, 1);
trial_stim_resps =  reshape(trial_stim_resps, nY*nX, []);

nStim = 12; nRep = size(trial_stim_resps, 2)/nStim; %nTfSf = numel(px_rr.st);

trial_stim_resps = reshape(trial_stim_resps, [], nStim, nRep);

resp = trial_stim_resps(signal(iD).bw(:),:,:);

dirs = -px_rr.p.dirs +360;
dirs(dirs>=360) = dirs(dirs>=360) -360;
[~, sort_dirs] = sort(dirs, 'ascend');

oris = px_rr.p.dirs; %[0 360]
oris(oris>=180) = oris(oris>=180)-180; %[0 180]
oris = oris - 90; %[-90 90]

resp = resp(:,sort_dirs, :);
%%
ave_px_resp = mean(resp, 3);
ave_px_resp = bsxfun(@minus, ave_px_resp, min(ave_px_resp, [], 2));
% ave_px_resp = ave_px_resp/ max(ave_px_resp(:));
% ave_px_resp = bsxfun(@rdivide, ave_px_resp, max(ave_px_resp, [], 2));

px_osi = circ_r(repmat(oris*2*pi/180, size(resp,1), 1), ave_px_resp, [],2);

edges =  [0:0.05:1];
px_resp(iD).px_osi_dist = histcounts(px_osi, edges);
px_resp(iD).px_osi_dist = px_resp(iD).px_osi_dist/sum(px_resp(iD).px_osi_dist);
px_resp(iD).px_osi_bins = edges(1:end-1);
% figure; bar(edges(1:end-1), px_osi_dist);

ave_px_resp_ori = (ave_px_resp(:, 1:6) + ave_px_resp(:, 7:12))/2;
ave_px_resp_ori = circGaussFilt(ave_px_resp_ori', 0.5)';

% pref_ori = angle(dendrite(iD).pixelMap.ori(signal(iD).bw(:)));
% 
[~, pref_ori] = max(ave_px_resp_ori, [],2);
[~, sort_ori] = sort(pref_ori, 'ascend');
% pref_ori = circ_mean(repmat(oris*2*pi/180, size(resp,1), 1), ave_px_resp, 2);
% [~, sort_ori] = sort(pref_ori, 'ascend');

px_resp(iD).ave_px_resp_ori_sort = ave_px_resp_ori(sort_ori, :); 
px_resp(iD).ave_px_ori_amp = sum(px_resp(iD).ave_px_resp_ori_sort,1);

if ~isempty(neuron.combo_px_map.soma_pref_ori)
soma_ori_shift = round(neuron.combo_px_map.soma_pref_ori/30);
else
soma_ori_shift = round(neuron.combo_px_map.pref_ori_norm/30);

end
if soma_ori_shift >2
    soma_ori_shift = -3;
end

% px_resp(iD).ave_px_resp_ori_sort_rel = circshift(px_resp(iD).ave_px_resp_ori_sort, -soma_ori_shift,2); 
px_resp(iD).ave_px_resp_ori_sort_rel = px_resp(iD).ave_px_resp_ori_sort; 

px_resp(iD).ave_px_ori_amp_rel = sum(px_resp(iD).ave_px_resp_ori_sort_rel,1);
px_resp(iD).n_px = size(px_resp(iD).ave_px_resp_ori_sort_rel,1);

% resps = bsxfun(@minus, resps, min(resps, [], 2));
% resps = bsxfun(@rdivide, resps, max(resps, [], 2));
end
%%
[~, d_sort] =sort(cat(1,px_resp(:).n_px), 'descend');

max_px = max(cat(1,px_resp(:).n_px));
max_input = max(makeVec(cat(1,px_resp(:).ave_px_ori_amp_rel)));
min_input = min(makeVec(cat(1,px_resp(:).ave_px_ori_amp_rel)));
min_input = 0;
max_resp = prctile(makeVec(cat(1,px_resp(:).ave_px_resp_ori_sort_rel)), 90);
min_resp = prctile(makeVec(cat(1,px_resp(:).ave_px_resp_ori_sort_rel)), 20);

tot_input = sum(makeVec(cat(1,px_resp(:).ave_px_ori_amp_rel)));

nD = nDendrites;

if ~isempty(neuron.combo_px_map.soma_pref_ori)

% soma = neuron.soma.aveOriPeak_centred;
soma = neuron.soma.aveOriPeak;

else
soma = neuron.combo_px_map.ori_bin_amp_norm;
% soma = circshift(soma, -soma_ori_shift);
end
if min(soma)<0
    soma = soma -min(soma);

end
soma = soma/max(soma);

figure('Color', 'w', 'Position', [305 272 1242 708]); 

for iP = 1:nD

max_y =     max(round(max_input/tot_input,1), 0.1);
iD = d_sort(iP);

subplot(5, nD, iP)
hold on;
plot(oris(1:6), soma, '--k', 'LineWidth', 0.5); hold on;
plot(oris(1:6), px_resp(iD).ave_px_ori_amp_rel/max(px_resp(iD).ave_px_ori_amp_rel), 'k', 'LineWidth', 1); hold on;

xlim([-100 100])
ylim([0 1])
if iP ==1
    set(gca, 'YTick', [0 1]);
    ylabel('Input-output')

else
    set(gca, 'YTickLabel', [], 'YTick', [0 1]);

end
set(gca, 'XTickLabel', [], 'XTick', [-90 0 90]);
% xlabel('\Delta soma ori')
xlabel(' ori')
formatAxes;

subplot(5, nD, nD+iP)
hold on;
plot(oris(1:6), px_resp(iD).ave_px_ori_amp_rel/tot_input, 'k', 'LineWidth', 1); hold on;

xlim([-100 100])
ylim([min_input, max_y])
if iP ==1
    set(gca, 'YTick', [0 max_y]);
    ylabel('Input density')

else
    set(gca, 'YTickLabel', [], 'YTick', [0 max_y]);

end
set(gca, 'XTickLabel', [], 'XTick', [-90 0 90]);
xlabel(' ori')

formatAxes

subplot(5, nD, [2*nD + iP, 3*nD+iP])
rr = nan(max_px, 6);
rr(1:px_resp(iD).n_px,:) = px_resp(iD).ave_px_resp_ori_sort_rel;
% rr = rr/max(rr(:));
imagesc(oris(1:6), 1:max_px,rr); 
colormap(1-gray);
caxis([min_resp max_resp])
if iP ==1
    set(gca, 'YTick', [0 1000]);
    ylabel('Px no.')

else
    set(gca, 'YTickLabel', [], 'YTick', [0 1000]);

end
set(gca, 'XTickLabel', [-90 0 90], 'XTick', [-90 0 90]);
formatAxes

subplot(5, nD, 4*nD + iP)
bar(px_resp(iD).px_osi_bins, px_resp(iD).px_osi_dist, 'k');
ylim([0 0.25])
if iP ==1
    set(gca, 'YTick', [0 0.2]);
    ylabel('Px no.')

else
    set(gca, 'YTickLabel', [], 'YTick', [0 0.2]);

end
set(gca, 'XTick', [0 1]);
xlabel('OSI')
formatAxes

end

[~, spine_folder] = build_path(neuron.db);

file_name = [neuron.db.animal, num2str(neuron.db.neuron_id)];
print('-vector', '-dpdf', fullfile(spine_folder, file_name));

%%
% trial_perm = randperm(nRep);
% even_resp = mean(trial_stim_resps(:, :, trial_perm(2:2:end)),3);
% odd_resp = mean(trial_stim_resps(:, :, trial_perm(1:2:end)),3);
% all_resp = mean(trial_stim_resps,3);
% 
% 
% [~, even_sort] = max(even_resp, [],2);
% 
% [ ~,even_sort] = sort(even_sort, 'ascend');
% 
% even_resp = even_resp(even_sort, :); 
% odd_resp = odd_resp(even_sort, :); 
% 
% figure; 
% subplot(1,2,1)
% imagesc(even_resp)
% caxis([0 5])
% subplot(1,2,2)
% imagesc(odd_resp)
% caxis([0 5])
% 
% %%
% resps = px_rr.stim_resp;
% 
% % resps = mean(trial_stim_resps,3);
% [max_resp, dir_sort] = max(resps, [],2);
% 
% [ ~,dir_sort] = sort(dir_sort, 'ascend');
% 
% max_thres = prctile(max_resp, 95);
% 
% max_sg = max_resp >max_thres;
% 
% resps = resps(dir_sort(max_sg), :); 
% 
% % resps = bsxfun(@minus, resps, min(resps, [], 2));
% % resps = bsxfun(@rdivide, resps, max(resps, [], 2));
% 
% figure; 
% imagesc(resps)
% caxis([0 5])
% 
% %%
% figure;
% 
% [max_resp, dir_sort] = max(px_rr.st(2).stim_resp, [],2);
% 
% [ ~,dir_sort] = sort(dir_sort, 'ascend');
% 
% max_thres = prctile(max_resp, 99.9);
% 
% max_sg = max_resp >max_thres;
% 
% for iSt = 1:numel(px_rr.st)
% 
% resps = px_rr.st(iSt).stim_resp;
% 
% resps = resps(dir_sort(max_sg), :); 
% 
% % resps = bsxfun(@minus, resps, min(resps, [], 2));
% % resps = bsxfun(@rdivide, resps, max(resps, [], 2));
% 
% subplot(1,numel(px_rr.st), iSt);
% imagesc(resps)
% caxis([0 5])
% end



%%





end