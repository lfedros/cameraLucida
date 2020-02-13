% STATISTICS 	circular statistics for all neurons
% 
%
% See also: OVERALL_DATAANALYSIS

% 2020 N Ghani and LF Rossi

%% generate dendOri v prefOri plot

%% Step 1: enter path of single neuron
addpath(genpath('/home/naureeng/cameraLucida')); 
addpath(genpath('/home/naureeng/cameraLucida/Dependencies'));

%% Step 2: build data struct
load('neuronData.mat');
n = length( neuronData ); % num of files
data = zeros(n,3);
for i = 1 : n
    data(i,1) = neuronData(i).db.prefOri;
    data(i,2) = neuronData(i).avgAng(1); % 1 of 2
    data(i,3) = neuronData(i).peaks_VM(2); % 2 of 2
   
end

%% plot
figure;
subplot(2,3,1);
alphas = nan(size(data));
alphas(:,1) = circ_ang2rad(data(:,1)*2);
alphas(:,2) = circ_ang2rad(data(:,2)*2);
plot(data(:,1), data(:,2) , 'ko')
hold on;
axis equal;
plot([-90 90], [-90 90], 'k--');
xlabel(' Preferred Orientation [deg] ');
ylabel(' Mean Angle Dendrite Orientation [deg]  ');

[c,p] = circ_corrcc(alphas(:,1), alphas(:,2));
title(sprintf('corr = %1.2f, p = %2.4f', c, p));


set(gca, 'xlim', [-120 120], 'xtick', -90:45:90 );
set(gca, 'ylim', [-120 120], 'ytick', -90:45:90 );
set(gca, 'fontname', 'Te X Gyre Heros'); % due to Linux compatability issue with Helvetica
set(gca, 'linewidth', 1.5);

%%
n_shuffles = 1000; % do 1000x shuffle for p-value
x = alphas(:,1);
y = alphas(:,2);
corr_shuffle = zeros(n_shuffles,1);
for i = 1:n_shuffles
    corr_shuffle(i,1) = bsxfun( @(x,y) circ_corrcc(x, y(randperm(length(y)))) , x, y );
end

subplot(2,3,4);
hist(corr_shuffle, 20);
hold on;
xline(c, 'r--','LineWidth', 2);
set(gca, 'fontname', 'Te X Gyre Heros'); % due to Linux compatability issue with Helvetica
p_val = length(find(corr_shuffle>c))/n_shuffles;
title(sprintf('p-value = %f', p_val));
xlabel('Circular Correlation');
ylabel('Counts');
set(gca, 'linewidth', 1.5);

%% generate ori tune std dev v. von Mises std dev plot
load('OT_std1'); % ori tune std dev
load('VM_std1'); % VM  tune std dev
figure;
scatter( OT_std1, VM_std1, 100, 'r','filled', 'MarkerEdgeColor', 'k' );
xlim([ 0 0.7] );
ylim([ 0 0.4] );
set(gca, 'fontname', 'Te X Gyre Heros'); % due to Linux compatability issue with Helvetica
xlabel(' Orientation Tuning Std Dev' );
ylabel(' Von Mises Std Dev ');

[r,p] = corrcoef( OT_std1, VM_std1 );
title(strcat ( sprintf('corr = %f', r(2)), sprintf(', p = %f', p(2)) ) );
axis square;
set(gca, 'linewidth', 1.5);
print(' OriVMstd ', '-dpng');

%% generate von Mises vs pref Ori plot
subplot(2,3,3);
alphas(:,1) = circ_ang2rad(data(:,1)*2);
alphas(:,2) = circ_ang2rad(data(:,3)*2);
plot(data(:,1), data(:,2) , 'ko')
hold on;
axis equal;
plot([-90 90], [-90 90], 'k--');
xlabel(' Preferred Orientation [deg] ');
ylabel(' von Mises Dendrite Orientation [deg]  ');

[c,p] = circ_corrcc(alphas(:,1), alphas(:,2));
title(sprintf('corr = %1.2f, p = %2.4f', c, p));


set(gca, 'xlim', [-120 120], 'xtick', -90:45:90 );
set(gca, 'ylim', [-120 120], 'ytick', -90:45:90 );
set(gca, 'fontname', 'Te X Gyre Heros'); % due to Linux compatability issue with Helvetica
set(gca, 'linewidth', 1.5);

