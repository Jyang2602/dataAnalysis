function [params] = getUserInput(cellNumber)
    prompt = {'Early or Late:', 'ChR2, Pyr, Chrimson or Opsin Negative:', ...
              '6 or 12 Pulses of Stimulus:', 'Early or Late Training:', ...
              'Blue or Red Light Stimulus:'};
    dlgtitle = sprintf('Input for Cell %d', cellNumber);
    dims = [1 35];
    definput = {'early', 'ChR2', '6', 'trainingEarly', 'blue'};
    answer = inputdlg(prompt, dlgtitle, dims, definput);
    
    params.time = answer{1};
    params.cellType = answer{2};
    params.pulses = sprintf('pulses%s', answer{3});
    params.training = answer{4};
    params.light = answer{5};
end
