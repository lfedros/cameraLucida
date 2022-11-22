function [psRF, expVar, anovaP, staRF, receptiveField, rfTimes, aveResp, oneTrace] = ...
    regressRF(resp, frameTimes, stimTimes, stimFrames, stimFrameTimes, RFtype, doPlot)
%
% wrapper code to compute STA and smooth pseudoinverse cross-validated RF
% see individual functions for details
%INPUTS 
% resp: nT x nN matrix of neuronal responses
% frameTimes: nT x 1 vector of timestamps of neuronal response
% stimTimes: structure containing .onset and .offset fields, containing timestamps of start and finish of each stimulus repeat
% stimFrames: nPxY x nPxX x nStim matrix of sparse noise stimuli
% stimFrameTimes: nTstim vector of timestamps of stimulus frames during a repeat
% doPlot: set to 1 to request summary plot, default 0
%
%OUTPUTS
% psRF: is the yPx*xPx*rfType psinv estimated RF
% expVar: nN*rfType is the variance explained by the RF, calculated as the correlation
% coefficient between predicted response and actual data
%
% anovaP: nN*rfType anova p-value testing if the cross validated RF estimate have
% pixels significatly different from the mean. 
%
% staRF: is the yPx*xPx*rfType stimulus triggered average spatial RFs
% receptiveField: yPx*xPx*nTkernel*rfType stimulus triggered average spati0-temporal RFs
% rfTimes: timestamps of RF kernel
% aveResp: nTstim * nN average response to stimulus repeats
% oneTrace: nTstim*nN*nResp single trial stimulus responses


if nargin < 7
    doPlot = 0;
end

if nargin <6
RFtype = {'on' , 'off',  'onoff', 'any'}; % receptive field types that we are going to compute
end

% RFtype = {'linear'};

    trace = zscore(resp); % zscore neuronal responses
    
    % average responses across repeats and interpolate to stim freq
    [aveResp, oneTrace] = rf.aveSparseNoiseReps(trace, ...
        frameTimes, stimFrameTimes, stimTimes); 
    
    for iType = 1: numel(RFtype)
        
        stim = rf.stim4typeRF(stimFrames, RFtype{iType}); % convert the stimulus for on, off, or any RF
        
        for iN = 1: size(aveResp,2)
            
            [yPx, xPx, nT] = size(stimFrames); % calculate size of stimulus
            
            % compute stimulus triggered average RFs
            [staRF(:,:,iN, iType), receptiveField(:,:,:,iN, iType), rfTimes] = ...
                rf.staRF(aveResp(:, iN), stim, stimFrameTimes);
            
            % cross-valitation to pick best smoothing constraint
            [psRF(:,:,iN, iType), expVar(iN,iType), lambda, predResp, anovaP(iN,iType)] =...
                rf.runPsinvSmoothRF(aveResp(:, iN), stim);
            
            % plot summary of the results if requested
            if doPlot 
                
                figure;
                rf.plot_RFregress(aveResp(:, iN) ,receptiveField(:,:,:,iN, iType), staRF(:,:,iN, iType),...
                    psRF(:,:,iN, iType),RFtype{iType},expVar(iN, iType), predResp);
                
                drawnow;
               
            end
        end
    end

end
