function [combo_map, map, signal, soma]= pxmap_combo(neuron)

nDendrites = numel(neuron.dendrite);

soma = neuron.soma;

[combo_map, map] = stitch_px_map(neuron.dendrite,0);

% thrs = 2; % threshold for significance, fold of std over the mean

for iD = 1:nDendrites

    % - threshold pixels based on intensity image
    thrs = 95; % threshold for significance, perctile of background
    filt_scale = 3; % spatial scale of filtering in pixels
    sig_mimg =threshold_map(map(iD).mimg, map(iD).branch_bw, 'tile', thrs, filt_scale,0);

    % - threshold pixels based on amplitude of direction tuning
    sig_dir = threshold_map(abs(map(iD).dir), map(iD).branch_bw, 'tile', 99, 5,0);

    % - threshold pixels based on amplitude of orientation tuning
    sig_ori = threshold_map(abs(map(iD).ori), map(iD).branch_bw, 'tile', 99, 5,0);

    % - find pixels with no signal (amp = 0) and remove them
    sig_zero_amp = abs(map(iD).ori) ==0 | abs(map(iD).dir) ==0;

    % - combine all significant pixels
%     sig_px = (sig_ori | sig_dir | sig_mimg) & ~sig_zero_amp;
    sig_px = (sig_ori | sig_dir) & ~sig_zero_amp;

    % remove noise (unconnected components smaller than 6 px)
    signal(iD).bw= bwareaopen(sig_px,8, 4);
    % figure; imagesc(signal(iD).bw)


    % extract properties of significant pixels.
    [signal(iD).i, signal(iD).j] = find(signal(iD).bw);
    signal(iD).px_x_um = combo_map.x_um(signal(iD).j);
    signal(iD).px_y_um = combo_map.y_um(signal(iD).i);
    signal(iD).px_ori = map(iD).ori(signal(iD).bw);
    signal(iD).px_dir = map(iD).dir(signal(iD).bw);
    signal(iD).px_den_id = ones(size(signal(iD).px_ori))*iD;
    % normalise responses to max in each receording
    %     signal(iD).px_ori_norm = map(iD).ori(signal(iD).bw)/nanmax(abs(map(iD).ori(signal(iD).bw)));
    %     signal(iD).px_dir_norm = map(iD).dir(signal(iD).bw)/nanmax(abs(map(iD).dir(signal(iD).bw)));

    signal(iD).px_ori_norm = map(iD).ori(signal(iD).bw)/nanmedian(abs(map(iD).ori(signal(iD).bw)));
    signal(iD).px_dir_norm = map(iD).dir(signal(iD).bw)/nanmedian(abs(map(iD).dir(signal(iD).bw)));


    signal(iD).px_ori_norm(isnan(signal(iD).px_ori_norm)) = 0;
    signal(iD).px_dir_norm(isnan(signal(iD).px_dir_norm)) = 0;

    %% measure distribution of preferred direction, weighted by DSI

    signal(iD).dir_edges = 0:pi/6:2*pi; % hardcoded, assumes 12 dir shown
    angles = angle(signal(iD).px_dir);
    angles(angles<0)  = angles(angles<0) +2*pi;
    [~,~,signal(iD).dir_bin_idx] = histcounts(angles, signal(iD).dir_edges);

    signal(iD).dir_bin = (signal(iD).dir_edges(1:end-1) + pi/12)*180/pi;

    % fit a tuning curve to the distribution
    for iB = 1:numel(signal(iD).dir_bin)
        signal(iD).dir_bin_amp(iB) = sum(abs(signal(iD).px_dir(signal(iD).dir_bin_idx == iB)));
    end

    signal(iD).tun_dirs = 0:360;
    signal(iD).dir_pars = mfun.fitTuning(signal(iD).dir_bin, circGaussFilt(double(signal(iD).dir_bin_amp),1), 'vm2');
    signal(iD).tuning_fit = mfun.vonMises2(signal(iD).dir_pars, signal(iD).tun_dirs);

    % fit a tuning curve to the distribution or norm resps
    for iB = 1:numel(signal(iD).dir_bin)
        signal(iD).dir_bin_amp_norm(iB) = sum(abs(signal(iD).px_dir_norm(signal(iD).dir_bin_idx == iB)));
    end

    signal(iD).dir_pars_norm = mfun.fitTuning(signal(iD).dir_bin, circGaussFilt(double(signal(iD).dir_bin_amp_norm),1), 'vm2');
    signal(iD).tuning_fit_norm = mfun.vonMises2(signal(iD).dir_pars_norm, signal(iD).tun_dirs);


    %% measure distribution of preferred orientation, weighted by OSI

    signal(iD).ori_edges = -pi/2:pi/6:pi/2;
    angles = angle(signal(iD).px_ori)/2;

    [~,~,signal(iD).ori_bin_idx] = histcounts(angles, signal(iD).ori_edges);

    signal(iD).ori_bin = (signal(iD).ori_edges(1:end-1) + pi/12)*180/pi;

    % fit a tuning curve to the distribution
    for iB = 1:numel(signal(iD).ori_bin)
        signal(iD).ori_bin_amp(iB) = sum(abs(signal(iD).px_ori(signal(iD).ori_bin_idx == iB)));
    end
    signal(iD).tun_oris = -90:90;
    signal(iD).ori_pars = mfun.fitTuning(signal(iD).ori_bin*2, circGaussFilt(double(signal(iD).ori_bin_amp),1), 'vm1');
    signal(iD).tuning_fit_ori = mfun.vonMises(signal(iD).ori_pars, signal(iD).tun_oris*2);

    % fit a tuning curve to the distribution of norm resps
    for iB = 1:numel(signal(iD).ori_bin)
        signal(iD).ori_bin_amp_norm(iB) = sum(abs(signal(iD).px_ori_norm(signal(iD).ori_bin_idx == iB)));
    end
    signal(iD).ori_pars_norm = mfun.fitTuning(signal(iD).ori_bin*2, circGaussFilt(double(signal(iD).ori_bin_amp_norm),1), 'vm1');
    signal(iD).tuning_fit_ori_norm = mfun.vonMises(signal(iD).ori_pars_norm, signal(iD).tun_oris*2);

