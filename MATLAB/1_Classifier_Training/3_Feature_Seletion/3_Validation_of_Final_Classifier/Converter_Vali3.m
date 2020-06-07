%% Converts and balances features of training scripts into classfier readable format

% clear all
% close all

load('randomSeed.mat');

folder =  'C:\Users\Emanuel\OneDrive\NEVR_Thesis\Code\MATLAB\2_Feature_Extraction\Features\Katja\1st_Session\Vali6';
mat = dir(strcat(folder,'\*.mat'));
mat = mat(7:9)

allFeatures3All = [];
featuresLoom    = [];
featuresNonLoom = [];
featuresRandom  = [];

datLoom = [];
datNonLoom = [];
datRandom = [];

for q = 1:length(mat)
    load(fullfile(folder, mat(q).name))
    loom    = repmat(q, [size(feat.loom.features,1),1]);
    nonloom = repmat(q, [size(feat.nonloom.features,1),1]);
    random  = repmat(q, [size(feat.random.features,1),1]);
    
    %   features3All = [feat.loom.features, loom; feat.nonloom.features nonloom; feat.random.features random];
    %   features3All = array2table(features3All,'VariableNames',colNames);
    features3All = [feat.loom.features; feat.nonloom.features; feat.random.features];
    allFeatures3All = [allFeatures3All; features3All];
    
    featuresLoom    = [featuresLoom ;feat.loom.features];
    featuresNonLoom = [featuresNonLoom ;feat.nonloom.features];
    featuresRandom  = [featuresRandom ;feat.random.features];

    datLoom    = cat(3,datLoom,feat.loom.dat);
    datNonLoom = cat(3,datNonLoom,feat.nonloom.dat);
    datRandom  = cat(3,datRandom,feat.random.dat);   
    
    clear loom nonloom random
end

colNamesBalanced = nameing();

loomRows    = find(allFeatures3All(:,end) == 1);
nonloomRows = find(allFeatures3All(:,end) == 2);
randomRows  = find(allFeatures3All(:,end) == 3);

lengthRows(1) = size(loomRows,1);
lengthRows(2) = size(nonloomRows,1);
lengthRows(3) = size(randomRows,1);

shortestArray = min(lengthRows);

rng(randomSeed);

[balancedLoom loomIdx] = datasample(featuresLoom, shortestArray, 'Replace', false);
[balancedNonLoom nonloomIdx] = datasample(featuresNonLoom, shortestArray, 'Replace', false);
[balancedRandom randomIdx] = datasample(featuresRandom, shortestArray, 'Replace', false);

datLoom    = datLoom(:,:,loomIdx);
datNonLoom = datNonLoom(:,:,nonloomIdx);
datRandom  = datRandom(:,:,randomIdx);

%balanced3All = [balancedLoom; balancedNonLoom; balancedRandom];
%balanced3All = array2table(balanced3All,'VariableNames',colNamesBalanced);

%balanced2LoomNon  = [balancedLoom; balancedNonLoom];
%balanced2LoomNon = array2table(balanced2LoomNon,'VariableNames',colNamesBalanced);

balanced2LoomRand = [balancedLoom; balancedRandom];
balanced2LoomRand = array2table(balanced2LoomRand,'VariableNames',colNamesBalanced);

