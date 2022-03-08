function mov = getIntrinsic(ExpRef)


video_file = dat.expFilePath(ExpRef, 'intrinsic', 'master');

% create videoreader object
vr = VideoReader(video_file);

numberOfFrames = vr.NumberOfFrames;
    
mov= squeeze(read(vr, [1 numberOfFrames ])); % load it
    


end