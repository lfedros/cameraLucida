function [sRF, tRF, rfTimes, stRF] =  sta_stRF(resp, stimFrames, stimFrameTimes, lagInFrames)

% computes STA receptive field using cross correlation. 
% INPUTS
% resp is nT long timecourse of fluorescece for one neuron (note common
% time stamps with stimulus frames)
% stimFrames is yPx*xPx*nT is the stimulus matrix of the Sparse Noise stimulus
% stimFrameTimes is nT array containing time stamps of stimulus and dF
% traces

%OUTPUTS
% spaceReceptiveField yPx*xPx STA RF map
% receptiveField yPx*xPx*rfT spatio temporal RF
% rfTimes rfT array containing timestamps of spatiotemporal RF
% itsKernel rfT array maximal response kernel


%%
stimTimeStep = median(diff(stimFrameTimes));
[yPx, xPx, nT] = size(stimFrames);
[nT, nN] = size(resp);

nPx = xPx*yPx;

RFtimesInFrames = lagInFrames+1;
corrTimesInFrames = -lagInFrames : lagInFrames;

[~, RFFrameInds] = intersect(corrTimesInFrames, 0:lagInFrames);

st = reshape(stimFrames, [], nT);

st = (st - mean(st(:))) ./ std(st(:));

RF = zeros(size(stimFrames, 1) * size(stimFrames, 2), ...
    nN, RFtimesInFrames);

for iN = 1: nN
    for pix = 1:size(st, 1)
        
        c = xcorr(resp(:, iN), st(pix,:), lagInFrames, 'unbiased');
        
        RF(pix, iN, :) = c(RFFrameInds);
    end
end

RF = reshape(RF, xPx*yPx*nN, []);

%% separate using SVD
% [U, S, V] = svd(RF, 'econ');
% 
% U = U(:,1);
% sV = S(1,1)*V(1,:);
% 
% sRF = reshape(U, xPx*yPx, nN);
% 
% tRF = reshape(sV, RFtimesInFrames, nN);
% 
% if corr(raw_tRF, tRF) <0
%     sRF = -sRF;
%     tRF = -tRF;   
% end
%%

[~, idx] = max(max(RF, [],2), [],1);

tRF = squeeze(makeVec(RF(idx,:)));

sRF = pinv(tRF)*RF';


%%
stRF = permute(reshape(RF, yPx,xPx, nN, []), [ 1 2 4 3]);

sRF = reshape(sRF, yPx,xPx, nN);

rfTimes = corrTimesInFrames(RFFrameInds) * stimTimeStep;




end