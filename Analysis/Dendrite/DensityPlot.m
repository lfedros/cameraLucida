% DENSITYPLOT 	average density plot of all neurons 
% 
% See also: DENSITYNEURON
% 2020 N Ghani and LF Rossi

%% step 1: density plots
load('neuronData.mat'); % load data
n = length(neuronData);
densityNeuron( neuronData, 1:n ); % non-shuffle in visual space [AE]
print( 'AE' , '-dpng' );
densityNeuron( neuronData, randperm(n) ); % shuffle in visual space [AE]
print( 'AE_shuffle', '-dpng' );
densityNeuronXY( neuronData, 1:n ); % non-shuffle in cortical space [XY]
print( 'XY', '-dpng' );

%% uncomment to change density plots to blue colormap
camp = BlueWhiteRed_burnLFR( 1001, 1 );
cmapBlue = cmap( 1:502, : );
cmap = cmapBlue;
colormap ( cmap );
colormap ( flipud(cmap) );

%% step 2: histogram for non-shuffle in visual space [AE]
[histCnts, avgAng, cVar]     = densityHist( neuronData, 1:n );
print( 'AE_hist', '-dpng');

%% step 3: histogram for shuffle in visual space [AE]
n_shuffles = 100; % number of shuffles
histCnts_s = cell(n_shuffles, 1);
avgAng_s   = cell(n_shuffles, 1);
cVar_s     = cell(n_shuffles, 1);
for i = 1 : n_shuffles
    [histCnts_s{i,1}, avgAng_s{i,1}, cVar_s{i,1}] = densityHist( neuronData, randperm(n) );
end

shuffleData_Ret.histCnts_s = histCnts_s; shuffleData_Ret.avgAng_s = avgAng_s; shuffleData_Ret.cVar_s = cVar_s;
save('shuffleData','shuffleData');

%% step 4: plot of unshuffled v. shuffled circular variance in visual space [AE] [prefOri shuffle]
figure; 
hist( cell2mat(cVar_s), 20);
hold on;
xline( cVar, '--r', 'LineWidth', 2);
xlim([0.3 0.5]);
set(gca, 'fontname', 'Te X Gyre Heros');
xlabel('Circular Variance');
ylabel('Counts');
legend('shuffled', 'unshuffled');

%% step 5: histogram for 100 shuffles in visual space [AE] 
histCnts_r = cat( 3, histCnts_s{:} );
histCnts_r = mean(histCnts_r, 3);
avgAng_r = rad2deg( circ_mean( deg2rad( cell2mat (avgAng_s) )));
obj1 = CircHist(histCnts_r, 'dataType', 'histogram', 'avgAng', avgAng_r);

%% step 6: clean up histogram 
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

%% step 7: plot prefOri arrow
obj1.drawArrow( 90 , [], 'HeadWidth', 10, 'LineWidth', 2, 'Color', 'b' );
obj1.drawArrow( 270 , [], 'HeadWidth', 10, 'LineWidth', 2, 'Color', 'b' );

%% step 8: plot avgAng arrow
obj1.drawArrow(obj1.avgAng, [] , 'HeadWidth', 10, 'LineWidth', 2, 'Color', 'k')
obj1.drawArrow(- (180 - obj1.avgAng) , [] , 'HeadWidth', 10, 'LineWidth', 2, 'Color', 'k')

%% step 9: save polar plot
print( 'AE_shuffle_hist', '-dpng' );
close;

%% step 10: shuffle for retinotopic space [AE]
n_shuffles = 100;
histCnts_ret        = cell(n_shuffles, 1);
avgAng_ret          = cell(n_shuffles, 1);
cVar_ret            = cell(n_shuffles, 1);
treeShuffleRetino   = cell(n_shuffles, 1);
for i = 1 : n_shuffles
    [histCnts_ret{i,1}, avgAng_ret{i,1}, cVar_ret{i,1}, treeShuffleRetino{i,1}] = ShuffleRetinotopy( neuronData );
end

shuffleData_Ret.histCnts_ret = histCnts_ret; 
shuffleData_Ret.avgAng_ret = avgAng_ret; 
shuffleData_Ret.cVar_ret = cVar_ret;
shuffleData_Ret.treeShuffleRetino = treeShuffleRetino;
save('shuffleData_Ret','shuffleData_Ret');

%% plot of unshuffled v. shuffled circular variance in visual space [AE] [retinotopy shuffle]
figure; 
cVar_ret = shuffleData_Ret.cVar_ret;
hist( cell2mat(cVar_ret), 20);
hold on;
xline( cVar, '--r', 'LineWidth', 2);
xlim([0.3 0.5]);
set(gca, 'fontname', 'Te X Gyre Heros');
xlabel('Circular Variance');
ylabel('Counts');
legend('shuffled', 'unshuffled');

%% 

