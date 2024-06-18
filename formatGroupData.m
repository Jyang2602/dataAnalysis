
function[n, idxName,  traceData, epspAmps, slope, tau, epspPeaks] = ...
    formatGroupData(epspMETA, idx, idxName, traceName,ampName,slopeName,tauName, peakName)


traceData = {epspMETA(idx).(traceName)};

% epspAmps = cell2mat({epspMETA(idx).(ampName)}');
epspAmps = {epspMETA(idx).(ampName)};
notEmptyA = ~cellfun('isempty', epspAmps);
epspAmps = cell2mat(epspAmps(notEmptyA)');

% slope = cell2mat({epspMETA(idx).(slopeName)}');
slope = {epspMETA(idx).(slopeName)};
notEmptyS = ~cellfun('isempty', slope);
slope = cell2mat(slope(notEmptyS)');

epspPeaks = {epspMETA(idx).(peakName)};
notEmptyP = ~cellfun('isempty', epspPeaks);
epspPeaks = cell2mat(epspPeaks(notEmptyP)');


tau = {epspMETA(idx).(tauName)};
notEmptyT = ~cellfun('isempty', tau);
tau = cell2mat(tau(notEmptyT)');

% notEmptyindx = ~cellfun(@isempty, traceData);
notEmptyTr = ~cellfun('isempty', traceData);
traceData = traceData(notEmptyTr);
n = numel(traceData);
n = num2str(n);
traceData = cellfun(@(x) x(1:20000), traceData, 'UniformOutput', false);
traceData = cell2mat(traceData');

% TTL =

smootheTTL = medfilt1(TTL, windowSize);
[peaks, onsets] = findpeaks(smootheTTL, 'MinPeakHeight', 10);
stim = (round(onsets * (dt / Dt))) / dt;

end