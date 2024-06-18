function [meanTrace,normMeanTrace, zeroTraces, normZeroTraces] = normMeanData(trace)
    traceData = trace;
    zeroTraces = traceData-mean(traceData(:,1:1000),2);
    normZeroTraces = zeroTraces./max(zeroTraces, [],2);
    meanTrace = mean(zeroTraces,1);
    normMeanTrace = meanTrace./max(meanTrace);
    % disp('the max used for this normalization:',max(meanTrace))
end 