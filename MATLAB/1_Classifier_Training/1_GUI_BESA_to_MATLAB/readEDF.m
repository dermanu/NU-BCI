clear all
close all

%addpath D:\emanu\OneDrive\NEVR_Thesis\Code\MATLAB\fieldtrip
addpath C:\Users\Emanuel\OneDrive\NEVR_Thesis\Code\MATLAB\fieldtrip
ft_defaults

cfg = [];
[cfg.name,path] = uigetfile('*.raw', 'Choose edf+ file');
cfg.dataset = strcat(path,cfg.name);

answer = questdlg('Choose the trial type you want to analyse:', ...
    'Trial type', ...
    '2s','3s','4s', '');
% Handle response
switch answer
    case '2s'
        cfg.speed = 1;
    case '3s'
        cfg.speed = 2;
    case '4s'
        cfg.speed = 3;
end
clear answer

cfg.trialfun              = 'ft_trialfun_nubci';
cfg.trialdef.eventtype    = 'trigger';
cfg.trialdef.eventvalue11 = {'200s' '300s' '400s'};
cfg.trialdef.eventvalue12 = 'stm+';
cfg.trialdef.eventvalue21 = 'stm-';
cfg.trialdef.prestim      = 2.0; % Prestimulus for filtering
cfg.trialdef.poststim     = 0.5; % Intervall should not be longer then 2s ms
cfg.randomOffMin          = 0.0;
cfg.randomOffMax          = 0.2; % No overlap up to 300 ms (for classifiction)
cfg.pre.prestim           = 1.500; % 1200 ms prestimuls for classifing
cfg.pre.poststim          = 0.200; % 200 ms poststimuls for classifing

cfg = ft_definetrial(cfg);
hdr = ft_read_header(cfg.dataset);

% Filter general setup
cfg.method = 'trial';
cfg.trials = 'all';

% Notch filter
cfg.dftfilter  = 'yes';
cfg.dftfreq    = [50 100 150 200];
cfg.dftreplace = 'zero';

% Bandpass filter
cfg.bpfilter       = 'yes';
cfg.bpfreq         = [1.8 20];
cfg.bpfiltord      = 12;
cfg.bpfilttype     = 'but';
cfg.bpfiltdir      = 'twopass';
cfg.instabilityfix = 'split';

% Rereferencing
cfg.channel   = 'EEG';
cfg.refmethod = 'avg';
cfg.refchan   = 'all';

% define pre and postimulus cut
cfg.pre.preDiff  = cfg.trialdef.prestim - cfg.pre.prestim;
cfg.pre.postDiff = cfg.trialdef.poststim - cfg.pre.poststim;

% convert into sampels
if exist('cfg.resampleFs', 'var')
    hdr.Fs = cfg.resampleFs;
else
    cfg.resampleFs = hdr.Fs;
end

cfg.pre.preDiffSamp  = round(cfg.pre.preDiff * cfg.resampleFs);
cfg.pre.postDiffSamp = round(cfg.pre.postDiff * cfg.resampleFs);
cfg.pre.prestimSamp  = round(cfg.pre.prestim  * cfg.resampleFs);
cfg.pre.poststimSamp = round(cfg.pre.poststim * cfg.resampleFs);


% these are for the data handling
count = 0;

% define a subset of channels for reading
cfg.channel = ft_channelselection(cfg.channel, hdr.label);
chanindx    = match_str(hdr.label, cfg.channel);

% Read channels using trial function
[cfg.trl, ~, cfg.trlname] = feval(cfg.trialfun, cfg);

for trllop=1:size(cfg.trl,1)  %go through all trails in the buffer
    begsample = cfg.trl(trllop,1);
    endsample = cfg.trl(trllop,2);
    offset    = cfg.trl(trllop,3);
    speed     = cfg.trlname(trllop,1);
    class     = cfg.trlname(trllop,2);
    
    if speed == cfg.speed
        % remember up to where the data was read
        count = count + 1;
        
        % read data segment from buffer
        dat(:,:,count) = ft_read_data(cfg.datafile, 'header', hdr, 'begsample', begsample, 'endsample', endsample, 'chanindx', chanindx, 'checkboundary', false);
        
        % Rereferencing data
        %datReref(:,:,count) = ft_preproc_rereference(dat(:,:,count), cfg.refchan, cfg.refmethod);
        
        
        % Filter data
        %procDat(:,:,count) = ft_preproc_dftfilter(datReref(:,:,count), hdr.Fs, cfg.dftfreq);
        %procDat(:,:,count) = ft_preproc_bandpassfilter(procDat(:,:,count), hdr.Fs, cfg.bpfreq, cfg.bpfiltord, cfg.bpfilttype, cfg.bpfiltdir, cfg.instabilityfix);
        
        % Cut data
        procDatCut(:,:,count) = dat(:, cfg.pre.preDiffSamp : end-cfg.pre.postDiffSamp, count);
        
        % Baseline correction ( is calculated with the data after collision
        % (stimulus end)
        %procDatCut(:,:,count) = ft_preproc_baselinecorrect(procDatCut(:,:,count), cfg.pre.prestimSamp, cfg.pre.prestimSamp+cfg.pre.poststimSamp);
        
        cfg.trlIdx(count) = trllop;
    end
end

% these are for the data handling
count      = 0;

for trllop=1:size(cfg.trl,1)  %go through all trails in the buffer
    begsample = cfg.trl(trllop,1);
    endsample = cfg.trl(trllop,2);
    offset    = cfg.trl(trllop,3);
    speed     = cfg.trlname(trllop,1);
    class     = cfg.trlname(trllop,2);
    
    if speed == 0
        % remember up to where the data was read
        count = count + 1;
        
        % read data segment from buffer
        datBad(:,:,count) = ft_read_data(cfg.datafile, 'header', hdr, 'begsample', begsample, 'endsample', endsample, 'chanindx', chanindx, 'checkboundary', false);
        
    end
end
clear procDat

nametmp  = split(cfg.dataset, '.');
name     = append(nametmp(1),'_Speed_',int2str(cfg.speed),'.mat');
save(name{1,1},'datBad')

app = Read_GUI(cfg, procDatCut, dat);
