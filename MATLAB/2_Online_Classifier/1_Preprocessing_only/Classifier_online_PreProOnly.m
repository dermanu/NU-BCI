clear all;
close all;

addpath C:\Users\NU-BCI\Documents\MATLAB\fieldtrip
ft_defaults

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Set all parameter and default configuration settings
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
cfg.trialdef.prestim      = 1.500; % 1500 ms prestimuls for filtering (add 500 ms to assure good filtering)
cfg.trialdef.poststim     = 0.500; % 500 ms poststimulus for filtering (add 500 ms to assure good filtering)
cfg.pre.prestim           = 1.200; % 1200 ms prestimuls for classifing 
cfg.pre.poststim          = 0.500; % 200 ms poststimuls for classifing

% Filter general setup 
cfg.channel = 'all';    % to 'all' if not working
cfg.method  = 'trial';
cfg.trials  = 'all';

% Resmaple data
%cfg.resampleFs      = 500;
%cfg.resampleMethod  = 'resample';

% Notch filter
cfg.dftfilter  = 'yes';
cfg.dftfreq    = [50 100 150];
cfg.dftreplace = 'zero';

% Bandpass filter
cfg.bpfilter       = 'yes';
cfg.bpfreq         = [3 20];
cfg.bpfiltord      = 4;
cfg.bpfilttype     = 'but';
cfg.bpfiltdir      = 'twopass';
cfg.instabilityfix = 'split';

% Rerefernce data
cfg.refmethod = 'avg';
cfg.refchan = 'all';

% Artifact correction based on threshold in uV
cfg.costumRej.artfMax = 1.200;
cfg.costumRej.artfMin = 0.001;

% Artifact correction based on z-value
cfg.costumRej.zThreshold = 10; % see fieldtrip for values
cfg.costumRej.badElcRej  = 13; % if more then 10% of electrodes are bad reject trial 

% Settings LDA beamformer
beam = [];

% Setting feature extraction
feat = [];
feat.refCh         = [41:49 53 54]; % ?
feat.peakBeg       = -0.450; % Set to 12 month old infants ERP
feat.peakEnd       = -0.850;
feat.fractionalLat = 50; % fractional area latency in percent
feat.fractionalOn  = 25;
feat.fractionalOff = 75;

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
%% Check connection with BCI2000
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
%% Read header and set parameters according to read out
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
%% this is the general BCI loop where realtime incoming data is handled
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
 
  %start timer for read speed 
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
    %% from here onward it is specific to the preprocessing of the data
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Feature ideas:
    %   * Use Multiscale Principal Component Analysis (MSPCA) for denoising
    %     instead of filtering
    %   * Use PCA/ICA to exclude artifacts       
    %   * Use EOG electrodes to exclude artifacts
    %   * https://www.ncbi.nlm.nih.gov/pmc/articles/PMC4105585/
    %
    
    % Timing of artifact detection
    tic;
    
    % Resampling data for better performance (filter properties?)
      %dat = ft_preproc_resample(dat, hdr.Fs, cfg.resampleFs, cfg.resampleMethod);
      %hdr.Fs = cfg.resampleFs;
      
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
    
    figure(2);
    yNames = {' ', 'Artifact (Thres/Z)', 'Artifact (Z-value)', 'Artifact (Threshold)', 'No loom detected', 'Loom detected', ' '};
    plot(plotCount,plotValue, 'Marker', '*', 'LineStyle', 'none')
    set(gca,'ytick', (-4):2, 'yticklabel', yNames, 'YAxisLocation','right');
    xlabel('Trial number');
    ylim([-4 2])
    xlim([count-10 count+1])
    drawnow
     
     if nnz(doc.threshold(count,:)) > cfg.costumRej.badElcRej || any(doc.zScore(count,1))   %% if more then 9 channels are bad, then reject
         fprintf('Recjected trial %d from sample %d to %d due to artifacts.\n', count, begsample, endsample);
        continue
     end
     
