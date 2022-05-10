function spines = pool_spines(neuron, doPlot)

if nargin < 2
    doPlot = 0;
end


%% load spines data and reformat


spines.x_um = double(cat(1, neuron.dendrite(:).X));
spines.y_um = double(cat(1, neuron.dendrite(:).Y));

spines.tune_pars = [];
spines.tuning = [];
spines.tun_dirs = 0:359;
spines.exp_ref = [];
s_count = 0;

for iD = 1:numel(neuron.dendrite)
    for iS = 1: numel(neuron.dendrite(iD).Fitpars)

        s_count = s_count+1;
        spines.exp_ref = cat(1, spines.exp_ref, neuron.db.spine_seq{iD}(1:end-13));
        spines.tune_pars = cat(1, spines.tune_pars, neuron.dendrite(iD).Fitpars{iS});

        spines.tuning(:, s_count) = mfun.vonMises2(neuron.dendrite(iD).Fitpars{iS}, spines.tun_dirs);

        pk(s_count) = max(spines.tuning(:, s_count));

        if pk(s_count)>0
            spines.tuning(:, s_count) = spines.tuning(:, s_count)/pk(s_count);
        else
            spines.tuning(:, s_count)= (spines.tuning(:, s_count)+abs(min(spines.tuning(:, s_count))))...
                /max(spines.tuning(:, s_count)+abs(min(spines.tuning(:, s_count)))) ;
        end
    end
end

spines.soma_tuning = nanmean(spines.tuning, 2);

spines.pref_dir = spines.tune_pars(:,1); %[0 360]
[~, spines.sort_idx] = sort(spines.pref_dir, 'ascend');
spines.ori = spines.pref_dir-90; %[-90, 270]
spines.ori(spines.ori>180) = spines.ori(spines.ori>180)-180; %[-90 90]
spines.ori(spines.ori<0) = spines.ori(spines.ori<0)+180; %[0 180]

spines.soma_ori = rad2deg(circ_mean(spines.ori*2*pi/180))/2;

spines.d_ori = spines.ori - spines.soma_ori;
spines.d_ori(spines.d_ori>90) = spines.d_ori(spines.d_ori>90)-180;
spines.d_ori(spines.d_ori<-90) = spines.d_ori(spines.d_ori<-90)+180;
spines.d_ori = abs(spines.d_ori);


if doPlot

figure; plot(spines.tun_dirs, spines.tuning(:, spines.sort_idx), 'Color', [0.5, 0.5, 0.5]);hold on
plot(spines.tun_dirs,spines.soma_tuning, 'k', 'Linewidth', 2)
formatAxes
xlabel('D stimulus direction')
ylabel('Tuning')
xlim([-10 370])
ylim([-0.3 1.1])
title('iGluSnFR3 spines and soma')


figure; 
subplot(1,2,1)
tun_color = hsv(180);
scatter(spines.x_um, spines.y_um, tun_color(ceil(spines.ori+0.01), :)); hold on
scatter(0 , 0, tun_color(round(spines.soma_ori), :))
subplot(1,2,2)
histogram(spines.ori, [0:30:180]);


end


end