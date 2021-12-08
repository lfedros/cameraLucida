function [tunePars, xval] = OriTune_Figure( folder_name , colorID )

% ORITUNE_FIGURE	plots orientation tuning curve
%
%       INPUTS:
%       [1] folder_name     = neuron reconstruction         [string]
%		[2] colorID         = preferred orientation color   [HEX code]
%
%		OUTPUTS:
%       [1] tunePars        = orientation tuning parameters [double]
%       [2] xval            = degree range                  [double]
%       [3] color plot of orientation tuning                [.tif]
%
% See also: ORITUNE, FITORI, CIRCSTATS, CIRCSTATS360

% 2019 LF Rossi

%% Code to load and plot orientation tuning responses
addpath('/home/naureeng/cameraLucida/Analysis/MatteoBox')
addpath('/home/naureeng/cameraLucida')

%% Load data

load( strcat( folder_name, '_orientationTuning.mat' ) );

%% plot average response and tuning curve

[nN, nStim, nRep, nT] = size(allResp);
figure;

oris = 0:30:330;
for iStim = 1: nStim-1
    
    subplot(1, nStim+2 , iStim)
    
    shadePlot(kernelTime{1}, squeeze(aveAllResp(1,iStim,:, :)), squeeze(seAllResp(1,iStim,:, :)), [0 0 0])
    xlim([min(kernelTime{1}),max(kernelTime{1})])
    
    ylim([-0.5 5])
    set(gca, 'Xtick', [], 'YTick', [],'visible', 'off')
    formatAxes
end
hold on
plot([-1, -1], [1, 2] , 'k')

subplot(1, nStim+2, (nStim: nStim+2))

toFit= makeVec(allResPeak(1, 1:end-1, :))';

xval = 0:5:330;
xval2 = 0:30:360;

[tunePars, ~] = fitori(repmat(oris, 1,nRep), toFit);
oriFit = oritune(tunePars, 0:5:330);
errorbar(xval2 - 90, aveAllResPeak, seAllResPeak, 'ok'); hold on

%% extract values for oriTune curve

plot(xval - 90, oriFit, 'Color', colorID.colorID , 'LineWidth', 2)
formatAxes
set(gca, 'YColor', 'none','YTick', [], 'XTick', [0:90:360], 'XTickLabel', {0:90:270, 'Blank'});
xlim([-90 , 270])
ylim([min(aveAllResPeak) - mean(seAllResPeak), max(aveAllResPeak) + max(seAllResPeak)])

%%
set(gcf, 'Position', get(0, 'Screensize'));
print(strcat(folder_name, '_oriTune'), '-dtiff');
