function [estRF, predResp, const] = psinvSmoothRF_dev(response, stimFrames, la)

% receptive field estimation using regularised pseudoinverse with
% smoothness constraint (after Smyth, ...,Tolhurst 2003, J Neurosci). The
% method was adapted to work with entire calcium imaging traces. In
% particular, a response kernel is convolved with the stimulus matrix
% before proceeding with the RF estimation. 

% response = makeVec(response);
[nT, nN] = size(response);

[xPx, yPx, nT] = size(stimFrames); % size of 3D stimulus matrix

nPx = xPx*yPx; % tot number of pixels of the screen

smoothL = Ret.zeroStimLaplacian(stimFrames); % laplacian matrix, one per stimulus pixel, xPx*yPx*nPx 

convStimS = reshape(smoothL, [], nPx)*la; % reshape to 2D and multiply by regularisation parameter

convStim = reshape(stimFrames, [], nT)'; % reshape to 2D matrix

convStimS = [convStim; convStimS]; % concatenate with stimulus matrix

convStimS = cat(2, convStimS, ones(size(convStimS,1), 1)); % add column of one to design matrix for intercept

responseS = [response; zeros(nPx, nN)]; % add trail of 0 to response, to set the conditions for smoothness constraint

% estRF = pinv(convStimS)*responseS; % pseudoinverse estimation of receptive field
estRF = convStimS\responseS; % pseudoinverse estimation of receptive field

const = estRF(end,:); % that's the intercept
estRF = estRF(1:end-1,:); % that is the spatial RF

predResp = convStim*estRF + const; % compute predicted response
% predResp = convStim*estRF; % compute predicted response

estRF = reshape(estRF, xPx,yPx, nN); % reshape to 2D recetive field


end