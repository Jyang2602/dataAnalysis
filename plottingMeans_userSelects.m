%% show user options of which cell types, training, and stimulus are curretnly available in meanPlots structure%

disp('Please select which cell types/training and stimulus combo you would like to plot: ')
for i = 1:length(options)
fprintf('%d: %s %s\n', i, options{i}, stimulus{i});
end

%plot chosen index
plotIndex =input('Enter the numbers of which two conditions you would like to plot and run SEM on: ex "[1 2]" ');
meanT = {meanPlots(plotIndex).meanTrace};
normMeanT = {meanPlots(plotIndex).normMeanTrace};

if contains(meanPlots(plotIndex(1)).cellTrain, 'Early')
    traceAllE = (meanPlots(plotIndex(1)).zeroTraces);
    traceAllL = (meanPlots(plotIndex(2)).zeroTraces);

    normTraceAllE =(meanPlots(plotIndex(1)).normZeroTraces);
    normTraceAllL=(meanPlots(plotIndex(2)).normZeroTraces);

    meanTraceE =meanPlots(plotIndex(1)).meanTrace;
    meanTraceL =meanPlots(plotIndex(2)).meanTrace;

    normTraceE =meanPlots(plotIndex(1)).normMeanTrace;
    normTraceL =meanPlots(plotIndex(2)).normMeanTrace;
    
    nEarly = meanPlots(plotIndex(1)).n;
    nLate = meanPlots(plotIndex(2)).n;
    
else
    traceAllE = (meanPlots(plotIndex(2)).zeroTraces);
    traceAllL = (meanPlots(plotIndex(1)).zeroTraces);

    normTraceAllE =(meanPlots(plotIndex(2)).normZeroTraces);
    normTraceAllL=(meanPlots(plotIndex(1)).normZeroTraces);

    meanTraceE =meanPlots(plotIndex(2)).meanTrace;
    meanTraceL =meanPlots(plotIndex(1)).meanTrace;
    normTraceE =meanPlots(plotIndex(2)).normMeanTrace;
    normTraceL =meanPlots(plotIndex(1)).normMeanTrace;

    nEarly = meanPlots(plotIndex(2)).n;
    nLate = meanPlots(plotIndex(1)).n;


end
Lcolor = [255, 182, 193] / 255;  % Light Pink
Ecolor = [173, 216, 230] / 255;  % Light Blue
normY = input('Would you like to plot the normalized or non-normalized traces? enter 1 for normalized and 0 for non-normalized:')
figure;
if normY ==1

[semE, semL,taxis] = makeSEMData(normTraceAllE,normTraceAllL);
% figure
FillSemPlot(taxis, normTraceE,0,semE,Ecolor);
FillSemPlot(taxis, normTraceL,0,semL,Lcolor);

plot(normTraceE, 'b-', 'DisplayName', 'All cells Early 12');  % Plot Early 12 in blue
plot(normTraceL, 'r-', 'DisplayName', 'All Cells Late 12');

normText = 'Normalized plot';

% titleText = strcat(options{1},' VS ', options{2});
% title(titleText)
else

[semE, semL,taxis] = makeSEMData(traceAllE,traceAllL);

subplot(2,1,1)
FillSemPlot(taxis, meanTraceE,0,semE,Ecolor);
hold on;  % Hold on to plot multiple traces
FillSemPlot(taxis, meanTraceL,0,semL,Lcolor);
plot(meanTraceE, 'b-', 'DisplayName', 'All cells Early 12');  % Plot Early 12 in blue
plot(meanTraceL, 'r-', 'DisplayName', 'All Cells Late 12');
normText = 'non-normalized plot';

end

titleText = strcat(options{plotIndex(1)},  'VS   ', options{plotIndex(2)});

title(titleText, normText)
legE = strcat('Early: ','n = ' ,nEarly);
legL = strcat("Late:  ", 'n=  ', nLate);
legend(legE, legL)


