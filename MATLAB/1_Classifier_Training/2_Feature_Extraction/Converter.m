%% Balances the features and subsequently converts it into a for the classifier readable format.

clear all
close all

folder =  'C:\Users\Emanuel\OneDrive\NEVR_Thesis\Code\MATLAB\2_Feature_Extraction\Features\Katja\1st_Session\All';

mat = dir(strcat(folder,'\*.mat'));

allFeatures3All = [];
featuresLoom    = [];
featuresNonLoom = [];
featuresRandom  = [];

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

balancedLoom    = datasample(featuresLoom, shortestArray, 'Replace', false);
balancedNonLoom = datasample(featuresNonLoom, shortestArray, 'Replace', false);
balancedRandom  = datasample(featuresRandom, shortestArray, 'Replace', false);
balancedComb    = datasample([featuresNonLoom; featuresRandom], shortestArray, 'Replace', false);
balancedComb(:, end) = repmat(2, [size(balancedComb,1),1]);

balanced3All = [balancedLoom; balancedNonLoom; balancedRandom];
balanced3All = array2table(balanced3All,'VariableNames',colNamesBalanced);

balanced2RandNon  = [balancedRandom; balancedNonLoom];
balanced2RandNon = array2table(balanced2RandNon,'VariableNames',colNamesBalanced);

balanced2LoomNon  = [balancedLoom; balancedNonLoom];
balanced2LoomNon = array2table(balanced2LoomNon,'VariableNames',colNamesBalanced);

balanced2LoomRand = [balancedLoom; balancedRandom];
balanced2LoomRand = array2table(balanced2LoomRand,'VariableNames',colNamesBalanced);

balanced2Comb   = [balancedLoom; balancedComb];
balanced2Comb   = array2table(balanced2Comb,'VariableNames',colNamesBalanced);

writetable(balanced3All, 'balancedAll.txt');
writetable(balanced2LoomNon, 'balanced2LoomNon.txt');
%  writetable(balanced2LoomRand, 'balanced2LoomRand.txt');
%  writetable(balanced2Comb, 'balanced2Comb.txt');
%
%clearvars -except balanced2LoomNon
