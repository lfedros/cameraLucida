function [xy, xbins, ybins] = plot_Density2D (x, y, spaceBin, sigma, mlims, NaNbkg, doPlot)
%PLOT_DENSITY2D computes the joint density of variables x and y, and plots
%it together with their 1D marginals
%   xy is the joint density 
%   xbins are the bins for the x marginal
%   ybins are the bins for the y marginal

%    x is variable you want on the x axis
%    y is variable you want on the x axis
%   spaceBin is the width of the bins for the 2D density
%   sigma is the std, in number of bins, of gaussian smoothing used for plotting
%   mlims is the interval you want to compute the density within. 
%       mlims = [] uses min([x, y]) and max([x, y]) as range
%       mlims = [xlim, ylim] uses [-xlim, xlim] and [-ylim, ylim] as ranges
%       mlims = [xmin, xmax, ymin, ymax] to specify every limit 
%   NaNbkg set to 1 to set empty bins to transparent NaNs in the colormap,
%   doPlot set to 1 to plot, 0 otherwise

if nargin <7
    doPlot = 0;
end
if nargin < 6
    NaNbkg = false;
end

%% pool data across experiments
if iscell(x)
    xpool = cell2vec(x);
    ypool = cell2vec(y);
else
    xpool = x(:);
    ypool = y(:);
end
% spaceBin = 25; %microns

%% calculate the size limits of the density maps
if isempty(mlims)
    xmax = ceil(max(abs(xpool))/spaceBin)*spaceBin;
    ymax = ceil(max(abs(ypool))/spaceBin)*spaceBin;
%     nbinx = round(2*xmax/spaceBin);
%     nbiny = round(2*xmax/spaceBin);
xbins = -xmax:spaceBin:xmax;
ybins = -ymax:spaceBin:ymax;
elseif numel(mlims) ==2    
    [xmax, ymax] = vecdeal(mlims);
%     nbinx = round(2*xmax/spaceBin);
%     nbiny = round(2*xmax/spaceBin);
xbins = -xmax:spaceBin:xmax;
ybins = -ymax:spaceBin:ymax;
else
    [xmin, xmax, ymin, ymax] = vecdeal(mlims);
xbins = xmin:spaceBin:xmax;
ybins = ymin:spaceBin:ymax;
end


% xbins = linspace(-xmax, xmax, nbinx);
% ybins = linspace(-ymax, ymax, nbiny);
%% Compute 2D projections and 1D marginals
[xy, ~] = hist3(double([ypool,xpool]), {ybins, xbins});

xyProf = imgaussfilt(xy, sigma);
xyProf = xyProf/ sum(xyProf(:));


ydist = sum(xyProf, 2);
xdist = sum(xyProf, 1);

%% do the plotting

cmap = BlueWhiteRed_burnLFR(1001,1); 
% cmapBu = flip(cmap(1:501,:),1);
cmapRed = cmap(502:1001,:);

if doPlot
% figure;

% subplot(4, 4, [5:7, 9:11, 13:15])
cmap = cmapRed;
if NaNbkg
    zax = imagesc(xbins, ybins, xyProf); axis image
    nanMask =  xyProf;
    nanMask(xyProf == 0) = NaN;
    set(zax, 'alphadata', ~isnan(nanMask))
else
    zax = imagesc(xbins, ybins, xyProf); axis image
end
colormap(cmap);
scale = caxis/2;
caxis(scale)
% daspect([1 1 1])
xlabel('Z-projection')
set(gca, 'YTick',[]);

formatAxes
% 
% subplot(4, 4, 1:3)
% histContour(xbins, xdist, [0 0 0])
% xlim([min(xbins), max(xbins)])
% formatAxes
% set(gca, 'XTick', [], 'YTick',[])
% formatAxes
% 
% subplot(4, 4, [8,12,16])
% histContour(ybins, ydist, [0 0 0])
% xlim([min(ybins), max(ybins)])
% set(gca,'XAxisLocation','top')
% formatAxes
% set(gca,  'YTick',[])
% view(-90,90) 
% set(gca,'ydir', 'reverse', 'xdir', 'reverse' )
end
end