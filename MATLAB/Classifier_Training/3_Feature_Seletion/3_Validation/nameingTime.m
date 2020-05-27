function [nameArray] = nameingTime()
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here

nameArray        = [];
lableRegions     = {'All', 'Occ', 'Ref'};
lableTimeRaw = {'SpatialFilter', 'EpochCut', 'AmpMean','AmpStd','AmpMedian', 'AmpVar', 'AmpMax', 'AmpMin', 'PeakLat', 'PeakDur', 'MatlabAmp', 'PhaseGenerel', 'PhaseDiff', 'phaseDatVar', 'LowFreqAmp', 'InstFreq', 'Pentropy', 'ZeroCross', 'PFD', 'Mobility', 'Activity', 'zScore'};
DWTname = {'bior2.2', 'bior4.4', 'sym6', 'db4'};
FreqDWT = {'Delta', 'Theta', 'Alpha', 'BetaGamma'};
lableDWT = {'Mean', 'Median', 'Min', 'Max', 'Var', 'Power', 'Skewness', 'Entropy'};

for i = 1:3
    lableDWTTmp2     = [];
    lableDiffDWTTmp2 = [];
    lableTimeTmp     = [];
    % Variables time-domain
    lableTimeTmp = strcat(lableRegions{i}, '_', lableTimeRaw);
    
    for j = 1:4
        lableDWTTmp = [];
        for k = 1:4
            lableDWTTmp = [lableDWTTmp strcat(lableRegions{i}, '_', DWTname{j}, '_', FreqDWT{k}, '_',lableDWT)];
        end
        lableDWTTmp2 = [lableDWTTmp2 strcat(lableRegions{i},'_','DWTGenerel_', DWTname{j}) lableDWTTmp];
    end
    
%     if i == 3
%         for j = 1:4
%             lableDiffDWTTmp = [];
%             for k = 1:4
%                 lableDiffDWTTmp = [lableDiffDWTTmp strcat(lableRegions{4}, '_', DWTname{j}, '_', FreqDWT{k}, '_',lableDWT)];
%             end
%             lableDiffDWTTmp2 = [lableDiffDWTTmp2 strcat('DWTGenerel_', DWTname{j}) lableDiffDWTTmp];
%         end
%     end
    nameArray    = [nameArray lableTimeTmp lableDWTTmp2];
end
    nameArray = [nameArray];  
end


