%% Circular Statistics Demo
% CircHist and CircStat by Behrens Lab [2009-2019]
% NOTES
% (1) Do NOT put Trees Toolbox by Cuntz Lab on same path, overlap in function names
% (2) Keep track of units [deg v rad]

addpath(genpath('C:\Users\Experiment\CircHist'));
addpath(genpath('C:\Users\Experiment\circstat-matlab'));

%% 
% make distribution data
% von Mises with theta == 90 deg

rng default
sDist = mod(rad2deg(circ_vmrnd(pi/2, 2, 100)), 360); % [deg]
nBins = 36; % 360/36 = 10 deg bins

% plot distribution data
obj1 = CircHist(sDist, nBins);

% adjust appearance
obj1.colorBar = 'k'; % change color of bars
obj1.avgAngH.LineStyle = '--'; % make average-angle line dashed
obj1.avgAngH.LineWidth = 1; % make average-angle line thinner
obj1.colorAvgAng = [.5 .5 .5]; % change average-angle line color

% remove offset bw bars and plot-center
rl = rlim;
obj1.setRlim([0, r1(2)]); % set lower limit to 0
% draw circle at r == 0.5 (where r = 1 is outer plot edge)
rl = rlim;
obj1.drawCircc((rl(2) -rl(1)) /2, '--b', 'LineWidth', 2);




