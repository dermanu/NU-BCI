%% Preprocessing and feature extraction of the data based on the imported spatial pattern

clear all
close all

answer = questdlg('Choose which session you want to analyse:', ...
    'Session:', ...
    '1st','2nd', '');
switch answer
    case '1st'
        epochFolder = 'EpochedData\Katja\1st session';
        epoch       = [-0.600 -1.250];
        thresholdMax   = 200;
        load('C:\Users\Emanuel\OneDrive\NEVR_Thesis\Code\MATLAB\2_Feature_Extraction\FilterMatrix\FilterMatrix_1st_Session_80.mat')
        
    case '2nd'
        epochFolder = 'EpochedData\Katja\2nd session';
        epoch       = [-0.400 -1.250];
        thresholdMax   = 120;
        load('C:\Users\Emanuel\OneDrive\NEVR_Thesis\Code\MATLAB\2_Feature_Extraction\FilterMatrix\FilterMatrix_80_2nd_Session.mat')
        end

mat = dir(strcat('..\', epochFolder,'\*.mat'));
mat = mat(61:end);

DWTname = {'bior2.2', 'bior4.4', 'sym6', 'db4'};

for q = 1:length(mat)
    clearvars -except q mat train epochFolder epoch DWTname answer thresholdMax
    %     feat.loom.features    = [];
    %     feat.nonloom.features = [];
    %     feat.random.features  = [];
    
    ft_defaults
    
    load(fullfile('..\', epochFolder, mat(q).name))
    clear procDatCut
    
    % Preprocessing matrix
    doc = [];
    
    %trail settings
    cfg.trialdef.prestim  = 2.000; % 1500 ms prestimuls for filtering (add 500 ms to assure good filtering)
    cfg.trialdef.poststim = 0.500; % 500 ms poststimulus for filtering (add 500 ms to assure good filtering)
    cfg.pre.prestim       = 1.500; % 1200 ms prestimuls for classifing
    cfg.pre.poststim      = 0.200; % 200 ms poststimuls for classifing
    
    % Filter general setup
    cfg.channel = 'all';    % to 'all' if not working
    cfg.method  = 'trial';
    cfg.trials  = 'all';
    
    %Padding
    cfg.padding = zeros(size(rawDat,1), 3000);
    
    % Resmaple data
    %cfg.resampleFs     = 500;
    %cfg.resampleMethod = 'resample';
    
    % Notch filter
    cfg.dftfilter  = 'yes';
    cfg.dftfreq    = [50 100 150 200];
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
    cfg.refchan   = 'all';
    
    % Artifact correction based on threshold in uV
    cfg.costumRej.artfMax   = thresholdMax;
    cfg.costumRej.artfMin   = 0.01;
    cfg.costumRej.badElcRej = 13; % if more then 10% of electrodes are bad reject trial
    
    % Artifact correction based on z-value
    cfg.costumRej.zThreshold = 19; % see fieldtrip for values
    
    % Setting feature extraction
    feat = [];
    feat.nulling       = 0.40;
    feat.refCh         = [41:49 53 54]; % ?
    feat.peakBeg       = epoch(1); % Set to 12 month old infants ERP
    feat.peakEnd       = epoch(2);
    feat.fractionalLat = 50; % fractional area latency in percent
    feat.fractionalOn  = 25;
    feat.fractionalOff = 75;
    feat.minPeakWidth  = 0.11;
    %feat.GW6Window     = 1; % in samples
    
    % set the default configuration options
    if ~isfield(cfg, 'dataformat'),     cfg.dataformat = [];      end % default is detected automatically
    if ~isfield(cfg, 'headerformat'),   cfg.headerformat = [];    end % default is detected automatically
    if ~isfield(cfg, 'eventformat'),    cfg.eventformat = [];     end % default is detected automatically
    if ~isfield(cfg, 'channel'),        cfg.channel = 'all';      end % channels are choosen in BCI2000 to minimize computation
    if ~isfield(cfg, 'bufferdata'),     cfg.bufferdata = 'last';  end % first or last
    
    % define pre and postimulus cut
    cfg.pre.preDiff  = cfg.trialdef.prestim - cfg.pre.prestim;
    cfg.pre.postDiff = cfg.trialdef.poststim - cfg.pre.poststim;
    
    % convert into sampels
    feat.offsetSamp      = round(cfg.pre.prestim * cfg.resampleFs);
    cfg.pre.preDiffSamp  = round(cfg.pre.preDiff * cfg.resampleFs);
    cfg.pre.postDiffSamp = round(cfg.pre.postDiff * cfg.resampleFs);
    feat.peakBegSamp     = round(feat.peakBeg * cfg.resampleFs);
    feat.peakEndSamp     = round(feat.peakEnd * cfg.resampleFs);
    cfg.pre.prestimSamp  = round(cfg.pre.prestim * cfg.resampleFs);
    cfg.pre.poststimSamp = round(cfg.pre.poststim * cfg.resampleFs);
    
    % For data handling in the loop
    count = 0;
    
    for dataLoop = 1:size(rawDat,3)
        if any(datRes(dataLoop) == [1 2 3])
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            %% from here onward it is specific to the preprocessing of the looming data   %%
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            
            % Resampling data for better performance (filter properties?)
            %dat = ft_preproc_resample(dat, hdr.Fs, cfg.resampleFs, cfg.resampleMethod);
            %hdr.Fs = cfg.resampleFs;
            
            % Rereferencing data (needed)
            dat = ft_preproc_rereference(rawDat(:,:,dataLoop), cfg.refchan, cfg.refmethod);
                                                
            %Zero-padding data
            procDat = [cfg.padding dat cfg.padding];
            
            % Filter data
            procDat = ft_preproc_dftfilter(procDat, cfg.resampleFs, cfg.dftfreq);
            procDat = ft_preproc_bandpassfilter(procDat, cfg.resampleFs, cfg.bpfreq, cfg.bpfiltord, cfg.bpfilttype, cfg.bpfiltdir, cfg.instabilityfix);
            
            % Cut data
            procDat = procDat(:, size(cfg.padding,2) + cfg.pre.preDiffSamp :  end - (cfg.pre.postDiffSamp + size(cfg.padding,2)));    
            
            % Baseline correction
            procDat = ft_preproc_baselinecorrect(procDat, cfg.pre.prestimSamp, cfg.pre.prestimSamp+cfg.pre.poststimSamp);
            
            % Artifact rejection based on maximum and minimum threshold.
            for i = 1:size(procDat,1)
                % looks for 3 or more consecutive samples bellow the minimum threshold
                idx    = abs(procDat(i,:)) < cfg.costumRej.artfMin;
                lowBeg = strfind([0 idx 0],[0 1]);
                lowEnd = strfind([0 idx 0],[1 0])-1;
                low    = (lowEnd-lowBeg+1) >= 3;
                
                if any(abs(procDat(i,:)) > cfg.costumRej.artfMax) || any(low)
                    doc.loom.threshold(dataLoop,i) = 1; %%Trailstate saves if a trial and channel was ignored or not
                    procDat(i,:) = zeros(1,size(procDat,2));
                else
                    doc.loom.threshold(dataLoop,i) = 0;
                end
            end
            
            % Artifact rejection based on z-transformed data
            doc.loom.zScore(dataLoop,1) = zValue(cfg.costumRej.zThreshold, procDat);
            
            if nnz(doc.loom.threshold(dataLoop,:)) > cfg.costumRej.badElcRej || any(doc.loom.zScore(dataLoop,1))   %% if more then 9 a bad reject
                fprintf('Looming trial %d was rejected for subject %d.\n', dataLoop, q);
                continue
            end
            count = count+1;
            finalLoomDat(:,:, count) = procDat;
        end
    end
    
    % Reset count for data handling
    clear dat procDat idx lowBeg lowEnd low i loop
    count = 0;
    
    for dataLoop = 1:size(rawDat,3)
        if datRes(dataLoop) == 0
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            %% from here onward it is specific to the preprocessing of the non-looming data %%
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            
            % Resampling data for better performance (filter properties?)
            %dat = ft_preproc_resample(dat, hdr.Fs, cfg.resampleFs, cfg.resampleMethod);
            %hdr.Fs = cfg.resampleFs;
            
            % Rereferencing data (needed)
            dat = ft_preproc_rereference(rawDat(:,:,dataLoop), cfg.refchan, cfg.refmethod);
                                                
            %Zero-padding data
            procDat = [cfg.padding dat cfg.padding];
            
            % Filter data
            procDat = ft_preproc_dftfilter(procDat, cfg.resampleFs, cfg.dftfreq);
            procDat = ft_preproc_bandpassfilter(procDat, cfg.resampleFs, cfg.bpfreq, cfg.bpfiltord, cfg.bpfilttype, cfg.bpfiltdir, cfg.instabilityfix);
            
            % Cut data
            procDat = procDat(:, size(cfg.padding,2)+cfg.pre.preDiffSamp :  end-(cfg.pre.postDiffSamp + size(cfg.padding,2)));    
                       
            % Baseline correction
            procDat = ft_preproc_baselinecorrect(procDat, cfg.pre.prestimSamp, cfg.pre.prestimSamp+cfg.pre.poststimSamp);
            
            % Artifact rejection based on maximum and minimum threshold.
            for i = 1:size(procDat,1)
                % looks for 3 or more consecutive samples bellow the minimum threshold
                idx    = abs(procDat(i,:)) < cfg.costumRej.artfMin;
                lowBeg = strfind([0 idx 0],[0 1]);
                lowEnd = strfind([0 idx 0],[1 0])-1;
                low    = (lowEnd-lowBeg+1) >= 3;
                
                if any(abs(procDat(i,:)) > cfg.costumRej.artfMax) || any(low)
                    doc.nonloom.threshold(dataLoop,i) = 1; %%Trailstate saves if a trial and channel was ignored or not
                    procDat(i,:) = zeros(1,size(procDat,2));
                else
                    doc.nonloom.threshold(dataLoop,i) = 0;
                end
            end
            
            % Artifact rejection based on z-transformed data
            doc.nonloom.zScore(dataLoop,1) = zValue(cfg.costumRej.zThreshold, procDat);
            
            if nnz(doc.nonloom.threshold(dataLoop,:)) > cfg.costumRej.badElcRej || any(doc.nonloom.zScore(dataLoop,1))   %% if more then 9 a bad reject
                fprintf('Non-looming trial %d was rejected for subject %d.\n', dataLoop,q);
                continue
            end
            count = count+1;
            finalNONLoomDat(:,:, count) = procDat;
        end
    end
    
    % Reset count for data handling
    clear dat procDat idx lowBeg lowEnd low i loop
    count = 0;
    
    for dataLoop = 1:size(datBad,3)
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %% from here onward it is specific to the preprocessing of the random post-collision data %%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        % Resampling data for better performance (filter properties?)
        %dat = ft_preproc_resample(dat, hdr.Fs, cfg.resampleFs, cfg.resampleMethod);
        %hdr.Fs = cfg.resampleFs;
        
        % Rereferencing data (needed)
        dat = ft_preproc_rereference(datBad(:,:,dataLoop), cfg.refchan, cfg.refmethod);
                                            
        %Zero-padding data
        procDat = [cfg.padding dat cfg.padding];
                 
        % Filter data
        procDat = ft_preproc_dftfilter(procDat, cfg.resampleFs, cfg.dftfreq);
        procDat = ft_preproc_bandpassfilter(procDat, cfg.resampleFs, cfg.bpfreq, cfg.bpfiltord, cfg.bpfilttype, cfg.bpfiltdir, cfg.instabilityfix);
        
        % Cut data
        procDat = procDat(:, size(cfg.padding,2) + cfg.pre.preDiffSamp :  end - (cfg.pre.postDiffSamp + size(cfg.padding,2)));    
            
        % Baseline correction
        procDat = ft_preproc_baselinecorrect(procDat, cfg.pre.prestimSamp, cfg.pre.prestimSamp+cfg.pre.poststimSamp);
        
        % Artifact rejection based on maximum and minimum threshold.
        for i = 1:size(procDat,1)
            % looks for 3 or more consecutive samples bellow the minimum threshold
            idx    = abs(procDat(i,:)) < cfg.costumRej.artfMin;
            lowBeg = strfind([0 idx 0],[0 1]);
            lowEnd = strfind([0 idx 0],[1 0])-1;
            low    = (lowEnd-lowBeg+1) >= 3;
            
            if any(abs(procDat(i,:)) > cfg.costumRej.artfMax) || any(low)
                doc.random.threshold(dataLoop,i) = 1; % Trailstate saves if a trial and channel was ignored or not
                   procDat(i,:) = zeros(1,size(procDat,2));
            else
                doc.random.threshold(dataLoop,i) = 0;
            end
        end
        
        % Artifact rejection based on z-transformed data
        doc.random.zScore(dataLoop,1) = zValue(cfg.costumRej.zThreshold, procDat);
        
        if nnz(doc.random.threshold(dataLoop,:)) > cfg.costumRej.badElcRej || any(doc.random.zScore(dataLoop,1))
            fprintf('Random trial %d was rejected for subject %d.\n', dataLoop, q);
            continue
        end
        count = count+1;
        finalRandomDat(:,:, count) = procDat;
    end
    
    % sort everything for training
    if exist('finalLoomDat', 'var') && exist('finalNONLoomDat', 'var') && exist('finalRandomDat', 'var')
        feat.loom.dat    = finalLoomDat;
        feat.nonloom.dat = finalNONLoomDat;
        feat.random.dat  = finalRandomDat;
    else
        continue
    end
    
    % clear up workspace
    clear low count i idx lowBeg lowEnd finalLoomDat finalNONLoomDat finalRandomDat loop procDat dat
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %% Feature extraction                                                         %%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    for dataLoop = 1:3
        switch dataLoop
            case 1
                datall = feat.loom.dat;
            case 2
                datall = feat.nonloom.dat;
            case 3
                datall = feat.random.dat;
        end
        
        for trialLoop = 1:size(datall,3)
            dat = datall(:,:,trialLoop);
            featuresTmp2 = [];
            DWTFeatOcc = [];
            
            for spatialLoop = 1:3
                DWTFeat = [];
                % Spatial filtering
                %nullingPercentage = round(size(train.score{1,spatialLoop}{1,1},1) * feat.nulling) + 3; %Adds 75 percent (3/4) (minus 1 component) of the nulling array
                spatDat = diySpatialFilter(train.score{1,spatialLoop}, dat(train.channel{spatialLoop},:));         
                   
                % Test normalization
                
                %spatDat = normalize(spatDat, 'range');
                
                % get ERP epoch
                erp_epoch_beam = spatDat(:, (feat.offsetSamp + feat.peakEndSamp):(feat.offsetSamp + feat.peakBegSamp));
                
                % Time-Domain: Amplitude (mean amplitude using RMS)
                % Calculating new offset and adding it to the previous set peak
                % beginning and end time
                ampDat     = rms(erp_epoch_beam);
                ampStdDat  = std(erp_epoch_beam); %% Might be intressting for control
                medianDat  = median(erp_epoch_beam);
                varDat     = var(erp_epoch_beam);
                
                % Max. and Minmum Voltage
                maxDat = max(erp_epoch_beam);
                minDat = min(erp_epoch_beam);
                
                % Time-Domain: Latency (fractional area latency)
                % * calculate cumulative sum => last element correspond to area bellow
                %   ERP
                % * Substract half area (sum(erp)/2) from cumulative values
                % * The 50% value is the one closest to zero in the array (min(abs())
                % * But we are not intressted in the value, but in into the index to
                %   find the data
                
                [~,latIdx] = min(abs(cumsum(erp_epoch_beam)-sum(erp_epoch_beam)/(100/feat.fractionalLat)));
                latIdx     = feat.peakBegSamp +  latIdx;
                latDat     = latIdx / cfg.resampleFs; % Translate back into ms for every channel
                
                
                % Time-Domain: Duration (based on fractional area latency)
                % not optimal as it depends on stepness of curve as well
                [~,latIdxOn]  = min(abs(cumsum(erp_epoch_beam)-sum(erp_epoch_beam)/(100/feat.fractionalOn)));
                [~,latIdxOff] = min(abs(cumsum(erp_epoch_beam)-sum(erp_epoch_beam)/(100/feat.fractionalOff)));
                durDat        = abs(latIdxOff/cfg.resampleFs - latIdxOn/cfg.resampleFs); % Translate back into ms for every channel
                
                % Improved Amplitude, Latency and duration analysis useing MATLAB
                % findpeaks
                [mAmpDat, mLatDat, mDurDat, mPromDat] = findpeaks(-spatDat, cfg.resampleFs, 'MinPeakWidth', feat.minPeakWidth, 'SortStr', 'descend', 'NPeaks', 1);
                if isempty(mAmpDat)
                    [mAmpDat, mLatDat, mDurDat, mPromDat] = findpeaks(-spatDat, cfg.resampleFs, 'SortStr', 'descend', 'NPeaks', 1);
                end
                if isempty(mAmpDat)
                    mAmpDat  = 0;
                    mLatDat  = 0;
                    mDurDat  = 0;
                    mPromDat = 0;
                end
                
                %% Phase (Teodoro) over whole epoch
                spatDatFilt  = ft_preproc_bandpassfilter(spatDat, cfg.resampleFs, [3 7], cfg.bpfiltord, cfg.bpfilttype, cfg.bpfiltdir, cfg.instabilityfix);
                phaseDatStim = hilbert(spatDatFilt);
                phaseDatStim = angle(phaseDatStim); % only phase info
                
                % reference phase
                phaseDatRef = dat(feat.refCh,:); % determine reference channels
                phaseDatRef = exp(1j*phaseDatRef); % complex numbers (magnitude 1)
                phaseDatRef = mean(phaseDatRef,1);
                phaseDatRef = angle(phaseDatRef); % angle reference
                
                % phase difference
                %         phaseDatStim = phaseDatStim(:, (feat.offsetSamp + feat.peakEndSamp):(feat.offsetSamp + feat.peakBegSamp));
                %         phaseDatRef = phaseDatRef(:, (feat.offsetSamp + feat.peakEndSamp):(feat.offsetSamp + feat.peakBegSamp));
                phaseDat    = mean(phaseDatStim - phaseDatRef); % angle differences
                phaseDatVar = std(phaseDatStim - phaseDatRef);
                
                %% Frequency-Domain:
                % Using the two highest and three smallest values of the covariance
                % matrix of the LDA beamformer. Method based on:(https://ieeexplore.ieee.org/document/4408441)
                
                %         spatDatFilt = ft_preproc_bandpassfilter(spatDat, cfg.resampleFs, [3 7], cfg.bpfiltord, cfg.bpfilttype, cfg.bpfiltdir, cfg.instabilityfix);
                %         erp_epoch_beam_filt = spatDatFilt(:, (feat.offsetSamp + feat.peakEndSamp):(feat.offsetSamp + feat.peakBegSamp));
                %         freqLowDat    = rms(erp_epoch_beam_filt);
                
                freqLowDat = bandpower(spatDat, cfg.resampleFs, [3 10]);
                
                % Instantaneous frequency
                instFreqDat = mean(instfreq(erp_epoch_beam, cfg.resampleFs));
                
                % Spectral Entropy
                pentropyDat = mean(pentropy(erp_epoch_beam, cfg.resampleFs));
                
                % Petrosian's algorithmn (estimation of fractal dimension of
                % signal)
                zeroCrossDat = length(find([0 diff(sign(erp_epoch_beam))]~=0));
                pfdDat       = log10(length(erp_epoch_beam)) / (log10(length(erp_epoch_beam)) + log10(length(erp_epoch_beam) / (length(erp_epoch_beam) + 0.4 * zeroCrossDat)));
                
                % Hjorth parameters
                dSig  = diff([0;erp_epoch_beam']);
                ddSig = diff([0;dSig]);
                
                %complexityDat = real(sqrt((var(ddSig) / var(dSig))^2 - (var(erp_epoch_beam) / var(dSig))^2));
                mobilityDat   = sqrt(var(dSig) / var(erp_epoch_beam));
                activityDat   = var(erp_epoch_beam)^2;
                
                % z-Score
                zScore = (maxDat - minDat) / ampStdDat;
                
                %DWT
                % Time difference
                % Spatial difference
                % Frequency Ratio
                % https://ieeexplore.ieee.org/document/7856467
                
                sampleFreq = [7.8125 7.8125 32.5 15.625]; % Sample Frequency of different wavelets
                
                for DWTLoop = 1:4
                    DWTspatDat = [spatDat cfg.padding(1,:)]; 
                    [c,l] = wavedec(DWTspatDat,6,char(DWTname(DWTLoop)));
                    Delta = appcoef(c,l,char(DWTname(DWTLoop)));
                    [BetaGamma,Alpha,Theta] = detcoef(c,l,[4 5 6]);
                    DWTFreq = {Delta(2:17) Theta(2:16) Alpha(2:29) BetaGamma(2:55)};
                    DWTFeatTemp = [];
                    for DWTFreqLoop = 1:4
                        timeTmp = [(ceil(cfg.pre.prestim*sampleFreq(DWTFreqLoop))+(ceil(feat.peakEnd*sampleFreq(DWTFreqLoop)))) (ceil(cfg.pre.prestim*sampleFreq(DWTFreqLoop))+(ceil(feat.peakBeg*sampleFreq(DWTFreqLoop))))];
                        DWTFreqTemp = DWTFreq{1,DWTFreqLoop};
%                       DWTFreqTemp = DWTFreqTemp(timeTmp(1) : timeTmp(2));
%                         
                        DWTmean     = mean(DWTFreqTemp);
                        DWTmedian   = median(DWTFreqTemp);
                        DWTmin      = min(DWTFreqTemp);
                        DWTmax      = max(DWTFreqTemp);
                        DWTvar      = var(DWTFreqTemp);
                        DWTskewness = (1/size(DWTFreqTemp,2)) * sum(((DWTFreqTemp-mean(DWTFreqTemp)) ./ std(DWTFreqTemp)).^4-3);
                        DWTpower    = (1/size(DWTFreqTemp,2)) * sum(DWTFreqTemp).^2;
                        DWTentropy  = entropy(DWTFreqTemp/max(abs(DWTFreqTemp)));
                        DWTFeatTemp = [DWTFeatTemp DWTmean DWTmedian DWTmin DWTmax DWTvar DWTskewness DWTpower DWTentropy];
                    end
                    DWTFeat = [DWTFeat DWTFeatTemp];
                end
                
                if spatialLoop == 3 %% Difference between Occ Electrodes and Reference Electrodes
                    % Spatial filtering
                    %nullingPercentage = round(size(train.score{1,spatialLoop}{1,1},1) * feat.nulling) + 3; %Adds 75 percent (3/4) (minus 1 component) of the nulling array
                    spatDat = diySpatialFilter(train.score{1,2}, dat(train.channel{2, 1},:));
                
                    for DWTLoop = 1:4
                    DWTspatDat = [spatDat cfg.padding(1,:)]; 
                    [c,l] = wavedec(DWTspatDat,6,char(DWTname(DWTLoop)));
                    Delta = appcoef(c,l,char(DWTname(DWTLoop)));
                    [BetaGamma,Alpha,Theta] = detcoef(c,l,[4 5 6]);
                    DWTFreq = {Delta(2:17) Theta(2:16) Alpha(2:29) BetaGamma(2:55)};
                        DWTFeatTemp = [];
                        for DWTFreqLoop = 1:4
                            timeTmp = [(ceil(cfg.pre.prestim*sampleFreq(DWTFreqLoop))+(ceil(feat.peakEnd*sampleFreq(DWTFreqLoop)))) (ceil(cfg.pre.prestim*sampleFreq(DWTFreqLoop))+(ceil(feat.peakBeg*sampleFreq(DWTFreqLoop))))];
                            DWTFreqTemp = DWTFreq{1,DWTFreqLoop};
                            % DWTFreqTemp = DWTFreqTemp(timeTmp(1) : timeTmp(2));
                            
                            DWTmean     = mean(DWTFreqTemp);
                            DWTmedian   = median(DWTFreqTemp);
                            DWTmin      = min(DWTFreqTemp);
                            DWTmax      = max(DWTFreqTemp);
                            DWTvar      = var(DWTFreqTemp);
                            DWTskewness = (1/size(DWTFreqTemp,2)) * sum(((DWTFreqTemp-mean(DWTFreqTemp)) ./ std(DWTFreqTemp)).^4-3);
                            DWTpower    = (1/size(DWTFreqTemp,2)) * sum(DWTFreqTemp).^2;
                            DWTentropy  = entropy(DWTFreqTemp/max(abs(DWTFreqTemp)));
                            DWTFeatTemp = [DWTFeatTemp DWTmean DWTmedian DWTmin DWTmax DWTvar DWTskewness DWTpower DWTentropy];
                        end
                        DWTFeatOcc = [DWTFeatOcc DWTFeatTemp];
                    end
                    fprintf('Beginn: %d\n', length(DWTFeat))
                    DWTFeat = [DWTFeat (DWTFeatOcc - DWTFeat)];
                    fprintf('End: %d\n', length(DWTFeat))
                end
                
                % GW6
                %         sync = GW6(dat([60:62 66:67 70:72 75:78 83:85],:), cfg.resampleFs, feat.GW6Window, [cfg.pre.prestim + feat.peakEnd cfg.pre.prestim + feat.peakBeg], 0, 'data');
                %         [syncMaxDat, syncMaxLatDat] = max(sync); % in percent and sec
                
                % Save data
                featuresTmp       = [];
                featuresTmp(1,1)  = ampDat;
                featuresTmp(1,2)  = ampStdDat;
                featuresTmp(1,3)  = medianDat;
                featuresTmp(1,4)  = varDat;
                featuresTmp(1,5)  = maxDat;
                featuresTmp(1,6)  = minDat;
                featuresTmp(1,7)  = latDat;
                featuresTmp(1,8)  = durDat;
                featuresTmp(1,9)  = phaseDat;
                featuresTmp(1,10) = instFreqDat;
                featuresTmp(1,11) = pentropyDat;
                featuresTmp(1,12) = zeroCrossDat;
                featuresTmp(1,13) = pfdDat;
                %featuresTmp(1,15) = complexityDat;
                featuresTmp(1,14) = mobilityDat;
                featuresTmp(1,15) = activityDat;
                featuresTmp(1,16) = freqLowDat;
                featuresTmp(1,17) = zScore;
                featuresTmp(1,18) = mAmpDat;
                featuresTmp(1,19) = mLatDat;
                featuresTmp(1,20) = mDurDat;
                featuresTmp(1,21) = mPromDat;
                featuresTmp(1,22) = phaseDatVar;
                featuresTmp = [featuresTmp DWTFeat];
                featuresTmp2 = [featuresTmp2 featuresTmp];
                DWTFeat = [];
            end
            switch dataLoop
                case 1
                    featuresTmp2 = [featuresTmp2 1];
                    feat.loom.features(trialLoop,:)  = featuresTmp2;
                case 2
                    featuresTmp2 = [featuresTmp2 2];
                    feat.nonloom.features(trialLoop,:) = featuresTmp2;
                case 3
                    featuresTmp2 = [featuresTmp2 3];
                    feat.random.features(trialLoop,:) = featuresTmp2;
            end
            clearvars -except cfg dat datall datBad datRes doc DWTname epoch epochFolder feat dataLoop mat q rawDat spatialLoop trialLoop train trial answer thresholdMax
        end
    end
    clear trialLoop dat datall
    
    nametmp  = split(mat(q).name, '.');
    name = append('..\Features\', nametmp(1),'_PCA_', answer, '.mat');
    save(name{1,1},'feat', 'doc', 'train', 'cfg', 'rawDat', 'datBad', 'datRes')
    
end