end

%% pool significant pixels across dendrites

% combo_map.soma_tuning = nanmean(cat(2,signal(:).tuning_fit),2);
% combo_map.soma_pars = mfun.fitTuning(signal(1).tun_dirs, combo_map.soma_tuning, 'vm2');
% combo_map.soma_tuning_fit = mfun.vonMises2(combo_map.soma_pars, signal(1).tun_dirs);
combo_map.dir_edges = signal(iD).dir_edges;
combo_map.dir_bin = signal(iD).dir_bin;
combo_map.tun_dirs = signal(iD).tun_dirs;

combo_map.ori_edges = signal(iD).ori_edges;
combo_map.ori_bin = signal(iD).ori_bin;
combo_map.tun_oris = signal(iD).tun_oris;

combo_map.sig_bw = nanmax(cat(3, signal(:).bw), [], 3);
combo_map.sig_i = cat(1, signal(:).i);
combo_map.sig_j = cat(1, signal(:).j);
combo_map.sig_x_um = cat(2, signal(:).px_x_um)';
combo_map.sig_y_um = cat(2, signal(:).px_y_um)';
combo_map.sig_ori = cat(1, signal(:).px_ori);
combo_map.sig_dir = cat(1, signal(:).px_dir);
combo_map.sig_ori_norm = cat(1, signal(:).px_ori_norm);
combo_map.sig_dir_norm = cat(1, signal(:).px_dir_norm);
combo_map.sig_den_id = cat(1, signal(:).px_den_id);


%% measure distribution of preferred directions, weighted by OSI

angles = angle(combo_map.sig_dir);
angles(angles<0)  = angles(angles<0) +2*pi;

[~,~,combo_map.dir_bin_idx] = histcounts(angles,combo_map.dir_edges);

% fit a tuning curve to the distribution of resps

