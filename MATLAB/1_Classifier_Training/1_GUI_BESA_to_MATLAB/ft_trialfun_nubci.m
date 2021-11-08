function [trl, event, trlname] = ft_trialfun_nubci(cfg)
% Function to extract trials from raw-Besa files for looming stimulus of
% NU-Lab. 
% It first finds the trails marks them according to their looming speed and then
% extracts the EEG around stimulus end (collision). 
%
% You would use this function as follows
%   cfg              = [];   
%   cfg.dataset      = string, containing filename or directory
%   cfg.trialfun     = 'ft_trialfun_example1';
%   cfg.randomOffMin = int, time in ms for minimum offset for class 0;
%   cfg.randomOffMax = int, time in ms for maximum offset for class 0;
%   cfg              = definetrial(cfg);
%   data             = preprocessing(cfg);
%
% See also FT_DEFINETRIAL, FT_PREPROCESSING

% read the header information and the events from the data
hdr   = ft_read_header(cfg.dataset);
event = ft_read_event(cfg.dataset);

j = 0;
for i = 1:length(event)
    % search for "annotation" events
    if strcmp(cfg.trialdef.eventtype, event(i).type)
        % search for stimulus end trigger and extract the looming speed
        % from the previous start trigger
        if any(strcmp(cfg.trialdef.eventvalue21, event(i).value)) && any(strcmp(cfg.trialdef.eventvalue12, event(i-1).value)) && any(strcmp(cfg.trialdef.eventvalue11, event(i-2).value))
            j = j+1;
            sample(j,1) = event(i).sample;
            if strcmp(cfg.trialdef.eventvalue11(1), event(i-2).value)
                sample(j,2) = 1;
            elseif strcmp(cfg.trialdef.eventvalue11(2), event(i-2).value)
                sample(j,2) = 2;
            elseif strcmp(cfg.trialdef.eventvalue11(3), event(i-2).value)
                sample(j,2) = 3;
            end
        end
    end
end

% determine the number of samples before and after the trigger
pretrig  = -round(cfg.trialdef.prestim  * hdr.Fs);
posttrig =  round(cfg.trialdef.poststim * hdr.Fs);

trlname = [];
trl = [];

for j = 1:(length(sample) - 1) %% ingnoring last trial as it can be incomplet
   % Saves looming-realated EEG 
    trlbegin = sample(j,1) + pretrig;       
    trlend   = sample(j,1) + posttrig;       
    offset   = pretrig;
    class    = 1;
    speed    = sample(j,2);
    newtrl   = [trlbegin trlend offset];
    trl      = [trl; newtrl];
    newtrlname = [speed class];
    trlname  = [trlname; newtrlname];
   
    % Generates an random offset
    randomOffset = round(((cfg.randomOffMax-cfg.randomOffMin)*rand() + cfg.randomOffMin) * hdr.Fs);
    
    % Saves non-looming EEG - Adds therefore a random offset to the stimulus end trigger
    trlbegin = sample(j,1) + randomOffset; % adds some random offset  
    trlend   = sample(j,1) + posttrig - pretrig + randomOffset; % adds some random offset
    offset   = pretrig;
    class    = 0;
    speed    = 0;
    newtrl   = [trlbegin trlend offset];
    trl      = [trl; newtrl];
    newtrlname = [speed class];
    trlname  = [trlname; newtrlname];
end

