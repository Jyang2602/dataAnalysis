function [semE, semL,taxis] = makeSEMData(traceAllE,traceAllL)

semE = std(traceAllE)./sqrt(size(traceAllE,1));
semL = std(traceAllL)./sqrt(size(traceAllL,1));

taxis = (1:size(traceAllE,2));
end