for iB = 1:numel(combo_map.dir_bin)
    combo_map.dir_bin_amp(iB) = sum(abs(combo_map.sig_dir(combo_map.dir_bin_idx == iB)));
end
combo_map.dir_pars = mfun.fitTuning(combo_map.dir_bin,  double(combo_map.dir_bin_amp), 'vm2');
combo_map.tuning_fit = mfun.vonMises2(combo_map.dir_pars, combo_map.tun_dirs );

combo_map.pref_dir= combo_map.dir_pars(1); %[0 360];
combo_map.pref_dir_ori = combo_map.pref_dir -90; %[-90 270]
combo_map.pref_dir_ori(combo_map.pref_dir_ori >=180) = combo_map.pref_dir_ori(combo_map.pref_dir_ori >=180) -180;%[0 180];
combo_map.pref_dir_ori(combo_map.pref_dir_ori <0) = combo_map.pref_dir_ori(combo_map.pref_dir_ori <0) +180;%[0 180];

% fit a tuning curve to the distribution of norm resps
for iB = 1:numel(combo_map.dir_bin)
    combo_map.dir_bin_amp_norm(iB) = sum(abs(combo_map.sig_dir_norm(combo_map.dir_bin_idx == iB)));
end

combo_map.dir_pars_norm = mfun.fitTuning(combo_map.dir_bin,  double(combo_map.dir_bin_amp_norm), 'vm2');
combo_map.tuning_fit_norm = mfun.vonMises2(combo_map.dir_pars_norm, combo_map.tun_dirs );

combo_map.pref_dir_norm= combo_map.dir_pars_norm(1); %[0 360];
combo_map.pref_dir_ori_norm= combo_map.pref_dir_norm -90; %[-90 270]
combo_map.pref_dir_ori_norm(combo_map.pref_dir_ori_norm >=180) = combo_map.pref_dir_ori_norm(combo_map.pref_dir_ori_norm >=180) -180;%[0 180];
combo_map.pref_dir_ori_norm(combo_map.pref_dir_ori_norm <0) = combo_map.pref_dir_ori_norm(combo_map.pref_dir_ori_norm <0) +180;%[0 180];

%% measure distribution of preferred orientation, weighted by OSI
angles = angle(combo_map.sig_ori)/2;

[~,~,combo_map.ori_bin_idx] = histcounts(angles,combo_map.ori_edges);

% fit a tuning curve to the distribution ofresps
for iB = 1:numel(combo_map.ori_bin)
    combo_map.ori_bin_amp(iB) = sum(abs(combo_map.sig_ori(combo_map.ori_bin_idx == iB)));
end

combo_map.ori_pars = mfun.fitTuning(combo_map.ori_bin*2,  double(combo_map.ori_bin_amp), 'vm1');
combo_map.ori_pars_centred = combo_map.ori_pars;
combo_map.ori_pars_centred(1) = 0;

combo_map.tuning_fit_ori = mfun.vonMises(combo_map.ori_pars, combo_map.tun_oris*2 );
combo_map.tuning_fit_ori_centred = mfun.vonMises(combo_map.ori_pars_centred, combo_map.tun_oris*2 );

combo_map.pref_ori = combo_map.ori_pars(1)/2;

% fit a tuning curve to the distribution of norm resps

for iB = 1:numel(combo_map.ori_bin)
    combo_map.ori_bin_amp_norm(iB) = sum(abs(combo_map.sig_ori_norm(combo_map.ori_bin_idx == iB)));
end

combo_map.ori_pars_norm = mfun.fitTuning(combo_map.ori_bin*2,  double(combo_map.ori_bin_amp_norm), 'vm1');
combo_map.ori_pars_centred_norm = combo_map.ori_pars_norm;
combo_map.ori_pars_centred_norm(1) = 0;

combo_map.tuning_fit_ori_norm = mfun.vonMises(combo_map.ori_pars_norm, combo_map.tun_oris*2 );
combo_map.tuning_fit_ori_centred_norm = mfun.vonMises(combo_map.ori_pars_centred_norm, combo_map.tun_oris*2 );

