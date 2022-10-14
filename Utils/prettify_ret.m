function ret = prettify_ret(maps)

ret.vessels = fliplr(maps.meanFrame);
ret.azimuth = fliplr(maps.maps.xpos.prefPhase);
ret.azimuth = ret.azimuth*(-135)/(2*pi); % convert to degrees
ret.elevation = fliplr(maps.maps.ypos.prefPhase);
ret.elevation = 38 - ret.elevation*(76)/(2*pi); % convert to degrees

ret.signal = fliplr(maps.maps.xpos.amplitude.*maps.maps.ypos.amplitude);
ret.signal(ret.signal == inf) = 0;
ret.signal(isnan(ret.signal)) = 0;

ret.signal_bw = mat2gray(imgaussfilt(ret.signal.^0.05,10));
thres = graythresh(ret.signal_bw);
ret.signal_bw(ret.signal_bw >= thres) =1;
ret.signal_bw(ret.signal_bw < thres) =0;
se= strel('disk',20);
ret.signal_bw = imclose(ret.signal_bw, se);

% figure; imagesc(ret.signal_bw); axis image

se= strel('disk', 5);
img = 1-mat2gray(ret.vessels);
img(img ==inf) = 0;
img(isnan(img)) = 0;
img = mat2gray(imgaussfilt(imtophat(img, se),1));
% figure; imagesc(img);

thres = graythresh(img(ret.signal_bw==1));
ret.vessels_bw = zeros(size(ret.vessels));

ret.vessels_bw(img>= thres) =1;
ret.vessels_bw = imdilate(ret.vessels_bw, strel('disk', 2));
% figure; imagesc(ret.vessels_bw);axis image
% test = ret.azimuth;
% test(ret.vessels_bw==1) = nan;
% figure; imagesc(test);axis image

ret.goodpx = ret.signal_bw & ~ret.vessels_bw;
% figure; imagesc(ret.goodpx);axis image
CC = bwconncomp(ret.goodpx);
S = regionprops(CC, 'Area');
[~, ccid] = max([S.Area]);
ret.signal_bw = zeros(size(ret.goodpx));

ret.signal_bw(CC.PixelIdxList{ccid}) = 1;
% ret.signal_bw = imdilate(ret.signal_bw, strel('disk', 40));
% ret.signal_bw = imerode(ret.signal_bw, strel('disk', 40));
ret.signal_bw = imclose(ret.signal_bw, strel('disk', 40));
ret.signal_bw = imdilate(ret.signal_bw, strel('disk', 10));

% figure; imagesc(ret.signal_bw);axis image

ret.goodpx = ret.signal_bw & ~ret.vessels_bw;
% figure; imagesc(ret.goodpx);axis image


%%

[isig, jsig] = find(ret.signal_bw);
[ipx, jpx] = find(ret.goodpx);

Fa = scatteredInterpolant(ipx, jpx, ret.azimuth(ret.goodpx));
Fe = scatteredInterpolant(ipx, jpx, ret.elevation(ret.goodpx));

a = Fa(isig, jsig);
ret.azimuth(logical(ret.signal_bw)) = a;
ret.azimuth(~logical(ret.signal_bw)) =NaN;
% figure; imagesc(ret.azimuth); axis image

e = Fe(isig, jsig);
ret.elevation(logical(ret.signal_bw)) = e;
ret.elevation(~logical(ret.signal_bw)) =NaN;
% figure; imagesc(ret.elevation); axis image

filtWidth = 25;
filtSigma = 10;
kernel =fspecial('gaussian',filtWidth,filtSigma);
ret.elevation = nanconv(ret.elevation,kernel, 'nanout');
ret.azimuth = nanconv(ret.azimuth,kernel, 'nanout');

end

