function stim = stim4typeRF(stimFrames, stimType)

[xPx, yPx, nFrames] = size(stimFrames); % size of 3D stimulus matrix
nPx = xPx*yPx; % tot number of pixels on the screen

stim = stimFrames;

switch stimType
    
    case 'on'
        stim(stim < 0) = 0;
    case 'off'
        stim(stim > 0) = 0;
    case 'onoff' 
        stim = abs(stim);
    case 'linear'
        stim = stimFrames;
    case 'any'
        igood = stimFrames(:,:,2:nFrames) ~= stimFrames(:,:,1:nFrames-1);
        
        igood = reshape(igood, nPx, []);
    
        stim = reshape(igood, [], nFrames-1); % reshape stim to 2D matrix
    
        stim = [zeros(size(stim, 1), 1), stim]; % add back first blank frame
    
        stim = reshape(stim, xPx, yPx, []);
        
    otherwise
        error('Stimulus type was wrong');
end

% stim = (stim - mean(stim(:))) ./ std(stim(:)); % zscore stimulus
% stim = bsxfun(@minus, stim, mean(stim,3));
% stim = bsxfun(@rdivide, stim, std(stim,1,3));



end