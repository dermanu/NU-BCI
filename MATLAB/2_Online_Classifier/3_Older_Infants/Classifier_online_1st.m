clear all;
close all;

addpath C:\Users\NU-BCI\Documents\MATLAB\fieldtrip
ft_defaults

load('FilterMatrix.mat');
load('Classifier_Trained.mat');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Set all parameter and default configuration settings                       %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Stream settings
cfg          = [];
cfg.dataset  = 'buffer://localhost:1972';

% Documentation matrix
doc = [];

% Preprocessing matrix
pre = [];

%trail settings
cfg.trialfun              = 'ft_trialfun_nubci_online';

cfg.trialdef.eventtype    = 'T';
cfg.trialdef.eventvalue   = 1;
cfg.trialdef.prestim      = 2.000; % 2000 ms prestimuls for filtering (add 500 ms to assure good filtering)
cfg.trialdef.poststim     = 0.500; % 500 ms poststimulus for filtering (add 500 ms to assure good filtering)
cfg.pre.prestim           = 1.500; % 1200 ms prestimuls for classifing
cfg.pre.poststim          = 0.500; % 200 ms poststimuls for classifing

% Filter general setup
cfg.channel = 'all';    % to 'all' if not working
cfg.method  = 'trial';
cfg.trials  = 'all';

%Padding
cfg.padding = zeros(size(rawDat,1), 3000);

% Notch filter
cfg.dftfilter  = 'yes';
cfg.dftfreq    = [50 100 150];
cfg.dftreplace = 'zero';

% Bandpass filter
cfg.bpfilter       = 'yes';
cfg.bpfreq         = [1.8 25];
cfg.bpfiltord      = 4;
cfg.bpfilttype     = 'but';
cfg.bpfiltdir      = 'twopass';
cfg.instabilityfix = 'split';

% Rerefernce data
cfg.refmethod = 'avg';
cfg.refchan = 'all';

% Artifact correction based on threshold in uV
cfg.costumRej.artfMax = 120;
cfg.costumRej.artfMin = 0.001;

% Artifact correction based on z-value
cfg.costumRej.zThreshold = 19; % see fieldtrip for values
cfg.costumRej.badElcRej  = 13; % if more then 10% of electrodes are bad reject trial

% Settings LDA beamformer
beam = [];

% Setting feature extraction
feat = [];
feat.nulling       = 0.40;
feat.refCh         = [41:49 53 54]; %
feat.peakBeg       = -0.400; % Set to 12 month old infants ERP
feat.peakEnd       = -1.250;
feat.fractionalLat = 50; % fractional area latency in percent
feat.fractionalOn  = 25;
feat.fractionalOff = 75;
feat.minPeakWidth  = 0.11;

% Define pre and postimulus cut
cfg.pre.preDiff  = cfg.trialdef.prestim - cfg.pre.prestim;
cfg.pre.postDiff = cfg.trialdef.poststim - cfg.pre.poststim;

% Convert into sampels
feat.offsetSamp      = round(cfg.pre.prestim * cfg.resampleFs);
cfg.pre.preDiffSamp  = round(cfg.pre.preDiff * cfg.resampleFs);
cfg.pre.postDiffSamp = round(cfg.pre.postDiff * cfg.resampleFs);
feat.peakBegSamp     = round(feat.peakBeg * cfg.resampleFs);
feat.peakEndSamp     = round(feat.peakEnd * cfg.resampleFs);
cfg.pre.prestimSamp  = round(cfg.pre.prestim * cfg.resampleFs);
cfg.pre.poststimSamp = round(cfg.pre.poststim * cfg.resampleFs);


% Define event that is writen to BCI2000 (might be chanced to event?)
% event_Result send information about the artifact correction a
% classification to BCI2000
event_Result.type     = 'E';
event_Result.sample   = 1;
event_Result.offset   = 0;
event_Result.duration = 1;

event_detected = event_Result;
event_detected.value = 9;

event_notDetected = event_Result;
event_notDetected.value = 8;

event_threshold  = event_Result;
event_threshold.value = 7;

event_zScore = event_Result;
event_zScore.value = 6;

event_artifact = event_Result;
event_artifact.value = 5;

%event_matlabReady tells BCI2000 that this Matlab script is running
Mevent.type     = 'M';
Mevent.sample   = 1;
Mevent.offset   = 0;
Mevent.duration = 1;

event_matlabReady = Mevent;
event_matlabReady.value = 1;

