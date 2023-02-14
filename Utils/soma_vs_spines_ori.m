function soma_vs_spines_ori(neruon, ori_flag)

if nargin < 2
    ori_flag = 1;
end

nDb = numel(neruon);

for iDb = 1:nDb

    if ori_flag
        den_pref(iDb) = neuron(iDb).combo_px_map.pref_ori;
        if ~isempty(neuron(iDb).combo_px_map.soma_pref_ori)
            soma_pref(iDb) = neuron(iDb).combo_px_map.soma_pref_dir_ori;
            %         soma_pref_ori(iDb) = neuron(iDb).combo_px_map.soma_pref_ori; % pure ori can be unstable for dir seletive neurons
        else
            soma_pref(iDb) = NaN;
        end

    else
        den_pref(iDb) = neuron(iDb).combo_px_map.pref_dir;
        if ~isempty(neuron(iDb).combo_px_map.soma_pref_dir)
            soma_pref(iDb) = neuron(iDb).combo_px_map.soma_pref_dir;
            %         soma_pref_ori(iDb) = neuron(iDb).combo_px_map.soma_pref_ori; % pure ori can be unstable for dir seletive neurons
        else
            soma_pref(iDb) = NaN;
        end
    end
end

missing = isnan(soma_pref);
soma_pref(missing) = [];
den_pref(missing) = [];

if ori_flag

    soma_pref = soma_pref*2;
    den_pref = den_pref*2;

end

nDb = numel(soma_pref);

nS = 1000;
for iS = 1:nS
    shuffle = randperm(nDb);
    rs(iS) = circ_corrcc(soma_pref(shuffle)*pi/180, den_pref*pi/180);
end

r = circ_corrcc(soma_pref*pi/180, den_pref*pi/180);

p = sum(rs>r)/(nS+1);


d_pref = den_pref - soma_pref ;

flip_up = d_pref <= -180;
flip_dw = d_pref > 180;

soma_pref(flip_up) = soma_pref + 360;
soma_pref(flip_dw) = soma_pref - 360;

if ori_flag
    soma_pref = soma_pref/2;
    den_pref = den_pref/2;
end


%% plot
figure;
subplot(1,2,1)
hold on;
plot([0 180], [0 180], '--', 'Color', [0.7 0.7 0.7]);
plot(soma_pref, den_pref, 'o', 'MarkerFaceColor', [0 1 0.5], 'MarkerEdgeColor', [0 0 0], 'MarkerSize', 10);
axis square
if ori_flag
    xlim([0 180])
    ylim([0 180])
else
    xlim([0 360])
    ylim([0 360])
end
formatAxes
title(sprintf('rcc = %03f, p = %03f', r, p));
subplot(1,2,2)
if ori_flag
    edges = 0:30:90;
else
    edges = 0:30:180;
end
bins = edges(1:end-1) + mean(diff(edges))/2;
d_pref = abs(den_pref - soma_pref);
ad = histcounts(d_pref,edges);
bar(bins, ad, 0.8, 'EdgeColor', [0 0 0], 'FaceColor', [0 1 0.5]);
axis square
set(gca, 'XTick', edges)
formatAxes



end