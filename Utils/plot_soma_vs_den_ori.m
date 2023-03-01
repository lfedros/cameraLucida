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
        soma_pref(iDb) = neuron(iDb).combo_px_map.soma_pref_dir_ori;
        % den_raw(:, iN) = neuron(iDb).combo_px_map.ori_bin_amp/max(neuron(iDb).combo_px_map.ori_bin_amp);
        % soma_raw(:,iN) = neuron(iDb).soma.aveOriPeak/max(neuron(iDb).soma.aveOriPeak);
        
        if norm_flag
        den_pref(iDb) = neuron(iDb).combo_px_map.pref_ori_norm;
        den_fit(:, iDb) = neuron(iDb).combo_px_map.tuning_fit_ori_centred_norm/max(neuron(iDb).combo_px_map.tuning_fit_ori_centred_norm);
        den_osi(iDb) = vis.osi(neuron(iDb).combo_px_map.ori_bin, neuron(iDb).combo_px_map.ori_bin_amp_norm,1);

        else
        den_pref(iDb) = neuron(iDb).combo_px_map.pref_ori;
        den_fit(:, iDb) = neuron(iDb).combo_px_map.tuning_fit_ori_centred/max(neuron(iDb).combo_px_map.tuning_fit_ori_centred);
        den_osi(iDb) = vis.osi(neuron(iDb).combo_px_map.ori_bin, neuron(iDb).combo_px_map.ori_bin_amp,1);
        end

        soma_fit(:,iDb) = neuron(iDb).soma.ori_fit_vm_centred/max(neuron(iDb).soma.ori_fit_vm_centred);
        if min(soma_fit(:,iDb)) <0
            soma_fit(:,iDb) = soma_fit(:,iDb)-min(soma_fit(:,iDb));
            soma_fit(:,iDb) = soma_fit(:,iDb)/max(soma_fit(:,iDb));
        end
% 
%         sort_den(:, iDb)  = (sort(den_fit(:,iDb), 'ascend') - min(den_fit(:,iDb)))/(max(den_fit(:,iDb))- min(den_fit(:,iDb)));
%         sort_soma(:, iDb) = (sort(soma_fit(:,iDb), 'ascend') - min(soma_fit(:,iDb)))/(max(soma_fit(:,iDb))- min(soma_fit(:,iDb)));
        
        sort_den(:, iDb)  = sort(den_fit(:,iDb), 'ascend') /max(den_fit(:,iDb));
        sort_soma(:, iDb) = sort(soma_fit(:,iDb), 'ascend')/max(soma_fit(:,iDb));

        
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



%% plot
figure('Color', 'w', 'Position', [508 534 732 444]);


subplot(2,3,1)
tun_oris = neuron(iDb).combo_px_map.tun_oris;
plot(tun_oris , den_fit, 'Color', [0.7 0.7 0.7], 'LineWidth', 0.5); hold on;
plot(tun_oris , mean(den_fit,2), 'Color', [0 0 0], 'LineWidth', 2); hold on;
xlim([-100 100])
ylim([ -0.1 1.1])
set(gca, 'XTick', [-90 0 90]);
axis square;
xlabel('D pref ori')
ylabel('Normalised glut input')
formatAxes

subplot(2,3,2)
plot(tun_oris , soma_fit, 'Color', [0.7 0.7 0.7], 'LineWidth', 0.5); hold on;
plot(tun_oris , mean(soma_fit,2), 'Color', [0 0 0], 'LineWidth', 2); hold on;
xlim([-100 100])
ylim([ -0.1 1.1])
set(gca, 'XTick', [-90 0 90]);
axis square;
xlabel('D pref ori')
ylabel('Normalised soma resp')
formatAxes

subplot(2,3,3)
plot([0.5 1], [0.5 1], '--', 'Color', [0 0 0]); hold on
for iN = 1: nDb
    plot(sort_den(:, iN) , sort_soma(:, iN) , 'Color', [0.7 0.7 0.7], 'LineWidth', 0.5); 
end
plot(mean(sort_den ,2), mean(sort_soma ,2), 'Color', [0 0 0], 'LineWidth', 2); 
xlim([0.45 1.1])
ylim([ -0.1 1.1])
set(gca, 'XTick', [0.5 1]);
axis square;
xlabel('Glut input')
ylabel('Soma resp')
formatAxes

subplot(2,3,4)
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

subplot(2,3,5)
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

subplot(2,3,6)
hold on;
plot([0 1], [0 1], '--', 'Color', [0 0 0]);
plot(soma_osi, den_osi, 'o', 'MarkerFaceColor', [0.7 0.7 0.7], 'MarkerEdgeColor', [0 0 0], 'MarkerSize', 7);
axis square
xlabel('Soma OSI')
ylabel('Input OSI')
formatAxes
% title(sprintf('rcc = %03f, p = %03f', r, p));

end