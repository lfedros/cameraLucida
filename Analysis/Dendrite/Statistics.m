% STATISTICS 	circular statistics for all neurons
% 
%
% See also: OVERALL_DATAANALYSIS

% 2020 N Ghani and LF Rossi

%% Step 1: enter path of single neuron
addpath(genpath('/home/naureeng/cameraLucida')); 
addpath(genpath('/home/naureeng/cameraLucida/Dependencies'));

%% Step 2: build data struct
load('neuronData.mat');
n = length( neuronData ); % num of files
data = zeros(n,3);
for i = 1 : n
    data(i,1) = neuronData(i).db.prefOri;
    data(i,2) = neuronData(i).peaks_VM(1); % 1 of 2 peaks
    data(i,3) = neuronData(i).peaks_VM(2); % 2 of 2 peaks
end

diffVM =  min( abs([data(:,1)-data(:,2), data(:,1)-data(:,3)]), [], 2);

figure; 
plot(data(:,1), data(:,1)+diffVM , 'ko' );
hold on;
axis equal;
plot([-90 90], [-90 90], 'k--');
xlabel(' Preferred Orientation [deg] ');
ylabel(' Dendrite Orientation [deg]  ');

set(gca, 'xlim', [-120 120], 'xtick', -90:45:90 );
set(gca, 'ylim', [-120 120], 'ytick', -90:45:90 );