combo_map.pref_ori_norm = combo_map.ori_pars_norm(1)/2;

%% compare single dendrites with soma

if ~isempty(neuron.soma)

    combo_map.soma_pref_dir = neuron.soma.dir_pars_vm(1);
    combo_map.soma_pref_dir_ori = combo_map.soma_pref_dir; 
    combo_map.soma_pref_dir_ori(combo_map.soma_pref_dir_ori >=180) = combo_map.soma_pref_dir_ori(combo_map.soma_pref_dir_ori >=180) -180;%[0 180];
    combo_map.soma_pref_dir_ori = combo_map.soma_pref_dir -90; %[-90 90]
    combo_map.soma_pref_ori = neuron.soma.ori_pars_vm(1)/2;

    soma.ori_pars_vm_rel = soma.ori_pars_vm;
    soma.ori_pars_vm_rel(1) = soma.ori_pars_vm_rel(1)-combo_map.ori_pars(1);

    if soma.ori_pars_vm_rel(1) <-180
        soma.ori_pars_vm_rel(1) = soma.ori_pars_vm_rel(1) +360;
    elseif soma.ori_pars_vm_rel(1) >= 180
        soma.ori_pars_vm_rel(1) = soma.ori_pars_vm_rel(1) -360;
    end

    soma.ori_fit_vm_rel = mfun.vonMises(soma.ori_pars_vm_rel, combo_map.tun_oris*2 );

    soma.ori_pars_vm_centred = soma.ori_pars_vm;
    soma.ori_pars_vm_centred(1) = 0;
    soma.ori_fit_vm_centred = mfun.vonMises(soma.ori_pars_vm_centred, combo_map.tun_oris*2 );

    % here add code to compute dendrites relative to soma
    % to shift the non-fitted responses, use circshift(resps,4-maxSoma_pos)
    
    [~, d_idx] = max(soma.avePeak(1:12));
    [~, o_idx] = max(soma.aveOriPeak);

    soma.avePeak_cent = circshift(soma.avePeak(1:12), 7 - d_idx);
    soma.aveOriPeak_cent = circshift(soma.aveOriPeak, 4 - o_idx);
    combo_map.dir_bin_amp_soma_rel = circshift(combo_map.dir_bin_amp, 7 - d_idx);
    combo_map.dir_bin_amp_norm_soma_rel = circshift(combo_map.dir_bin_amp_norm, 7 - d_idx);
    combo_map.ori_bin_amp_soma_rel = circshift(combo_map.ori_bin_amp, 4 - o_idx);
    combo_map.ori_bin_amp_norm_soma_rel = circshift(combo_map.ori_bin_amp_norm, 4 - o_idx);

else
    combo_map.soma_pref_dir = [];
    combo_map.soma_pref_dir_ori = [];
    combo_map.soma_pref_ori = [];
    combo_map.dir_bin_amp_soma_rel = [];
    combo_map.dir_bin_amp_soma_rel = [];
    combo_map.ori_bin_amp_soma_rel= [];
    combo_map.ori_bin_amp_soma_rel = [];


end


for iD = 1: nDendrites
    signal(iD).ori_pars_rel =signal(iD).ori_pars;
    signal(iD).ori_pars_rel(1) = signal(iD).ori_pars_rel(1) - combo_map.ori_pars(1);

    if signal(iD).ori_pars_rel(1) <-180
        signal(iD).ori_pars_rel(1) = signal(iD).ori_pars_rel(1) +360;
    elseif signal(iD).ori_pars_rel(1) >= 180
        signal(iD).ori_pars_rel(1) = signal(iD).ori_pars_rel(1) -360;

    end

    signal(iD).tuning_fit_ori_rel = mfun.vonMises(signal(iD).ori_pars_rel, signal(iD).tun_oris*2);

end

%% compare global dendrites with soma
if ~isempty(neuron.soma)

