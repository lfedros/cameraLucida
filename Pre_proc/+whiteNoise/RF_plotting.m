roiPlanes = readNPY('_ss_2pRois._ss_2pPlanes.npy');
ids = readNPY('_ss_2pRois.ids.npy');
rfs = readNPY('_ss_rf.maps.npy');
pos = readNPY('_ss_rfDescr.edges.npy');
pValues=readNPY('_ss_rf.pValues.npy');
lam=readNPY('_ss_rf.lambdasStim.npy');
ev=readNPY('_ss_rf.explVarsStim.npy');

titles = {'ON field','OFF field','Mean field'};
% colormaps
red = [1 0 .5];
blue = [0 .5 1];
black = [1 1 1].*0.5;
grad = linspace(0,1,100)';
reds = red.*flip(grad) + [1 1 1].*grad;
blacks = black.*flip(grad) + [1 1 1].*grad;
cm_ON = [blacks; flip(reds(1:end-1,:),1)];
blues = blue.*flip(grad) + [1 1 1].*grad;
cm_OFF = [blacks; flip(blues(1:end-1,:),1)];
cm_mean = [blues; flip(reds(1:end-1,:),1)];
colormaps = {cm_ON, cm_OFF, cm_mean};

roi = 475;
fprintf('expl. var.: %.4f (>0.01), p: %.4f (<0.05), lamda: %.4f (<1)\n', [ev(roi), pValues(roi), lam(roi)])


rf = squeeze(rfs(roi,:,:,:,:));
rf(:,:,:,2) = -rf(:,:,:,2); % positive values in OFF field now mean: unit is driven by black stimuli
squW = diff(pos(1:2)) / size(rf,2);
squH = diff(pos(3:4)) / size(rf,1);
rf_reshaped = reshape(permute(rf,[1 2 4 3]),[],size(rf,3));
[mx,mxTime] = max(max(abs(rf_reshaped),[],1));
[~,mxPix] = max(abs(rf_reshaped(:,mxTime)));
mx_signed = rf_reshaped(mxPix,mxTime);
mrf = mean(rf(:,:,mxTime,:),4);
rf_fit = mrf;
if mx_signed < 0
    rf_fit = -mrf;
end
% fit Gaussian
fitPars = whiteNoise.fit2dGaussRF(rf_fit, false);
[x0, y0] = meshgrid(linspace(0.5, size(rf,2)+0.5, 100), ...
    linspace(0.5, size(rf,1)+0.5, 100));
fitRF = whiteNoise.D2GaussFunctionRot(fitPars, cat(3, x0, y0));
[x1,y1] = meshgrid(linspace(pos(1), pos(2), 100), ...
    linspace(pos(3), pos(4), 100));
figure('Position', [680 60 560 920])
for f = 1:2
    subplot(3,1,f)
    imagesc([pos(1)+squW/2 pos(2)-squW/2], [pos(3)+squH/2 pos(4)-squH/2], ...
        rf(:,:,mxTime,f),[-mx mx])
    hold on
    contour(x1, y1, fitRF, [1 1].*fitPars(1)/2, 'k', 'LineWidth', 1)
    axis image
    set(gca, 'box', 'off', 'XTick', pos(1:2), 'YTick', [pos(3) 0 pos(4)], ...
        'YTickLabel', [-pos(3) 0 -pos(4)])
    colormap(gca, colormaps{f})
    ylabel(titles{f})
    colorbar
    if f == 1
        title(sprintf('Unit %d', roi))
    end
end
f = 3;
subplot(3,1,f)
imagesc([pos(1)+squW/2 pos(2)-squW/2], [pos(3)+squH/2 pos(4)-squH/2], ...
    mrf,[-1 1] .* max(abs(mrf(:))))
hold on
contour(x1, y1, fitRF, [1 1].*fitPars(1)/2, 'k', 'LineWidth', 1)
axis image
set(gca, 'box', 'off', 'XTick', pos(1:2), 'YTick', [pos(3) 0 pos(4)], ...
    'YTickLabel', [-pos(3) 0 -pos(4)])
colormap(gca, colormaps{f})
ylabel(titles{f})
colorbar