%     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%     %% Spatial Filtering
%     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%      % train.P has to be derived from the training data as for example:
%      %   * mean amplitude in an interval around an ERP peak (spatial pattern = ERP topography)
%      %   * a principal component of the covariance matrix
%      %   * a principal component of the (real part of the) cross-spectrum at a particular frequency
%      % See example: https://github.com/treder/LDA-beamformer
%      
%     [w,spatDat,covMat] = LDAbeamformer(train.P,procDat);
% 
%     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%     %% Feature extraction
%     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%     % PCA afterwards to destinguish if a LDA can work
%     
%     % get ERP epoch
%     feat.erp_epoch = spatDat(:, (feat.offsetSamp + feat.peakEndSamp):(feat.offsetSamp + feat.peakBegSamp)); % check that
%     
%     % Time-Domain: Amplitude (mean amplitude using RMS)  
%     % Calculating new offset and adding it to the previous set peak
%     % beginning and end time
%     ampDat = rms(feat.erp_epoch,2);
%     ampStdDat = std(feat.erp_epoch,2); %% Might be intressting for control
%     
%     % Time-Domain: Latency (fractional area latency)  
%     % * calculate cumulative sum => last element correspond to area bellow
%     %   ERP
%     % * Substract half area (sum(erp)/2) from cumulative values
%     % * The 50% value is the one closest to zero in the array (min(abs())
%     % * But we are not intressted in the value, but in into the index to
%     %   find the data
%     
%     for k = 1:size(feat.erp_epoch, 1)
%         [~,latIdx(k)] = min(abs(cumsum(feat.erp_epoch(k,:))-sum(feat.erp_epoch(k,:))/feat.fractionalLat));
%         latIdx(k)     = feat.peakBegSamp +  latIdx(k) - 1; % Overlap and thats why -1 ??? CHECK!!!
%         latDat(k)     = latIdx(k) / cfg.resampleFs; % Translate back into ms for every channel
%     end
%     
%     % Time-Domain: Duration (based on fractional area latency) 
%     % not optimal as it depends on stepness of curve as well
%     for k = 1:size(feat.erp_epoch, 1)
%         [~,latIdxOn(k)]  = min(abs(cumsum(feat.erp_epoch(k,:))-sum(feat.erp_epoch(k,:))/feat.fractionOn));
%         [~,latIdxOff(k)] = min(abs(cumsum(feat.erp_epoch(k,:))-sum(feat.erp_epoch(k,:))/feat.fractionOff));
%         durDat(k)        = latIdxOff(k)/cfg.resampleFs - latIdxOn(k)/cfg.resampleFs; % Translate back into ms for every channel
%     end
%     
%     %% Phase (Teodoro) over whole epoch
%     phaseDat = hilbert(spatData);
%     phaseDat = angle(phaseDat); % only phase info
% 
%     % reference phase
%     phaseDatRef = phaseDat(:,feat.refCh); % determine reference channels
%     phaseDatRef = exp(1j*phaseDatRef); % complex numbers (magnitude 1)
%     phaseDatRef = mean(phaseDatRef,2);
%     phaseDatRef = angle(phaseDatRef); % angle reference
% 
%     % phase difference
%     phaseDat = phaseDat - repmat(phaseDatRef,1,size(phaseDat,2)); % angle differences
%     
%     % Frequency-Domain: 
%     % Using the two highest and three smallest values of the covariance
%     % matrix of the LDA beamformer. Method based on:(https://ieeexplore.ieee.org/document/4408441)
%     procDatCSP = ft_preproc_bandpassfilter(procDat, hdr.Fs, [3 7], cfg.bpfiltord, cfg.bpfilttype, cfg.bpfiltdir, cfg.instabilityfix);
%     cspLowDat = train.csp'*procDatCSP;
%     
%     procDatCSP = ft_preproc_bandpassfilter(procDat, hdr.Fs, [3 20], cfg.bpfiltord, cfg.bpfilttype, cfg.bpfiltdir, cfg.instabilityfix);
%     cspHighDat = train.csp'*procDatCSP;
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %% Classification
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
     
%     discrimination (LDA)
%     m1 = median(tmpC1);  %mean(tmp_c1); % mean per channel
%     m2 = median(tmpCM1); %mean(tmp_cm1);
%     m = 0.5*(m1+m2);
%     
%     Regularization
%     [s1,plamb_s1] = cov_shrink(tmpC1);
%     [s2,plamb_s2] = cov_shrink(tmpCM1);
%     sigR = 0.5*(s1+s2); % common covariance (spatial)
%     
%     w = pinv(sigR)*(m1-m2)';
%     b= -w'*m';
%     
%     Classification OF TEST DATA
%     out = w'*[tmpC1;tmpCM1]'+b;
%     trues = [ones(1,size(tmpC1,1)) -1*ones(1,size(tmpCM1,1))];
%     
%     accs(numSamp) = mean(sign(out)==sign(trues));

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %% from here documentation and plotting 
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    figure(3)
    clf(3);
    for j = 1:4
        subplot(2,2,j);
        hold on
        x = [-cfg.pre.prestim : (cfg.pre.prestim + cfg.pre.poststim)/size(procDat,2) : cfg.pre.poststim];
        x = x(1:end-1);
        plot(x, dat(j,cfg.pre.preDiffSamp : end-cfg.pre.postDiffSamp))
        plot(x, procDat(j,:))
        xline(0);
        yline(0);
        hold off
    end
    drawnow
    
   end
 end % of for-loop
 if length(cfg.event) > 25 && strcmp(cfg.event(end).type, 'T') && ~cfg.event(end).value == 1
     ft_flush_event(cfg.dataset);
 end
% ft_flush_event(cfg.dataset);
end % while true
 fprintf('Stimulus sequence ended. Recording was stopped.');
 %% save array (tarti, tread)      