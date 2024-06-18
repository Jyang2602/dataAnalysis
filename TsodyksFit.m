function [coef, V, R1, r2]  =TsodyksFit(monoPeak,spikeTimes,synapseTaus,traceNorm,GUESS);
%FIRST RUN PPPQUANT (which currently only runs one trace)
%this will save a file call CurrentPPPData
%which will be used here

% GUESS=[0.5  100]; for @MARKRAMFITFUNCDEPONLY
% GUESS = [0.5, 10, 100]; %U, tauF, tauD
% GUESS = [0.2, 400, 400]; %U, tauF, tauD
% GUESS = [0.25, 50, 100]; %U, tauF, tauD
% GUESS = [0.05, 50, 100]; %U, tauF, tauD
% GUESS = [0.05, 1000, 10]; %U, tauF, tauD
% GUESS = [0.1, 500, 500]; %U, tauF, tauD
lb = [0.05, 0, 0];       % lower bound
ub = [0.95, 2000, 2000]; % upper bound
% FIT_METHOD = 'nlinfitDVB'; % see cases below for options
FIT_METHOD = 'nlinfitDVB'; % see cases below for options
FIT_REPETITIONS = 50;

peaks = monoPeak ./ monoPeak(1); % normalize to first
% peaks = monoPeak ./ max(monoPeak); % normalize to max

switch FIT_METHOD
    case 'nlinfitDVB'
        localGuess = GUESS;
        for fitInd = 1:FIT_REPETITIONS
            [coef, R1, J1] = nlinfitDVB(spikeTimes, peaks, @threeMarkram, localGuess);
            % nlm = fitnlm(spikeTimes, peaks, @threeMarkram, localGuess);
            
            %[coef, R1, J1] = nlinfit(spikeTimes', peaks', @threeMarkram, localGuess);


            fprintf('iter = %d, STP: U=%5.2f tauF=%5.2f tauD=%5.2f\n', fitInd, coef(1), coef(2), coef(3));
            coef = fixMarkram(coef);
            localGuess = coef;
            R1';
            % disp (sum(R1.^2))
            % disp(nlm)
        end
    case 'nlinfit'  % breaks because it tries to make parameters negative
        coef = nlinfit(spikeTimes, peaks', @threeMarkram, GUESS);
    case 'lsqcurvefit'  % doesn't work very well...
        options = optimoptions('lsqcurvefit');
        options.MaxFunctionEvaluations = 3000;
        coef = lsqcurvefit(@threeMarkram, GUESS, spikeTimes, peaks', lb, ub, options);
        coef = coef';
end
yMean = mean(peaks);
sst = sum((peaks-yMean).^2);

% disp(sst);

ssr = sum(R1.^2); 
r2 = 1-(ssr/sst);
r2_str = sprintf('R^2 = %.2f', r2);


coefFixed = fixMarkram(coef);

STP = threeMarkram(coefFixed, spikeTimes)';
fprintf('STP: U=%5.2f tauF=%5.2f tauD=%5.2f\n', coefFixed(1), coefFixed(2), coefFixed(3));
fprintf('R-squared (Goodness of Fit): %.4f\n', r2);
% disp(nlm)

% STP=MARKRAMFITFUNCDEPONLY(coef,spikeTimes)';
% fprintf('STP: U=%5.2f tauD=%5.2f\n',coef(1),coef(2));

%%% VOLTAGE %%%
spikecount = 0;
% tauEPSP = tau(1);

tauEPSP = median(synapseTaus);
v = 0;
for t = 1:length(traceNorm)

    spike = find(t == spikeTimes);

    if (~isempty(spike))
        spikecount = spikecount + 1;
        release = STP(spikecount);
    else
        release = 0;
    end

    V(t) = v + v / tauEPSP + release;
    v = V(t);
end


figure(2); clf;
plot(traceNorm)
hold on
plot(V, 'k', 'linewidth', [2])
title(r2_str, "FontSize",12, "FontWeight","bold");
for i = 1:length(spikeTimes)
    line([spikeTimes(i) spikeTimes(i)], ylim, 'LineStyle', ':', 'Color', [0.5 0.5 0.5]);
end



end

