function plot_single_spine(img)

nS = size(img,3);

nCols = 10;
nRows = ceil(nS/nCols);

for iS = 1:nS

    subplot(nRows, nCols, iS)
    imagesc(img(:,:,iS)); %title(fprintf('%d', iS));
    caxis([0 1]); axis image; colormap(1-gray); %colorbar;
    formatAxes
    set(gca, 'Box', 'off', 'XTick', [], 'Ytick', [])



end


end