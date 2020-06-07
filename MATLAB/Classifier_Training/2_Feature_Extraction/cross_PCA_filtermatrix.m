%% Extraction of the spatial pattern based on the EEG trials

function [score, explained] = cross_PCA_filtermatrix(epochFolder, epoch, thresholdMax, channels, ch)

mat = dir(strcat('..\', epochFolder, '\*.mat'));
looming = [];

for q = 1:length(mat)
    clearvars -except q mat looming epochFolder epoch channels thresholdMax ch
    
    ft_defaults
    
    load(fullfile('..\', epochFolder, mat(q).name))
    clear procDatCut path
    
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
    cfg.bpfreq         = [1.8 20];
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
    feat.peakBeg       = epoch(1); % Set to 12 month old infants ERP
    feat.peakEnd       = epoch(2);
    
    % Training
    train = [];
    
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
    
    for loop = 1:size(rawDat,3)
        if any(datRes(loop) == [1 2 3])
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            %% from here onward it is specific to the preprocessing of the looming data   %%
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            % Resampling data for better performance (filter properties?)
            %dat = ft_preproc_resample(dat, hdr.Fs, cfg.resampleFs, cfg.resampleMethod);
            %hdr.Fs = cfg.resampleFs;
            
            % Rereferencing data (needed)
            %dat = ft_preproc_rereference(rawDat(:,:,loop), cfg.refchan, cfg.refmethod);
            dat = ft_preproc_rereference(rawDat(:,:,loop), cfg.refchan, cfg.refmethod);
            
            % Zero-padding data
            dat = [cfg.padding dat cfg.padding];
            
            % Filter data
            procDat = ft_preproc_dftfilter(dat, cfg.resampleFs, cfg.dftfreq);
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
                    doc.loom.threshold(loop,i) = 1; %%Trailstate saves if a trial and channel was ignored or not
                    procDat(i,:) = zeros(1,size(procDat,2));
                else
                    doc.loom.threshold(loop,i) = 0;
                end
            end
            
            % Artifact rejection based on z-transformed data
            doc.loom.zScore(loop,1) = zValue(cfg.costumRej.zThreshold, procDat);
            
            if nnz(doc.loom.threshold(loop,:)) > cfg.costumRej.badElcRej || any(doc.loom.zScore(loop,1))   %% if more then 9 a bad reject
                fprintf('Looming trial %d was rejected for subject %d.\n', loop, q);
                continue
            end
            
            count = count+1;
            finalLoomDat(:,:, count) = procDat;
            
        end
    end
    
    % sort everything for training
    if exist('finalLoomDat', 'var')
    % avgPeak = finalLoomDat(:, (feat.offsetSamp + feat.peakEndSamp):(feat.offsetSamp + feat.peakBegSamp),:);
    avgPeak = finalLoomDat;
    looming = cat(3, looming, avgPeak);
    else
        continue
        
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Train spatial filters                                                      %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% train.P has to be derived from the training data as for example:
%   * mean amplitude in an interval around an ERP peak (spatial pattern = ERP topography)
%   * a principal component of the covariance matrix
%   * a principal component of the (real part of the) cross-spectrum at a particular frequency
% See example: https://github.com/treder/LDA-beamformer

% Grand Average over all subjects
avgLoom = mean(looming,3);

% PCA
[~, score,~,~,explained,~] = pca(avgLoom(channels,:));
score = normalize(sum(score(:,ch),2));

clear dat loop
end
