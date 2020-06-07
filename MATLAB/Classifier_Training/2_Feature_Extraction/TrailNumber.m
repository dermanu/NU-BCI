%% Converts features of v5 training scripts into classfier readable format
clear all
close all

folder =  'Features\Katja\2nd_Session\All';
mat = dir(strcat('..\', folder,'\*.mat'));


for q = 1:length(mat)
    load(fullfile('..\', folder, mat(q).name))
    loom(q)    = size(feat.loom.features,1);
    nonloom(q) = size(feat.nonloom.features,1);
    random(q)  = size(feat.random.features,1);
end

