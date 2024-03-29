function [stimFrames, frameTimes, stimPosition] = getStimulusFrames(info)

SetDefaultDirs;

% pars = ProtocolLoad_LFRnew(info.subject, ...
%     str2double(info.expDate(info.expDate ~= '-')), info.exp);
pars = ProtocolLoad_LFRnew(info.subject, ...
    info.expDate, info.exp);

stimFile = str2func(strtok(pars.xfile, '.'));
% load myScreenInfo
load(fullfile(info.folderTL, strrep(info.basenameTL, 'Timeline', 'hardwareInfo')))
myScreenInfo.windowPtr = NaN;
% call x-file to create stimuli
SS = stimFile(myScreenInfo, pars.pars);
stimFrames = cat(3, SS.ImageTextures{:});

switch pars.xfile
    case 'stimSparseNoiseUncorrAsync.x'
framesPerImage = 1;
    otherwise
framesPerImage = pars.pars(6,:);
end
frameTimes = (0 : size(stimFrames, 3)-1) * framesPerImage / myScreenInfo.FrameRate;
stimPosition = [pars.pars(2), pars.pars(3), pars.pars(4), pars.pars(5)] / 10;