clear;
close all;

% Set this variable to true for inside rig, false for outside rig
RIG_IN = true;
SAVE_CELL = true;

selecting_files = true;

% TraceDur = 3 %in Second
% dt = p.???
% NumSample = 3/dt = 30000

condition_text = ["12BLUE", "12RED", "6RED", "6BLUE"];
conditions = [2 3 6 7];
num_conditions = length(conditions);
conIndex = 0;
Dt = 1;

while selecting_files
    close all;

    continuing = input('Input -1 to quit or anything else to continue: ', 's');
    continuing = sscanf(continuing, '%f');

    if continuing == -1
        selecting_files = false;
    else
        continuing = 0;
    end

    if selecting_files
        [fileName, matDir] = uigetfile({'*.mat', 'mat files (*.mat)'}, 'Choose a file to load', 'multiselect', 'on');

        if numel(fileName) == 1 && all(fileName == 0)
            error('No valid file selected');
        end

        if ischar(fileName)
            fileName = {fileName};
        end

        filenamelength = length(fileName);
        filename = [matDir fileName{filenamelength}];
        load(filename);

        % ExpCond
        condOrder
        if RIG_IN
            dt = sampleRate{1}; % dt in ms for inside rig
        else
            dt = sampleRate; % dt in ms for outside rig
        end

        trainProtocol = stimProtocol;

        condind = input('Input the condition index(es) (position) to select frames from (example: [2 3]) or 0 to skip: ');
    end

    skip = false;
    if continuing == -1
        skip = true;
        selecting_files = false;
    elseif condind == 0
        skip = true;
        disp('Skipped this cell');
    end

    if ~skip
        % Going through each condition of each cell

        SAVE_DATA = true;
        SR = 10000; % DEFAULT SAMPLING RATE IN HZ
        SMOOTH_WIDTH = 5; % width of smoothing window in ms % default: 1.5

        numindexes = length(condind);

        DATA = struct();
        DATA.trainProtocol = stimProtocol;
        DATA.trainDur = trainDur;
        DATA.cell1Type = cell1Type;
        DATA.virus = transfectedVirus;
        DATA.sampleRate = dt;
        DATA.DIV = DIV;
        DATA.drug = drug;

        if strcmp(drug, 'yes')
            DATA.drugType = drugType;
            DATA.drugConc = drugConc;
        end
        figure('Position', [100, 100, 1200, 1000]);
        % clf;

        for loop = 1:numindexes
            % close all;
            current_index = condind(loop);
            ExpCondition = condOrder{current_index};
            ExpCondition_text = ExpCondition;

            keepTrace = [];
            keepPulse = [];
            tracesToDelete = [];
            tracesKept = [];

            nA = nAclamp{current_index};
            nTraces = length(CH1{current_index}(:, 1));
            TraceAll = (CH1{current_index});
            if strcmp(drug,'yes')
            drugActive = drugTrial{current_index};
            end

            if RIG_IN
                TTLAll = (CH3{current_index}); % For inside rig
                % drugActive = drugTrial{current_index};
            else
                TTLAll = (CH2{current_index}); % For outside rig
            end

            normTraceAll = zeros(size(TraceAll));
            selected_one = false;
            stimInten = condInten{current_index};
            

            for traceInd = 1:nTraces
                Trace = squeeze(TraceAll(traceInd, :));
                if ~isempty(TTLAll)

                % if RIG_IN
                % 
                %     TTL = squeeze(TTLAll(traceInd, :));
                % else
                    % if ~isempty(CH2{current_index})
                        TTL = squeeze(TTLAll(traceInd, :));
                    else
                        TTL = [];
                    
                end

                time = dt:dt:(length(Trace) * dt);
                maxt = time(length(time));

                clf;
                hold on;
                set(gcf, 'color', 'w');

                % Plot trace and account for different length in
                % excitability and light pulses
                
                if length(Trace) < 11000
                    plot(time(1:8000), Trace(1:8000), 'k', 'linewidth', 2);
                else
                    plot(time(1:20000), Trace(1:20000), 'k', 'linewidth', 2);
                    if ~isempty(TTL)
                        plot(time(1:20000), TTL(1:20000) - 65, 'Color', [0, 0, 0, 0.8]);
                    end
                end

                ylim([-90 -30]);

                % save things
                if SAVE_DATA
                    str = input('Good trace? [Y]: enter Y to keep, or else just hit enter', 's');
                    if ~isempty(str)
                        keepTrace(end + 1, :) = Trace;
                        tracesKept(end + 1) = traceInd;
                        % if ~isempty(TTL)
                        %     keepPulse(end + 1, :) = TTL;
                        % end
                        selected_one = true;
                    else
                        tracesToDelete(end + 1) = traceInd;
                    end
                else
                    waitforbuttonpress;
                end

                spacer = 0;
            end

            if selected_one
                conIndex = conIndex + 1;
                ExpCondition_text = strcat(ExpCondition_text, '_', num2str(conIndex));
                if ~contains(ExpCondition_text, 'EXC_')
                    DATA.(ExpCondition_text).tracesToDelete = tracesToDelete;
                    % DATA.(ExpCondition_text).keepTrace = keepTrace;
                    DATA.(ExpCondition_text).keepTraces = tracesKept;
                    DATA.(ExpCondition_text).TraceAll = single(TraceAll);
                    DATA.(ExpCondition_text).nAclamp = nA;
                    if strcmp(drug,'yes')
                    
                    DATA.(ExpCondition_text).drugActive = drugActive;
                    end
                    
                    DATA.(ExpCondition_text).StimInten = stimInten;
                    DATA.(ExpCondition_text).TTL = single(TTL);

                    index = 1:nTracmnm, .0es;
                    tracestokeep = ismember(index, tracesToDelete);
                    tracestokeep = index(~tracestokeep);
                    keepTraceMean = mean(TraceAll(tracestokeep, :));
                    DATA.(ExpCondition_text).keepTraceMean = single(keepTraceMean);


                    %%% DO SLOPE AMP AND TAU FITS%%
                    fit = input('would you like to fit peaks amps and slopes to these traces?: enter 0 for no and 1 for yes');
                    if fit ==1
                    dt = 0.1;
                    trace = keepTraceMean;
                    windowSize = 95;
                    smootheTTL = medfilt1(TTL, windowSize);
                    [peaks, onsets] = findpeaks(smootheTTL, 'MinPeakHeight', 10);
                    stim = (round(onsets * (dt / Dt))) / dt;
                    [Amps, Slopes, tau, Peaks] = STP_MeasureEPSP_JM(trace, stim, dt);
                    DATA.(ExpCondition_text).epspAmps = single(Amps);
                    DATA.(ExpCondition_text).slopes = single(Slopes);
                    DATA.(ExpCondition_text).taus = single(tau);
                    DATA.(ExpCondition_text).epspPeaks = single(Peaks);
                    
                    end
                else
                    DATA.(ExpCondition_text).TraceAll = single(TraceAll);
                    DATA.(ExpCondition_text).nAclamp = nA;
                end
            end
        end

        folder_name = pwd;
        fileN = fileName{1};
        saveFilePostFix = sprintf('CLEANED_%s', fileN);
        cellName = split(fileN, '_');
        cellName = join(cellName(3:end), '_');

        DATA.NAME = cellName;
        DATA.expCondTested = condOrder;

        goodcell = input('Do you want to save this cell (y/n): ', 's');
        if strcmpi(goodcell, 'y')
            save(saveFilePostFix, 'DATA');
            disp(['Saved ' saveFilePostFix]);
        end
    end
end
