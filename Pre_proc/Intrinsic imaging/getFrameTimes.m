function [frameTimes] = getFrameTimes(ExpRef, suffix)

% This function will return the frametimes of the eye-tracking movie
% The frame times will be aligned to the Timeline time axis
% If corresponding Timeline file does not exist, frame times will be
% relative only.
%
% frameTimes = getFrameTimes(ExpRef, suffix)
%   suffix - a string, if the files have a suffix different from 'eye', e.g
%   'intrinsic'

% These ways of calling are not supported yet:
% frameTimes = getFrameTimes(eyeCameraFileName, timelineFileName)

% May 2014 - MK Created

if nargin == 0
    % will open uigetfile(), so that user will be able to choose the video
    % file
    p = dat.paths;
    startPath = p.mainRepository;
    [Filename, eyeFolder] = uigetfile('*.*', 'Choose an eye-tracking data file', startPath);
    [~, eyeFileStem, ~] = fileparts(Filename);
    % loading the eye data
    warning off % there is always an annoying warning about a videoinput object
    load(fullfile(eyeFolder, eyeFileStem));
    warning on
    
    % figuring out where the Timeline data sits
    und_idx = strfind(eyeFileStem, '_eye');
    expRef = eyeFileStem(1:und_idx(end)-1);
    fullNames = dat.expFilePath(expRef, 'Timeline');
    % the second cell is the server location
    % loading the Timeline data
    load(fullNames{2});
    
else
    % ExpRef is supplied as an argument
    % loading the Eye-tracking data
    if nargin < 2
        suffix = 'eye';
    end
    eyeFolder = dat.expPath(ExpRef, 'main', 'master');
    eyeFileStem = sprintf('%s_%s', ExpRef, suffix);
    % load the log file from the server
    warning off % there is always an annoying warning about a videoinput object
    load(fullfile(eyeFolder, eyeFileStem)); % will create an 'eyeLog' variable
    warning on
    
    % loading the Timeline data from the server
    fullNames = dat.expFilePath(ExpRef, 'Timeline');
    load(fullNames{2});
    
    %TODO figure out what is the proper way to figure out if eyeLog is bad
    if true%~isfield(eyeLog, 'TriggerData')
        % something went wrong when saving the log file, recover the data
        % from the text files
        timesFile = dir(fullfile(eyeFolder, [ExpRef, '*', suffix, '_tmpFrameTime*.txt']));
        frameTimesFilename = fullfile(timesFile.folder, timesFile.name);
        udpFile = dir(fullfile(eyeFolder, [ExpRef, '*', suffix, '_tmpUDP*.txt']));
        UDPLogFilename = fullfile(udpFile.folder, udpFile.name);
        
        
        [eyeLog.udpEventTimes, eyeLog.udpEvents] = readUDPs(UDPLogFilename);
        eyeLog.TriggerData = readFrameTimes(frameTimesFilename);
    end
    
end

vReader = VideoReader(fullfile(eyeFolder, eyeLog.loggerInfo.Filename));
nFrames = vReader.NumberOfFrames;
fprintf('There are %d frames in the video file\n', nFrames);
fprintf('There are %d timestamps in the log file\n', length(eyeLog.TriggerData));

% these are UDPs recorded in Timeline
TLUDPs = Timeline.mpepUDPEvents(1:Timeline.mpepUDPCount);
UDPMessages = eyeLog.udpEvents;
UDPAbsTimes = eyeLog.udpEventTimes;

% find UDP messages corresponding to the ones in Timeline
[isIn, idx] = ismember(UDPMessages, TLUDPs);
UDPMessages = UDPMessages(isIn);
idx = idx(isIn);
UDPAbsTimes = UDPAbsTimes(isIn);

