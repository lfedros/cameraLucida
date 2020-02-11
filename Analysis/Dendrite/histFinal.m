function [VM_std, OT_std] = histFinal( thetaMap_V, db, colorID, tunePars, folder_name )

% HISTFINAL 	plots visual space data in cortical space view
%  
%		INPUTS:
%       [1] thetaMap_V      = theta distribution                [string]
%       [2] db              = preferred orientation             [degrees]
%       [2] colorID         = preferred orientation color       [HEX code]
%       [3] tunePars        = tuning parameters                 [double]
%       [4] folder_name     = neuron reconstruction             [string]
%
%       OUTPUTS:
%       [1]  plot dendritic histogram with von Mises fit        [.tif]
%       
%       DEPENDENCIES:
%       [1] treestoolbox    = Hermann Cuntz [2011]
%
%       REFERENCES:
%       [1] Cuntz H, Forstner F, Borst A, Häusser M (2010). One rule to grow them all: A general theory of neuronal branching and its practical application. PLoS Comput Biol 6(8): e1000877.
%
% 2020 N Ghani 

%% Step 1: add paths
addpath(genpath('/home/naureeng/cameraLucida'));

%% Step 2: plot von Mises fit
alpha = (thetaMap_V).*2; % [deg]
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
VM_std = std(y1_norm);
save( strcat(folder_name,'_VM_std'), 'VM_std');

%% Step 3: find min and max of von Mises fits
xval = x1/2;
[~,a] = min(y1_norm);
min_V = xval(a);
[~,b] = max(y1_norm);
max_V = xval(b);
peaks = [min_V, max_V];
save('peaks_VM','peaks');

%% Step 4: label plot 
set(h,'LineWidth',2)
set(h,'Color', colorID.colorID );
xticks(-180:90:180);
xlim([-190 190]);
ylim([0 1.05]);
yticks(0:1);
hold on;

%% Step 5: plot normalised hist counts of axial theta values [-90 90]
theta_axial = thetaMap_V;
[n,x] = hist( theta_axial, 20);
n_norm = n/max(n); % max normalisation of histogram bin counts "n"

% plot bin counts with "bar" rather than "hist"
h = bar(x, n_norm, 1);

set(h,'facealpha',0.25);
set(h,'facecolor', 'black');
set(h,'edgecolor', 'none');

% outline the histogram bins
stairs([x(1)-(x(2)-x(1))/2 x-(x(2)-x(1))/2 x(length(x))+(x(2)-x(1))/2],[0 n_norm 0], 'linewidth', 2, 'color','k');

%% Step 6: plot orientation tuning curve
% compute pars (prefOri) from db.prefDir
pars = db.prefOri;
pars(2:5) = tunePars(2:5);
pars(3) = pars(2);
oriFit = oritune(pars, -90:90);
y1 = oriFit/max(oriFit);
hold on;
h = plot( -90:90 , y1);
OT_std = std(y1);
save( strcat(folder_name,'_OT_std'), 'OT_std');
set(h,'LineWidth',2)
set(h,'Color', colorID.colorID );
set(h,'LineStyle','--');

%% Step 7: save plot
box off
xlim([-125 125]);
h = gca; h.YAxis.Visible = 'off';
set(gca, 'fontname', 'Te X Gyre Heros'); % due to Linux compatability issue with Helvetica font
print( strcat(folder_name, '_VM'), '-dtiff')
end


