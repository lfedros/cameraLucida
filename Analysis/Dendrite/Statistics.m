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

%%
n_shuffles = 1000; % do 1000x shuffle for p-value
x = alphas(:,1);
y = alphas(:,2);
corr_shuffle = zeros(n_shuffles,1);
for i = 1:n_shuffles
    corr_shuffle(i,1) = bsxfun( @(x,y) circ_corrcc(x, y(randperm(length(y)))) , x, y );
end

figure;
hist(corr_shuffle, 20);
hold on;
xline(c, 'r--','LineWidth', 2);
set(gca, 'fontname', 'Te X Gyre Heros'); % due to Linux compatability issue with Helvetica
p_val = length(find(corr_shuffle>c))/n_shuffles;
title(sprintf('p-value = %f', p_val));
xlabel('Circular Correlation');
ylabel('Counts');

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
print(' OriVMstd ', '-dpng');

%% generate von Mises vs pref Ori plot
figure; 
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

%%
n_shuffles = 1000; % do 1000x shuffle for p-value
x = alphas(:,1);
y = alphas(:,2);
corr_shuffle = zeros(n_shuffles,1);
for i = 1:n_shuffles
    corr_shuffle(i,1) = bsxfun( @(x,y) circ_corrcc(x, y(randperm(length(y)))) , x, y );
end

figure;
hist(corr_shuffle, 20);
hold on;
xline(c, 'r--','LineWidth', 2);
set(gca, 'fontname', 'Te X Gyre Heros'); % due to Linux compatability issue with Helvetica
p_val = length(find(corr_shuffle>c))/n_shuffles;
title(sprintf('p-value = %f', p_val));
xlabel('Circular Correlation');
ylabel('Counts');

%% generate prefOri vs dendOri with circular distance [circ_dist] function
figure; 
alphas(:,1) = circ_ang2rad(data(:,1)*2);
diff_avg = circ_dist( data(:,1), data(:,2) );
alphas(:,2) = circ_ang2rad((data(:,1)+diff_avg)*2);
plot(data(:,1), data(:,1)+diff_avg , 'ko')
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

%%
n_shuffles = 1000; % do 1000x shuffle for p-value
x = alphas(:,1);
y = alphas(:,2);
corr_shuffle = zeros(n_shuffles,1);
for i = 1:n_shuffles
    corr_shuffle(i,1) = bsxfun( @(x,y) circ_corrcc(x, y(randperm(length(y)))) , x, y );
end

figure;
hist(corr_shuffle, 20);
hold on;
xline(c, 'r--','LineWidth', 2);
set(gca, 'fontname', 'Te X Gyre Heros'); % due to Linux compatability issue with Helvetica
p_val = length(find(corr_shuffle>c))/n_shuffles;
title(sprintf('p-value = %f', p_val));
xlabel('Circular Correlation');
ylabel('Counts');
