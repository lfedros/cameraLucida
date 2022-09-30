function plot_single_spine(img, norm_flag)

if nargin <2
    norm_flag = 0;
end

nS = size(img,3);

nCols = 10;
nRows = ceil(nS/nCols);

for iS = 1:nS

    subplot(nRows, nCols, iS)
    
    if norm_flag
    imgg = img(:,:,iS);        
    mini = prctile(imgg(:), 5);
    maxi = prctile(imgg(:), 95);
    imgg =  mat2gray(imgg, double([mini maxi]));      
    else
        imgg = img(:,:,iS);
    end

    imagesc(imgg); %title(fprintf('%d', iS));
    caxis([0 1]); axis image; colormap(1-gray); %colorbar;
    formatAxes
    set(gca, 'Box', 'off', 'XTick', [], 'Ytick', [])



end


end