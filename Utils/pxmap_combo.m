function [combo_map, map, signal]= pxmap_combo(neuron)

nDendrites = numel(neuron.dendrite);

[combo_map, map] = stitch_px_map(neuron.dendrite);

% for each_map

thrs_scale = 2;

for iD = 1:nDendrites

    % - find threshold of significance to consider pixels
    this_img = map(iD).mimg;
    nan_idx = isnan(this_img);
    this_img(nan_idx) =0;
    amp_mimg = imtophat(this_img, strel('disk', 2));
    % amp_mimg = map(iD).mimg;
    amp_mimg(nan_idx) = NaN;
    amp_mimg = amp_mimg/nanmax(amp_mimg(:));
    null_mimg = amp_mimg.*(map(iD).branch_bw <1);
    null_mimg(map(iD).branch_bw >0) = NaN;
    thres_mimg = nanmean(null_mimg(:)) + thrs_scale*nanstd(null_mimg(:));
    sig_mimg = amp_mimg>thres_mimg;

    this_img = abs(map(iD).dir);
    nan_idx = isnan(this_img);
    this_img(nan_idx) =0;
    amp_dir = imtophat(this_img,strel('disk', 2));
    amp_dir(nan_idx) = NaN;
    % amp_dir = abs(map(iD).dir);
    amp_dir = amp_dir/nanmax(amp_dir(:));
    null_dir = amp_dir.*(map(iD).branch_bw <1);
    null_dir(map(iD).branch_bw >0) = NaN;
    thres_dir = nanmean(null_dir(:)) + thrs_scale*nanstd(null_dir(:));
    sig_dir = amp_dir>thres_dir;

    this_img = abs(map(iD).ori);
    nan_idx = isnan(this_img);
    this_img(nan_idx) =0;
    amp_ori = imtophat(this_img,strel('disk', 2));
    % amp_ori = abs(map(iD).ori);
    amp_ori(nan_idx) = NaN;
    amp_ori = amp_dir/nanmax(amp_ori(:));
    null_ori = amp_ori.*(map(iD).branch_bw <1);
    null_ori(map(iD).branch_bw >0) = NaN;
    thres_ori = nanmean(null_ori(:)) + thrs_scale*nanstd(null_ori(:));
    sig_ori = amp_ori>thres_ori;

    sig_px = sig_ori | sig_dir | sig_mimg;
    sig_px = bwareaopen(sig_px,6);
    % figure; imagesc(sig_px)
    signal(iD).bw =sig_px & map(iD).branch_bw>0;
%     figure; imagesc(signal(iD).bw)

    [signal(iD).i, signal(iD).j] = find(signal(iD).bw);

    signal(iD).px_x_um = combo_map.x_um(signal(iD).j);
    signal(iD).px_y_um = combo_map.y_um(signal(iD).i);
    signal(iD).px_ori = map(iD).ori(signal(iD).bw);
    signal(iD).px_dir = map(iD).dir(signal(iD).bw);
      signal(iD).px_ori_norm = map(iD).ori(signal(iD).bw)/nanmax(abs(map(iD).ori(signal(iD).bw)));
    signal(iD).px_dir_norm = map(iD).dir(signal(iD).bw)/nanmax(abs(map(iD).dir(signal(iD).bw)));

    signal(iD).dir_bin = 0:pi/6:2*pi;
    angles = angle(signal(iD).px_dir);
    angles(angles<0)  = angles(angles<0) +2*pi;

    [~,~,signal(iD).dir_bin_idx] = histcounts(angles, signal(iD).dir_bin);

    signal(iD).dir_bin = (signal(iD).dir_bin(1:end-1) + pi/12)*180/pi;

    for iB = 1:numel(signal(iD).dir_bin)
        signal(iD).dir_bin_amp(iB) = sum(abs(signal(iD).px_dir(signal(iD).dir_bin_idx == iB)));
    end

    signal(iD).tun_dirs = 0:360;
    signal(iD).dir_pars = mfun.fitTuning(signal(iD).dir_bin, circGaussFilt(double(signal(iD).dir_bin_amp),1), 'vm2');
    signal(iD).tuning_fit = mfun.vonMises2(signal(iD).dir_pars, signal(iD).tun_dirs);

    %%
%     signal(iD).ori_bin = 0:pi/6:pi;
%     angles = angle(signal(iD).px_ori);
%     angles(angles<0)  = angles(angles<0) +pi;

    signal(iD).ori_bin = -pi/2:pi/6:pi/2;
    angles = angle(signal(iD).px_ori);
    angles(angles<0)  = angles(angles<0) +pi;
    angles(angles>=pi/2)  = angles(angles>=pi/2) -pi;

    [~,~,signal(iD).ori_bin_idx] = histcounts(angles, signal(iD).ori_bin);

    signal(iD).ori_bin = (signal(iD).ori_bin(1:end-1) + pi/12)*180/pi;

    for iB = 1:numel(signal(iD).ori_bin)
        signal(iD).ori_bin_amp(iB) = sum(abs(signal(iD).px_ori(signal(iD).ori_bin_idx == iB)));
    end

    signal(iD).tun_oris = -90:90;
    signal(iD).ori_pars = mfun.fitTuning(signal(iD).ori_bin*2, circGaussFilt(double(signal(iD).ori_bin_amp),1), 'vm1');
    signal(iD).tuning_fit_ori = mfun.vonMises(signal(iD).ori_pars, signal(iD).tun_oris*2);

    %%

