clear all

epspMETA = struct();
% epsp12 = struct();
condition =[];
tracesToDelete = [];
keepTrace =[];
TraceAll = [];
keepPulse = [];
lightcolor =[];
tracesKept =[];


useCon = {'ABOVE_12RED','ABOVE_6RED', 'ABOVE_12BLUE', 'ABOVE_6BLUE'}

file = dir('Clean*.mat');
% file = dir('*.mat*');
% file = file(3:end);
numFiles = length(file);
L6indx=[];
L12indx=[];
E12indx = [];
pyrIndx = [];
ChR2Indx = [];

indx = 0;
for i = 1:numFiles
    filename = file(i).name;
    load(filename);
    epspMETA(i).sliceTraining = DATA.trainProtocol;
    if strcmpi (DATA.trainProtocol,'12EARLY')
        E12indx(end+1) = i;
    elseif strcmpi (DATA.trainProtocol,'12LATE')
        L12indx(end+1)=i;
    elseif strcmpi (DATA.trainProtocol,'6LATE')
        L6indx(end+1) = i;
    end

    % epspMETA(i).genDATA = DATA;
    epspMETA(i).name = DATA.NAME;
    epspMETA(i).cellType = DATA.cell1Type;
    if strcmpi(DATA.cell1Type, 'pyr')
        pyrIndx(end+1) = i;
    elseif strcmpi(DATA.cell1Type,'ChR2')
        ChR2Indx(end+1) = i;
    end

    epspMETA(i).drug = DATA.drug;
    if strcmp(DATA.drug,'yes')
        epspMETA(i).drugUsed= DATA.drugType;
        epspMETA(i).drugConc = DATA.drugConc;
    end
    epspMETA(i).DIV = DATA.DIV;
    epspMETA(i).trainDur= DATA.trainDur;

    names = fieldnames(DATA);
    numCons = length(useCon);
    numNames = length(names);

    profile on


    %finding how many times each condition was ran, pulling feild info from
    %each condition rep and renaming
    % for c = 1:numNames
    for p = 1:numCons
        matchFeilds = names(contains(names,useCon{p}));
        numOccur = numel(matchFeilds);
        % timer on
        if numOccur ==1
            data = DATA.(matchFeilds{1});
            conFields = fieldnames(data);
            for f = 1:length(conFields);
                fieldName = conFields{f};
                fieldValue = data.(fieldName);
                newName = [useCon{p},'_', '1',fieldName];
                % if contains(fieldName, 'TTL')
                %     r12TTL = 
                % newName = [useCon{p}, '_', (strcmp(fieldName, 'TTL') * '' + ~strcmp(fieldName, 'TTL') * '1'), '1',fieldName];
                if ~ismember(fieldName, {'TTL','Condition'}) && ~contains(fieldName, 'keepPulse')
                % if ~strcmp(fieldName, 'Condition') && ~contains(fieldName, 'keepPulse')
                % if strcmp(fieldName,'TTL')
                %     newName = strcat(useCon{p},'_',fieldName);
                %     % epspMETA(i).(newName) = fieldValue;
                % else
                %     newName = strcat(useCon{p},'_','1',fieldName);
                % end
                epspMETA(i).(newName) = single(fieldValue);
                end
            end

        else

            for o =1:numOccur

                data = DATA.(matchFeilds{o});
                conFields = fieldnames(data);
                % nonTTL = ~strcmp(conFields, 'TTL');
                % goodFields = conFields(nonTTL);
                for f = 1:length(conFields);
                    fieldName = conFields{f};
                    % if ~strcmp(fieldName,'TTL')
                    if ~ismember(fieldName, {'TTL','Condition'}) && ~contains(fieldName, 'keepPulse')

                        fieldValue = data.(fieldName);
                        newName = strcat(useCon{p},'_',num2str(o),fieldName);
                        epspMETA(i).(newName) = single(fieldValue);

                        if strcmp(fieldName,'keepTraceMean')
                            newNames = strcat(useCon{p},'_',fieldName,'combo');


                            if isfield(epspMETA(i), newNames)
                                epspMETA(i).(newNames){end+1}= single(fieldValue);
                            else
                                epspMETA(i).(newNames) = {fieldValue};
                            end
                        end
                    end
                end
            end
        end
        %
        % end
    end
end



%ChR2(+) Indexes for late6, late 12 and early 12
ChR2IndxL6 = intersect(ChR2Indx,L6indx);
ChR2IndxL12 = intersect(ChR2Indx, L12indx);
ChR2IndxE12 = intersect(ChR2Indx, E12indx);
%Opsin(-) indexes for late 6 late 12 and early 12
pyrIndxL6 = intersect(pyrIndx,L6indx);
pyrIndxL12 = intersect(pyrIndx, L12indx);
pyrIndxE12 = intersect(pyrIndx, E12indx);
%Early and Late 12 indexes for Opsin(-) cells
pyrE12L12 = intersect(pyrIndxE12,pyrIndxL12);
pyrL6L12 = intersect(pyrIndxL6, pyrIndxL12);

% %ChR2(+) indexes for early and late 12
% ChrE12L12 = intersect(ChR2IndxE12,ChR2IndxL12);
% ChrL6L12 = intersect(ChR2IndxL6, ChR2IndxL12);






% plotMeanTrace(epspMETA, pyrIndxL12,'Opsin (-) Late 12 ', 'ABOVE_6RED_1keepTraceMean');
% plotMeanTrace(epspMETA, pyrIndxE12, 'Opsin (-) Early12','ABOVE_6RED_1keepTraceMean');

% epspMETA(1).ChR2Late6 = ChR2IndxL6;
% epspMETA(1).ChR2Late12 = ChR2IndxL12;
% epspMETA(1).ChR2Early12 = ChR2IndxE12;

% save('epspMETA_fits.mat', 'epspMETA','-v7.3' )
% Save the epspMETA and all index variables
save('epspMETA_fits.mat', 'epspMETA', 'E12indx','L12indx','L6indx','ChR2IndxL6', 'ChR2IndxL12', 'ChR2IndxE12', 'pyrIndxL6', 'pyrIndxL12', 'pyrIndxE12',  '-v7.3');