function plot_px_map(map, map_type, sigma, lims, invert)

if nargin <3
    sigma = 1; % sigma of gaussian filter
end

if nargin <4
    lims = [1 3]; % lims of color S for plot
end
if nargin <5
    invert = true;

end

switch map_type
    case 'gratings'
        f = fspecial('gaussian', 5, sigma);
        pxTun_dir = imfilter(map.dir, f);
        pxTun_ori = imfilter(map.ori, f);
        mimg = map.mimg;
        
        pxAmp_dir = abs(pxTun_dir);
        pxAng_dir = angle(pxTun_dir);

        pxAmp_ori = abs(pxTun_ori);
        pxAng_ori = angle(pxTun_ori)/2;

        Hue = mat2gray(pxAng_dir);
        Sat = mat2gray(pxAmp_dir, lims);
        Val = ones(size(pxAng_dir));
        pixelMap_dir = hsv2rgb(cat(3, Hue, Sat, Val));

        Hue = mat2gray(pxAng_ori);
        Sat = mat2gray(pxAmp_ori, lims);
        Val = ones(size(pxAng_ori));
        pixelMap_ori = hsv2rgb(cat(3, Hue, Sat, Val));

        %%
        if invert
            mimg = 1-mimg;
        end
        figure ('Color', 'w', 'Position', [283 224 1370 605]);
%         d = subplot(2,3,1);
%         imagesc(mimg); axis image; caxis([0.5, 0.9])
%         colormap(d, gray);
%         colorbar('Location', 'southoutside', 'Ticks', []);
%         formatAxes
%         title('Avg img')
% 
%          d = subplot(2,3,4);
%         imshow(mimg); axis image; caxis([0.5, 0.9])
%         formatAxes


        d = subplot(1,4,1);
        image(pixelMap_dir); axis image;
        formatAxes
        colormap(d, 'hsv');  colorbar('Location', 'southoutside', 'Ticks', [0 0.5 1], 'TickLabels', [-180 0 180]);
%         caxis([0 1]);
        title('Direction tuning')

       
        d = subplot(1,4,2);
        imshow(mimg); axis image; caxis([0.5, 0.9]); hold on
%         colormap(d, gray);
        h = imshow(pixelMap_dir); axis image; hold off
        set(h, 'AlphaData', mat2gray(pxAmp_dir, lims).^0.5)
        formatAxes
% 
        o = subplot(1,4,3);
        image(pixelMap_ori); axis image;
        formatAxes
        colormap(o, 'hsv'); colorbar('Location', 'southoutside', 'Ticks', [0 0.5 1], 'TickLabels', [-90 0 90]);
%         caxis([0 1]); 
        title('Orientation tuning')

           o = subplot(1,4,4);
        imshow(mimg); axis image; caxis([0.5, 0.9]); hold on
        h = imshow(pixelMap_ori); axis image; hold off
        set(h, 'AlphaData', mat2gray(pxAmp_ori, lims).^0.5)
        formatAxes

end
end