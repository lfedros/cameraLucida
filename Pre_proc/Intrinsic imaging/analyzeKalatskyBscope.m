function [out, pars] = analyzeKalatskyBscope(ExpRef)

if nargin<1
    % this is just for debugging
    ExpRef = '2021-11-01_1_AH001';
end

%%
p = getMpepProtocol(ExpRef);

Timeline = getTimeline(ExpRef);

mov = getIntrinsic(ExpRef);

% mov = getRegIntrinsic(ExpRef); % if you want to include image
% registration, but it does not seem to help

%%

% these are the frame onsets
fprintf('Extracting frame times...\n');
bscopeCamFrameTimes = getFrameTimes(ExpRef,'intrinsic');

% these are stimulus onset/offset times, as detected from the
% photodiode signal - nStims x nRepeats cell array
stimTimes = getStimTimes(Timeline, p);

% these are indices of frames acquired during the corresponding stimuli
stimFrames = cellfun(@(x) find(bscopeCamFrameTimes>x(1) & bscopeCamFrameTimes<x(2)), stimTimes, 'UniformOutput', false);

pars = getStimPars(p);
nStims = length(pars);
for iStim = 1:nStims
    pars(iStim).xAxis = linspace(3.5,0,size(mov,1));
    pars(iStim).yAxis = linspace(0,3.5,size(mov,2));
end

out.ExpRef = ExpRef;
out.pars = pars;
out.meanFrame = nanmean(mov, 3);

nrSVDtoRemove = 1;

if nrSVDtoRemove>0
    if nrSVDtoRemove>1
        fprintf('Subtracting first %d SVD components... ',nrSVDtoRemove);
    else
        fprintf('Subtracting first SVD component... ');
    end
    mov2 = rmSVD((single(mov)-out.meanFrame)./out.meanFrame, nrSVDtoRemove);
    fprintf('Done!\n');
else 
    mov2 = (single(mov)-out.meanFrame)./out.meanFrame; 
end

fprintf('Generating preference maps...\n');
%out.averageMov = getAverageMovies(mov2, fusiFrameTimes, stimTimes, pars);
out.maps = getPreferenceMaps(mov2, bscopeCamFrameTimes, stimTimes, pars);
fprintf('Done!\n');

%h = plotPreferenceMaps(out.maps,out.pars,true,'alpha'); %args: out.maps, out.pars, plotHemo, plotType
%%

% figure; 
% subplot(2,2,1)
% imagesc(out.maps.xpos.prefPhase);
% subplot(2,2,2)
% imagesc(out.maps.ypos.prefPhase);
% subplot(2,2,3)
% imagesc(out.maps.xpos.amplitude);
% subplot(2,2,4)
% imagesc(out.maps.ypos.amplitude);

