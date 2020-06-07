clear all
load('Features_1st.mat');

featVector = [ones(1,578)];
[AUC, validationAccuracy] = LDAClassifier(balanced2LoomNon, featVector)
