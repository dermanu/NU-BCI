%% The following code allows for the extraction of the filter matrix based on the training data and saves it. 
%% The resulting matrix is subsequently used for spatial filtering.


clear all
close all

answer = questdlg('Choose which session you want to analyse:', ...
    'Session:', ...
    '1st','2nd', '');

train = [];

switch answer
    case '1st'
        epochFolder = 'EpochedData\Katja\1st session\';
        %epoch       = [-0.55 -1.170];
        epoch        = [-0.600 -1.250];
        thresholdMax   = 200;
        train.channel = {1:128;  62:102; [41:49 53 54]};
        train.ch = {2:7; 1:9; 1:9};
        
    case '2nd'
        epochFolder = 'EpochedData\Katja\2nd session';
        epoch       = [-0.400 -1.250];
        thresholdMax   = 120;
        train.channel = {1:128;  62:102; 30:61};
        train.ch = {2:7; 1:7; 1:8};
end


for LDALoop = 1:3
    [train.score{LDALoop} train.explained{LDALoop}] = cross_PCA_filtermatrix(epochFolder, epoch, thresholdMax, train.channel{LDALoop}, train.ch{LDALoop});
end

save(strcat('FilterMatrix_', answer, '_Session'), 'train')
