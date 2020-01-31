%% Theta Polar Plot
% by Philip Berens Lab [2009-2019]

function [] = PolarPlot( thetaMap, fname, db , analysis_type, colorID)
% full-circle plot
% [0 360]

% thetaMap is coming in [-90 90]
% we must first properly rescale this for [0 360]

% 4th argument analysis_type is :
% 'seg'     segment-by-segment
% 'box'     box-by-box

switch analysis_type
    case 'seg'
        img = strcat(fname, '_theta_seg_polar');
    case 'box'
        img = strcat(fname, '_theta_box_polar');
end

%%
% add paths
addpath(genpath('/home/naureeng/cameraLucida/Dependencies/CircHist'));
addpath(genpath('/home/naureeng/cameraLucida/Dependencies/circstat-matlab'));
addpath(genpath('/home/naureeng/cameraLucida'));
load('retino_tree','retino_tree');
val = 0;
% thetaMap(thetaMap<0) = thetaMap(thetaMap<0) + 180; % [deg] % [0 180]
% thetaMap = rescale(thetaMap, 0, 360); % [deg] [0 360]

% axial range = [-90 90]
% circular range = [-180 180]

% degree range = [-5:10:360-5] NOT [0:10:360] so that bins are centered
% at -5:10:85 deg in final plot rather than 0:10:90

% true/false value differs in angle analysis
%val = -80;
obj1 = CircHist(thetaMap, (-5:10:360-5),  'areAxialData', true );

%% for scaling
data = obj1.histData(:,1);
data2 = data./max(data);
close all;

obj1 = CircHist( data2 , 'dataType', 'histogram' ,  'areAxialData', true );

obj1.colorBar = 'k'; % change color of bars
% obj1.avgAngH.LineStyle = '--'; % make average-angle line dashed
% obj1.avgAngH.LineWidth = 4; % make average-angle line thinner
obj1.polarAxs.ThetaZeroLocation = 'right'; % rotate the plot to have 0� on the right side
obj1.colorAvgAng = [.5 .5 .5]; % change average-angle line color
title('');

%%
db.prefDir( db.prefDir > 180 ) = db.prefDir ( db.prefDir  > 180 ) - 360;
db.prefDir ( db.prefDir  < -180) = db.prefDir (db.prefDir  < -180) + 360;

% % draw circle at r == 0.5 (where r == 1 would be outer plot edge)
% rl = rlim;
% obj1.drawCirc( (rl(2) - rl(1)) /2, '--b', 'LineWidth', 2);

obj1.scaleBarSide = 'left'; % draw rho-axis on the left side of the plot
% draw resultant vector r as arrow
delete(obj1.rH)
%obj1.drawArrow( - (180 - obj1.avgAng) , [], 'HeadWidth', 10, 'LineWidth', 2, 'Color', 'r');
%obj1.drawArrow( obj1.avgAng , [], 'HeadWidth', 10, 'LineWidth', 2, 'Color', 'r');



db.prefOri = - (db.prefDir - 90) - val ; % range = [-270 90]
%db.prefOri = - (db.prefDir - 90 ) + db.prefDir;

% db.prefOri(db.prefOri >360) = db.prefOri(db.prefOri >360)-360;
% db.prefOri(db.prefOri < -90) = db.prefOri(db.prefOri < -90)+360;
% db.prefOri(db.prefOri > 90) = db.prefOri(db.prefOri > 90)-360;

%%
% plot prefOri arrow
obj1.drawArrow( - (180 - db.prefOri) , [], 'HeadWidth', 10, 'LineWidth', 2, 'Color', cell2mat(retino_tree.color(colorID))  );
obj1.drawArrow( (db.prefOri) , [], 'HeadWidth', 10, 'LineWidth', 2, 'Color', cell2mat(retino_tree.color(colorID)) );

%%
% plot prefDir arrow
% obj1.drawArrow( - (180 - (360 - db.prefDir) ) , [], 'HeadWidth', 10, 'LineWidth', 2, 'Color', [0.098, 0.643, 0.682] );

% obj1.drawArrow( (360 - db.prefDir - val ) , [], 'HeadWidth', 10, 'LineWidth', 2, 'Color', [0.752 0.525 0.047] );
% %obj1.drawArrow ( (360 - db.prefDir) + db.prefDir , [], 'HeadWidth', 10, 'LineWidth', 2, 'Color', [0.752 0.525 0.047] );

% plot avgArrow
delete(obj1.rH)
obj1.drawArrow(obj1.avgAng, [] , 'HeadWidth', 10, 'LineWidth', 2, 'Color', 'k')
obj1.drawArrow(- (180 - obj1.avgAng) , [] , 'HeadWidth', 10, 'LineWidth', 2, 'Color', 'k')

obj1.polarAxs.ThetaAxis.MinorTickValues = []; % remove dotted tick-lines
thetaticks(0:90:360); % change major ticks

%% change r-ticks
rticks(0:1); % change rho-axis tick-steps to remove all concentric circles 
 % update scale bar
delete(obj1.scaleBar); % remove scale bar 

%%

set(gca, 'fontname', 'Te X Gyre Heros');
print(img, '-dtiff');
close all;

end

