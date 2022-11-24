function [resp, oneTrace] = aveSparseNoiseReps(signal, traceTimes, stimTimes, repetitionTimes)

traceTimes = traceTimes(:);
stimTimes = stimTimes(:);

for rep = 1:length(repetitionTimes.onset)
    % interpolate trace to times of stimulus frames
    oneTrace(:, :, rep) = interp1(traceTimes, signal, ...
        stimTimes + repetitionTimes.onset(rep));
end

resp = squeeze((nanmedian(oneTrace, 3)));
resp = zscore(resp);

end