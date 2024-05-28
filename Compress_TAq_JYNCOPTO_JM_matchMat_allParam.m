%%% Compress TAq data acquired for Jeffrey's Optogenetic training
%%% experiments
%%% Based on Compress_TAq1 and CompressTAq
%%% Modified 120722
% 
clear all
close all

repeat = 0;

CondLabels = {"EXCITABILITY", "ABOVE 12BLUE", "ABOVE 12RED", "TRAIN ALTERNATE B/R", "TRAIN RED FIRST", "ABOVE 6RED" "TRAIN BLUE FIRST", "6 RED PULSE"};
ExpCond = [];
Condition = [];
stimStrings = {'12LATE', '12EARLY', '6LATE', '6EARLY'};
SAVE = 1;

while repeat == 0
    % [fName, matDir] = uigetfile({'*.mat', 'mat files(*.mat)'}, ...
    % 'Choose a file to load');
    cell = input(('Which cell?-> '), 's');    %THE CELL TO COMPRESS
    str = sprintf('%s*.mat', cell);
    Files = dir(str);
    if ~isempty(Files)
        repeat = 1;
    else
        disp (['No files found for cell ' cell]);
    end
end


% SORT BY DATE/TIME SO THAT THEY ARE READ IN ORDER
s = [Files(:).datenum].';
[dumy, ind] = sort(s);
Filenames =  {Files(:).name}; % Cell array of names in order by datenum.
sorted_filenames = Filenames(ind);