% exclude UDPs with 'ExpStart', 'ExpEnd', and 'ExpInterrupt', they have 
% unreliable timing
isValid = ~contains(UDPMessages, 'ExpStart');
isValid = isValid & ~contains(UDPMessages, 'ExpEnd');
isValid = isValid & ~contains(UDPMessages, 'ExpInterrupt');
UDPMessages = UDPMessages(isValid);
idx = idx(isValid);
UDPAbsTimes = UDPAbsTimes(isValid);

% calculate median time difference
absTimes = cellfun(@datenum, UDPAbsTimes);
absTimes = absTimes(:) * 24*60*60; % convert to seconds
tlTimes = Timeline.mpepUDPTimes(idx); 

timeDiff = median(absTimes - tlTimes);
frameTimes = cellfun(@datenum, {eyeLog.TriggerData.AbsTime})*(24*60*60);
frameTimes = frameTimes(:) - timeDiff;


return;


%% =============some plotting for debugging purposes=========
eyeTimes = eyeTimes - timeDiff;

figure
stem(eyeTimes, ones(nEvents, 1), 'b');
hold on;
stem(tlTimes, ones(nEvents, 1), 'r:');
legend('eyeUDPs', 'tlUDPs');
xlabel('time [seconds]');
title('UDP messges Timing (aligned)');

figure
dd = diff(eyeTimes-tlTimes);
plot(dd(nEvents2Discard+1:end))
title('UDP timing jitter (eyeCamera - Timeline)');
xlabel('UDP message number');
ylabel('Time difference [sec]');

figure
hist(dd(nEvents2Discard+1:end), 20);
title('Time jitter histogram');
xlabel('Time difference [sec]');

end

%%
function [UDPAbsTimes, UDPMessages] = readUDPs(udpLog)
% extract UDP times and messages from the
fUDP = fopen(udpLog, 'r');
UDPAbsTimes = cell(0);
UDPMessages = cell(0);
titleLine = fgetl(fUDP);

while ~feof(fUDP)
    % read line-by-line and extract the necessary information
    logEntry = fgetl(fUDP);
    if ~isempty(logEntry)
        % absolute times are within square brackets
        startInd = find(logEntry == '[');
        endInd = find(logEntry == ']');
        UDPAbsTimes{end+1} = str2num(logEntry(startInd+1 : endInd-1));
        % The UDP message is in single quotes
        quoteIdx = find(logEntry == '''');
        if length(quoteIdx)>1
            UDPMessages{end+1} = logEntry(quoteIdx(1)+1 : quoteIdx(2)-1);
        else
            UDPMessages{end+1} = '';
        end
    end
end

fclose(fUDP);

end

%% ===============
function timingData = readFrameTimes(frameTimesFilename)
% Process the frame times log file
timingData = struct('AbsTime', [], 'FrameNumber', [], 'RelativeFrame', [], ...
    'TriggerIndex', [], 'Time', []);
fTimes = fopen(frameTimesFilename, 'r');
titleLine = fgetl(fTimes);

iFrame = 0;
while ~feof(fTimes)
    % read line-by-line and extract the necessary information
    logEntry = fgetl(fTimes);
    if ~isempty(logEntry)
        % absolute times are within square brackets
        % FrameNumber is the first number after that
        nums = str2num(logEntry);
        iFrame = iFrame + 1;
        timingData(iFrame).AbsTime = nums(1:6);
        timingData(iFrame).FrameNumber = nums(7);
        timingData(iFrame).RelativeFrame = nums(8);
        timingData(iFrame).TriggerIndex = nums(9);
        timingData(iFrame).Time = nums(10);
    end
end

fclose(fTimes);

absFrameTimes = cellfun(@datenum, {timingData.AbsTime}); % convert to datenums
absFrameTimes = absFrameTimes * 24*60*60; % convert to seconds

% we need to sort them, sometimes chunks of 100 frames get swapped during
% writing to the original txt files
[~, idx] = sort(absFrameTimes);
[~, idx2] = sort([timingData.FrameNumber]);
if ~isequal(idx(:), idx2(:))
    error('Houston, we have a problem here')
end

% reorder the whole structure
timingData = timingData(idx);

end