% set the default configuration options
if ~isfield(cfg, 'dataformat'),     cfg.dataformat = [];      end % default is detected automatically
if ~isfield(cfg, 'headerformat'),   cfg.headerformat = [];    end % default is detected automatically
if ~isfield(cfg, 'eventformat'),    cfg.eventformat = [];     end % default is detected automatically
if ~isfield(cfg, 'channel'),        cfg.channel = 'all';      end % channels are choosen in BCI2000 to minimize computation
if ~isfield(cfg, 'bufferdata'),     cfg.bufferdata = 'last';  end % first or last

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Check connection with BCI2000                                              %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Tell BCI2000 that Matlab is ready
ft_write_event(cfg.dataset, event_matlabReady);

% Wait till E-Prime starts
fprintf('Waiting for stimulus sequence to start...\n')
cfg.event = ft_read_event(cfg.dataset);

while isempty(cfg.event)
    cfg.event = ft_read_event(cfg.dataset);
    continue;
end
while ~(strcmp(cfg.event(end).type,'R') && cfg.event(end).value == 1)
    % Wait until BCI2000 is ready. The eventtype might have to be defined
    cfg.event = ft_read_event(cfg.dataset);
    continue;
end
fprintf('Ready\n');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Read header and set parameters according to read out                       %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% translate dataset into datafile+headerfile
cfg = ft_checkconfig(cfg, 'dataset2files', 'yes');
cfg = ft_checkconfig(cfg, 'required', {'datafile' 'headerfile'});

% ensure that the persistent variables related to caching are cleared
clear read_header
% start by reading the header from the realtime buffer
hdr = ft_read_header(cfg.headerfile, 'cache', true);

% define a subset of channels for reading
cfg.channel = ft_channelselection(cfg.channel, hdr.label);
chanindx   = 1:hdr.nChans;

% define pre and postimulus cut
cfg.pre.preDiff  = cfg.trialdef.prestim - cfg.pre.prestim;
cfg.pre.postDiff = cfg.trialdef.poststim - cfg.pre.poststim;

% convert into sampels
if exist('cfg.resampleFs', 'var')
    feat.offsetSamp      = round(cfg.pre.prestim * cfg.resampleFs);
    cfg.pre.preDiffSamp  = round(cfg.pre.preDiff * cfg.resampleFs);
    cfg.pre.postDiffSamp = round(cfg.pre.postDiff * cfg.resampleFs);
    feat.peakBegSamp     = round(feat.peakBeg * cfg.resampleFs);
    feat.peakEndSamp     = round(feat.peakEnd * cfg.resampleFs);
    cfg.pre.prestimSamp  = round(cfg.pre.prestim * cfg.resampleFs);
    cfg.pre.poststimSamp = round(cfg.pre.poststim * cfg.resampleFs);
else
    cfg.resampleFs = hdr.Fs;
    feat.offsetSamp = round(cfg.pre.prestim * hdr.Fs);
    cfg.pre.preDiffSamp  = round(cfg.pre.preDiff * hdr.Fs);
    cfg.pre.postDiffSamp = round(cfg.pre.postDiff * hdr.Fs);
    feat.peakBegSamp  = round(feat.peakBeg * hdr.Fs);
    feat.peakEndSamp = round(feat.peakEnd * hdr.Fs);
    cfg.pre.prestimSamp  = round(cfg.pre.prestim * hdr.Fs);
    cfg.pre.poststimSamp = round(cfg.pre.poststim * hdr.Fs);
end

% these are for the data handling
prevSample = 0;
count      = 0;
soldevent  = 0;
whileState = true;