combo_map.ori_pars_rel_soma = combo_map.ori_pars;
combo_map.ori_pars_rel_soma(1) = (combo_map.pref_ori - combo_map.soma_pref_ori)*2;

    if combo_map.ori_pars_rel_soma(1) <-180
        combo_map.ori_pars_rel_soma(1) = combo_map.ori_pars_rel_soma(1) +360;
    elseif combo_map.ori_pars_rel_soma(1) >= 180
        combo_map.ori_pars_rel_soma(1) = combo_map.ori_pars_rel_soma(1) -360;

    end

combo_map.tuning_fit_ori_rel_soma = mfun.vonMises(combo_map.ori_pars_rel_soma, combo_map.tun_oris*2 );

combo_map.ori_pars_rel_soma_norm = combo_map.ori_pars_norm;
combo_map.ori_pars_rel_soma_norm(1) = (combo_map.pref_ori_norm -combo_map.soma_pref_ori)*2;

   if combo_map.ori_pars_rel_soma_norm(1) <-180
        combo_map.ori_pars_rel_soma_norm(1) = combo_map.ori_pars_rel_soma_norm(1) +360;
    elseif combo_map.ori_pars_rel_soma_norm(1) >= 180
        combo_map.ori_pars_rel_soma_norm(1) = combo_map.ori_pars_rel_soma_norm(1)-360;

    end

combo_map.tuning_fit_ori_rel_soma_norm = mfun.vonMises(combo_map.ori_pars_rel_soma_norm, combo_map.tun_oris*2 );
else

combo_map.ori_pars_rel_soma = combo_map.ori_pars_centred;

combo_map.tuning_fit_ori_rel_soma = combo_map.tuning_fit_ori_centred;

combo_map.ori_pars_rel_soma_centred_norm = combo_map.ori_pars_centred_norm;

combo_map.tuning_fit_ori_rel_soma_centred_norm = combo_map.tuning_fit_ori_centred_norm;
end


%%

img = combo_map.mimg;
x_um = combo_map.x_um;
y_um = combo_map.y_um;
sig_x_um = combo_map.sig_x_um;
sig_y_um = combo_map.sig_y_um;
amp_ori= abs(combo_map.sig_ori_norm);
ori= angle(combo_map.sig_ori_norm)*180/(2*pi); %[-90 90]
ori(ori <=0) = ori(ori <=0) +180;


amp_dir= abs(combo_map.sig_dir_norm);
dir= angle(combo_map.sig_dir_norm)*180/pi; 
dir(dir <=0) = dir(dir <=0) +360;


figure('Color', 'w', 'Position', [418 456 822 522]);

subplot(1,3,1)
color = hsv(360); % colors for ori_bin
imagesc(x_um, y_um, img);
axis image; hold on;colormap(1-gray);
this_amp = ceil((amp_dir/max(amp_dir))/0.2).^2;
idx = this_amp >0;
this_amp(this_amp ==0) = NaN;
scatter(sig_x_um(idx), sig_y_um(idx), this_amp(idx), color(ceil(dir(idx)),:), 'filled'); hold on;
scatter(0, 0, 100, color(round(combo_map.soma_pref_dir),:), 'filled'); hold on;
formatAxes
xlabel('um')
title('Dir')


subplot(1,3,2)
color = hsv(180); % colors for ori_bin
imagesc(x_um, y_um, img);
axis image; hold on;colormap(1-gray);
this_amp = ceil((amp_ori/max(amp_ori))/0.2).^2;
idx = this_amp >0;
this_amp(this_amp ==0) = NaN;
scatter(sig_x_um(idx), sig_y_um(idx), this_amp(idx), color(ceil(ori(idx)),:), 'filled');
scatter(0, 0, 100, color(round(combo_map.soma_pref_ori),:), 'filled'); hold on;
formatAxes
xlabel('um')
title('Ori')

subplot(1,3,3)
% if ~isempty(neuron.soma)
%     plot(neuron.soma.ori_fit_pt, neuron.soma.ori_fit_vm/sum(neuron.soma.ori_fit_vm), '--k', 'Linewidth', 2); hold on
% end

allden = combo_map.tuning_fit_ori_centred/sum(combo_map.tuning_fit_ori_centred);

plot(signal(iD).tun_oris, allden/sum(allden), 'k', 'Linewidth', 2); hold on