end

% combo_map.soma_tuning = nanmean(cat(2,signal(:).tuning_fit),2);
% combo_map.soma_pars = mfun.fitTuning(signal(1).tun_dirs, combo_map.soma_tuning, 'vm2');
% combo_map.soma_tuning_fit = mfun.vonMises2(combo_map.soma_pars, signal(1).tun_dirs);
combo_map.dir_bin = signal(iD).dir_bin;
combo_map.tun_dirs = signal(iD).tun_dirs;

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

% combo_map.sig_ori = cat(1, signal(:).px_ori_norm);
% combo_map.sig_dir = cat(1, signal(:).px_dir_norm);

%%
combo_map.dir_bin = 0:pi/6:2*pi;
angles = angle(combo_map.sig_dir);
angles(angles<0)  = angles(angles<0) +2*pi;

[~,~,combo_map.dir_bin_idx] = histcounts(angles,combo_map.dir_bin);

combo_map.dir_bin = (combo_map.dir_bin(1:end-1) + pi/12)*180/pi;

for iB = 1:numel(combo_map.dir_bin)
   combo_map.dir_bin_amp(iB) = sum(abs(combo_map.sig_dir(combo_map.dir_bin_idx == iB)));
end

combo_map.soma_pars = mfun.fitTuning(combo_map.dir_bin,  double(combo_map.dir_bin_amp), 'vm2');
combo_map.soma_tuning_fit = mfun.vonMises2(combo_map.soma_pars, combo_map.tun_dirs );


combo_map.soma_dir= combo_map.soma_pars(1); %[0 360];
combo_map.soma_ori = combo_map.soma_dir -90; %[-90 270]
combo_map.soma_ori(combo_map.soma_ori >=180) = combo_map.soma_ori(combo_map.soma_ori >=180) -180;%[0 180];
combo_map.soma_ori(combo_map.soma_ori <0) = combo_map.soma_ori(combo_map.soma_ori <0) +180;%[0 180];

if ~isempty(neuron.soma)
%   
% combo_map.soma_dir = neuron.soma.dir_pars_vm(1);
% combo_map.soma_ori = combo_map.soma_dir -90; %[-90 270]
% combo_map.soma_ori(combo_map.soma_ori >=180) = combo_map.soma_ori(combo_map.soma_ori >=180) -180;%[0 180];
% combo_map.soma_ori(combo_map.soma_ori <0) = combo_map.soma_ori(combo_map.soma_ori <0) +180;%[0 180];

end
%%

% combo_map.ori_bin = 0:pi/6:pi;
% angles = angle(combo_map.sig_ori);
% angles(angles<0)  = angles(angles<0) +pi;

combo_map.ori_bin = -pi/2:pi/6:pi/2;
angles = angle(combo_map.sig_ori);
angles(angles<0)  = angles(angles<0) +pi;
    angles(angles>=pi/2)  = angles(angles>=pi/2) -pi;

[~,~,combo_map.ori_bin_idx] = histcounts(angles,combo_map.ori_bin);

combo_map.ori_bin = (combo_map.ori_bin(1:end-1) + pi/12)*180/pi;

for iB = 1:numel(combo_map.ori_bin)
   combo_map.ori_bin_amp(iB) = sum(abs(combo_map.sig_ori(combo_map.ori_bin_idx == iB)));
end

combo_map.soma_pars_ori = mfun.fitTuning(combo_map.ori_bin*2,  double(combo_map.ori_bin_amp), 'vm1');
combo_map.soma_pars_ori_rel = combo_map.soma_pars_ori;
combo_map.soma_pars_ori_rel(1) = 0;

combo_map.soma_tuning_fit_ori = mfun.vonMises(combo_map.soma_pars_ori, combo_map.tun_oris*2 );
combo_map.soma_tuning_fit_ori_rel = mfun.vonMises(combo_map.soma_pars_ori_rel, combo_map.tun_oris*2 );

combo_map.soma_ori_ori = combo_map.soma_pars_ori(1)/2;

for iD = 1: nDendrites
   signal(iD).ori_pars_rel =signal(iD).ori_pars;
    signal(iD).ori_pars_rel(1) = signal(iD).ori_pars_rel(1) - combo_map.soma_pars_ori(1);
if signal(iD).ori_pars_rel(1) <-90
    signal(iD).ori_pars_rel(1) = signal(iD).ori_pars_rel(1) +180;
