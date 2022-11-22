function [estRF, expVar, lambda, predResp, const] =...
    runPsinvSmoothRF_dev(resp, stimFrames, tKernel)

% wrapper code for receptive field estimation using regularised pseudoinverse with
% smoothness constraint (after Smyth, ...,Tolhurst 2003, J Neurosci). Runs
% the RF estimation and crossvalidation of the smoothness parameter

% INPUT
% resp is nT long timecourse of fluorescece for one neuron (note common
% time stamps with stimulus frames)

% stimFrames is yPx*xPx*nT is the stimulus matrix of the Sparse Noise stimulus

%OUTPUT
% estRF is the yPx*xPx estimated RF

% expVar is the variance explained by the RF, calculated as the correlation
% coefficient between predicted response and actual data

% lambda smoothness parameter with maximum explained variance in cross
% validation

% predResp nT long predicted response

% anovaP anova p-value testing if the cross validated RF estimate have
% pixels significatly different from the mean. 


%% k fold cross validation of smoothness parameter

[yPx, xPx, nT] = size(stimFrames);
nPx = xPx*yPx;
[nT, nN] = size(resp);

stim = rf.convolveStimMatrix(stimFrames, tKernel);

k = 6;
[testResp, trainingResp, testStim, trainingStim] = rf.kfoldSplit(resp, stim , k);

% la = [0.005 0.01 0.02 0.05 0.1 0.2 0.5 1 2 5 10 20 50 100];
la = [sqrt(exp(-10:7)) 1000];

nl = numel(la);

nMsgChars = 0;
for il = 1:nl
    testPred = [];
    testData = [];

    for ik = 1:k
        
        
        [cvRF, ~, const] = rf.psinvSmoothRF_dev(zscore(trainingResp{ik}), trainingStim{ik}, la(il));
        
        convStim = reshape(testStim{ik}, nPx, [])'; % reshape to 2D matrix
        
        cvRF = reshape(cvRF, [], nN);
        
        testPred = convStim*cvRF + const;
        testData = zscore(testResp{ik});
        cvScore(il, ik, :) = arrayfun(@(n) corr(testPred(:, n), testData(:, n)), 1:nN, 'Uni', 1);
        
%         cvScore(il, ik, :) = 1-bsxfun(@rdivide, sum((testData - testPred).^2,1), sum(testData.^2,1));
        
        nMsgChars = overfprintf(nMsgChars, 'lambda = %.2f, set n. %d', la(il), ik);
        
    end
    
%     cvScore(il, :) = 1-bsxfun(@rdivide, sum((testData - testPred).^2,1), sum(testData.^2));
end

nMsgChars = overfprintf(nMsgChars, '\r done cross-validating lambda \r');

[expVar, best] = max(squeeze(mean(cvScore, 2)), [],1);
% [expVar, best] = max(cvScore, [],1);
% anovaP = anova1(reshape(permute(cvRF{best}, [3,1,2]), k, []), [], 'off');

%%
lambda = la(best);

for iN = 1:nN
[estRF(:,:, iN), predResp(:, iN), const(iN)] = rf.psinvSmoothRF_dev(resp(:, iN), stim, lambda(iN));
end
% corr(predResp, resp);
% 1-sum((resp-predResp).^2)/sum(resp.^2);
end