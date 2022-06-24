function plot_px_map(map, map_type, sigma)

if nargin <3
    sigma = 1; % sigma of gaussian filter
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
        pxAng_ori = angle(pxTun_ori);

        Hue = mat2gray(pxAng_dir);
        Sat = mat2gray(pxAmp_dir, [1 3]);
        Val = ones(size(pxAng_dir));
        pixelMap_dir = hsv2rgb(cat(3, Hue, Sat, Val));

        Hue = mat2gray(pxAng_ori);
        Sat = mat2gray(pxAmp_ori, [1 3]);
        Val = ones(size(pxAng_ori));
        pixelMap_ori = hsv2rgb(cat(3, Hue, Sat, Val));

        %%
        figure ('Color', 'w', 'Position', [283 224 1370 605]);
        d = subplot(1,3,1);
        imagesc(mimg); axis image; caxis([0.5, 0.9])
        colormap(d, gray);
        colorbar('Location', 'southoutside', 'Ticks', []);
        formatAxes

        d = subplot(1,3,2);
        image(pixelMap_dir); axis image;
        formatAxes
        colormap(d, 'hsv'); caxis([0 1]); colorbar('Location', 'southoutside', 'Ticks', [0 0.5 1], 'TickLabels', [-180 0 180]);
        title('Direction tuning')

        o = subplot(1,3,3);
        image(pixelMap_ori); axis image;
        formatAxes
        colormap(o, 'hsv'); caxis([0 1]); colorbar('Location', 'southoutside', 'Ticks', [0 0.5 1], 'TickLabels', [-90 0 90]);
        title('Orientation tuning')

end
end