elseif signal(iD).ori_pars_rel(1) >= 90
        signal(iD).ori_pars_rel(1) = signal(iD).ori_pars_rel(1) -180;

end

    signal(iD).tuning_fit_ori_rel = mfun.vonMises(signal(iD).ori_pars_rel, signal(iD).tun_oris*2);

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
dir= angle(combo_map.sig_dir_norm)*180/pi; %[-90 90]
dir(dir <=0) = dir(dir <=0) +360;


figure('Color', 'w', 'Position', [418 456 822 522]);

subplot(1,3,1)
color = hsv(360); % colors for ori_bin
imagesc(x_um, y_um, img);
axis image; hold on;colormap(1-gray);
this_amp = ceil((amp_dir/max(amp_dir))/0.2).^2;
idx = this_amp ==0;
this_amp(this_amp ==0) = NaN;
scatter(sig_x_um(idx), sig_y_um(idx), this_amp(idx), color(ceil(dir(idx)),:), 'filled');
formatAxes
xlabel('um')
title('Dir')


subplot(1,3,2)
color = hsv(180); % colors for ori_bin
imagesc(x_um, y_um, img);
axis image; hold on;colormap(1-gray);
this_amp = ceil((amp_ori/max(amp_ori))/0.2).^2;
idx = this_amp ==0;
this_amp(this_amp ==0) = NaN;
scatter(sig_x_um(idx), sig_y_um(idx), this_amp(idx), color(ceil(ori(idx)),:), 'filled');
formatAxes
xlabel('um')
title('Ori')

subplot(1,3,3)
% if ~isempty(neuron.soma)
%     plot(neuron.soma.ori_fit_pt, neuron.soma.ori_fit_vm/sum(neuron.soma.ori_fit_vm), '--k', 'Linewidth', 2); hold on
% end
soma = combo_map.soma_tuning_fit_ori_rel/sum(combo_map.soma_tuning_fit_ori_rel);

plot(signal(iD).tun_oris, soma/max(soma), 'k', 'Linewidth', 2); hold on

for iD = 1: nDendrites
    den = signal(iD).tuning_fit_ori_rel/sum( signal(iD).tuning_fit_ori_rel);
    den = den/max(soma);
plot(signal(iD).tun_oris, den, 'Color', [0.2 0.2 0.2]); hold on
end

set(gca, 'Xtick', [-90 0 90]);
xlabel('D pref ori')
ylabel('Norm tuning')
formatAxes
axis square
%%
figure;

subplot(3,2,2)
if ~isempty(neuron.soma)
    plot(neuron.soma.fit_pt, neuron.soma.fit_vm/max(neuron.soma.fit_vm), 'r', 'Linewidth', 2); hold on
    plot(neuron.soma.dirs, neuron.soma.avePeak(1:12)/max(neuron.soma.avePeak(1:12)), 'r', 'Linewidth', 0.5)
end
plot(signal(iD).tun_dirs, combo_map.soma_tuning_fit/max(combo_map.soma_tuning_fit), 'k', 'Linewidth', 2); hold on
plot(combo_map.dir_bin, combo_map.dir_bin_amp/max(combo_map.dir_bin_amp), 'k', 'Linewidth', 0.5)
axis tight

subplot(3,2,4)
plot(signal(iD).tun_dirs, cat(2, signal(:).tuning_fit)); hold on
axis tight;
subplot(3,2,6)
plot(signal(iD).dir_bin,cat(1, signal(:).dir_bin_amp)'); hold on
axis tight;

subplot(3,2,1)
if ~isempty(neuron.soma)
%     neuron.soma.ori_fit_vm = mfun.vonMises(neuron.soma.ori_pars_vm, combo_map.tun_oris*2);
%     neuron.soma.ori_fit_pt = signal(1).tun_oris;
    plot(neuron.soma.ori_fit_pt, neuron.soma.ori_fit_vm/max(neuron.soma.ori_fit_vm), 'r', 'Linewidth', 2); hold on
        plot(neuron.soma.oris(1:6), neuron.soma.aveOriPeak/max(neuron.soma.aveOriPeak), 'r', 'Linewidth', 0.5)

end

plot(signal(iD).tun_oris, combo_map.soma_tuning_fit_ori/max(combo_map.soma_tuning_fit_ori), 'k', 'Linewidth', 2); hold on
plot(combo_map.ori_bin, combo_map.ori_bin_amp/max(combo_map.ori_bin_amp), 'k', 'Linewidth', 0.5)

axis tight
subplot(3,2,3)
plot(signal(iD).tun_oris, cat(2, signal(:).tuning_fit_ori)); hold on
axis tight;
subplot(3,2,5)
plot(signal(iD).ori_bin,cat(1, signal(:).ori_bin_amp)'); hold on
axis tight;


% - find the significant pixels
% - save vector with their x and y pos around the soma
% - save complex dir and ori
% - bin pixels according to prefOri
% - sum R for each bin


end