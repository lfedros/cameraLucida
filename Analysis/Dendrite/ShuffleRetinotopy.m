function [ histCnts, avgAng, cVar, treeShuffleRetino ] = ShuffleRetinotopy( neuronData )

n = length( neuronData );
ind_1 = 1 : n;
rng('shuffle');
ind_2 = randperm( n );

thetaShuffleRetino = cell(n,1);
for i = 1 : n
    [tree, tree1, retX, retY] = RetinoMap( neuronData(ind_1(i)).name, neuronData(ind_2(i)).dbVis );
    file_name_vis = strcat(neuronData(ind_1(i)).name, '_V');
    fname_V = strcat(file_name_vis, '_soma');
    thetaShuffleRetino{i,1} = DendriteBox_Moment( tree1, file_name_vis );
    treeShuffleRetino(i).AE = tree1;
    close all;
end

%% step 1: compute angle values (thetaData)
thetaData = cell(n,1);
for i = 1 : n
    thetaData{i,1} = thetaShuffleRetino{i,1}.theta_axial;
end

%% step 2: compute histogram counts (histData) based on angle values (thetaData)
histData_n = cell(n, 1);
for j = 1 : n
    obj1 = CircHist(thetaData{j, 1}, (-5:10:360-5),  'areAxialData', true );
    histData = obj1.histData;
    histData_n{j,1} = histData(:,1)./sum( histData(:, 1) ); 
    close all;
end

avg_hist_n = reshape( cell2mat(histData_n), 36, n );
avg_hist_n = mean( avg_hist_n, 2 );
histCnts = avg_hist_n(:,1); % final result is histogram counts of average of all neurons

%% step 3: compute average angle (avgAng) and circular variance (cVar)
axialDim = 2; % angular data is axial
axTrans = @(x)circ_axial(x,axialDim);

% edge calculations
edges = 0 : (360/numel(histCnts)) : 360;

% deduce bin data from edges
binSizeDeg = abs(edges(1) - edges(2));
binCentersDeg = edges(1:end-1) + binSizeDeg/2;
binCentersRad = deg2rad(binCentersDeg');

% compute stats
avgAng  = rad2deg(circ_mean(axTrans(binCentersRad),histCnts)) / axialDim; 
cVar    = circ_var( axTrans(binCentersRad),histCnts ) / axialDim;

%% step 4: plot histogram
obj1 = CircHist(histCnts, 'dataType', 'histogram', 'avgAng', avgAng);

%% step 5: clean up histogram 
obj1.colorBar = 'k'; % change color of bars
obj1.polarAxs.ThetaZeroLocation = 'right'; % rotate the plot to have 0 on the right side
obj1.colorAvgAng = [.5 .5 .5]; % change average-angle line color
title(''); % remove title
obj1.scaleBarSide = 'left'; % draw rho-axis on the left side of the plot
% draw resultant vector r as arrow
% delete(obj1.rH)
rl = rlim; % get current limits
obj1.setRLim([rl(1) 0.07]);
obj1.polarAxs.ThetaAxis.MinorTickValues = []; % remove dotted tick-lines
thetaticks(0:90:360); % change major ticks
rticks(0:1); % change rho-axis tick-steps to remove all concentric circles 
% update scale bar
delete(obj1.scaleBar); % remove scale bar 
set(gca, 'fontname', 'Te X Gyre Heros'); % due to Linux compatability issue with Helvetica font]

%% Step 6: plot prefOri arrow
obj1.drawArrow( 90 , [], 'HeadWidth', 10, 'LineWidth', 2, 'Color', 'b' );
obj1.drawArrow( 270 , [], 'HeadWidth', 10, 'LineWidth', 2, 'Color', 'b' );

%% Step 7: plot avgAng arrow
obj1.drawArrow(obj1.avgAng, [] , 'HeadWidth', 10, 'LineWidth', 2, 'Color', 'k')
obj1.drawArrow(- (180 - obj1.avgAng) , [] , 'HeadWidth', 10, 'LineWidth', 2, 'Color', 'k')
end


% %% Step 8: make density plot
% % add in original db files to struct (unchanged in retinotopy shuffle)
% for i = 1 : n
%     treeShuffleRetino(i).db = neuronData(ind_2(i)).db;
% end
% 
% densityNeuron( treeShuffleRetino, 1 : n );



