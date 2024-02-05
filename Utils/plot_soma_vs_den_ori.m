function plot_soma_vs_den_ori(neuron, ori_flag, norm_flag)

if nargin < 2
    ori_flag = 1;
end

if nargin < 3
    norm_flag = 1;
end


nDb = numel(neuron);

for iDb = 1:nDb
    if ~isempty(neuron(iDb).combo_px_map.soma_pref_ori)
        missing(iDb) = false;
    else
        missing(iDb) = true;

    end
end

neuron = neuron(~missing);
nDb = numel(neuron);

for iDb = 1:nDb

    if ori_flag
        soma_pref(iDb) = neuron(iDb).combo_px_map.soma_pref_ori;
        % den_raw(:, iN) = neuron(iDb).combo_px_map.ori_bin_amp/max(neuron(iDb).combo_px_map.ori_bin_amp);
        % soma_raw(:,iN) = neuron(iDb).soma.aveOriPeak/max(neuron(iDb).soma.aveOriPeak);
        
        if norm_flag
        den_pref(iDb) = neuron(iDb).combo_px_map.pref_ori_norm;
        den_fit(:, iDb) = neuron(iDb).combo_px_map.tuning_fit_ori_rel_soma_norm/max(neuron(iDb).combo_px_map.tuning_fit_ori_rel_soma_norm);
        den_osi(iDb) = vis.osi(neuron(iDb).combo_px_map.ori_bin, neuron(iDb).combo_px_map.ori_bin_amp_norm,1);

        den(:, iDb) = neuron(iDb).combo_px_map.ori_bin_amp_norm_soma_rel/max(neuron(iDb).combo_px_map.ori_bin_amp_norm_soma_rel);

        else
        den_pref(iDb) = neuron(iDb).combo_px_map.pref_ori;
        den_fit(:, iDb) = neuron(iDb).combo_px_map.tuning_fit_ori_rel_soma/max(neuron(iDb).combo_px_map.tuning_fit_ori_rel_soma);
        den_osi(iDb) = vis.osi(neuron(iDb).combo_px_map.ori_bin, neuron(iDb).combo_px_map.ori_bin_amp,1);

        den(:, iDb) = neuron(iDb).combo_px_map.ori_bin_amp_soma_rel/max(neuron(iDb).combo_px_map.ori_bin_amp_soma_rel);

        end

        soma_fit(:,iDb) = neuron(iDb).soma.ori_fit_vm_centred/max(neuron(iDb).soma.ori_fit_vm_centred);
        soma(:, iDb) = neuron(iDb).soma.aveOriPeak_cent;

        if min(soma_fit(:,iDb)) <0
            soma_fit(:,iDb) = soma_fit(:,iDb)-min(soma_fit(:,iDb));

        end
        if min(soma(:, iDb)) <0
                        soma(:,iDb) = soma(:,iDb)-min(soma(:,iDb));

        end
           soma_fit(:,iDb) = soma_fit(:,iDb)/max(soma_fit(:,iDb));

            soma(:,iDb) = soma(:,iDb)/max(soma(:,iDb));

%         sort_den(:, iDb)  = (sort(den_fit(:,iDb), 'ascend') - min(den_fit(:,iDb)))/(max(den_fit(:,iDb))- min(den_fit(:,iDb)));
%         sort_soma(:, iDb) = (sort(soma_fit(:,iDb), 'ascend') - min(soma_fit(:,iDb)))/(max(soma_fit(:,iDb))- min(soma_fit(:,iDb)));
        
