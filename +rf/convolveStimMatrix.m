function convStim = convolveStimMatrix(stimFrames, tKernel)

[xPx, yPx, nT] = size(stimFrames); % size of 3D stimulus matrix

nPx = xPx*yPx; % tot number of pixels of the screen

sss = reshape(stimFrames, nPx, nT)'; % reshape to 2D matrix

convStim = conv2(tKernel, sss); % convolve with response kernel

convStim(nT+1:end,:) = []; % remove the tail of the convolution

convStim = reshape(convStim', xPx, yPx, nT);

end