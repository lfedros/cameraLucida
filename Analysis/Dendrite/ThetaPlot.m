%% Theta Polar Plot
% by Philip Berens Lab [2009-2019]

function [] = ThetaPlot( thetaMap, fname, db, analysis_type, colorID )
% semi-circle plot
% [-90 90]

switch analysis_type
    case 'seg'
        img = strcat(fname, '_theta_seg_axial');
    case 'box'
        img = strcat(fname, '_theta_box_axial');
end

%%
% add paths
addpath(genpath('C:\Users\Experiment\CircHist'));
addpath(genpath('C:\Users\Experiment\circstat-matlab'));
load('retino_tree','retino_tree');

% axial range = [-90 90]
% circular range = [-180 180]

% degree range = [-5:10:360-5] NOT [0:10:360] so that bins are centered
% at -5:10:85 deg in final plot rather than 0:10:90

db.prefDir( db.prefDir > 180 ) = db.prefDir ( db.prefDir  > 180 ) - 360;
db.prefDir ( db.prefDir  < -180) = db.prefDir (db.prefDir  < -180) + 360;

% thetaMap = rescale(thetaMap, -90, 90);
obj1 = CircHist(thetaMap, (-5:10:360-5) , 'areAxialData', true);

%%
data = obj1.histData(:,1);
data2 = data./max(data);
close all;

obj1 = CircHist( data2 , 'dataType', 'histogram' ,  'areAxialData', true );

%%

obj1.colorBar = 'k'; % change color of bars
obj1.avgAngH.LineStyle = '--'; % make average-angle line dashed
obj1.avgAngH.LineWidth = 1; % make average-angle line thinner
obj1.colorAvgAng = [.5 .5 .5]; % change average-angle line color
obj1.polarAxs.ThetaZeroLocation = 'right'; % rotate the plot to have 0� on the right side
thetalim([-180 180]); % change major ticks

% remove offset between bars and plot-center
% rl = rlim;
% obj1.setRLim([0,rl(2)]);

obj1.scaleBarSide = 'left'; % draw rho-axis on the left side of the plot
% draw resultant vector r as arrow
delete(obj1.rH)

title('');


% calc prefOri
db.prefOri = - (db.prefDir - 90); % range = [-270 90]

%%

% plot prefOri arrow
obj1.drawArrow( - (180 - db.prefOri) , [], 'HeadWidth', 10, 'LineWidth', 2, 'Color', cell2mat(retino_tree.color(colorID))  );
obj1.drawArrow( (db.prefOri) , [], 'HeadWidth', 10, 'LineWidth', 2, 'Color', cell2mat(retino_tree.color(colorID)) );

%%
% plot prefDir arrow
% obj1.drawArrow( - (180 - (360 - db.prefDir) ) , [], 'HeadWidth', 10, 'LineWidth', 2, 'Color', [0.098, 0.643, 0.682] );
% obj1.drawArrow( (360 - db.prefDir) , [], 'HeadWidth', 10, 'LineWidth', 2, 'Color', 'r' );
% plot avgArrow
delete(obj1.rH)
obj1.drawArrow(obj1.avgAng, [] , 'HeadWidth', 10, 'LineWidth', 2, 'Color', 'k')
obj1.drawArrow(- (180 - obj1.avgAng) , [] , 'HeadWidth', 10, 'LineWidth', 2, 'Color', 'k')

obj1.polarAxs.ThetaAxis.MinorTickValues = []; % remove dotted tick-lines
% change theta- and rho-axis ticks
thetaticks(-180:90:180); % change major ticks

%% change r-ticks
rticks(0:1); % change rho-axis tick-steps to remove all concentric circles 
delete(obj1.scaleBar); % remove scale bar 

%%
set(gca, 'fontname', 'Te X Gyre Heros');
print(img, '-dtiff');
close all;

end