if ~isempty(soma)
    soma_fit = soma.ori_fit_vm_rel;
    if min(soma_fit)<0
        plot(signal(iD).tun_oris, soma_fit/sum(soma_fit-min(soma_fit)), 'r', 'Linewidth', 2); hold on

    else
        plot(signal(iD).tun_oris, soma_fit/sum(soma_fit), 'r', 'Linewidth', 2); hold on
    end
end

for iD = 1: nDendrites
    den = signal(iD).tuning_fit_ori_rel/sum( signal(iD).tuning_fit_ori_rel);
    %     den = den/max(allden);
    plot(signal(iD).tun_oris, den, 'Color', [0.2 0.2 0.2]); hold on
end

set(gca, 'Xtick', [-90 0 90]);
xlabel('D pref ori')
ylabel('Norm tuning')
formatAxes
axis square
%%
figure('Color', 'w', 'Position', [680 419 560 559]);

subplot(3,2,2)
if ~isempty(soma)
    plot(soma.fit_pt, soma.fit_vm/max(soma.fit_vm), '--r', 'Linewidth', 2); hold on
    plot(soma.dirs, soma.avePeak(1:12)/max(soma.avePeak(1:12)), 'r', 'Linewidth', 0.5)
end
plot(signal(iD).tun_dirs, combo_map.tuning_fit/max(combo_map.tuning_fit), '--k', 'Linewidth', 2); hold on
plot(combo_map.dir_bin, combo_map.dir_bin_amp/max(combo_map.dir_bin_amp), 'k', 'Linewidth', 0.5)
formatAxes
xlim([0 360])
ylim([0, 1])

subplot(3,2,6)
den_raw = cat(1, signal(:).dir_bin_amp)';
plot(signal(iD).dir_bin,den_raw./sum(den_raw), 'k'); hold on
formatAxes
xlim([0 360])
ylim([0, max(max(den_raw./sum(den_raw)))])
xlabel('direction')

subplot(3,2,4)
den = cat(2, signal(:).tuning_fit);
plot(signal(iD).tun_dirs, den./sum(den_raw), 'k'); hold on
formatAxes
xlim([0 360])
ylim([0, max(max(den./sum(den_raw)))])

subplot(3,2,1)
if ~isempty(soma)
    %     neuron.soma.ori_fit_vm = mfun.vonMises(neuron.soma.ori_pars_vm, combo_map.tun_oris*2);
    %     neuron.soma.ori_fit_pt = signal(1).tun_oris;
    plot(soma.ori_fit_pt, soma.ori_fit_vm/max(soma.ori_fit_vm), '--r', 'Linewidth', 2); hold on
    plot(soma.oris(1:6), soma.aveOriPeak/max(soma.aveOriPeak), 'r', 'Linewidth', 0.5)

end

plot(signal(iD).tun_oris, combo_map.tuning_fit_ori/max(combo_map.tuning_fit_ori), '--k', 'Linewidth', 2); hold on
plot(combo_map.ori_bin, combo_map.ori_bin_amp/max(combo_map.ori_bin_amp), 'k', 'Linewidth', 0.5)

formatAxes
xlim([-90 90])
ylim([0, 1])
ylabel('response')

subplot(3,2,5)
den_raw =  cat(1, signal(:).ori_bin_amp)';
plot(signal(iD).ori_bin,den_raw./sum(den_raw), 'k'); hold on
formatAxes
xlim([-90 90])
ylim([0, max(max(den_raw./sum(den_raw)))])
xlabel('orientation')
ylabel('dendrites')

subplot(3,2,3)
den = cat(2, signal(:).tuning_fit_ori);
plot(signal(iD).tun_oris, den./sum(den_raw), 'k'); hold on
axis tight;
formatAxes
xlim([-90 90])
ylim([0, max(max(den./sum(den_raw)))])
ylabel('dendrites fit')

% - find the significant pixels
% - save vector with their x and y pos around the soma
% - save complex dir and ori
% - bin pixels according to prefOri
% - sum R for each bin


end