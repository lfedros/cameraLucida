function [thetaData_s, histData_f, prefDir, avgAng ] = ShuffleDir ( thetaMaps, db, fname )

% SHUFFLEDIR will create a random pair of thetaMap and prefDir to compute
% a histogram

% add paths
addpath(genpath('C:\Users\Experiment\CircHist'));
addpath(genpath('C:\Users\Experiment\circstat-matlab'));

% align thetaMap to random prefDir
n = length( thetaMaps.thetaMap ); 
thetaData_s = cell( n , 1);

db.prefDir( db.prefDir > 180 ) = db.prefDir ( db.prefDir  > 180 ) - 360;
db.prefDir ( db.prefDir  < -180) = db.prefDir (db.prefDir  < -180) + 360;

% % % randomize prefDir
% rng('shuffle');
db.prefDir = db.prefDir ( randperm (n) );

for i = 1 : n
    thetaMap_s = thetaMaps.thetaMap{i,1} + db.prefDir(i); % take each thetaMap + add a random prefDir
    thetaMap_s( thetaMap_s >= 180 ) = thetaMap_s( thetaMap_s >= 180 ) - 360;
    thetaMap_s( thetaMap_s < -180) = thetaMap_s( thetaMap_s < -180) + 360;
    thetaData_s{i, 1} = thetaMap_s;
end

% compute histData of thetaMap_s
histData_s = cell(n, 1);
for j = 1 : n
    obj1 = CircHist(thetaData_s{j, 1}, (-5:10:360-5),  'areAxialData', true );
    histData = obj1.histData;
    histData_s{j, 1} = histData(:,1)./sum( histData(:, 1) ); % sum normalisation
    close all;
end

% make avg_hist_s
% each entry of histData_s is 36 x 1 (36 bins, each 10 degrees for 360
% degrees of full circle)
% obtain an entry of 360 x 1 and divide by 36
avg_hist_s = reshape( cell2mat(histData_s), 36, n );
avg_hist_s = mean( avg_hist_s, 2 );

% make plot
obj1 = CircHist( avg_hist_s , 'dataType', 'histogram' ,  'areAxialData', true );
histData_f = obj1.histData(:,1);

obj1.colorBar = 'k'; 
obj1.polarAxs.ThetaZeroLocation = 'right'; % rotate the plot to have 0° on the right side
obj1.colorAvgAng = [.5 .5 .5]; % change average-angle line color
obj1.scaleBarSide = 'left'; 
delete(obj1.rH)

% calculate prefOri

radian_prefDir = db.prefDir.*(pi/180);
prefDir = circ_mean(radian_prefDir).*(180/pi);
prefOri = - (prefDir - 90 ) + prefDir;

% plot avgArrow
delete(obj1.rH)
obj1.drawArrow(obj1.avgAng, [] , 'HeadWidth', 10, 'LineWidth', 2, 'Color', 'k')
obj1.drawArrow(- (180 - obj1.avgAng) , [] , 'HeadWidth', 10, 'LineWidth', 2, 'Color', 'k')
avgAng = obj1.avgAng;


% plot prefOri arrow
obj1.drawArrow( - (180 - prefOri) , [], 'HeadWidth', 10, 'LineWidth', 2, 'Color', 'b' );
obj1.drawArrow( (prefOri) , [], 'HeadWidth', 10, 'LineWidth', 2, 'Color', 'b' );

% plot prefDir arrow
% obj1.drawArrow ( (360 - prefDir) + prefDir , [], 'HeadWidth', 10, 'LineWidth', 2, 'Color', 'r' );


% print( fname, '-dtiff');

end

