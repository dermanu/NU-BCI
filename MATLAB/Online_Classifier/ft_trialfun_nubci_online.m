function [trl, trlname, soldevent] = ft_trialfun_nubci_onine_2(cfg, soldevent)

% read the header information and the events from the data
event = cfg.event;

% determine the number of samples before and after the trigger
pretrig  = -round(cfg.trialdef.prestim  * cfg.hdr.Fs);
posttrig =  round(cfg.trialdef.poststim * cfg.hdr.Fs);

trl = [];
trlname = [];

if isempty(event) || event(end).sample == soldevent
    return;
    
elseif event(end).sample > soldevent
    soldevent = event(end).sample;
    
    if strcmp(event(end).type, cfg.trialdef.eventtype) && event(end).value == 1
        if event(end-1).value == 2 || event(end-1).value == 3 || event(end-1).value == 4
            trlbegin = event(end).sample + pretrig;
            trlend   = event(end).sample + posttrig-1;
            offset   = pretrig;
            trl   = [trlbegin trlend offset];
            speed = event(end-1).value;
            trlname = [trl speed];
        end
    end
end