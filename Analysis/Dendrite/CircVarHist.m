%% Circular Variance Histogram

%% obtain raw data
avg_hist_s = cell(1);

for i = 1 : 100
    [avg_hist_s{i,1}] = ShuffleTest ( 18 ); 
end

save( 'avg_hist_s', 'avg_hist_s');

%%
axTrans = @(x)circ_axial(x, 2);
avgAng = cell(100,1);
cVar   = cell(100,1);
axialDim = 2;
for j = 1 : length(avg_hist_s)
    histData = avg_hist_s{ j, 1 };
    histCnts = histData(:,1);
    
    % edge calculations
    edges = 0 : (360/numel(histCnts)) : 360;
    
    % deduce bin data from edges
    binSizeDeg = abs(edges(1) - edges(2));
    binSizeRad = deg2rad(binSizeDeg);
    binCentersDeg = edges(1:end-1) + binSizeDeg/2;
    binCentersRad = deg2rad(binCentersDeg');
    
    % compute histogram values
    alpha = axTrans(binCentersRad);
    w = histCnts;
    
    % compute stats
    avgAng{ j, 1 }  = rad2deg(circ_mean(axTrans(binCentersRad),histCnts)) / axialDim;
    cVar{  j, 1 }   = circ_var( axTrans(binCentersRad),histCnts ) / axialDim;
end

%% results of shuffled data 
avgAng = cell2mat(avgAng);
cVar   = cell2mat(cVar);

%% find cVar of non-shuffled data

% to compare to average shuffled-data, we must compute average non-shuffled
% data

load('thetaMaps.mat');
% compute histData of thetaMaps
n = 18; % num of cells
histData_n = cell(n, 1);
for j = 1 : n
    obj1 = CircHist(thetaMaps.thetaMap{j, 1}, (-5:10:360-5),  'areAxialData', true );
    histData = obj1.histData;
    histData_n{j,1} = histData(:,1)./sum( histData(:, 1) ); 
    close all;
end

avg_hist_n = reshape( cell2mat(histData_n), 36, n );
avg_hist_n = mean( avg_hist_n, 2 );

histCnts = avg_hist_n(:,1);

% edge calculations
edges = 0 : (360/numel(histCnts)) : 360;

% deduce bin data from edges
binSizeDeg = abs(edges(1) - edges(2));
binSizeRad = deg2rad(binSizeDeg);
binCentersDeg = edges(1:end-1) + binSizeDeg/2;
binCentersRad = deg2rad(binCentersDeg');

% compute histogram values
alpha = axTrans(binCentersRad);
w = histCnts;

% compute stats
avgAng_raw  = rad2deg(circ_mean(axTrans(binCentersRad),histCnts)) / axialDim;
cVar_raw   = circ_var( axTrans(binCentersRad),histCnts ) / axialDim;

%% compute p - value
factorial( 10 ); % num of permutations for n = 10 cells

% we randomly sample a subset of permutations since that value is too large
% = 100 shuffles of 10 cells

p_val  = 1 / 100; % one-tailed t-test




    
    
    
    


