function plot_dendrite_rois_old(dendrite, sig_flag)

if nargin <2 || sig_flag ==0
dendrite.SigInd = 1:numel(dendrite.xpixs);
end

xpx = dendrite.xpixs(dendrite.SigInd);
ypx = dendrite.ypixs(dendrite.SigInd);

meanImg = dendrite.meanImg;
se = strel('disk', 20);
meanImg  =  imtophat(meanImg , se);
meanImg =  mat2gray(meanImg ./max(meanImg (:)));
meanImg =  mat2gray(meanImg ./max(meanImg (:)), [0.02 0.2]);



[Ly, Lx] = size(meanImg);


pref_dir = dendrite.Fitpars(dendrite.SigInd,1); %[0 360]
pref_ori = pref_dir-90; %[-90, 270]
pref_ori(pref_ori>180) = pref_ori(pref_ori>180)-180; %[-90 90]
pref_ori(pref_ori<=0) = pref_ori(pref_ori<=0)+180; %[1 181]

color = hsv(181);

% resps = dendrite.responses(dendrite.SigInd,:,:,:);
% resps = dendrite.response(dendrite.SigInd,:,:,:);

nROI = numel(dendrite.SigInd);

map = zeros(numel(meanImg), 3);

h = randperm(nROI);

figure; imagesc(meanImg); axis image; colormap(1-gray); hold on; caxis([0 0.5]);

for iR = 1:nROI
    
    idx = sub2ind(size(meanImg), ypx{iR}, xpx{iR});
    
    this_roi = zeros(size(meanImg));

    this_roi(idx) = 1;

    this_roi = imerode(imdilate(this_roi,strel('disk',2)), strel('disk',2));

    CC = bwconncomp(this_roi);

    idx = CC.PixelIdxList{1};

%     idx = find(this_roi);

    this_roi = zeros(size(meanImg));
        this_roi(idx) = 1;

    M = contourc(this_roi,[0 0]);
%     M = contourf(this_roi,[1 1]);

    map(idx, :) = repmat(color(ceil(pref_ori(iR)), :), numel(idx), 1);

    patch(M(1, :), M(2, :), color(ceil(pref_ori(iR)),:), 'Edgecolor', 'none', 'FaceAlpha', 0.5);
       
end
formatAxes;

map_rgb = reshape(map, Ly, Lx, 3);

% figure; image(map_rgb)
end