%         sort_den(:, iDb)  = sort(den_fit(:,iDb), 'ascend') /max(den_fit(:,iDb));
        [sort_soma_fit(:, iDb), idx] = sort(soma_fit(:,iDb), 'ascend');
        sort_soma_fit(:, iDb) =sort_soma_fit(:, iDb) /max(soma_fit(:,iDb));
        sort_den_fit(:, iDb)  = den_fit(idx,iDb) /max(den_fit(:,iDb));

        [sort_soma_fit_disc(:, iDb), sort_den_fit_disc(:, iDb)] =  intervalReg(sort_den_fit(:, iDb), sort_soma_fit(:, iDb), 0:0.1:1);

        [sort_soma(:, iDb), idx] = sort(soma(:,iDb), 'ascend');
        sort_soma(:, iDb) =sort_soma(:, iDb) /max(soma(:,iDb));
        sort_den(:, iDb)  = den(idx,iDb) /max(den(:,iDb));

        [sort_soma_disc(:, iDb), sort_den_disc(:, iDb)] =  intervalReg(sort_den(:, iDb), sort_soma(:, iDb), 0:0.1:1);


        
        this_soma = neuron(iDb).soma.aveOriPeak;
        min_soma = min(this_soma);
        if min_soma <0
            this_soma = this_soma-min_soma;
        end
        soma_osi(iDb) = vis.osi(neuron(iDb).combo_px_map.ori_bin, this_soma',1);

    else

        if norm_flag
        den_pref(iDb) = neuron(iDb).combo_px_map.pref_dir_norm;
        else
        den_pref(iDb) = neuron(iDb).combo_px_map.pref_dir;
        end
        soma_pref(iDb) = neuron(iDb).combo_px_map.soma_pref_dir;

    end
end

        [ave_sort_soma_fit_disc, ave_sort_den_fit_disc] =  intervalReg(sort_den_fit(:), sort_soma_fit(:), 0:0.1:1, 1);
        [ave_sort_soma_disc, ave_sort_den_disc] =  intervalReg(sort_den(:), sort_soma(:), 0:0.1:1, 1);


if ori_flag

    soma_pref = soma_pref*2;
    den_pref = den_pref*2;

end

nDb = numel(soma_pref);

nS = 10000;
for iS = 1:nS
    shuffle = randperm(nDb);
    rs(iS) = circ_corrcc(soma_pref(shuffle)*pi/180, den_pref*pi/180);
    d_pref = unwrap_angle(den_pref*pi/180 - soma_pref(shuffle)*pi/180);
    [~, vs(iS)] = circ_vtest(d_pref, 0);

end

r = circ_corrcc(soma_pref*pi/180, den_pref*pi/180);
pr = sum(rs>r)/(nS+1);

d_pref = unwrap_angle(den_pref*pi/180 - soma_pref*pi/180);
[~, v] = circ_vtest(d_pref, 0);

pv = sum(vs>v)/(nS+1);

if ori_flag
    soma_pref = soma_pref/2;
    den_pref = den_pref/2;
    d_pref = den_pref - soma_pref;

    flip_up = d_pref <= -90;
    flip_dw = d_pref > 90;
    den_pref(flip_up) = den_pref(flip_up) + 180;
    den_pref(flip_dw) = den_pref(flip_dw) - 180;
    d_pref(d_pref >90) = d_pref(d_pref >90) -180;
    d_pref(d_pref <=-90) = d_pref(d_pref <=-90) +180;

    ad_pref = abs(d_pref);

else

    d_pref = den_pref - soma_pref ;
    flip_up = d_pref <= -180;
    flip_dw = d_pref > 180;
    den_pref(flip_up) = den_pref(flip_up) + 360;
    den_pref(flip_dw) = den_pref(flip_dw) - 360;
    ad_pref = abs(d_pref);

end

%% average stats

tun_oris = neuron(1).soma.oris(1:6);
tun_oris = [tun_oris, tun_oris(end)+unique(diff(tun_oris))];

ave_den =  median([den; den(1,:)],2); 
ave_soma =  median([soma; soma(1,:)],2); 

ave_den_fit =  median([den_fit; den_fit(1,:)],2); 
ave_soma_fit =  median([soma_fit; soma_fit(1,:)],2); 

[ave_sort_soma, idx] = sort(ave_soma, 'ascend');
ave_sort_den  = ave_den(idx)/max(ave_den);

[ave_sort_soma_fit, idx] = sort(ave_soma_fit, 'ascend');
ave_sort_den_fit  = ave_den_fit(idx) /max(ave_den_fit);

%% plot
figure('Color', 'w', 'Position', [508 534 732 444]);

subplot(3,3,1)
plot(tun_oris, [den; den(1,:)], 'Color', [0.7 0.7 0.7], 'LineWidth', 0.5); hold on;
plot(tun_oris, median([den; den(1,:)],2), 'Color', [0 0 0], 'LineWidth', 2); hold on;
xlim([-100 100])
ylim([ -0.1 1.1])
set(gca, 'XTick', [-90 0 90]);
axis square;
xlabel('D pref ori')
ylabel('Normalised glut input')
formatAxes

subplot(3,3,2)
plot(tun_oris , [soma; soma(1,:)], 'Color', [0.7 0.7 0.7], 'LineWidth', 0.5); hold on;
plot(tun_oris , median([soma; soma(1,:)],2), 'Color', [0 0 0], 'LineWidth', 2); hold on;
xlim([-100 100])
ylim([ -0.1 1.1])
set(gca, 'XTick', [-90 0 90]);
axis square;
xlabel('D pref ori')
ylabel('Normalised glut input')
formatAxes
% 
subplot(3,3,3)
plot([0.5 1], [0.5 1], '--', 'Color', [0 0 0]); hold on
for iN = 1: nDb
        plot(sort_den(:, iN) , sort_soma(:, iN) , 'o', 'Color', [0.7 0.7 0.7]); 
end
% plot(ave_sort_den_disc, ave_sort_soma_disc , 'Color', [0 0 0], 'LineWidth', 2); 
plot(ave_sort_den_disc,ave_sort_soma_disc, 'Color', [0 0 0], 'LineWidth', 2); 

xlim([0.45 1.1])
ylim([ -0.1 1.1])
set(gca, 'XTick', [0.5 1]);
axis square;
xlabel('Glut input')
ylabel('Soma resp')
formatAxes



subplot(3,3,4)
tun_oris = neuron(iDb).combo_px_map.tun_oris;
plot(tun_oris , den_fit, 'Color', [0.7 0.7 0.7], 'LineWidth', 0.5); hold on;
plot(tun_oris , nanmedian(den_fit,2), 'Color', [0 0 0], 'LineWidth', 2); hold on;
xlim([-100 100])
ylim([ -0.1 1.1])
set(gca, 'XTick', [-90 0 90]);
axis square;
xlabel('D pref ori')
ylabel('Normalised glut input')
formatAxes

subplot(3,3,5)
plot(tun_oris , soma_fit, 'Color', [0.7 0.7 0.7], 'LineWidth', 0.5); hold on;
plot(tun_oris , nanmedian(soma_fit,2), 'Color', [0 0 0], 'LineWidth', 2); hold on;
xlim([-100 100])
ylim([ -0.1 1.1])
set(gca, 'XTick', [-90 0 90]);
axis square;
xlabel('D pref ori')
ylabel('Normalised soma resp')
formatAxes


subplot(3,3,6)
plot([0.5 1], [0.5 1], '--', 'Color', [0 0 0]); hold on
for iN = 1: nDb
%     plot(sort_den_fit(:, iN) , sort_soma_fit(:, iN) , 'o', 'Color', [0.7 0.7 0.7], 'LineWidth', 0.5); 
        plot(sort_den_fit_disc(:, iN) , sort_soma_fit_disc(:, iN) , '-', 'Color', [0.7 0.7 0.7]); 

end
% plot(ave_sort_den_fit_disc, ave_sort_soma_fit_disc , 'Color', [0 0 0], 'LineWidth', 2);
plot(ave_sort_den_fit_disc,ave_sort_soma_fit_disc, 'Color', [0 0 0], 'LineWidth', 2); 
xlim([0.45 1.1])
ylim([ -0.1 1.1])
set(gca, 'XTick', [0.5 1]);
axis square;
xlabel('Glut input')
ylabel('Soma resp')
formatAxes

subplot(3,3,7)
hold on;
plot([0 180], [0 180], '--', 'Color', [0 0 0]);
plot(soma_pref, den_pref, 'o', 'MarkerFaceColor', [0.7 0.7 0.7], 'MarkerEdgeColor', [0 0 0], 'MarkerSize', 7);
axis square
if ori_flag
    xlim([-90 270])
    ylim([-90 270])
else
    xlim([-180 540])
    ylim([-180 540])
end
formatAxes
xlabel('Soma pref ori')
ylabel('Input pref ori')
title(sprintf('rcc = %03f, p = %03f \n  vp = %03f', r, pr, pv));

subplot(3,3,8)
if ori_flag
    edges = 0:15:90;
else
    edges = 0:30:180;
end
bins = edges(1:end-1) + mean(diff(edges))/2;
ad = histcounts(ad_pref,edges);
bar(bins, ad, 0.8, 'EdgeColor', [0 0 0], 'FaceColor', [0.7 0.7 0.7]);
axis square
set(gca, 'XTick', edges)
xlabel('Soma-input D ori')
ylabel('Count')
formatAxes

subplot(3,3,9)
hold on;
plot([0 1], [0 1], '--', 'Color', [0 0 0]);
plot(soma_osi, den_osi, 'o', 'MarkerFaceColor', [0.7 0.7 0.7], 'MarkerEdgeColor', [0 0 0], 'MarkerSize', 7);
axis square
xlabel('Soma OSI')
ylabel('Input OSI')
formatAxes
% title(sprintf('rcc = %03f, p = %03f', r, p));

end