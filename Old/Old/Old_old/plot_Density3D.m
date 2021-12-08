function [xy, xz, yz, xbins, ybins, zbins] = plot_Density3D (x, y, z, spaceBin, sigma, mlims, NaNbkg, cmap)

if nargin < 7
    NaNbkg = false;
end

if nargin < 8
    cmap = 'hot';
end

%% pool data across experiments
if iscell(x)
    xpool = cell2vec(x);
    ypool = cell2vec(y);
    zpool = cell2vec(z);
else
    xpool = x;
    ypool = y;
    zpool = z;
end
% spaceBin = 25; %microns

%% calculate the size limits of the density maps
if isempty(mlims)
    xmax = ceil(max(abs([xpool; ypool]))/spaceBin)*spaceBin;
    ymax = xmax;
%     ymax = ceil(max(abs(ypool))/spaceBin)*spaceBin;
    zmax = ceil(max(abs(zpool))/spaceBin)*spaceBin;
    zmin = ceil(min(zpool)/spaceBin)*spaceBin;
else    
    [xmax, ymax, zmax, zmin] = vecdeal(mlims);
end

xbins = -xmax:spaceBin:xmax;
ybins = -ymax:spaceBin:ymax;
zbins = zmin:spaceBin:zmax;

%% Compute 2D projections and 1D marginals
[xy, ~] = hist3(double([ypool,xpool]), {ybins, xbins});

xyProf = imgaussfilt(xy, sigma);
xyProf = xyProf/ sum(xyProf(:));

% [yxProf, Cyx] = hist3(double([xpool,ypool]), {xbins, ybins});
% 
% yxProf = imgaussfilt(yxProf, 1.5);
% yxProf = yxProf/ sum(yxProf(:));

[xz, ~] = hist3(double([zpool,xpool]), {zbins, xbins});

xzProf = imgaussfilt(xz, sigma);
xzProf = xzProf/ sum(xzProf(:));

[yz, ~] = hist3(double([zpool, ypool]), {zbins,ybins});

yzProf = imgaussfilt(yz, sigma);
yzProf = yzProf/ sum(yzProf(:));

ydist = sum(xyProf, 2);
xdist = sum(xyProf, 1);
zdist = sum(xzProf, 2);

%% do the plotting
figure;

subplot(4, 11, [19:21, 30:32, 41:43])
if NaNbkg
    zax = imagesc(xbins, ybins, xyProf);
    nanMask =  xyProf;
    nanMask(xyProf == 0) = NaN;
    set(zax, 'alphadata', ~isnan(nanMask))
else
%     contourf(xbins, ybins, xyProf,20, 'LineColor', 'none');
    zax = imagesc(xbins, ybins, xyProf);
end
colormap(cmap);
scale = caxis/3;
caxis(scale)
% daspect([1 1 1])
xlabel('X relative to starter')
set(gca, 'YTick',[])
formatAxes
axis image

subplot(4, 11, 2:4)
histContour(ybins, ydist, [0 0 0])
xlim([min(ybins), max(ybins)])
ylim([0 max([ydist; xdist'])])
formatAxes
set(gca, 'YTick',[], 'XTick',[])
formatAxes

subplot(4, 11, [12,23,34])
histContour(zbins, zdist, [0 0 0])
xlim([min(zbins), max(max(zbins), range(xbins))])
formatAxes
set(gca, 'YTickLabel', [], 'YTick',[])
view(-90,90) 
set(gca,'xdir','reverse')
formatAxes
xlabel('Z relative to soma (um)')

subplot(4, 11, [13:15, 24:26, 35:37])
if NaNbkg
    xax = imagesc(ybins, zbins,  yzProf);
    nanMask =  yzProf;
    nanMask(yzProf == 0) = NaN;
    set(xax, 'alphadata', ~isnan(nanMask))
else
% contourf(ybins, zbins,  yzProf,20, 'LineColor', 'none'); axis ij;
xax = imagesc(ybins, zbins,  yzProf);
end
% colormap(hot);
colormap(cmap);
caxis(scale);
% daspect([1 1 1])
set(gca, 'YTickLabel', [], 'YTick',[])
xlabel('Y relative to soma (um)')
% axis image
formatAxes
ylim([min(zbins), max(max(zbins), range(xbins))])
axis image

subplot(4, 11, 5:7)
histContour(xbins, xdist, [0 0 0])
xlim([min(xbins), max(xbins)])
ylim([0 max([ydist; xdist'])])
formatAxes
set(gca, 'XTick', [], 'YTick',[])
formatAxes


subplot(4, 11, [16:18, 27:29, 38:40])
if NaNbkg
    yax = imagesc(xbins, zbins, xzProf);
    nanMask =  xzProf;
    nanMask(xzProf == 0) = NaN;
    set(yax, 'alphadata', ~isnan(nanMask))
else
%  contourf(xbins, zbins, xzProf,20, 'LineColor', 'none'); axis ij; 
     yax = imagesc(xbins, zbins, xzProf);

end
% colormap(hot);
colormap(cmap);

caxis(scale);
% daspect([1 1 1])
set(gca, 'YTickLabel', [], 'YTick',[])
xlabel('X relative to soma (um)')
% axis image
formatAxes
ylim([min(zbins), max(max(zbins), range(xbins))])
axis image


subplot(4, 11, 8:10)
histContour(xbins, xdist, [0 0 0])
xlim([min(xbins), max(xbins)])
ylim([0 max([ydist; xdist'])])

set(gca,  'YTick',[], 'XTick', [])
formatAxes

subplot(4, 11, [22,33,44])
histContour(ybins, ydist, [0 0 0])
xlim([min(ybins), max(ybins)])
set(gca,'XAxisLocation','top')
formatAxes
set(gca,  'YTick',[])
view(-90,90) 
set(gca,'ydir','reverse','xdir','reverse' )
xlabel('Y relative to starter (um)')
end