%%
n_shuffles = 1000; % do 1000x shuffle for p-value
x = alphas(:,1);
y = alphas(:,2);
corr_shuffle = zeros(n_shuffles,1);
for i = 1:n_shuffles
    corr_shuffle(i,1) = bsxfun( @(x,y) circ_corrcc(x, y(randperm(length(y)))) , x, y );
end

subplot(2,3,6);
hist(corr_shuffle, 20);
hold on;
xline(c, 'r--','LineWidth', 2);
set(gca, 'fontname', 'Te X Gyre Heros'); % due to Linux compatability issue with Helvetica
p_val = length(find(corr_shuffle>c))/n_shuffles;
title(sprintf('p-value = %f', p_val));
xlabel('Circular Correlation');
ylabel('Counts');
set(gca, 'linewidth', 1.5);

%% generate prefOri vs dendOri with circular distance [circ_dist] function
subplot(2,3,2);
load('diff_avg1.mat');
alphas(:,1) = circ_ang2rad(data(:,1));
alphas(:,2) = circ_ang2rad((data(:,1)+diff_avg1));
plot(data(:,1), data(:,1)+diff_avg1 , 'ko')
hold on;
axis equal;
plot([-90 90], [-90 90], 'k--');
xlabel(' Preferred Orientation [deg] ');
ylabel(' Circular Distance Dendrite Orientation [deg]  ');

[c,p] = circ_corrcc(alphas(:,1), alphas(:,2));
title(sprintf('corr = %1.2f, p = %2.4f', c, p));

set(gca, 'xlim', [-120 120], 'xtick', -90:45:90 );
set(gca, 'ylim', [-120 120], 'ytick', -90:45:90 );
set(gca, 'fontname', 'Te X Gyre Heros'); % due to Linux compatability issue with Helvetica
set(gca, 'linewidth', 1.5);

%%
n_shuffles = 1000; % do 1000x shuffle for p-value
x = alphas(:,1);
y = alphas(:,2);
corr_shuffle = zeros(n_shuffles,1);
for i = 1:n_shuffles
    corr_shuffle(i,1) = bsxfun( @(x,y) circ_corrcc(x, y(randperm(length(y)))) , x, y );
end

subplot(2,3,5);
hist(corr_shuffle, 20);
hold on;
xline(c, 'r--','LineWidth', 2);
set(gca, 'fontname', 'Te X Gyre Heros'); % due to Linux compatability issue with Helvetica
p_val = length(find(corr_shuffle>c))/n_shuffles;
title(sprintf('p-value = %f', p_val));
xlabel('Circular Correlation');
ylabel('Counts');
set(gca, 'linewidth', 1.5);

%% save 2 x 3 = 6 panel figure as 1 PNG
print('Stats.png','-dpng');

%% shuffle in cortical space by changing dendOri when computing prefOri - dendOri
pref_ori = data(:,1);
dend_ori = data(:,2);

% unshuffled prefOri - dendOri
diff_ori = pref_ori - dend_ori; % range [-180 180]

% rescale to correct range [0 90]
    ii = diff_ori > 90;
    diff_ori(ii,1) = diff_ori(ii,1) - 180;
    ii = diff_ori < -90;
    diff_ori(ii,1) = diff_ori(ii,1) + 180;
    
diff_ori = abs( diff_ori );
    
mean_unshuffled = mean( diff_ori );  

% shuffled prefOri - dendOri

mean_shuffled = cell(1000,1);
for i = 1 : 1000 % 1000 shuffles
    ind = randperm(18,18);
    diff_ori = pref_ori - dend_ori(ind) ; % range [-180 180]
    
    % rescale to correct range [0 90]
    ii = diff_ori > 90;
    diff_ori(ii,1) = diff_ori(ii,1) - 180;
    ii = diff_ori < -90;
    diff_ori(ii,1) = diff_ori(ii,1) + 180;
    
    diff_ori = abs( diff_ori );
    
    mean_shuffled{i,1} = mean( diff_ori );
end

mean_shuffled = cell2mat(mean_shuffled);

%% make histogram for prefOri - dendOri shuffle
figure; 
hist( mean_shuffled, 20 );
hold on;
xline( mean_unshuffled, 'r--', 'linewidth', 2);

set(gca, 'fontname', 'Te X Gyre Heros'); % due to Linux compatability issue with Helvetica
set(gca, 'linewidth', 1.5);
xlabel('Mean Angle Difference [distance]');
ylabel('Counts');
p_val = length(find(mean_shuffled<mean_unshuffled))/n_shuffles;
title(sprintf('p-value = %f', p_val));