%% Visualize first 5 files of excitability?
hold on
for i = 1:5
    data = load(sorted_filenames{i});
    plot(data.data')
end
hold off
samplingRate = (data.p.AI_SR);
sampleRate = (1/samplingRate)*1000; %% dt in mS;

disp(Filenames)

%INPUT EXPERIMENT INFORMATION
DIV=input('How many days in vitro for slice-> ');
transDur = input('When was slice transfected —> ');
transfectedVirus = input('What virus was transfected? Ex: ChR2/Chrim', 's');
stimulated = input('Was this slice chronically stimulated yes/no = ','s');
drug = input('Was drug used for these trials? yes/no ', 's');
if strcmp(drug,'yes')
    drugType = input('What drug was used?','s');
    drugConc = input('Input concentration of drug, if more than one drug used enter concentrations in order of drugType', 's');
end

FLAG = false;


if strcmp(stimulated,'yes') == 1
    while ~ FLAG
        stimProtocol = input('What was the stim protocol? Enter:  12LATE, 12EARLY,  6LATE,  6EARLY ','s'); %EARLYPOST or LATEPOST
        str1=stimProtocol;
        if any(strcmp(stimProtocol, stimStrings))
            FLAG = true;
        else
            disp('Invalid stimProtocol. Please enter one of the following:')
            disp(stimStrings);
        end
    

    end
    trainDur = input("How long was the slice trained for: (hrs)");
    else
        str1 = 'non stimulated';
    
end

cell1Type = input("Enter the type of cell this recording was made from: 'Pyr', 'ChR2', 'Chrim, Inh'", 's');
% restMemb = input("Enter the resting membrane potential : ");


excitIntens = str2num(input('Input excitability intensities;  ex [-.1 .05 .1 .15 .2 .3 -.1 -.1 -.1 -.1]', 's'));


CondCount = 0;
tracecount = 0;
cond = 1; prevcond = -99;
CH2_check = false;

for j=1:size(sorted_filenames,2)
    file = sorted_filenames{j};
    fprintf('Reading %s.\n', file);
    load(file);
    % condition
    pts = strfind(file,'.');
    cond = str2double(file(pts(2)+1:pts(3)-1));
    if cond~=prevcond       %detect change in conditions (e.g., Excit(#2) to Caged(#6)
        CondCount = CondCount+1;
        prevcond = cond;
        tracecount = 0;
        ExpCond(end + 1) = cond;


    end
    tracecount = tracecount + 1;
    if (size(data, 1) == 2)
        CH1{CondCount}(tracecount,:)=10*data(1, :);
        CH2{CondCount}(tracecount,:)=10*data(2, :);
        CH2_check = true;
    end %%This 10 factor scales the data and places the units in mV.(really *1000/100; 100 = gain)
end


for j=1:CondCount

    % figure
    % imagesc(CH1{j})
    if ExpCond(j) ==1
        condOrder{j} = 'EXC_';
        plot(CH1{j}');
        disp('Enter info for condition:')
        disp(condOrder{j})
        nAclamp{j} = input("Enter current in nA, if none enter 0: ");
    elseif ExpCond(j) == 2
        condOrder{j} = 'ABOVE_12BLUE';
        plot(CH1{j}');
        disp('Enter info for condition:')
        disp(condOrder{j})
        condInten{j} = input(sprintf('For condition %s, what was the light intensity of the stimulus in mA? ', condOrder{j}), 's');
        if strcmp(drug,'yes')
        drugTrial{j} = input("was there drug active for this condition? yes/no", 's');
        end
        nAclamp{j} = input("Enter current in nA, if none enter 0: ");
    elseif ExpCond(j) == 3
        condOrder{j} = 'ABOVE_12RED';
        plot(CH1{j}');
        disp('Enter info for condition:')
        disp(condOrder{j})
        condInten{j} = input(sprintf('For condition %s, what was the light intensity of the stimulus in mA? ', condOrder{j}), 's');
        if strcmp(drug,'yes')
        drugTrial{j} = input("was there drug active for this condition? yes/no", 's');
        end
        nAclamp{j} = input("Enter current in nA, if none enter 0: ");
    elseif ExpCond(j) == 6
        condOrder{j} = 'ABOVE_6RED';
        plot(CH1{j}');
        disp('Enter info for condition:')
        disp(condOrder{j})
        condInten{j} = input(sprintf('For condition %s, what was the light intensity of the stimulus in mA? ', condOrder{j}), 's');
        if strcmp(drug,'yes')
        drugTrial{j} = input("was there drug active for this condition? yes/no", 's');
        end
        nAclamp{j} = input("Enter current in nA, if none enter 0: ");
    elseif ExpCond(j) ==7
        condOrder{j} = 'ABOVE_6BLUE';
        plot(CH1{j}');
        disp('Enter info for condition:')
        disp(condOrder{j})
        condInten{j} = input(sprintf('For condition %s, what was the light intensity of the stimulus in mA? ', condOrder{j}), 's');
        if strcmp(drug,'yes')
        drugTrial{j} = input("was there drug active for this condition? yes/no", 's');
        end
        nAclamp{j} = input("Enter current in nA, if none enter 0: ");
    end
end

% end
samplingRate = (p.AI_SR);
sampleRate(CondCount) = (1/samplingRate)*1000; %% dt in mS;
% str2 = fileN
Dir = pwd;
slashes = strfind(Dir,'\'); % '\' for pc
Dir = Dir(slashes(end)+1:end);
SaveFilePrefix = sprintf('COMPILED_%s_%s_%s.mat',str1, Dir, cell);
clearvars -except SaveFile stimProtocol drug condInten CH2 CH1 excitIntens...
    cell1Type trainDur drugConc drugType transfectedVirus transDur DIV ...
    sampleRate cell Dir stimulated condOrder p drugTrial nAclamp SaveFilePrefix
save(SaveFilePrefix)
% if (CH2_check)
%     save(SaveFile, 'DIV', 'transfectedVirus', 'transDur', 'stimProtocol', 'cell1Type', 'drug', 'drugType', 'drugConc', 'CH1', 'CH2' ,...
%         'transfectedVirus', 'condOrder', 'condInten',  'stimulated', 'sampleRate', 'p','cell');
% else
%     save(SaveFile, 'DIV', 'transfectedVirus', 'transDur', 'stimProtocol', 'cell1Type', 'drug', 'drugType', 'drugConc', 'CH1' ,...
%         'transfectedVirus', 'condOrder', 'condInten',  'stimulated', 'sampleRate', 'p','cell');
% end

% if (CH2_check)
%     save(SaveFile,'CH1', 'CH2' ,'DIV','transDur', 'transfectedVirus', 'condInten', 'ExpCond', 'stimulated', 'p','cell');
% else
%     save(SaveFile,'CH1' ,'DIV','transDur', 'transfectedVirus', 'CondInten', 'CondLabels', 'ExpCond','stimulated', 'p','cell');
% end





