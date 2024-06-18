% Define field names

fieldNames = {'ABOVE_12RED_1keepTraceMean', 'ABOVE_6RED_1keepTraceMean'};

meanPlots = struct();

Ecolor = [255, 182, 193] / 255;  % Light Pink
Lcolor = [173, 216, 230] / 255;  % Light Blue


configs = {







% CHR2(+) Base Mean ABOVE 6 RED
{'ChR2IndxE12', 'ChR2(+) Early 12', 'ABOVE_6RED_1keepTraceMean','ABOVE_6RED_1epspAmps','ABOVE_6RED_1slopes','ABOVE_6RED_1taus','ABOVE_6RED_1epspPeaks', 'Lcolor'},
{'ChR2IndxL12', 'ChR2(+) Late 12', 'ABOVE_6RED_1keepTraceMean','ABOVE_6RED_1epspAmps','ABOVE_6RED_1slopes','ABOVE_6RED_1taus','ABOVE_6RED_1epspPeaks', 'Ecolor'},
{'ChR2IndxL6', 'ChR2(+) Late 6', 'ABOVE_6RED_1keepTraceMean', 'ABOVE_6RED_1epspAmps','ABOVE_6RED_1slopes','ABOVE_6RED_1taus','ABOVE_6RED_1epspPeaks','Lcolor'},


% Opsin(-) Baseline Mean ABOVE 6 RED
{'pyrIndxE12', 'Opsin (-) Early 12', 'ABOVE_6RED_1keepTraceMean','ABOVE_6RED_1epspAmps','ABOVE_6RED_1slopes','ABOVE_6RED_1epspPeaks','ABOVE_6RED_1taus','Ecolor'},
{'pyrIndxL12', 'Opsin (-) Late 12', 'ABOVE_6RED_1keepTraceMean','ABOVE_6RED_1epspAmps','ABOVE_6RED_1slopes','ABOVE_6RED_1epspPeaks','ABOVE_6RED_1taus','Ecolor'},
{'pyrIndxL6', 'Opsin (-) Late 6', 'ABOVE_6RED_1keepTraceMean','ABOVE_6RED_1epspAmps','ABOVE_6RED_1slopes','ABOVE_6RED_1epspPeaks','ABOVE_6RED_1taus','Ecolor'},

% All cells Early 12 vs. Late 12 for ABOVE 12 RED
{'E12indx', 'All cells Early 12', 'ABOVE_6RED_1keepTraceMean','ABOVE_12RED_1epspAmps','ABOVE_12RED_1slopes','ABOVE_12RED_1taus','ABOVE_12RED_1epspPeaks', 'Ecolor'},
{'L12indx', 'All cells Late 12', 'ABOVE_6RED_1keepTraceMean','ABOVE_12RED_1epspAmps','ABOVE_12RED_1slopes','ABOVE_12RED_1taus', 'ABOVE_12RED_1epspPeaks','Lcolor'},
{'L6indx', 'All cells Late 6', 'ABOVE_6RED_1keepTraceMean','ABOVE_12RED_1epspAmps', 'ABOVE_12RED_1slopes','ABOVE_12RED_1taus','ABOVE_12RED_1epspPeaks','Lcolor'},



% CHR2(+) Baseline Mean ABOVE 12 RED
{'ChR2IndxE12', 'ChR2(+) Early12', 'ABOVE_12RED_1keepTraceMean','ABOVE_12RED_1epspAmps','ABOVE_12RED_1slopes','ABOVE_12RED_1taus','ABOVE_12RED_1epspPeaks', 'Ecolor'},
{'ChR2IndxL12', 'ChR2(+) Late 12', 'ABOVE_12RED_1keepTraceMean','ABOVE_12RED_1epspAmps', 'ABOVE_12RED_1slopes','ABOVE_12RED_1taus','ABOVE_12RED_1epspPeaks','Ecolor'},
{'ChR2IndxL6', 'ChR2(+) Late 6', 'ABOVE_12RED_1keepTraceMean','ABOVE_12RED_1epspAmps', 'ABOVE_12RED_1slopes','ABOVE_12RED_1taus','ABOVE_12RED_1epspPeaks','Lcolor'},

% Opsin(-) Baseilne Mean ABOVE 12 RED
{'pyrIndxE12', 'Opsin (-) Early 12', 'ABOVE_12RED_1keepTraceMean','ABOVE_12RED_1epspAmps','ABOVE_12RED_1slopes','ABOVE_12RED_1taus','ABOVE_12RED_1epspPeaks','Ecolor'},
{'pyrIndxL12', 'Opsin (-) Late 12', 'ABOVE_12RED_1keepTraceMean','ABOVE_12RED_1epspAmps','ABOVE_12RED_1slopes','ABOVE_12RED_1taus','ABOVE_12RED_1epspPeaks','Lcolor'},
{'pyrIndxL6', 'Opsin (-) Late 6', 'ABOVE_12RED_1keepTraceMean','ABOVE_12RED_1epspAmps','ABOVE_12RED_1slopes','ABOVE_12RED_1taus','ABOVE_12RED_1epspPeaks','Lcolor'},

% All cells Baseline Mean ABOVE 12 RED
{'E12indx', 'All cells Early 12', 'ABOVE_12RED_1keepTraceMean','ABOVE_12RED_1epspAmps','ABOVE_12RED_1slopes','ABOVE_12RED_1taus','ABOVE_12RED_1epspPeaks', 'Ecolor'},
{'L12indx', 'All cells Late 12', 'ABOVE_12RED_1keepTraceMean','ABOVE_12RED_1epspAmps','ABOVE_12RED_1slopes','ABOVE_12RED_1taus','ABOVE_12RED_1epspPeaks', 'Lcolor'},
{'L6indx', 'All cells Late6', 'ABOVE_12RED_1keepTraceMean','ABOVE_12RED_1epspAmps', 'ABOVE_12RED_1slopes','ABOVE_12RED_1taus','ABOVE_12RED_1epspPeaks','Lcolor'},

};


