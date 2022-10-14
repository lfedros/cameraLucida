
%% find 50% most responsive pixels (assumes V1 is around 50% of the FOV)

combo = maps.maps.xpos.amplitude.*maps.maps.ypos.amplitude;
combo(combo == inf) = 0;
combo(isnan(combo)) = 0;
 
combo = imgaussfilt(combo,10);
combo_bw = zeros(size(combo));
combo_bw(combo > prctile(combo(:),50)) = 1;
 
combo_bw = fliplr(combo_bw);
 
figure; imagesc(combo_bw);
%%
 
ret.vessels = fliplr(maps.meanFrame);

ret.vessel_mask = ret.vessels;
ret.vessel_mask(~combo_bw) = NaN;
 
figure; imagesc(ret.vessel_mask)

%%

se= strel('disk', 3);

img = 1-mat2gray(ret.vessels);

img(img ==inf) = 0;
img(isnan(img)) = 0;

img = imgaussfilt(imtophat(img, se),1);

figure; imagesc(img);