% Set timer variables
tRead(1)     = 0;
tArti(1)     = 0;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% this is the general BCI loop where realtime incoming data is handled       %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
while whileState
    % determine latest header and event information
    cfg.event = ft_read_event(cfg.dataset);
    cfg.hdr = hdr;
    
    % lets the loop run until the stimulus presentation is ended
    if ~isempty(cfg.event)
        whileState = ~(strcmp(cfg.event(end).type,'R') && cfg.event(end).value == 0);
    end
    
    % evaluate the trialfun, note that the trialfun should not re-read the events and header
    [trl, trlname, soldevent] = feval(cfg.trialfun, cfg, soldevent);
    
    if isempty(trl)
        % Skips the loop until a trial is detected
        continue;
    else
        fprintf('Trail detected and processed.\n')
    end
    
    for trllop=1:size(trl,1)  %go through all trails in the buffer
        if ~isempty(trl)
            begsample = trl(trllop,1);
            endsample = trl(trllop,2);
            offset    = trl(trllop,3);
            trl = [];
            
            % remember up to where the data was read
            prevSample  = endsample;
            count       = count + 1;
            plotCount(count) = count;
            fprintf('Processing segment %d from sample %d to %d\n', count, begsample, endsample);
            
            % Give buffer to get post-stimulus samples
            pause(cfg.trialdef.poststim)
            
            % Timing of reading data
            tic;
            
            % read data segment from buffer
            dato = ft_read_data(cfg.dataset, 'header', cfg.hdr, 'begsample', begsample, 'endsample', endsample, 'chanindx', chanindx, 'checkboundary', true);
            
            % keep track of the read timing
            tRead(end+1) = toc * 1000;
            fprintf('Read of last trail took %5.2f ms.\n', tRead(end));
            
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            %% from here onward it is specific to the preprocessing of the data           %%
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            % Timing of artifact detection
            tic;
            
            % Rereferencing data (needed)
            dat = ft_preproc_rereference(dato, cfg.refchan, cfg.refmethod);
            
            % Filter data
            procDat = ft_preproc_dftfilter(dat, hdr.Fs, cfg.dftfreq);
            procDat = ft_preproc_bandpassfilter(procDat, hdr.Fs, cfg.bpfreq, cfg.bpfiltord, cfg.bpfilttype, cfg.bpfiltdir, cfg.instabilityfix);
            
            % Cut data
            procDat = procDat(:, cfg.pre.preDiffSamp : end-cfg.pre.postDiffSamp);
            
            % Baseline correction
            procDat = ft_preproc_baselinecorrect(procDat, cfg.pre.prestimSamp, cfg.pre.prestimSamp+cfg.pre.poststimSamp);
            
            % Artifact rejection based on maximum and minimum threshold.
            for i = 1:size(procDat,1)
                % looks for 3 or more consecutive samples bellow the minimum threshold
                idx = abs(procDat(i,:)) < cfg.costumRej.artfMin;
                lowBeg = strfind([0 idx 0],[0 1]);
                lowEnd = strfind([0 idx 0],[1 0])-1;
                low = (lowEnd-lowBeg+1) >= 3;
                
                if any(abs(procDat(i,:)) > cfg.costumRej.artfMax) || any(low)
                    doc.threshold(count,i) = 1; %%Trailstate saves if a trial and channel was ignored or not
                else
                    doc.threshold(count,i) = 0;
                end
            end
            
            % Artifact rejection based on z-transformed data
            doc.zScore(count,1) = zValue(cfg.costumRej.zThreshold, procDat);
            
            % Documentation and output of artifact rejection results
            if nnz(doc.threshold(count,:)) > cfg.costumRej.badElcRej && any(doc.zScore(count,1))
                plotValue(count) = -3;
                event_artifact.sample = endsample + 1;
                ft_write_event(cfg.dataset, event_artifact);
            elseif any(doc.threshold(count,:))
                plotValue(count) = -1;
                event_threshold.sample = endsample + 1;
                ft_write_event(cfg.dataset, event_threshold);
            elseif any(doc.zScore(count,1))
                plotValue(count) = -2;
                event_zScore.sample = endsample + 1;
                ft_write_event(cfg.dataset, event_zScore);
            else
                plotValue(count) = 0;
            end
            
            % keep artifact detection of the read timing
            tArti(end+1) = toc * 1000;
            fprintf('Artifact detection of last trail took %5.2f ms.\n', tArti(end));
            
            if nnz(doc.threshold(count,:)) > cfg.costumRej.badElcRej || any(doc.zScore(count,1))   %% if more then 9 channels are bad, then reject
                fprintf('Recjected trial %d from sample %d to %d due to artifacts.\n', count, begsample, endsample);
                continue
            end
            
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            %% Spatial Filtering                                                          %%
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            
            spatDatAll = diySpatialFilter(train.score{1,1}, procDat(1:128,:));
            spatDatOcc = diySpatialFilter(train.score{1,2}, procDat(62:102,:));
            spatDatTemp = diySpatialFilter(train.score{1,3}, procDat(30:62,:));
            
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            %% Feature extraction
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            %%All
            DWTspatDat = [spatDatAll cfg.padding(1,:)];
            
            [c,l] = wavedec(DWTspatDat,6,'bior2.2');
            Delta = appcoef(c,l,'bior2.2');
            Delta = Delta(2:17);
            All(1)      = min(Delta);
            All(2)    = (1/size(Delta,2)) * sum(Delta).^2;
            
            [c,l] = wavedec(DWTspatDat,6,'bior4.4');
            Delta = appcoef(c,l,'bior4.4');
            [~,~,Theta] = detcoef(c,l,[4 5 6]);
            Delta = Delta(2:17);
            Theta = Theta(2:16);
            All(3)  = (1/size(Delta,2)) * sum(Delta).^2;
            All(4)  = mean(Theta);
            All(5)  = min(Theta);
            
            [c,l] = wavedec(DWTspatDat,6,'sym6');
            [~,~,Theta] = detcoef(c,l,[4 5 6]);
            Theta = Theta(2:16);
            All(6)  = median(Theta);
            
            [c,l] = wavedec(DWTspatDat,6,'db4');
            [~,~,Theta] = detcoef(c,l,[4 5 6]);
            Theta = Theta(2:16);
            All(7)  = median(Theta);
            All(8)  = (1/size(Theta,2)) * sum(Theta).^2;
            
            %%Occ
            spatDatOccERP = spatDatOcc(:, (feat.offsetSamp + feat.peakEndSamp)+1 : (feat.offsetSamp + feat.peakBegSamp));
            
            Occ(1)  = rms(spatDatOccERP);
            Occ(2) = length(find([0 diff(sign(spatDatOccERP))]~=0));
            Occ(3) = (max(spatDatOccERP) - min(spatDatOccERP)) / std(spatDatOccERP);
            
            [~, ~, ~, Occ(4)] = findpeaks(-spatDatOcc, cfg.resampleFs, 'MinPeakWidth', feat.minPeakWidth, 'SortStr', 'descend', 'NPeaks', 1);
            if isempty(Occ(4))
                [~, ~, ~, Occ(4)] = findpeaks(-spatDatOcc, cfg.resampleFs, 'SortStr', 'descend', 'NPeaks', 1);
            end
            if isempty(Occ(4))
                Occ(4) = 0;
            end
            
            spatDatFilt  = ft_preproc_bandpassfilter(spatDatOcc, cfg.resampleFs, [3 7], cfg.bpfiltord, cfg.bpfilttype, cfg.bpfiltdir, cfg.instabilityfix);
            phaseDatStim = hilbert(spatDatOcc);
            phaseDatStim = angle(spatDatOcc);
            phaseDatRef = spatDatAll(feat.refCh,:);
            phaseDatRef = exp(1j*phaseDatRef);
            phaseDatRef = mean(phaseDatRef,1);
            phaseDatRef = angle(phaseDatRef);
            Occ(5) = std(phaseDatStim - phaseDatRef);
            
            DWTspatDat = [spatDatOcc cfg.padding(1,:)];
            
            [c,l] = wavedec(DWTspatDat,6,'bior2.2');
            Delta = appcoef(c,l,'bior2.2');
            [~,Alpha,Theta] = detcoef(c,l,[4 5 6]);
            Delta = Delta(2:17);
            Theta = Theta(2:16);
            Alpha = Alpha(2:29);
            Occ(6)  = max(Delta);
            Occ(7)  = var(Theta);
            Occ(8)  = median(Alpha);
            Occ(9)  = min(Alpha);
            Occ(10) = max(Alpha);
            Occ(11) = entropy(Alpha/max(abs(Alpha)));
            
            [c,l] = wavedec(DWTspatDat,6,'bior4.4');
            Delta = appcoef(c,l,'bior2.2');
            Delta = Delta(2:17);
            Occ(12) = max(Delta);
            
            [c,l] = wavedec(DWTspatDat,6,'sym6');
            [BetaGamma,Alpha,~] = detcoef(c,l,[4 5 6]);
            BetaGamma = BetaGamma(2:55);
            Alpha = Alpha(2:29);
            Occ(13) = (1/size(Alpha,2)) * sum(((Alpha-mean(Alpha)) ./ std(Alpha)).^4-3);
            Occ(14) = min(BetaGamma);
            
            [c,l] = wavedec(DWTspatDat,6,'db4');
            [~,Alpha,Theta] = detcoef(c,l,[4 5 6]);
            Alpha = Alpha(2:29);
            Theta = Theta(2:16);
            Occ(15)   = var(Theta);
            Occ(16) = (1/size(Theta,2)) * sum(Theta).^2;
            Occ(17)  = mean(Alpha);
            
            %% Temporal
            spatDatTempERP = spatDatTemp(:, (feat.offsetSamp + feat.peakEndSamp)+1 : (feat.offsetSamp + feat.peakBegSamp));
            
            Temp(1) = max(spatDatTempERP)
            
            [~, Temp(2), ~, ~] = findpeaks(-spatDatTemp, cfg.resampleFs, 'MinPeakWidth', feat.minPeakWidth, 'SortStr', 'descend', 'NPeaks', 1);
            if isempty(Temp(2))
                [~, Temp(2), ~, ~] = findpeaks(-spatDatTemp, cfg.resampleFs, 'SortStr', 'descend', 'NPeaks', 1);
            end
            if isempty(Temp(2))
                Temp(2)  = 0;
            end
            
            DWTspatDat = [spatDatTemp cfg.padding(1,:)];
            
            [c,l] = wavedec(DWTspatDat,6,'bior4.4');
            [BetaGamma,Alpha,Theta] = detcoef(c,l,[4 5 6]);
            Theta = Theta(2:16);
            Alpha = Alpha(2:29);
            BetaGamma = BetaGamma(2:55);
            Temp(3) = median(Theta);
            Temp(4) = min(Alpha);
            Temp(5) = max(Alpha);
            Temp(6) = (1/size(BetaGamma,2)) * sum(((BetaGamma-mean(BetaGamma)) ./ std(BetaGamma)).^4-3);
            
            [c,l] = wavedec(DWTspatDat,6,'sym6');
            [BetaGamma,~,Theta] = detcoef(c,l,[4 5 6]);
            Theta = Theta(2:16);
            BetaGamma = BetaGamma(2:55);
            Temp(7) = min(Theta);
            Temp(8) = mean(BetaGamma);
            
            [c,l] = wavedec(DWTspatDat,6,'db4');
            [BetaGamma,~,Theta] = detcoef(c,l,[4 5 6]);
            Theta = Theta(2:16);
            BetaGamma = BetaGamma(2:55);
            Temp(9)  = entropy(Theta/max(abs(Theta)));
            Temp(10)  = entropy(BetaGamma/max(abs(BetaGamma)));
            
            %%Difference

            [c,l] = wavedec(DWTspatDat,6,'bior2.2');
            [~,Alpha,~] = detcoef(c,l,[4 5 6]);
            Alpha = Alpha(2:29);
            Diff(1) = min(Alpha);
            
            [c,l] = wavedec(DWTspatDat,6,'sym6');
            [BetaGamma,Alpha,~] = detcoef(c,l,[4 5 6]);
            Alpha = Alpha(2:29);
            BetaGamma = BetaGamma(2:55);
            Diff(2) = (1/size(Alpha,2)) * sum(((Alpha-mean(Alpha)) ./ std(Alpha)).^4-3);
            Diff(3) = min(BetaGamma);
            
            [c,l] = wavedec(DWTspatDat,6,'db4');
            [~,Alpha,~] = detcoef(c,l,[4 5 6]);
            Alpha = Alpha(2:29);
            Diff(4) = mean(Alpha);
            
            Diff(1) = Occ(9)  - Diff(1);
            Diff(2) = Occ(13) - Diff(2);
            Diff(3) = Occ(14) - Diff(3);
            Diff(4) = Occ(17) - Diff(4);
            
            features = [All Occ Temp Diff];
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            % Classification
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            
            %%LDA classifier
            [lable, ~] = predict(classificationDiscriminant, features);
            
            if lable == 1
                plotValue(count) = 1;
                ft_write_event(cfg.dataset, event_detected);  
            elseif lable == 3
                plotValue(count) = 2;
                ft_write_event(cfg.dataset, event_notDetected);   
            end
                        
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            %% from here documentation and plotting                                       %%
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            
            figure(1);
            yNames = {' ', 'Artifact (Thres/Z)', 'Artifact (Z-value)', 'Artifact (Threshold)', 'No loom detected', 'Loom detected', ' '};
            plot(plotCount,plotValue, 'Marker', '*', 'LineStyle', 'none')
            set(gca,'ytick', (-4):2, 'yticklabel', yNames, 'YAxisLocation','right');
            xlabel('Trial number');
            ylim([-4 2])
            xlim([count-10 count+1])
            drawnow          
            
            clear All Occ Temp Diff
        end
    end % of for-loop
    if length(cfg.event) > 25 && strcmp(cfg.event(end).type, 'T') && ~cfg.event(end).value == 1
        ft_flush_event(cfg.dataset);
    end
    % ft_flush_event(cfg.dataset);
end % while true
fprintf('Stimulus sequence ended. Recording was stopped.');
%% save array (tarti, tread)