% load('epspMETA_fits.mat', 'epspMETA');
load('epspMETA_fits.mat');
for i = 1:length(configs)
    idx = eval(configs{i}{1});
    idxName = configs{i}{2};
    traceName = configs{i}{3};
    ampName =configs{i}{4};
    slopeName = configs{i}{5};
    tauName = configs{i}{6};
    peakName=configs{i}{7};

    [n, idxName, traceName, traceData, epspAmps, slope, tau, epspPeaks] = ...
        formatGroupData(epspMETA, idx, idxName, traceName,ampName,slopeName,tauName, peakName);


    %pull name for storage
    stimName = split(traceName, '_');
    stimName = strcat(stimName{1}, '_', stimName{2});

    % add to structure

    meanPlots(i).n = n;
    meanPlots(i).cellTrain = idxName;
    meanPlots(i).stimName = stimName;
    meanPlots(i).traceData = traceData;
    meanPlots(i).epspAmps = epspAmps;
    meanPlots(i).Slope = slope;
    meanPlots(i).Tau = tau;
    meanPlots(i).epspPeaks = epspPeaks;


    % end

    % for i= 1:length(meanPlots)
    %
    %     trace = meanPlots(i).traceData;

%%normalize trace data
    trace = traceData;
    if ~isempty(trace)
        [meanTrace,normMeanTrace, zeroTraces, normZeroTraces] = normMeanData(trace);
        meanPlots(i).meanTrace = meanTrace;
        meanPlots(i).normMeanTrace = normMeanTrace;
        meanPlots(i).zeroTraces = zeroTraces;
        meanPlots(i).normZeroTraces = normZeroTraces;
%%do STP fits
        % while keepFitting == true;
        %     peaks = epspAmps;
        % 
        % 
        % 
        %     [coef, fitTrace, R1, r2] = TsodyksFit(peaks,spikeTimes,synapseTaus,normTrace,GUESS);
        %     [FLAG, keepFitting, newGUESS] = stp_refit (GUESS);
        %     Rval = R1';
        % 
        %     GUESS = newGUESS
        %     % disp (r2);
        % 
        % 
        % end
    end
end


%%%%% only load above part once, to plot start here%%%%

options = arrayfun(@(x) x.cellTrain, meanPlots, 'UniformOutput', false);
stimulus = arrayfun(@(x) x.stimName, meanPlots, 'UniformOutput', false);
save('meanPlots.mat','meanPlots', 'E12indx','L12indx','L6indx','ChR2IndxL6', 'ChR2IndxL12', 'ChR2IndxE12', 'pyrIndxL6', 'pyrIndxL12', 'pyrIndxE12','options','stimulus');


