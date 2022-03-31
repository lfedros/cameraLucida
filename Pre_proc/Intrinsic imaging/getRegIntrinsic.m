function reg_mov = getRegIntrinsic(ExpRef)


video_file = dat.expFilePath(ExpRef, 'intrinsic', 'master');

% create videoreader object
vr = VideoReader(video_file);

numberOfFrames = vr.NumberOfFrames;

%% compute target frame

% rndFrames = randi(numberOfFrames, 1000,1);
rndFrames = 2000;
fprintf('Computing target frame....') 
tic
% for iF = 1: numel(rndFrames)
%     target(:,:,iF)= squeeze(read(vr, rndFrames(iF))); % load it
% end
target = squeeze(read(vr, [1 rndFrames])); % load it
t = toc;
fprintf('done in %02f s \n', t);

target = mean(target,3);

[roi] = draw.freeRectROI(target);

[i, j] = ind2sub( size(target), roi{1});
crop = [min(i), max(i), min(j), max(j)];
 
target_crop = target(crop(1): crop(2), crop(3): crop(4));
%% batch load and register

nFramesPerBatch = 2000;
nBatches = ceil(numberOfFrames/nFramesPerBatch);

regOps = build_rigidops(target_crop);
regOps.subPixel = 0;
regOps.phaseCorrelation = false;

reg_mov = [];
dv = [];
tic
for iB = 1:nBatches
    fprintf('Registering batch %d of %d \n', iB, nBatches);

    frameStart = nFramesPerBatch*(iB-1)+1;
    frameEnd = min(numberOfFrames,nFramesPerBatch*iB);
    
    mov = squeeze(read(vr, [frameStart frameEnd ])); % load it
    
    [dv_batch, corr] = phaseCorrKriging(mov(crop(1): crop(2), crop(3): crop(4), :), regOps);
    
    reg_batch = rigidRegFrames(mov ,regOps, dv_batch);
    
    reg_mov = cat(3, reg_mov, reg_batch);
    
    dv = cat(1, dv, dv_batch); 
end
t = toc;
fprintf('Done in %02f s \n', t);






end