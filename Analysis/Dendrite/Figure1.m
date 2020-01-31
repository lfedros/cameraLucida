%% Print Figure 1

img1 = imread('FR140_1_oriTune.tif');
a = subplot(1,4,1); imshow(img1,'InitialMagnification',100);

img2 = imread('FR140_1_V_soma_box_X_c.tif');
b = subplot(1,4,2); imshow(img2);

img3 = imread('FR140_1_V_soma_theta_box_polar.tif');
c = subplot(1,4,3); imshow(img3);

img4 = imread('FR140_1_VM.tif');
d = subplot(1,4,4); imshow(img4);

set(a, 'Position', [0 0.3 0.3 0.3]);
set(b, 'Position',[0.24 0.3 0.3 0.3]);
set(c, 'Position',[0.4 0.3 0.3 0.3]);
set(d, 'Position',[0.6 0.3 0.3 0.3]); 

set(gcf, 'Position', get(0, 'Screensize'));
print(gcf, 'FR140_1_Fig1.tiff', '-dtiff', '-r300');
