function [] = ThetaPlot( thetaMap, fname, db, analysis_type, colorID )

% THETAPLOT 	plots dendritic histogram [-90 90]
%  
%		INPUTS:
%       [1] thetaMap        = dendritic histogram counts        [double]
%       [2] fname           = folder name                       [string]
%       [3] analysis_type   = 'seg' OR 'box'                    [string]
%               'seg' = segment-by-segment (dendrite branches)
%               'box' = box-by-box (resampling in microns) 
%       [4] colorID         = preferred orientation color       [HEX code]
%
%       OUTPUTS:
%       [1] image of polar plot                                 [.tif]
%       
%       DEPENDENCIES:
%       [1] CircHist        = Philip Berens [2009]
%       [2] circstat-matlab = Philip Berens [2009]
%       [3] treestoolbox    = Hermann Cuntz [2011]
%
%       REFERENCES:
%       [1] P. Berens, CircStat: A Matlab Toolbox for Circular Statistics, Journal of Statistical Software, Volume 31, Issue 10, 2009 
%       [2] Cuntz H, Forstner F, Borst A, Häusser M (2010). One rule to grow them all: A general theory of neuronal branching and its practical application. PLoS Comput Biol 6(8): e1000877.
%
% 2020 N Ghani 

switch analysis_type
    case 'seg'
        img = strcat(fname, '_theta_seg_polar_circular');
    case 'box'
        img = strcat(fname, '_theta_box_polar_circular');
end

%% Step 1: add paths 
addpath(genpath('/home/naureeng/cameraLucida/Dependencies/CircHist'));
addpath(genpath('/home/naureeng/cameraLucida/Dependencies/circstat-matlab'));
addpath(genpath('/home/naureeng/cameraLucida'));

%% Step 2: plot histogram 
obj1 = CircHist(thetaMap, (-5:10:360-5) , 'areAxialData', true);

%% Step 3: normalize histogram 
data = obj1.histData(:,1);
data2 = data./max(data);
close all;

%% Step 4: plot normalized histogram
obj1 = CircHist( data2 , 'dataType', 'histogram' ,  'areAxialData', true );

%% Step 5: clean up plot 
obj1.colorBar = 'k'; % change color of bars
obj1.avgAngH.LineStyle = '--'; % make average-angle line dashed
obj1.avgAngH.LineWidth = 1; % make average-angle line thinner
obj1.colorAvgAng = [.5 .5 .5]; % change average-angle line color
obj1.polarAxs.ThetaZeroLocation = 'right'; % rotate the plot to have 0 on the right side
thetalim([-180 180]); % change major ticks
obj1.scaleBarSide = 'left'; % draw rho-axis on the left side of the plot
delete(obj1.rH)
title(''); % remove title
obj1.polarAxs.ThetaAxis.MinorTickValues = []; % remove dotted tick-lines
% change theta- and rho-axis ticks
thetaticks(-180:90:180); % change major ticks
rticks(0:1); % change rho-axis tick-steps to remove all concentric circles 
delete(obj1.scaleBar); % remove scale bar 

%% Step 6: compute prefOri [-90 90]
db.prefDir( db.prefDir > 180 ) = db.prefDir ( db.prefDir  > 180 ) - 360;
db.prefDir ( db.prefDir  < -180) = db.prefDir (db.prefDir  < -180) + 360;
db.prefOri = - (db.prefDir - 90); % range = [-270 90]

%% Step 7: plot prefOri arrow
obj1.drawArrow( - (180 - db.prefOri) , [], 'HeadWidth', 10, 'LineWidth', 2, 'Color', colorID.colorID  );
obj1.drawArrow( (db.prefOri) , [], 'HeadWidth', 10, 'LineWidth', 2, 'Color', colorID.colorID );

%% Step 8: plot avgAng arrow
obj1.drawArrow(obj1.avgAng, [] , 'HeadWidth', 10, 'LineWidth', 2, 'Color', 'k')
obj1.drawArrow(- (180 - obj1.avgAng) , [] , 'HeadWidth', 10, 'LineWidth', 2, 'Color', 'k')
avgAng = [obj1.avgAng -(180 - obj1.avgAng)];
save(strcat(fname, '_avgAng'),'avgAng');

%% Step 9: save polar plot
set(gca, 'fontname', 'Te X Gyre Heros'); % due to Linux compatability issue with Helvetica font
print(img, '-dtiff');
% close all;

end



