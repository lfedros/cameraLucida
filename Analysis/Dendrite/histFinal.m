%% histogram for figure:

function [] = histFinal( mouse_name, colorID, tunePars )
%% For color-coding
addpath(genpath('/home/naureeng/cameraLucida'));
load('retino_tree','retino_tree');
%% (1) plot von Mises fit

%% box analysis in V [axial theta]
path_name = fullfile(strcat('/home/naureeng/cameraLucida/', mouse_name));
load(fullfile(strcat(path_name, '/thetaBox.mat')));
%%
alpha = (thetaBox.theta_axial).*2; % [deg]
alpha_rad = deg2rad(alpha); % [rad]
[thetahat, kappa] = circ_vmpar( alpha_rad ); % [von Mises parameters]
[p, ~] = circ_vmpdf( alpha_rad, thetahat, kappa ); % [von Mises pdf]
figure;
f = fit(alpha , p, 'smoothingspline'); % [spline fit]
plot(f);
fig = gcf;

% extract y-data of fit "f"
dataObjsY = findobj(fig,'-property','YData');
y1 = dataObjsY(1).YData;
% extract x-data of fit "f"
dataObjsX = findobj(fig,'-property','XData');
x1 = dataObjsX(1).XData;

close all;

figure;
y1_norm = y1/max(y1);
h = plot(x1/2, y1_norm);

%% find min and max
xval = x1/2;
[~,a] = min(y1_norm);
min_V = xval(a);
[~,b] = max(y1_norm);
max_V = xval(b);
peaks = [min_V, max_V];
save('peaks','peaks');

%%
set(h,'LineWidth',2)
set(h,'Color', cell2mat(retino_tree.color(colorID)) );
xticks(-180:90:180);
xlim([-190 190]);
ylim([0 1.05]);
yticks(0:1);
hold on;

%% (2) plot normalised hist counts of axial theta values [-90 90]

theta_axial = thetaBox.theta_axial;
[n,x] = hist( theta_axial, 20);
n_norm = n/max(n); % max normalisation of histogram bin counts "n"

% plot bin counts with "bar" rather than "hist"
h = bar(x, n_norm, 1);

set(h,'facealpha',0.25);
set(h,'facecolor', 'black');
set(h,'edgecolor', 'none');

% outline the histogram bins
stairs([x(1)-(x(2)-x(1))/2 x-(x(2)-x(1))/2 x(length(x))+(x(2)-x(1))/2],[0 n_norm 0], 'linewidth', 2, 'color','k');

%% (3) plot orientation tuning curve
% oriVal = oriFit/max(oriFit);
% h = plot( xval -90 ,oriVal);
% set(h,'LineWidth',1)
% set(h,'Color', cell2mat(retino_tree.color(colorID)) );
% set(h,'LineStyle',':');
% Dp = load('Dp.mat');
% Dp = 360- Dp.Dp;
% if Dp<0
%     Dp = Dp+360; % [0 360]
% else
%     disp('Dp OK');
% end
% 
% % Dp = [-180 180] (0-180, 360-180)
% Dp(Dp>180) = Dp-180;
% 
% % Op = [-90 90]
% Op = Dp - 90;
% y1 = gaussmf( -90:2.7:90 , [sigma Op]);
% hold on;
% 

% correct for Dp to be within [0 360]
load('/home/naureeng/cameraLucida/retino_tree.mat');
% Dp = retino_tree.Dp(colorID,1);
% Dp(Dp<0) = Dp + 360;
% Dp(Dp>360) = Dp-360;
% 
% pars = Dp + 90;
% pars(pars<0) = pars + 360;
% pars(pars>360) = pars-360;

pars = retino_tree.Op{colorID, 1};
pars(2:5) = tunePars(2:5);
pars(3) = pars(2);
oriFit = oritune(pars, -90:90);
y1 = oriFit/max(oriFit);
hold on;
h = plot( -90:90 , y1);
set(h,'LineWidth',2)
set(h,'Color', cell2mat(retino_tree.color(colorID)) );
set(h,'LineStyle','--');

%%
box off
xlim([-125 125]);
h = gca; h.YAxis.Visible = 'off';
set(gca, 'fontname', 'Te X Gyre Heros');
print( strcat(mouse_name, '_1_VM'), '-dtiff')


