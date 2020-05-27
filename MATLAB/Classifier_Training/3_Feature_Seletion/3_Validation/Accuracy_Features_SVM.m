%% Use:[AUC ACC] = Accuracy_Features_KNN(balanced2LoomNon, minVect(end,:))
close all
load('Features_1st.mat');
load('FilterMatrix_1st_Session_All.mat');
load('randomSeed.mat');
inputTable = balanced2LoomRand;
inputTable.Properties.VariableNames = {'All_AmpMean', 'All_AmpStd', 'All_AmpMedian', 'All_AmpVar', 'All_AmpMax', 'All_AmpMin', 'All_PeakLat', 'All_PeakDur', 'All_PhaseDiff', 'All_InstFreq', 'All_Pentropy', 'All_ZeroCross', 'All_PFD', 'All_Mobility', 'All_Activity', 'All_LowFreqAmp', 'All_zScore', 'All_mAmplitude', 'All_mLatency', 'All_mDuration', 'All_mProminence', 'All_phaseDatVar', 'All_bior2_2_Delta_Mean', 'All_bior2_2_Delta_Median', 'All_bior2_2_Delta_Min', 'All_bior2_2_Delta_Max', 'All_bior2_2_Delta_Var', 'All_bior2_2_Delta_Power', 'All_bior2_2_Delta_Skewness', 'All_bior2_2_Delta_Entropy', 'All_bior2_2_Theta_Mean', 'All_bior2_2_Theta_Median', 'All_bior2_2_Theta_Min', 'All_bior2_2_Theta_Max', 'All_bior2_2_Theta_Var', 'All_bior2_2_Theta_Power', 'All_bior2_2_Theta_Skewness', 'All_bior2_2_Theta_Entropy', 'All_bior2_2_Alpha_Mean', 'All_bior2_2_Alpha_Median', 'All_bior2_2_Alpha_Min', 'All_bior2_2_Alpha_Max', 'All_bior2_2_Alpha_Var', 'All_bior2_2_Alpha_Power', 'All_bior2_2_Alpha_Skewness', 'All_bior2_2_Alpha_Entropy', 'All_bior2_2_BetaGamma_Mean', 'All_bior2_2_BetaGamma_Median', 'All_bior2_2_BetaGamma_Min', 'All_bior2_2_BetaGamma_Max', 'All_bior2_2_BetaGamma_Var', 'All_bior2_2_BetaGamma_Power', 'All_bior2_2_BetaGamma_Skewness', 'All_bior2_2_BetaGamma_Entropy', 'All_bior4_4_Delta_Mean', 'All_bior4_4_Delta_Median', 'All_bior4_4_Delta_Min', 'All_bior4_4_Delta_Max', 'All_bior4_4_Delta_Var', 'All_bior4_4_Delta_Power', 'All_bior4_4_Delta_Skewness', 'All_bior4_4_Delta_Entropy', 'All_bior4_4_Theta_Mean', 'All_bior4_4_Theta_Median', 'All_bior4_4_Theta_Min', 'All_bior4_4_Theta_Max', 'All_bior4_4_Theta_Var', 'All_bior4_4_Theta_Power', 'All_bior4_4_Theta_Skewness', 'All_bior4_4_Theta_Entropy', 'All_bior4_4_Alpha_Mean', 'All_bior4_4_Alpha_Median', 'All_bior4_4_Alpha_Min', 'All_bior4_4_Alpha_Max', 'All_bior4_4_Alpha_Var', 'All_bior4_4_Alpha_Power', 'All_bior4_4_Alpha_Skewness', 'All_bior4_4_Alpha_Entropy', 'All_bior4_4_BetaGamma_Mean', 'All_bior4_4_BetaGamma_Median', 'All_bior4_4_BetaGamma_Min', 'All_bior4_4_BetaGamma_Max', 'All_bior4_4_BetaGamma_Var', 'All_bior4_4_BetaGamma_Power', 'All_bior4_4_BetaGamma_Skewness', 'All_bior4_4_BetaGamma_Entropy', 'All_sym6_Delta_Mean', 'All_sym6_Delta_Median', 'All_sym6_Delta_Min', 'All_sym6_Delta_Max', 'All_sym6_Delta_Var', 'All_sym6_Delta_Power', 'All_sym6_Delta_Skewness', 'All_sym6_Delta_Entropy', 'All_sym6_Theta_Mean', 'All_sym6_Theta_Median', 'All_sym6_Theta_Min', 'All_sym6_Theta_Max', 'All_sym6_Theta_Var', 'All_sym6_Theta_Power', 'All_sym6_Theta_Skewness', 'All_sym6_Theta_Entropy', 'All_sym6_Alpha_Mean', 'All_sym6_Alpha_Median', 'All_sym6_Alpha_Min', 'All_sym6_Alpha_Max', 'All_sym6_Alpha_Var', 'All_sym6_Alpha_Power', 'All_sym6_Alpha_Skewness', 'All_sym6_Alpha_Entropy', 'All_sym6_BetaGamma_Mean', 'All_sym6_BetaGamma_Median', 'All_sym6_BetaGamma_Min', 'All_sym6_BetaGamma_Max', 'All_sym6_BetaGamma_Var', 'All_sym6_BetaGamma_Power', 'All_sym6_BetaGamma_Skewness', 'All_sym6_BetaGamma_Entropy', 'All_db4_Delta_Mean', 'All_db4_Delta_Median', 'All_db4_Delta_Min', 'All_db4_Delta_Max', 'All_db4_Delta_Var', 'All_db4_Delta_Power', 'All_db4_Delta_Skewness', 'All_db4_Delta_Entropy', 'All_db4_Theta_Mean', 'All_db4_Theta_Median', 'All_db4_Theta_Min', 'All_db4_Theta_Max', 'All_db4_Theta_Var', 'All_db4_Theta_Power', 'All_db4_Theta_Skewness', 'All_db4_Theta_Entropy', 'All_db4_Alpha_Mean', 'All_db4_Alpha_Median', 'All_db4_Alpha_Min', 'All_db4_Alpha_Max', 'All_db4_Alpha_Var', 'All_db4_Alpha_Power', 'All_db4_Alpha_Skewness', 'All_db4_Alpha_Entropy', 'All_db4_BetaGamma_Mean', 'All_db4_BetaGamma_Median', 'All_db4_BetaGamma_Min', 'All_db4_BetaGamma_Max', 'All_db4_BetaGamma_Var', 'All_db4_BetaGamma_Power', 'All_db4_BetaGamma_Skewness', 'All_db4_BetaGamma_Entropy', 'Occ_AmpMean', 'Occ_AmpStd', 'Occ_AmpMedian', 'Occ_AmpVar', 'Occ_AmpMax', 'Occ_AmpMin', 'Occ_PeakLat', 'Occ_PeakDur', 'Occ_PhaseDiff', 'Occ_InstFreq', 'Occ_Pentropy', 'Occ_ZeroCross', 'Occ_PFD', 'Occ_Mobility', 'Occ_Activity', 'Occ_LowFreqAmp', 'Occ_zScore', 'Occ_mAmplitude', 'Occ_mLatency', 'Occ_mDuration', 'Occ_mProminence', 'Occ_phaseDatVar', 'Occ_bior2_2_Delta_Mean', 'Occ_bior2_2_Delta_Median', 'Occ_bior2_2_Delta_Min', 'Occ_bior2_2_Delta_Max', 'Occ_bior2_2_Delta_Var', 'Occ_bior2_2_Delta_Power', 'Occ_bior2_2_Delta_Skewness', 'Occ_bior2_2_Delta_Entropy', 'Occ_bior2_2_Theta_Mean', 'Occ_bior2_2_Theta_Median', 'Occ_bior2_2_Theta_Min', 'Occ_bior2_2_Theta_Max', 'Occ_bior2_2_Theta_Var', 'Occ_bior2_2_Theta_Power', 'Occ_bior2_2_Theta_Skewness', 'Occ_bior2_2_Theta_Entropy', 'Occ_bior2_2_Alpha_Mean', 'Occ_bior2_2_Alpha_Median', 'Occ_bior2_2_Alpha_Min', 'Occ_bior2_2_Alpha_Max', 'Occ_bior2_2_Alpha_Var', 'Occ_bior2_2_Alpha_Power', 'Occ_bior2_2_Alpha_Skewness', 'Occ_bior2_2_Alpha_Entropy', 'Occ_bior2_2_BetaGamma_Mean', 'Occ_bior2_2_BetaGamma_Median', 'Occ_bior2_2_BetaGamma_Min', 'Occ_bior2_2_BetaGamma_Max', 'Occ_bior2_2_BetaGamma_Var', 'Occ_bior2_2_BetaGamma_Power', 'Occ_bior2_2_BetaGamma_Skewness', 'Occ_bior2_2_BetaGamma_Entropy', 'Occ_bior4_4_Delta_Mean', 'Occ_bior4_4_Delta_Median', 'Occ_bior4_4_Delta_Min', 'Occ_bior4_4_Delta_Max', 'Occ_bior4_4_Delta_Var', 'Occ_bior4_4_Delta_Power', 'Occ_bior4_4_Delta_Skewness', 'Occ_bior4_4_Delta_Entropy', 'Occ_bior4_4_Theta_Mean', 'Occ_bior4_4_Theta_Median', 'Occ_bior4_4_Theta_Min', 'Occ_bior4_4_Theta_Max', 'Occ_bior4_4_Theta_Var', 'Occ_bior4_4_Theta_Power', 'Occ_bior4_4_Theta_Skewness', 'Occ_bior4_4_Theta_Entropy', 'Occ_bior4_4_Alpha_Mean', 'Occ_bior4_4_Alpha_Median', 'Occ_bior4_4_Alpha_Min', 'Occ_bior4_4_Alpha_Max', 'Occ_bior4_4_Alpha_Var', 'Occ_bior4_4_Alpha_Power', 'Occ_bior4_4_Alpha_Skewness', 'Occ_bior4_4_Alpha_Entropy', 'Occ_bior4_4_BetaGamma_Mean', 'Occ_bior4_4_BetaGamma_Median', 'Occ_bior4_4_BetaGamma_Min', 'Occ_bior4_4_BetaGamma_Max', 'Occ_bior4_4_BetaGamma_Var', 'Occ_bior4_4_BetaGamma_Power', 'Occ_bior4_4_BetaGamma_Skewness', 'Occ_bior4_4_BetaGamma_Entropy', 'Occ_sym6_Delta_Mean', 'Occ_sym6_Delta_Median', 'Occ_sym6_Delta_Min', 'Occ_sym6_Delta_Max', 'Occ_sym6_Delta_Var', 'Occ_sym6_Delta_Power', 'Occ_sym6_Delta_Skewness', 'Occ_sym6_Delta_Entropy', 'Occ_sym6_Theta_Mean', 'Occ_sym6_Theta_Median', 'Occ_sym6_Theta_Min', 'Occ_sym6_Theta_Max', 'Occ_sym6_Theta_Var', 'Occ_sym6_Theta_Power', 'Occ_sym6_Theta_Skewness', 'Occ_sym6_Theta_Entropy', 'Occ_sym6_Alpha_Mean', 'Occ_sym6_Alpha_Median', 'Occ_sym6_Alpha_Min', 'Occ_sym6_Alpha_Max', 'Occ_sym6_Alpha_Var', 'Occ_sym6_Alpha_Power', 'Occ_sym6_Alpha_Skewness', 'Occ_sym6_Alpha_Entropy', 'Occ_sym6_BetaGamma_Mean', 'Occ_sym6_BetaGamma_Median', 'Occ_sym6_BetaGamma_Min', 'Occ_sym6_BetaGamma_Max', 'Occ_sym6_BetaGamma_Var', 'Occ_sym6_BetaGamma_Power', 'Occ_sym6_BetaGamma_Skewness', 'Occ_sym6_BetaGamma_Entropy', 'Occ_db4_Delta_Mean', 'Occ_db4_Delta_Median', 'Occ_db4_Delta_Min', 'Occ_db4_Delta_Max', 'Occ_db4_Delta_Var', 'Occ_db4_Delta_Power', 'Occ_db4_Delta_Skewness', 'Occ_db4_Delta_Entropy', 'Occ_db4_Theta_Mean', 'Occ_db4_Theta_Median', 'Occ_db4_Theta_Min', 'Occ_db4_Theta_Max', 'Occ_db4_Theta_Var', 'Occ_db4_Theta_Power', 'Occ_db4_Theta_Skewness', 'Occ_db4_Theta_Entropy', 'Occ_db4_Alpha_Mean', 'Occ_db4_Alpha_Median', 'Occ_db4_Alpha_Min', 'Occ_db4_Alpha_Max', 'Occ_db4_Alpha_Var', 'Occ_db4_Alpha_Power', 'Occ_db4_Alpha_Skewness', 'Occ_db4_Alpha_Entropy', 'Occ_db4_BetaGamma_Mean', 'Occ_db4_BetaGamma_Median', 'Occ_db4_BetaGamma_Min', 'Occ_db4_BetaGamma_Max', 'Occ_db4_BetaGamma_Var', 'Occ_db4_BetaGamma_Power', 'Occ_db4_BetaGamma_Skewness', 'Occ_db4_BetaGamma_Entropy', 'Ref_AmpMean', 'Ref_AmpStd', 'Ref_AmpMedian', 'Ref_AmpVar', 'Ref_AmpMax', 'Ref_AmpMin', 'Ref_PeakLat', 'Ref_PeakDur', 'Ref_PhaseDiff', 'Ref_InstFreq', 'Ref_Pentropy', 'Ref_ZeroCross', 'Ref_PFD', 'Ref_Mobility', 'Ref_Activity', 'Ref_LowFreqAmp', 'Ref_zScore', 'Ref_mAmplitude', 'Ref_mLatency', 'Ref_mDuration', 'Ref_mProminence', 'Ref_phaseDatVar', 'Ref_bior2_2_Delta_Mean', 'Ref_bior2_2_Delta_Median', 'Ref_bior2_2_Delta_Min', 'Ref_bior2_2_Delta_Max', 'Ref_bior2_2_Delta_Var', 'Ref_bior2_2_Delta_Power', 'Ref_bior2_2_Delta_Skewness', 'Ref_bior2_2_Delta_Entropy', 'Ref_bior2_2_Theta_Mean', 'Ref_bior2_2_Theta_Median', 'Ref_bior2_2_Theta_Min', 'Ref_bior2_2_Theta_Max', 'Ref_bior2_2_Theta_Var', 'Ref_bior2_2_Theta_Power', 'Ref_bior2_2_Theta_Skewness', 'Ref_bior2_2_Theta_Entropy', 'Ref_bior2_2_Alpha_Mean', 'Ref_bior2_2_Alpha_Median', 'Ref_bior2_2_Alpha_Min', 'Ref_bior2_2_Alpha_Max', 'Ref_bior2_2_Alpha_Var', 'Ref_bior2_2_Alpha_Power', 'Ref_bior2_2_Alpha_Skewness', 'Ref_bior2_2_Alpha_Entropy', 'Ref_bior2_2_BetaGamma_Mean', 'Ref_bior2_2_BetaGamma_Median', 'Ref_bior2_2_BetaGamma_Min', 'Ref_bior2_2_BetaGamma_Max', 'Ref_bior2_2_BetaGamma_Var', 'Ref_bior2_2_BetaGamma_Power', 'Ref_bior2_2_BetaGamma_Skewness', 'Ref_bior2_2_BetaGamma_Entropy', 'Ref_bior4_4_Delta_Mean', 'Ref_bior4_4_Delta_Median', 'Ref_bior4_4_Delta_Min', 'Ref_bior4_4_Delta_Max', 'Ref_bior4_4_Delta_Var', 'Ref_bior4_4_Delta_Power', 'Ref_bior4_4_Delta_Skewness', 'Ref_bior4_4_Delta_Entropy', 'Ref_bior4_4_Theta_Mean', 'Ref_bior4_4_Theta_Median', 'Ref_bior4_4_Theta_Min', 'Ref_bior4_4_Theta_Max', 'Ref_bior4_4_Theta_Var', 'Ref_bior4_4_Theta_Power', 'Ref_bior4_4_Theta_Skewness', 'Ref_bior4_4_Theta_Entropy', 'Ref_bior4_4_Alpha_Mean', 'Ref_bior4_4_Alpha_Median', 'Ref_bior4_4_Alpha_Min', 'Ref_bior4_4_Alpha_Max', 'Ref_bior4_4_Alpha_Var', 'Ref_bior4_4_Alpha_Power', 'Ref_bior4_4_Alpha_Skewness', 'Ref_bior4_4_Alpha_Entropy', 'Ref_bior4_4_BetaGamma_Mean', 'Ref_bior4_4_BetaGamma_Median', 'Ref_bior4_4_BetaGamma_Min', 'Ref_bior4_4_BetaGamma_Max', 'Ref_bior4_4_BetaGamma_Var', 'Ref_bior4_4_BetaGamma_Power', 'Ref_bior4_4_BetaGamma_Skewness', 'Ref_bior4_4_BetaGamma_Entropy', 'Ref_sym6_Delta_Mean', 'Ref_sym6_Delta_Median', 'Ref_sym6_Delta_Min', 'Ref_sym6_Delta_Max', 'Ref_sym6_Delta_Var', 'Ref_sym6_Delta_Power', 'Ref_sym6_Delta_Skewness', 'Ref_sym6_Delta_Entropy', 'Ref_sym6_Theta_Mean', 'Ref_sym6_Theta_Median', 'Ref_sym6_Theta_Min', 'Ref_sym6_Theta_Max', 'Ref_sym6_Theta_Var', 'Ref_sym6_Theta_Power', 'Ref_sym6_Theta_Skewness', 'Ref_sym6_Theta_Entropy', 'Ref_sym6_Alpha_Mean', 'Ref_sym6_Alpha_Median', 'Ref_sym6_Alpha_Min', 'Ref_sym6_Alpha_Max', 'Ref_sym6_Alpha_Var', 'Ref_sym6_Alpha_Power', 'Ref_sym6_Alpha_Skewness', 'Ref_sym6_Alpha_Entropy', 'Ref_sym6_BetaGamma_Mean', 'Ref_sym6_BetaGamma_Median', 'Ref_sym6_BetaGamma_Min', 'Ref_sym6_BetaGamma_Max', 'Ref_sym6_BetaGamma_Var', 'Ref_sym6_BetaGamma_Power', 'Ref_sym6_BetaGamma_Skewness', 'Ref_sym6_BetaGamma_Entropy', 'Ref_db4_Delta_Mean', 'Ref_db4_Delta_Median', 'Ref_db4_Delta_Min', 'Ref_db4_Delta_Max', 'Ref_db4_Delta_Var', 'Ref_db4_Delta_Power', 'Ref_db4_Delta_Skewness', 'Ref_db4_Delta_Entropy', 'Ref_db4_Theta_Mean', 'Ref_db4_Theta_Median', 'Ref_db4_Theta_Min', 'Ref_db4_Theta_Max', 'Ref_db4_Theta_Var', 'Ref_db4_Theta_Power', 'Ref_db4_Theta_Skewness', 'Ref_db4_Theta_Entropy', 'Ref_db4_Alpha_Mean', 'Ref_db4_Alpha_Median', 'Ref_db4_Alpha_Min', 'Ref_db4_Alpha_Max', 'Ref_db4_Alpha_Var', 'Ref_db4_Alpha_Power', 'Ref_db4_Alpha_Skewness', 'Ref_db4_Alpha_Entropy', 'Ref_db4_BetaGamma_Mean', 'Ref_db4_BetaGamma_Median', 'Ref_db4_BetaGamma_Min', 'Ref_db4_BetaGamma_Max', 'Ref_db4_BetaGamma_Var', 'Ref_db4_BetaGamma_Power', 'Ref_db4_BetaGamma_Skewness', 'Ref_db4_BetaGamma_Entropy', 'Diff_bior2_2_Delta_Mean', 'Diff_bior2_2_Delta_Median', 'Diff_bior2_2_Delta_Min', 'Diff_bior2_2_Delta_Max', 'Diff_bior2_2_Delta_Var', 'Diff_bior2_2_Delta_Power', 'Diff_bior2_2_Delta_Skewness', 'Diff_bior2_2_Delta_Entropy', 'Diff_bior2_2_Theta_Mean', 'Diff_bior2_2_Theta_Median', 'Diff_bior2_2_Theta_Min', 'Diff_bior2_2_Theta_Max', 'Diff_bior2_2_Theta_Var', 'Diff_bior2_2_Theta_Power', 'Diff_bior2_2_Theta_Skewness', 'Diff_bior2_2_Theta_Entropy', 'Diff_bior2_2_Alpha_Mean', 'Diff_bior2_2_Alpha_Median', 'Diff_bior2_2_Alpha_Min', 'Diff_bior2_2_Alpha_Max', 'Diff_bior2_2_Alpha_Var', 'Diff_bior2_2_Alpha_Power', 'Diff_bior2_2_Alpha_Skewness', 'Diff_bior2_2_Alpha_Entropy', 'Diff_bior2_2_BetaGamma_Mean', 'Diff_bior2_2_BetaGamma_Median', 'Diff_bior2_2_BetaGamma_Min', 'Diff_bior2_2_BetaGamma_Max', 'Diff_bior2_2_BetaGamma_Var', 'Diff_bior2_2_BetaGamma_Power', 'Diff_bior2_2_BetaGamma_Skewness', 'Diff_bior2_2_BetaGamma_Entropy', 'Diff_bior4_4_Delta_Mean', 'Diff_bior4_4_Delta_Median', 'Diff_bior4_4_Delta_Min', 'Diff_bior4_4_Delta_Max', 'Diff_bior4_4_Delta_Var', 'Diff_bior4_4_Delta_Power', 'Diff_bior4_4_Delta_Skewness', 'Diff_bior4_4_Delta_Entropy', 'Diff_bior4_4_Theta_Mean', 'Diff_bior4_4_Theta_Median', 'Diff_bior4_4_Theta_Min', 'Diff_bior4_4_Theta_Max', 'Diff_bior4_4_Theta_Var', 'Diff_bior4_4_Theta_Power', 'Diff_bior4_4_Theta_Skewness', 'Diff_bior4_4_Theta_Entropy', 'Diff_bior4_4_Alpha_Mean', 'Diff_bior4_4_Alpha_Median', 'Diff_bior4_4_Alpha_Min', 'Diff_bior4_4_Alpha_Max', 'Diff_bior4_4_Alpha_Var', 'Diff_bior4_4_Alpha_Power', 'Diff_bior4_4_Alpha_Skewness', 'Diff_bior4_4_Alpha_Entropy', 'Diff_bior4_4_BetaGamma_Mean', 'Diff_bior4_4_BetaGamma_Median', 'Diff_bior4_4_BetaGamma_Min', 'Diff_bior4_4_BetaGamma_Max', 'Diff_bior4_4_BetaGamma_Var', 'Diff_bior4_4_BetaGamma_Power', 'Diff_bior4_4_BetaGamma_Skewness', 'Diff_bior4_4_BetaGamma_Entropy', 'Diff_sym6_Delta_Mean', 'Diff_sym6_Delta_Median', 'Diff_sym6_Delta_Min', 'Diff_sym6_Delta_Max', 'Diff_sym6_Delta_Var', 'Diff_sym6_Delta_Power', 'Diff_sym6_Delta_Skewness', 'Diff_sym6_Delta_Entropy', 'Diff_sym6_Theta_Mean', 'Diff_sym6_Theta_Median', 'Diff_sym6_Theta_Min', 'Diff_sym6_Theta_Max', 'Diff_sym6_Theta_Var', 'Diff_sym6_Theta_Power', 'Diff_sym6_Theta_Skewness', 'Diff_sym6_Theta_Entropy', 'Diff_sym6_Alpha_Mean', 'Diff_sym6_Alpha_Median', 'Diff_sym6_Alpha_Min', 'Diff_sym6_Alpha_Max', 'Diff_sym6_Alpha_Var', 'Diff_sym6_Alpha_Power', 'Diff_sym6_Alpha_Skewness', 'Diff_sym6_Alpha_Entropy', 'Diff_sym6_BetaGamma_Mean', 'Diff_sym6_BetaGamma_Median', 'Diff_sym6_BetaGamma_Min', 'Diff_sym6_BetaGamma_Max', 'Diff_sym6_BetaGamma_Var', 'Diff_sym6_BetaGamma_Power', 'Diff_sym6_BetaGamma_Skewness', 'Diff_sym6_BetaGamma_Entropy', 'Diff_db4_Delta_Mean', 'Diff_db4_Delta_Median', 'Diff_db4_Delta_Min', 'Diff_db4_Delta_Max', 'Diff_db4_Delta_Var', 'Diff_db4_Delta_Power', 'Diff_db4_Delta_Skewness', 'Diff_db4_Delta_Entropy', 'Diff_db4_Theta_Mean', 'Diff_db4_Theta_Median', 'Diff_db4_Theta_Min', 'Diff_db4_Theta_Max', 'Diff_db4_Theta_Var', 'Diff_db4_Theta_Power', 'Diff_db4_Theta_Skewness', 'Diff_db4_Theta_Entropy', 'Diff_db4_Alpha_Mean', 'Diff_db4_Alpha_Median', 'Diff_db4_Alpha_Min', 'Diff_db4_Alpha_Max', 'Diff_db4_Alpha_Var', 'Diff_db4_Alpha_Power', 'Diff_db4_Alpha_Skewness', 'Diff_db4_Alpha_Entropy', 'Diff_db4_BetaGamma_Mean', 'Diff_db4_BetaGamma_Median', 'Diff_db4_BetaGamma_Min', 'Diff_db4_BetaGamma_Max', 'Diff_db4_BetaGamma_Var', 'Diff_db4_BetaGamma_Power', 'Diff_db4_BetaGamma_Skewness', 'Diff_db4_BetaGamma_Entropy','Class'};
P = train.score{1,1};
% Set predictor names
predictorNames = {'All_AmpMean', 'All_AmpStd', 'All_AmpMedian', 'All_AmpVar', 'All_AmpMax', 'All_AmpMin', 'All_PeakLat', 'All_PeakDur', 'All_PhaseDiff', 'All_InstFreq', 'All_Pentropy', 'All_ZeroCross', 'All_PFD', 'All_Mobility', 'All_Activity', 'All_LowFreqAmp', 'All_zScore', 'All_mAmplitude', 'All_mLatency', 'All_mDuration', 'All_mProminence', 'All_phaseDatVar', 'All_bior2_2_Delta_Mean', 'All_bior2_2_Delta_Median', 'All_bior2_2_Delta_Min', 'All_bior2_2_Delta_Max', 'All_bior2_2_Delta_Var', 'All_bior2_2_Delta_Power', 'All_bior2_2_Delta_Skewness', 'All_bior2_2_Delta_Entropy', 'All_bior2_2_Theta_Mean', 'All_bior2_2_Theta_Median', 'All_bior2_2_Theta_Min', 'All_bior2_2_Theta_Max', 'All_bior2_2_Theta_Var', 'All_bior2_2_Theta_Power', 'All_bior2_2_Theta_Skewness', 'All_bior2_2_Theta_Entropy', 'All_bior2_2_Alpha_Mean', 'All_bior2_2_Alpha_Median', 'All_bior2_2_Alpha_Min', 'All_bior2_2_Alpha_Max', 'All_bior2_2_Alpha_Var', 'All_bior2_2_Alpha_Power', 'All_bior2_2_Alpha_Skewness', 'All_bior2_2_Alpha_Entropy', 'All_bior2_2_BetaGamma_Mean', 'All_bior2_2_BetaGamma_Median', 'All_bior2_2_BetaGamma_Min', 'All_bior2_2_BetaGamma_Max', 'All_bior2_2_BetaGamma_Var', 'All_bior2_2_BetaGamma_Power', 'All_bior2_2_BetaGamma_Skewness', 'All_bior2_2_BetaGamma_Entropy', 'All_bior4_4_Delta_Mean', 'All_bior4_4_Delta_Median', 'All_bior4_4_Delta_Min', 'All_bior4_4_Delta_Max', 'All_bior4_4_Delta_Var', 'All_bior4_4_Delta_Power', 'All_bior4_4_Delta_Skewness', 'All_bior4_4_Delta_Entropy', 'All_bior4_4_Theta_Mean', 'All_bior4_4_Theta_Median', 'All_bior4_4_Theta_Min', 'All_bior4_4_Theta_Max', 'All_bior4_4_Theta_Var', 'All_bior4_4_Theta_Power', 'All_bior4_4_Theta_Skewness', 'All_bior4_4_Theta_Entropy', 'All_bior4_4_Alpha_Mean', 'All_bior4_4_Alpha_Median', 'All_bior4_4_Alpha_Min', 'All_bior4_4_Alpha_Max', 'All_bior4_4_Alpha_Var', 'All_bior4_4_Alpha_Power', 'All_bior4_4_Alpha_Skewness', 'All_bior4_4_Alpha_Entropy', 'All_bior4_4_BetaGamma_Mean', 'All_bior4_4_BetaGamma_Median', 'All_bior4_4_BetaGamma_Min', 'All_bior4_4_BetaGamma_Max', 'All_bior4_4_BetaGamma_Var', 'All_bior4_4_BetaGamma_Power', 'All_bior4_4_BetaGamma_Skewness', 'All_bior4_4_BetaGamma_Entropy', 'All_sym6_Delta_Mean', 'All_sym6_Delta_Median', 'All_sym6_Delta_Min', 'All_sym6_Delta_Max', 'All_sym6_Delta_Var', 'All_sym6_Delta_Power', 'All_sym6_Delta_Skewness', 'All_sym6_Delta_Entropy', 'All_sym6_Theta_Mean', 'All_sym6_Theta_Median', 'All_sym6_Theta_Min', 'All_sym6_Theta_Max', 'All_sym6_Theta_Var', 'All_sym6_Theta_Power', 'All_sym6_Theta_Skewness', 'All_sym6_Theta_Entropy', 'All_sym6_Alpha_Mean', 'All_sym6_Alpha_Median', 'All_sym6_Alpha_Min', 'All_sym6_Alpha_Max', 'All_sym6_Alpha_Var', 'All_sym6_Alpha_Power', 'All_sym6_Alpha_Skewness', 'All_sym6_Alpha_Entropy', 'All_sym6_BetaGamma_Mean', 'All_sym6_BetaGamma_Median', 'All_sym6_BetaGamma_Min', 'All_sym6_BetaGamma_Max', 'All_sym6_BetaGamma_Var', 'All_sym6_BetaGamma_Power', 'All_sym6_BetaGamma_Skewness', 'All_sym6_BetaGamma_Entropy', 'All_db4_Delta_Mean', 'All_db4_Delta_Median', 'All_db4_Delta_Min', 'All_db4_Delta_Max', 'All_db4_Delta_Var', 'All_db4_Delta_Power', 'All_db4_Delta_Skewness', 'All_db4_Delta_Entropy', 'All_db4_Theta_Mean', 'All_db4_Theta_Median', 'All_db4_Theta_Min', 'All_db4_Theta_Max', 'All_db4_Theta_Var', 'All_db4_Theta_Power', 'All_db4_Theta_Skewness', 'All_db4_Theta_Entropy', 'All_db4_Alpha_Mean', 'All_db4_Alpha_Median', 'All_db4_Alpha_Min', 'All_db4_Alpha_Max', 'All_db4_Alpha_Var', 'All_db4_Alpha_Power', 'All_db4_Alpha_Skewness', 'All_db4_Alpha_Entropy', 'All_db4_BetaGamma_Mean', 'All_db4_BetaGamma_Median', 'All_db4_BetaGamma_Min', 'All_db4_BetaGamma_Max', 'All_db4_BetaGamma_Var', 'All_db4_BetaGamma_Power', 'All_db4_BetaGamma_Skewness', 'All_db4_BetaGamma_Entropy', 'Occ_AmpMean', 'Occ_AmpStd', 'Occ_AmpMedian', 'Occ_AmpVar', 'Occ_AmpMax', 'Occ_AmpMin', 'Occ_PeakLat', 'Occ_PeakDur', 'Occ_PhaseDiff', 'Occ_InstFreq', 'Occ_Pentropy', 'Occ_ZeroCross', 'Occ_PFD', 'Occ_Mobility', 'Occ_Activity', 'Occ_LowFreqAmp', 'Occ_zScore', 'Occ_mAmplitude', 'Occ_mLatency', 'Occ_mDuration', 'Occ_mProminence', 'Occ_phaseDatVar', 'Occ_bior2_2_Delta_Mean', 'Occ_bior2_2_Delta_Median', 'Occ_bior2_2_Delta_Min', 'Occ_bior2_2_Delta_Max', 'Occ_bior2_2_Delta_Var', 'Occ_bior2_2_Delta_Power', 'Occ_bior2_2_Delta_Skewness', 'Occ_bior2_2_Delta_Entropy', 'Occ_bior2_2_Theta_Mean', 'Occ_bior2_2_Theta_Median', 'Occ_bior2_2_Theta_Min', 'Occ_bior2_2_Theta_Max', 'Occ_bior2_2_Theta_Var', 'Occ_bior2_2_Theta_Power', 'Occ_bior2_2_Theta_Skewness', 'Occ_bior2_2_Theta_Entropy', 'Occ_bior2_2_Alpha_Mean', 'Occ_bior2_2_Alpha_Median', 'Occ_bior2_2_Alpha_Min', 'Occ_bior2_2_Alpha_Max', 'Occ_bior2_2_Alpha_Var', 'Occ_bior2_2_Alpha_Power', 'Occ_bior2_2_Alpha_Skewness', 'Occ_bior2_2_Alpha_Entropy', 'Occ_bior2_2_BetaGamma_Mean', 'Occ_bior2_2_BetaGamma_Median', 'Occ_bior2_2_BetaGamma_Min', 'Occ_bior2_2_BetaGamma_Max', 'Occ_bior2_2_BetaGamma_Var', 'Occ_bior2_2_BetaGamma_Power', 'Occ_bior2_2_BetaGamma_Skewness', 'Occ_bior2_2_BetaGamma_Entropy', 'Occ_bior4_4_Delta_Mean', 'Occ_bior4_4_Delta_Median', 'Occ_bior4_4_Delta_Min', 'Occ_bior4_4_Delta_Max', 'Occ_bior4_4_Delta_Var', 'Occ_bior4_4_Delta_Power', 'Occ_bior4_4_Delta_Skewness', 'Occ_bior4_4_Delta_Entropy', 'Occ_bior4_4_Theta_Mean', 'Occ_bior4_4_Theta_Median', 'Occ_bior4_4_Theta_Min', 'Occ_bior4_4_Theta_Max', 'Occ_bior4_4_Theta_Var', 'Occ_bior4_4_Theta_Power', 'Occ_bior4_4_Theta_Skewness', 'Occ_bior4_4_Theta_Entropy', 'Occ_bior4_4_Alpha_Mean', 'Occ_bior4_4_Alpha_Median', 'Occ_bior4_4_Alpha_Min', 'Occ_bior4_4_Alpha_Max', 'Occ_bior4_4_Alpha_Var', 'Occ_bior4_4_Alpha_Power', 'Occ_bior4_4_Alpha_Skewness', 'Occ_bior4_4_Alpha_Entropy', 'Occ_bior4_4_BetaGamma_Mean', 'Occ_bior4_4_BetaGamma_Median', 'Occ_bior4_4_BetaGamma_Min', 'Occ_bior4_4_BetaGamma_Max', 'Occ_bior4_4_BetaGamma_Var', 'Occ_bior4_4_BetaGamma_Power', 'Occ_bior4_4_BetaGamma_Skewness', 'Occ_bior4_4_BetaGamma_Entropy', 'Occ_sym6_Delta_Mean', 'Occ_sym6_Delta_Median', 'Occ_sym6_Delta_Min', 'Occ_sym6_Delta_Max', 'Occ_sym6_Delta_Var', 'Occ_sym6_Delta_Power', 'Occ_sym6_Delta_Skewness', 'Occ_sym6_Delta_Entropy', 'Occ_sym6_Theta_Mean', 'Occ_sym6_Theta_Median', 'Occ_sym6_Theta_Min', 'Occ_sym6_Theta_Max', 'Occ_sym6_Theta_Var', 'Occ_sym6_Theta_Power', 'Occ_sym6_Theta_Skewness', 'Occ_sym6_Theta_Entropy', 'Occ_sym6_Alpha_Mean', 'Occ_sym6_Alpha_Median', 'Occ_sym6_Alpha_Min', 'Occ_sym6_Alpha_Max', 'Occ_sym6_Alpha_Var', 'Occ_sym6_Alpha_Power', 'Occ_sym6_Alpha_Skewness', 'Occ_sym6_Alpha_Entropy', 'Occ_sym6_BetaGamma_Mean', 'Occ_sym6_BetaGamma_Median', 'Occ_sym6_BetaGamma_Min', 'Occ_sym6_BetaGamma_Max', 'Occ_sym6_BetaGamma_Var', 'Occ_sym6_BetaGamma_Power', 'Occ_sym6_BetaGamma_Skewness', 'Occ_sym6_BetaGamma_Entropy', 'Occ_db4_Delta_Mean', 'Occ_db4_Delta_Median', 'Occ_db4_Delta_Min', 'Occ_db4_Delta_Max', 'Occ_db4_Delta_Var', 'Occ_db4_Delta_Power', 'Occ_db4_Delta_Skewness', 'Occ_db4_Delta_Entropy', 'Occ_db4_Theta_Mean', 'Occ_db4_Theta_Median', 'Occ_db4_Theta_Min', 'Occ_db4_Theta_Max', 'Occ_db4_Theta_Var', 'Occ_db4_Theta_Power', 'Occ_db4_Theta_Skewness', 'Occ_db4_Theta_Entropy', 'Occ_db4_Alpha_Mean', 'Occ_db4_Alpha_Median', 'Occ_db4_Alpha_Min', 'Occ_db4_Alpha_Max', 'Occ_db4_Alpha_Var', 'Occ_db4_Alpha_Power', 'Occ_db4_Alpha_Skewness', 'Occ_db4_Alpha_Entropy', 'Occ_db4_BetaGamma_Mean', 'Occ_db4_BetaGamma_Median', 'Occ_db4_BetaGamma_Min', 'Occ_db4_BetaGamma_Max', 'Occ_db4_BetaGamma_Var', 'Occ_db4_BetaGamma_Power', 'Occ_db4_BetaGamma_Skewness', 'Occ_db4_BetaGamma_Entropy', 'Ref_AmpMean', 'Ref_AmpStd', 'Ref_AmpMedian', 'Ref_AmpVar', 'Ref_AmpMax', 'Ref_AmpMin', 'Ref_PeakLat', 'Ref_PeakDur', 'Ref_PhaseDiff', 'Ref_InstFreq', 'Ref_Pentropy', 'Ref_ZeroCross', 'Ref_PFD', 'Ref_Mobility', 'Ref_Activity', 'Ref_LowFreqAmp', 'Ref_zScore', 'Ref_mAmplitude', 'Ref_mLatency', 'Ref_mDuration', 'Ref_mProminence', 'Ref_phaseDatVar', 'Ref_bior2_2_Delta_Mean', 'Ref_bior2_2_Delta_Median', 'Ref_bior2_2_Delta_Min', 'Ref_bior2_2_Delta_Max', 'Ref_bior2_2_Delta_Var', 'Ref_bior2_2_Delta_Power', 'Ref_bior2_2_Delta_Skewness', 'Ref_bior2_2_Delta_Entropy', 'Ref_bior2_2_Theta_Mean', 'Ref_bior2_2_Theta_Median', 'Ref_bior2_2_Theta_Min', 'Ref_bior2_2_Theta_Max', 'Ref_bior2_2_Theta_Var', 'Ref_bior2_2_Theta_Power', 'Ref_bior2_2_Theta_Skewness', 'Ref_bior2_2_Theta_Entropy', 'Ref_bior2_2_Alpha_Mean', 'Ref_bior2_2_Alpha_Median', 'Ref_bior2_2_Alpha_Min', 'Ref_bior2_2_Alpha_Max', 'Ref_bior2_2_Alpha_Var', 'Ref_bior2_2_Alpha_Power', 'Ref_bior2_2_Alpha_Skewness', 'Ref_bior2_2_Alpha_Entropy', 'Ref_bior2_2_BetaGamma_Mean', 'Ref_bior2_2_BetaGamma_Median', 'Ref_bior2_2_BetaGamma_Min', 'Ref_bior2_2_BetaGamma_Max', 'Ref_bior2_2_BetaGamma_Var', 'Ref_bior2_2_BetaGamma_Power', 'Ref_bior2_2_BetaGamma_Skewness', 'Ref_bior2_2_BetaGamma_Entropy', 'Ref_bior4_4_Delta_Mean', 'Ref_bior4_4_Delta_Median', 'Ref_bior4_4_Delta_Min', 'Ref_bior4_4_Delta_Max', 'Ref_bior4_4_Delta_Var', 'Ref_bior4_4_Delta_Power', 'Ref_bior4_4_Delta_Skewness', 'Ref_bior4_4_Delta_Entropy', 'Ref_bior4_4_Theta_Mean', 'Ref_bior4_4_Theta_Median', 'Ref_bior4_4_Theta_Min', 'Ref_bior4_4_Theta_Max', 'Ref_bior4_4_Theta_Var', 'Ref_bior4_4_Theta_Power', 'Ref_bior4_4_Theta_Skewness', 'Ref_bior4_4_Theta_Entropy', 'Ref_bior4_4_Alpha_Mean', 'Ref_bior4_4_Alpha_Median', 'Ref_bior4_4_Alpha_Min', 'Ref_bior4_4_Alpha_Max', 'Ref_bior4_4_Alpha_Var', 'Ref_bior4_4_Alpha_Power', 'Ref_bior4_4_Alpha_Skewness', 'Ref_bior4_4_Alpha_Entropy', 'Ref_bior4_4_BetaGamma_Mean', 'Ref_bior4_4_BetaGamma_Median', 'Ref_bior4_4_BetaGamma_Min', 'Ref_bior4_4_BetaGamma_Max', 'Ref_bior4_4_BetaGamma_Var', 'Ref_bior4_4_BetaGamma_Power', 'Ref_bior4_4_BetaGamma_Skewness', 'Ref_bior4_4_BetaGamma_Entropy', 'Ref_sym6_Delta_Mean', 'Ref_sym6_Delta_Median', 'Ref_sym6_Delta_Min', 'Ref_sym6_Delta_Max', 'Ref_sym6_Delta_Var', 'Ref_sym6_Delta_Power', 'Ref_sym6_Delta_Skewness', 'Ref_sym6_Delta_Entropy', 'Ref_sym6_Theta_Mean', 'Ref_sym6_Theta_Median', 'Ref_sym6_Theta_Min', 'Ref_sym6_Theta_Max', 'Ref_sym6_Theta_Var', 'Ref_sym6_Theta_Power', 'Ref_sym6_Theta_Skewness', 'Ref_sym6_Theta_Entropy', 'Ref_sym6_Alpha_Mean', 'Ref_sym6_Alpha_Median', 'Ref_sym6_Alpha_Min', 'Ref_sym6_Alpha_Max', 'Ref_sym6_Alpha_Var', 'Ref_sym6_Alpha_Power', 'Ref_sym6_Alpha_Skewness', 'Ref_sym6_Alpha_Entropy', 'Ref_sym6_BetaGamma_Mean', 'Ref_sym6_BetaGamma_Median', 'Ref_sym6_BetaGamma_Min', 'Ref_sym6_BetaGamma_Max', 'Ref_sym6_BetaGamma_Var', 'Ref_sym6_BetaGamma_Power', 'Ref_sym6_BetaGamma_Skewness', 'Ref_sym6_BetaGamma_Entropy', 'Ref_db4_Delta_Mean', 'Ref_db4_Delta_Median', 'Ref_db4_Delta_Min', 'Ref_db4_Delta_Max', 'Ref_db4_Delta_Var', 'Ref_db4_Delta_Power', 'Ref_db4_Delta_Skewness', 'Ref_db4_Delta_Entropy', 'Ref_db4_Theta_Mean', 'Ref_db4_Theta_Median', 'Ref_db4_Theta_Min', 'Ref_db4_Theta_Max', 'Ref_db4_Theta_Var', 'Ref_db4_Theta_Power', 'Ref_db4_Theta_Skewness', 'Ref_db4_Theta_Entropy', 'Ref_db4_Alpha_Mean', 'Ref_db4_Alpha_Median', 'Ref_db4_Alpha_Min', 'Ref_db4_Alpha_Max', 'Ref_db4_Alpha_Var', 'Ref_db4_Alpha_Power', 'Ref_db4_Alpha_Skewness', 'Ref_db4_Alpha_Entropy', 'Ref_db4_BetaGamma_Mean', 'Ref_db4_BetaGamma_Median', 'Ref_db4_BetaGamma_Min', 'Ref_db4_BetaGamma_Max', 'Ref_db4_BetaGamma_Var', 'Ref_db4_BetaGamma_Power', 'Ref_db4_BetaGamma_Skewness', 'Ref_db4_BetaGamma_Entropy', 'Diff_bior2_2_Delta_Mean', 'Diff_bior2_2_Delta_Median', 'Diff_bior2_2_Delta_Min', 'Diff_bior2_2_Delta_Max', 'Diff_bior2_2_Delta_Var', 'Diff_bior2_2_Delta_Power', 'Diff_bior2_2_Delta_Skewness', 'Diff_bior2_2_Delta_Entropy', 'Diff_bior2_2_Theta_Mean', 'Diff_bior2_2_Theta_Median', 'Diff_bior2_2_Theta_Min', 'Diff_bior2_2_Theta_Max', 'Diff_bior2_2_Theta_Var', 'Diff_bior2_2_Theta_Power', 'Diff_bior2_2_Theta_Skewness', 'Diff_bior2_2_Theta_Entropy', 'Diff_bior2_2_Alpha_Mean', 'Diff_bior2_2_Alpha_Median', 'Diff_bior2_2_Alpha_Min', 'Diff_bior2_2_Alpha_Max', 'Diff_bior2_2_Alpha_Var', 'Diff_bior2_2_Alpha_Power', 'Diff_bior2_2_Alpha_Skewness', 'Diff_bior2_2_Alpha_Entropy', 'Diff_bior2_2_BetaGamma_Mean', 'Diff_bior2_2_BetaGamma_Median', 'Diff_bior2_2_BetaGamma_Min', 'Diff_bior2_2_BetaGamma_Max', 'Diff_bior2_2_BetaGamma_Var', 'Diff_bior2_2_BetaGamma_Power', 'Diff_bior2_2_BetaGamma_Skewness', 'Diff_bior2_2_BetaGamma_Entropy', 'Diff_bior4_4_Delta_Mean', 'Diff_bior4_4_Delta_Median', 'Diff_bior4_4_Delta_Min', 'Diff_bior4_4_Delta_Max', 'Diff_bior4_4_Delta_Var', 'Diff_bior4_4_Delta_Power', 'Diff_bior4_4_Delta_Skewness', 'Diff_bior4_4_Delta_Entropy', 'Diff_bior4_4_Theta_Mean', 'Diff_bior4_4_Theta_Median', 'Diff_bior4_4_Theta_Min', 'Diff_bior4_4_Theta_Max', 'Diff_bior4_4_Theta_Var', 'Diff_bior4_4_Theta_Power', 'Diff_bior4_4_Theta_Skewness', 'Diff_bior4_4_Theta_Entropy', 'Diff_bior4_4_Alpha_Mean', 'Diff_bior4_4_Alpha_Median', 'Diff_bior4_4_Alpha_Min', 'Diff_bior4_4_Alpha_Max', 'Diff_bior4_4_Alpha_Var', 'Diff_bior4_4_Alpha_Power', 'Diff_bior4_4_Alpha_Skewness', 'Diff_bior4_4_Alpha_Entropy', 'Diff_bior4_4_BetaGamma_Mean', 'Diff_bior4_4_BetaGamma_Median', 'Diff_bior4_4_BetaGamma_Min', 'Diff_bior4_4_BetaGamma_Max', 'Diff_bior4_4_BetaGamma_Var', 'Diff_bior4_4_BetaGamma_Power', 'Diff_bior4_4_BetaGamma_Skewness', 'Diff_bior4_4_BetaGamma_Entropy', 'Diff_sym6_Delta_Mean', 'Diff_sym6_Delta_Median', 'Diff_sym6_Delta_Min', 'Diff_sym6_Delta_Max', 'Diff_sym6_Delta_Var', 'Diff_sym6_Delta_Power', 'Diff_sym6_Delta_Skewness', 'Diff_sym6_Delta_Entropy', 'Diff_sym6_Theta_Mean', 'Diff_sym6_Theta_Median', 'Diff_sym6_Theta_Min', 'Diff_sym6_Theta_Max', 'Diff_sym6_Theta_Var', 'Diff_sym6_Theta_Power', 'Diff_sym6_Theta_Skewness', 'Diff_sym6_Theta_Entropy', 'Diff_sym6_Alpha_Mean', 'Diff_sym6_Alpha_Median', 'Diff_sym6_Alpha_Min', 'Diff_sym6_Alpha_Max', 'Diff_sym6_Alpha_Var', 'Diff_sym6_Alpha_Power', 'Diff_sym6_Alpha_Skewness', 'Diff_sym6_Alpha_Entropy', 'Diff_sym6_BetaGamma_Mean', 'Diff_sym6_BetaGamma_Median', 'Diff_sym6_BetaGamma_Min', 'Diff_sym6_BetaGamma_Max', 'Diff_sym6_BetaGamma_Var', 'Diff_sym6_BetaGamma_Power', 'Diff_sym6_BetaGamma_Skewness', 'Diff_sym6_BetaGamma_Entropy', 'Diff_db4_Delta_Mean', 'Diff_db4_Delta_Median', 'Diff_db4_Delta_Min', 'Diff_db4_Delta_Max', 'Diff_db4_Delta_Var', 'Diff_db4_Delta_Power', 'Diff_db4_Delta_Skewness', 'Diff_db4_Delta_Entropy', 'Diff_db4_Theta_Mean', 'Diff_db4_Theta_Median', 'Diff_db4_Theta_Min', 'Diff_db4_Theta_Max', 'Diff_db4_Theta_Var', 'Diff_db4_Theta_Power', 'Diff_db4_Theta_Skewness', 'Diff_db4_Theta_Entropy', 'Diff_db4_Alpha_Mean', 'Diff_db4_Alpha_Median', 'Diff_db4_Alpha_Min', 'Diff_db4_Alpha_Max', 'Diff_db4_Alpha_Var', 'Diff_db4_Alpha_Power', 'Diff_db4_Alpha_Skewness', 'Diff_db4_Alpha_Entropy', 'Diff_db4_BetaGamma_Mean', 'Diff_db4_BetaGamma_Median', 'Diff_db4_BetaGamma_Min', 'Diff_db4_BetaGamma_Max', 'Diff_db4_BetaGamma_Var', 'Diff_db4_BetaGamma_Power', 'Diff_db4_BetaGamma_Skewness', 'Diff_db4_BetaGamma_Entropy'};

% Only uses features as indicated by feature vector
predictorNames = predictorNames(:,logical(minVect(end,:)));

% Extract predictors and response
% This code processes the data into the right shape for training the
% model.
predictors             = inputTable(:, predictorNames);
response               = inputTable.Class;

%isCategoricalPredictor= [false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false];

% Train a classifier
% This code specifies all the classifier options and trains the classifier.
        classificationSVM = fitcsvm(...
            predictors, ...
            response, ...
            'KernelFunction', 'polynomial', ...
            'PolynomialOrder', 3, ...
            'KernelScale', 'auto', ...
            'BoxConstraint', 1, ...
            'Standardize', true, ...
            'ClassNames', [1; 3]);
% Perform cross-validation
rng(randomSeed);
cp = cvpartition(response, 'KFold', 10, 'Stratify', true);
partitionedModel = crossval(classificationSVM, 'CVPartition', cp);

% Compute validation predictions
[lable, validationScores] = kfoldPredict(partitionedModel);

% Compute AUC of ROC Curve
[~,~,~,AUC] = perfcurve(response,validationScores(:,1),1);

% Compute validation accuracy
validationAccuracy = 1 - kfoldLoss(partitionedModel, 'LossFun', 'ClassifError')

Converter_Vali3
close all

inputTable = balanced2LoomRand;
inputTable.Properties.VariableNames = {'All_AmpMean', 'All_AmpStd', 'All_AmpMedian', 'All_AmpVar', 'All_AmpMax', 'All_AmpMin', 'All_PeakLat', 'All_PeakDur', 'All_PhaseDiff', 'All_InstFreq', 'All_Pentropy', 'All_ZeroCross', 'All_PFD', 'All_Mobility', 'All_Activity', 'All_LowFreqAmp', 'All_zScore', 'All_mAmplitude', 'All_mLatency', 'All_mDuration', 'All_mProminence', 'All_phaseDatVar', 'All_bior2_2_Delta_Mean', 'All_bior2_2_Delta_Median', 'All_bior2_2_Delta_Min', 'All_bior2_2_Delta_Max', 'All_bior2_2_Delta_Var', 'All_bior2_2_Delta_Power', 'All_bior2_2_Delta_Skewness', 'All_bior2_2_Delta_Entropy', 'All_bior2_2_Theta_Mean', 'All_bior2_2_Theta_Median', 'All_bior2_2_Theta_Min', 'All_bior2_2_Theta_Max', 'All_bior2_2_Theta_Var', 'All_bior2_2_Theta_Power', 'All_bior2_2_Theta_Skewness', 'All_bior2_2_Theta_Entropy', 'All_bior2_2_Alpha_Mean', 'All_bior2_2_Alpha_Median', 'All_bior2_2_Alpha_Min', 'All_bior2_2_Alpha_Max', 'All_bior2_2_Alpha_Var', 'All_bior2_2_Alpha_Power', 'All_bior2_2_Alpha_Skewness', 'All_bior2_2_Alpha_Entropy', 'All_bior2_2_BetaGamma_Mean', 'All_bior2_2_BetaGamma_Median', 'All_bior2_2_BetaGamma_Min', 'All_bior2_2_BetaGamma_Max', 'All_bior2_2_BetaGamma_Var', 'All_bior2_2_BetaGamma_Power', 'All_bior2_2_BetaGamma_Skewness', 'All_bior2_2_BetaGamma_Entropy', 'All_bior4_4_Delta_Mean', 'All_bior4_4_Delta_Median', 'All_bior4_4_Delta_Min', 'All_bior4_4_Delta_Max', 'All_bior4_4_Delta_Var', 'All_bior4_4_Delta_Power', 'All_bior4_4_Delta_Skewness', 'All_bior4_4_Delta_Entropy', 'All_bior4_4_Theta_Mean', 'All_bior4_4_Theta_Median', 'All_bior4_4_Theta_Min', 'All_bior4_4_Theta_Max', 'All_bior4_4_Theta_Var', 'All_bior4_4_Theta_Power', 'All_bior4_4_Theta_Skewness', 'All_bior4_4_Theta_Entropy', 'All_bior4_4_Alpha_Mean', 'All_bior4_4_Alpha_Median', 'All_bior4_4_Alpha_Min', 'All_bior4_4_Alpha_Max', 'All_bior4_4_Alpha_Var', 'All_bior4_4_Alpha_Power', 'All_bior4_4_Alpha_Skewness', 'All_bior4_4_Alpha_Entropy', 'All_bior4_4_BetaGamma_Mean', 'All_bior4_4_BetaGamma_Median', 'All_bior4_4_BetaGamma_Min', 'All_bior4_4_BetaGamma_Max', 'All_bior4_4_BetaGamma_Var', 'All_bior4_4_BetaGamma_Power', 'All_bior4_4_BetaGamma_Skewness', 'All_bior4_4_BetaGamma_Entropy', 'All_sym6_Delta_Mean', 'All_sym6_Delta_Median', 'All_sym6_Delta_Min', 'All_sym6_Delta_Max', 'All_sym6_Delta_Var', 'All_sym6_Delta_Power', 'All_sym6_Delta_Skewness', 'All_sym6_Delta_Entropy', 'All_sym6_Theta_Mean', 'All_sym6_Theta_Median', 'All_sym6_Theta_Min', 'All_sym6_Theta_Max', 'All_sym6_Theta_Var', 'All_sym6_Theta_Power', 'All_sym6_Theta_Skewness', 'All_sym6_Theta_Entropy', 'All_sym6_Alpha_Mean', 'All_sym6_Alpha_Median', 'All_sym6_Alpha_Min', 'All_sym6_Alpha_Max', 'All_sym6_Alpha_Var', 'All_sym6_Alpha_Power', 'All_sym6_Alpha_Skewness', 'All_sym6_Alpha_Entropy', 'All_sym6_BetaGamma_Mean', 'All_sym6_BetaGamma_Median', 'All_sym6_BetaGamma_Min', 'All_sym6_BetaGamma_Max', 'All_sym6_BetaGamma_Var', 'All_sym6_BetaGamma_Power', 'All_sym6_BetaGamma_Skewness', 'All_sym6_BetaGamma_Entropy', 'All_db4_Delta_Mean', 'All_db4_Delta_Median', 'All_db4_Delta_Min', 'All_db4_Delta_Max', 'All_db4_Delta_Var', 'All_db4_Delta_Power', 'All_db4_Delta_Skewness', 'All_db4_Delta_Entropy', 'All_db4_Theta_Mean', 'All_db4_Theta_Median', 'All_db4_Theta_Min', 'All_db4_Theta_Max', 'All_db4_Theta_Var', 'All_db4_Theta_Power', 'All_db4_Theta_Skewness', 'All_db4_Theta_Entropy', 'All_db4_Alpha_Mean', 'All_db4_Alpha_Median', 'All_db4_Alpha_Min', 'All_db4_Alpha_Max', 'All_db4_Alpha_Var', 'All_db4_Alpha_Power', 'All_db4_Alpha_Skewness', 'All_db4_Alpha_Entropy', 'All_db4_BetaGamma_Mean', 'All_db4_BetaGamma_Median', 'All_db4_BetaGamma_Min', 'All_db4_BetaGamma_Max', 'All_db4_BetaGamma_Var', 'All_db4_BetaGamma_Power', 'All_db4_BetaGamma_Skewness', 'All_db4_BetaGamma_Entropy', 'Occ_AmpMean', 'Occ_AmpStd', 'Occ_AmpMedian', 'Occ_AmpVar', 'Occ_AmpMax', 'Occ_AmpMin', 'Occ_PeakLat', 'Occ_PeakDur', 'Occ_PhaseDiff', 'Occ_InstFreq', 'Occ_Pentropy', 'Occ_ZeroCross', 'Occ_PFD', 'Occ_Mobility', 'Occ_Activity', 'Occ_LowFreqAmp', 'Occ_zScore', 'Occ_mAmplitude', 'Occ_mLatency', 'Occ_mDuration', 'Occ_mProminence', 'Occ_phaseDatVar', 'Occ_bior2_2_Delta_Mean', 'Occ_bior2_2_Delta_Median', 'Occ_bior2_2_Delta_Min', 'Occ_bior2_2_Delta_Max', 'Occ_bior2_2_Delta_Var', 'Occ_bior2_2_Delta_Power', 'Occ_bior2_2_Delta_Skewness', 'Occ_bior2_2_Delta_Entropy', 'Occ_bior2_2_Theta_Mean', 'Occ_bior2_2_Theta_Median', 'Occ_bior2_2_Theta_Min', 'Occ_bior2_2_Theta_Max', 'Occ_bior2_2_Theta_Var', 'Occ_bior2_2_Theta_Power', 'Occ_bior2_2_Theta_Skewness', 'Occ_bior2_2_Theta_Entropy', 'Occ_bior2_2_Alpha_Mean', 'Occ_bior2_2_Alpha_Median', 'Occ_bior2_2_Alpha_Min', 'Occ_bior2_2_Alpha_Max', 'Occ_bior2_2_Alpha_Var', 'Occ_bior2_2_Alpha_Power', 'Occ_bior2_2_Alpha_Skewness', 'Occ_bior2_2_Alpha_Entropy', 'Occ_bior2_2_BetaGamma_Mean', 'Occ_bior2_2_BetaGamma_Median', 'Occ_bior2_2_BetaGamma_Min', 'Occ_bior2_2_BetaGamma_Max', 'Occ_bior2_2_BetaGamma_Var', 'Occ_bior2_2_BetaGamma_Power', 'Occ_bior2_2_BetaGamma_Skewness', 'Occ_bior2_2_BetaGamma_Entropy', 'Occ_bior4_4_Delta_Mean', 'Occ_bior4_4_Delta_Median', 'Occ_bior4_4_Delta_Min', 'Occ_bior4_4_Delta_Max', 'Occ_bior4_4_Delta_Var', 'Occ_bior4_4_Delta_Power', 'Occ_bior4_4_Delta_Skewness', 'Occ_bior4_4_Delta_Entropy', 'Occ_bior4_4_Theta_Mean', 'Occ_bior4_4_Theta_Median', 'Occ_bior4_4_Theta_Min', 'Occ_bior4_4_Theta_Max', 'Occ_bior4_4_Theta_Var', 'Occ_bior4_4_Theta_Power', 'Occ_bior4_4_Theta_Skewness', 'Occ_bior4_4_Theta_Entropy', 'Occ_bior4_4_Alpha_Mean', 'Occ_bior4_4_Alpha_Median', 'Occ_bior4_4_Alpha_Min', 'Occ_bior4_4_Alpha_Max', 'Occ_bior4_4_Alpha_Var', 'Occ_bior4_4_Alpha_Power', 'Occ_bior4_4_Alpha_Skewness', 'Occ_bior4_4_Alpha_Entropy', 'Occ_bior4_4_BetaGamma_Mean', 'Occ_bior4_4_BetaGamma_Median', 'Occ_bior4_4_BetaGamma_Min', 'Occ_bior4_4_BetaGamma_Max', 'Occ_bior4_4_BetaGamma_Var', 'Occ_bior4_4_BetaGamma_Power', 'Occ_bior4_4_BetaGamma_Skewness', 'Occ_bior4_4_BetaGamma_Entropy', 'Occ_sym6_Delta_Mean', 'Occ_sym6_Delta_Median', 'Occ_sym6_Delta_Min', 'Occ_sym6_Delta_Max', 'Occ_sym6_Delta_Var', 'Occ_sym6_Delta_Power', 'Occ_sym6_Delta_Skewness', 'Occ_sym6_Delta_Entropy', 'Occ_sym6_Theta_Mean', 'Occ_sym6_Theta_Median', 'Occ_sym6_Theta_Min', 'Occ_sym6_Theta_Max', 'Occ_sym6_Theta_Var', 'Occ_sym6_Theta_Power', 'Occ_sym6_Theta_Skewness', 'Occ_sym6_Theta_Entropy', 'Occ_sym6_Alpha_Mean', 'Occ_sym6_Alpha_Median', 'Occ_sym6_Alpha_Min', 'Occ_sym6_Alpha_Max', 'Occ_sym6_Alpha_Var', 'Occ_sym6_Alpha_Power', 'Occ_sym6_Alpha_Skewness', 'Occ_sym6_Alpha_Entropy', 'Occ_sym6_BetaGamma_Mean', 'Occ_sym6_BetaGamma_Median', 'Occ_sym6_BetaGamma_Min', 'Occ_sym6_BetaGamma_Max', 'Occ_sym6_BetaGamma_Var', 'Occ_sym6_BetaGamma_Power', 'Occ_sym6_BetaGamma_Skewness', 'Occ_sym6_BetaGamma_Entropy', 'Occ_db4_Delta_Mean', 'Occ_db4_Delta_Median', 'Occ_db4_Delta_Min', 'Occ_db4_Delta_Max', 'Occ_db4_Delta_Var', 'Occ_db4_Delta_Power', 'Occ_db4_Delta_Skewness', 'Occ_db4_Delta_Entropy', 'Occ_db4_Theta_Mean', 'Occ_db4_Theta_Median', 'Occ_db4_Theta_Min', 'Occ_db4_Theta_Max', 'Occ_db4_Theta_Var', 'Occ_db4_Theta_Power', 'Occ_db4_Theta_Skewness', 'Occ_db4_Theta_Entropy', 'Occ_db4_Alpha_Mean', 'Occ_db4_Alpha_Median', 'Occ_db4_Alpha_Min', 'Occ_db4_Alpha_Max', 'Occ_db4_Alpha_Var', 'Occ_db4_Alpha_Power', 'Occ_db4_Alpha_Skewness', 'Occ_db4_Alpha_Entropy', 'Occ_db4_BetaGamma_Mean', 'Occ_db4_BetaGamma_Median', 'Occ_db4_BetaGamma_Min', 'Occ_db4_BetaGamma_Max', 'Occ_db4_BetaGamma_Var', 'Occ_db4_BetaGamma_Power', 'Occ_db4_BetaGamma_Skewness', 'Occ_db4_BetaGamma_Entropy', 'Ref_AmpMean', 'Ref_AmpStd', 'Ref_AmpMedian', 'Ref_AmpVar', 'Ref_AmpMax', 'Ref_AmpMin', 'Ref_PeakLat', 'Ref_PeakDur', 'Ref_PhaseDiff', 'Ref_InstFreq', 'Ref_Pentropy', 'Ref_ZeroCross', 'Ref_PFD', 'Ref_Mobility', 'Ref_Activity', 'Ref_LowFreqAmp', 'Ref_zScore', 'Ref_mAmplitude', 'Ref_mLatency', 'Ref_mDuration', 'Ref_mProminence', 'Ref_phaseDatVar', 'Ref_bior2_2_Delta_Mean', 'Ref_bior2_2_Delta_Median', 'Ref_bior2_2_Delta_Min', 'Ref_bior2_2_Delta_Max', 'Ref_bior2_2_Delta_Var', 'Ref_bior2_2_Delta_Power', 'Ref_bior2_2_Delta_Skewness', 'Ref_bior2_2_Delta_Entropy', 'Ref_bior2_2_Theta_Mean', 'Ref_bior2_2_Theta_Median', 'Ref_bior2_2_Theta_Min', 'Ref_bior2_2_Theta_Max', 'Ref_bior2_2_Theta_Var', 'Ref_bior2_2_Theta_Power', 'Ref_bior2_2_Theta_Skewness', 'Ref_bior2_2_Theta_Entropy', 'Ref_bior2_2_Alpha_Mean', 'Ref_bior2_2_Alpha_Median', 'Ref_bior2_2_Alpha_Min', 'Ref_bior2_2_Alpha_Max', 'Ref_bior2_2_Alpha_Var', 'Ref_bior2_2_Alpha_Power', 'Ref_bior2_2_Alpha_Skewness', 'Ref_bior2_2_Alpha_Entropy', 'Ref_bior2_2_BetaGamma_Mean', 'Ref_bior2_2_BetaGamma_Median', 'Ref_bior2_2_BetaGamma_Min', 'Ref_bior2_2_BetaGamma_Max', 'Ref_bior2_2_BetaGamma_Var', 'Ref_bior2_2_BetaGamma_Power', 'Ref_bior2_2_BetaGamma_Skewness', 'Ref_bior2_2_BetaGamma_Entropy', 'Ref_bior4_4_Delta_Mean', 'Ref_bior4_4_Delta_Median', 'Ref_bior4_4_Delta_Min', 'Ref_bior4_4_Delta_Max', 'Ref_bior4_4_Delta_Var', 'Ref_bior4_4_Delta_Power', 'Ref_bior4_4_Delta_Skewness', 'Ref_bior4_4_Delta_Entropy', 'Ref_bior4_4_Theta_Mean', 'Ref_bior4_4_Theta_Median', 'Ref_bior4_4_Theta_Min', 'Ref_bior4_4_Theta_Max', 'Ref_bior4_4_Theta_Var', 'Ref_bior4_4_Theta_Power', 'Ref_bior4_4_Theta_Skewness', 'Ref_bior4_4_Theta_Entropy', 'Ref_bior4_4_Alpha_Mean', 'Ref_bior4_4_Alpha_Median', 'Ref_bior4_4_Alpha_Min', 'Ref_bior4_4_Alpha_Max', 'Ref_bior4_4_Alpha_Var', 'Ref_bior4_4_Alpha_Power', 'Ref_bior4_4_Alpha_Skewness', 'Ref_bior4_4_Alpha_Entropy', 'Ref_bior4_4_BetaGamma_Mean', 'Ref_bior4_4_BetaGamma_Median', 'Ref_bior4_4_BetaGamma_Min', 'Ref_bior4_4_BetaGamma_Max', 'Ref_bior4_4_BetaGamma_Var', 'Ref_bior4_4_BetaGamma_Power', 'Ref_bior4_4_BetaGamma_Skewness', 'Ref_bior4_4_BetaGamma_Entropy', 'Ref_sym6_Delta_Mean', 'Ref_sym6_Delta_Median', 'Ref_sym6_Delta_Min', 'Ref_sym6_Delta_Max', 'Ref_sym6_Delta_Var', 'Ref_sym6_Delta_Power', 'Ref_sym6_Delta_Skewness', 'Ref_sym6_Delta_Entropy', 'Ref_sym6_Theta_Mean', 'Ref_sym6_Theta_Median', 'Ref_sym6_Theta_Min', 'Ref_sym6_Theta_Max', 'Ref_sym6_Theta_Var', 'Ref_sym6_Theta_Power', 'Ref_sym6_Theta_Skewness', 'Ref_sym6_Theta_Entropy', 'Ref_sym6_Alpha_Mean', 'Ref_sym6_Alpha_Median', 'Ref_sym6_Alpha_Min', 'Ref_sym6_Alpha_Max', 'Ref_sym6_Alpha_Var', 'Ref_sym6_Alpha_Power', 'Ref_sym6_Alpha_Skewness', 'Ref_sym6_Alpha_Entropy', 'Ref_sym6_BetaGamma_Mean', 'Ref_sym6_BetaGamma_Median', 'Ref_sym6_BetaGamma_Min', 'Ref_sym6_BetaGamma_Max', 'Ref_sym6_BetaGamma_Var', 'Ref_sym6_BetaGamma_Power', 'Ref_sym6_BetaGamma_Skewness', 'Ref_sym6_BetaGamma_Entropy', 'Ref_db4_Delta_Mean', 'Ref_db4_Delta_Median', 'Ref_db4_Delta_Min', 'Ref_db4_Delta_Max', 'Ref_db4_Delta_Var', 'Ref_db4_Delta_Power', 'Ref_db4_Delta_Skewness', 'Ref_db4_Delta_Entropy', 'Ref_db4_Theta_Mean', 'Ref_db4_Theta_Median', 'Ref_db4_Theta_Min', 'Ref_db4_Theta_Max', 'Ref_db4_Theta_Var', 'Ref_db4_Theta_Power', 'Ref_db4_Theta_Skewness', 'Ref_db4_Theta_Entropy', 'Ref_db4_Alpha_Mean', 'Ref_db4_Alpha_Median', 'Ref_db4_Alpha_Min', 'Ref_db4_Alpha_Max', 'Ref_db4_Alpha_Var', 'Ref_db4_Alpha_Power', 'Ref_db4_Alpha_Skewness', 'Ref_db4_Alpha_Entropy', 'Ref_db4_BetaGamma_Mean', 'Ref_db4_BetaGamma_Median', 'Ref_db4_BetaGamma_Min', 'Ref_db4_BetaGamma_Max', 'Ref_db4_BetaGamma_Var', 'Ref_db4_BetaGamma_Power', 'Ref_db4_BetaGamma_Skewness', 'Ref_db4_BetaGamma_Entropy', 'Diff_bior2_2_Delta_Mean', 'Diff_bior2_2_Delta_Median', 'Diff_bior2_2_Delta_Min', 'Diff_bior2_2_Delta_Max', 'Diff_bior2_2_Delta_Var', 'Diff_bior2_2_Delta_Power', 'Diff_bior2_2_Delta_Skewness', 'Diff_bior2_2_Delta_Entropy', 'Diff_bior2_2_Theta_Mean', 'Diff_bior2_2_Theta_Median', 'Diff_bior2_2_Theta_Min', 'Diff_bior2_2_Theta_Max', 'Diff_bior2_2_Theta_Var', 'Diff_bior2_2_Theta_Power', 'Diff_bior2_2_Theta_Skewness', 'Diff_bior2_2_Theta_Entropy', 'Diff_bior2_2_Alpha_Mean', 'Diff_bior2_2_Alpha_Median', 'Diff_bior2_2_Alpha_Min', 'Diff_bior2_2_Alpha_Max', 'Diff_bior2_2_Alpha_Var', 'Diff_bior2_2_Alpha_Power', 'Diff_bior2_2_Alpha_Skewness', 'Diff_bior2_2_Alpha_Entropy', 'Diff_bior2_2_BetaGamma_Mean', 'Diff_bior2_2_BetaGamma_Median', 'Diff_bior2_2_BetaGamma_Min', 'Diff_bior2_2_BetaGamma_Max', 'Diff_bior2_2_BetaGamma_Var', 'Diff_bior2_2_BetaGamma_Power', 'Diff_bior2_2_BetaGamma_Skewness', 'Diff_bior2_2_BetaGamma_Entropy', 'Diff_bior4_4_Delta_Mean', 'Diff_bior4_4_Delta_Median', 'Diff_bior4_4_Delta_Min', 'Diff_bior4_4_Delta_Max', 'Diff_bior4_4_Delta_Var', 'Diff_bior4_4_Delta_Power', 'Diff_bior4_4_Delta_Skewness', 'Diff_bior4_4_Delta_Entropy', 'Diff_bior4_4_Theta_Mean', 'Diff_bior4_4_Theta_Median', 'Diff_bior4_4_Theta_Min', 'Diff_bior4_4_Theta_Max', 'Diff_bior4_4_Theta_Var', 'Diff_bior4_4_Theta_Power', 'Diff_bior4_4_Theta_Skewness', 'Diff_bior4_4_Theta_Entropy', 'Diff_bior4_4_Alpha_Mean', 'Diff_bior4_4_Alpha_Median', 'Diff_bior4_4_Alpha_Min', 'Diff_bior4_4_Alpha_Max', 'Diff_bior4_4_Alpha_Var', 'Diff_bior4_4_Alpha_Power', 'Diff_bior4_4_Alpha_Skewness', 'Diff_bior4_4_Alpha_Entropy', 'Diff_bior4_4_BetaGamma_Mean', 'Diff_bior4_4_BetaGamma_Median', 'Diff_bior4_4_BetaGamma_Min', 'Diff_bior4_4_BetaGamma_Max', 'Diff_bior4_4_BetaGamma_Var', 'Diff_bior4_4_BetaGamma_Power', 'Diff_bior4_4_BetaGamma_Skewness', 'Diff_bior4_4_BetaGamma_Entropy', 'Diff_sym6_Delta_Mean', 'Diff_sym6_Delta_Median', 'Diff_sym6_Delta_Min', 'Diff_sym6_Delta_Max', 'Diff_sym6_Delta_Var', 'Diff_sym6_Delta_Power', 'Diff_sym6_Delta_Skewness', 'Diff_sym6_Delta_Entropy', 'Diff_sym6_Theta_Mean', 'Diff_sym6_Theta_Median', 'Diff_sym6_Theta_Min', 'Diff_sym6_Theta_Max', 'Diff_sym6_Theta_Var', 'Diff_sym6_Theta_Power', 'Diff_sym6_Theta_Skewness', 'Diff_sym6_Theta_Entropy', 'Diff_sym6_Alpha_Mean', 'Diff_sym6_Alpha_Median', 'Diff_sym6_Alpha_Min', 'Diff_sym6_Alpha_Max', 'Diff_sym6_Alpha_Var', 'Diff_sym6_Alpha_Power', 'Diff_sym6_Alpha_Skewness', 'Diff_sym6_Alpha_Entropy', 'Diff_sym6_BetaGamma_Mean', 'Diff_sym6_BetaGamma_Median', 'Diff_sym6_BetaGamma_Min', 'Diff_sym6_BetaGamma_Max', 'Diff_sym6_BetaGamma_Var', 'Diff_sym6_BetaGamma_Power', 'Diff_sym6_BetaGamma_Skewness', 'Diff_sym6_BetaGamma_Entropy', 'Diff_db4_Delta_Mean', 'Diff_db4_Delta_Median', 'Diff_db4_Delta_Min', 'Diff_db4_Delta_Max', 'Diff_db4_Delta_Var', 'Diff_db4_Delta_Power', 'Diff_db4_Delta_Skewness', 'Diff_db4_Delta_Entropy', 'Diff_db4_Theta_Mean', 'Diff_db4_Theta_Median', 'Diff_db4_Theta_Min', 'Diff_db4_Theta_Max', 'Diff_db4_Theta_Var', 'Diff_db4_Theta_Power', 'Diff_db4_Theta_Skewness', 'Diff_db4_Theta_Entropy', 'Diff_db4_Alpha_Mean', 'Diff_db4_Alpha_Median', 'Diff_db4_Alpha_Min', 'Diff_db4_Alpha_Max', 'Diff_db4_Alpha_Var', 'Diff_db4_Alpha_Power', 'Diff_db4_Alpha_Skewness', 'Diff_db4_Alpha_Entropy', 'Diff_db4_BetaGamma_Mean', 'Diff_db4_BetaGamma_Median', 'Diff_db4_BetaGamma_Min', 'Diff_db4_BetaGamma_Max', 'Diff_db4_BetaGamma_Var', 'Diff_db4_BetaGamma_Power', 'Diff_db4_BetaGamma_Skewness', 'Diff_db4_BetaGamma_Entropy','Class'};

% Set predictor names
predictorNames = {'All_AmpMean', 'All_AmpStd', 'All_AmpMedian', 'All_AmpVar', 'All_AmpMax', 'All_AmpMin', 'All_PeakLat', 'All_PeakDur', 'All_PhaseDiff', 'All_InstFreq', 'All_Pentropy', 'All_ZeroCross', 'All_PFD', 'All_Mobility', 'All_Activity', 'All_LowFreqAmp', 'All_zScore', 'All_mAmplitude', 'All_mLatency', 'All_mDuration', 'All_mProminence', 'All_phaseDatVar', 'All_bior2_2_Delta_Mean', 'All_bior2_2_Delta_Median', 'All_bior2_2_Delta_Min', 'All_bior2_2_Delta_Max', 'All_bior2_2_Delta_Var', 'All_bior2_2_Delta_Power', 'All_bior2_2_Delta_Skewness', 'All_bior2_2_Delta_Entropy', 'All_bior2_2_Theta_Mean', 'All_bior2_2_Theta_Median', 'All_bior2_2_Theta_Min', 'All_bior2_2_Theta_Max', 'All_bior2_2_Theta_Var', 'All_bior2_2_Theta_Power', 'All_bior2_2_Theta_Skewness', 'All_bior2_2_Theta_Entropy', 'All_bior2_2_Alpha_Mean', 'All_bior2_2_Alpha_Median', 'All_bior2_2_Alpha_Min', 'All_bior2_2_Alpha_Max', 'All_bior2_2_Alpha_Var', 'All_bior2_2_Alpha_Power', 'All_bior2_2_Alpha_Skewness', 'All_bior2_2_Alpha_Entropy', 'All_bior2_2_BetaGamma_Mean', 'All_bior2_2_BetaGamma_Median', 'All_bior2_2_BetaGamma_Min', 'All_bior2_2_BetaGamma_Max', 'All_bior2_2_BetaGamma_Var', 'All_bior2_2_BetaGamma_Power', 'All_bior2_2_BetaGamma_Skewness', 'All_bior2_2_BetaGamma_Entropy', 'All_bior4_4_Delta_Mean', 'All_bior4_4_Delta_Median', 'All_bior4_4_Delta_Min', 'All_bior4_4_Delta_Max', 'All_bior4_4_Delta_Var', 'All_bior4_4_Delta_Power', 'All_bior4_4_Delta_Skewness', 'All_bior4_4_Delta_Entropy', 'All_bior4_4_Theta_Mean', 'All_bior4_4_Theta_Median', 'All_bior4_4_Theta_Min', 'All_bior4_4_Theta_Max', 'All_bior4_4_Theta_Var', 'All_bior4_4_Theta_Power', 'All_bior4_4_Theta_Skewness', 'All_bior4_4_Theta_Entropy', 'All_bior4_4_Alpha_Mean', 'All_bior4_4_Alpha_Median', 'All_bior4_4_Alpha_Min', 'All_bior4_4_Alpha_Max', 'All_bior4_4_Alpha_Var', 'All_bior4_4_Alpha_Power', 'All_bior4_4_Alpha_Skewness', 'All_bior4_4_Alpha_Entropy', 'All_bior4_4_BetaGamma_Mean', 'All_bior4_4_BetaGamma_Median', 'All_bior4_4_BetaGamma_Min', 'All_bior4_4_BetaGamma_Max', 'All_bior4_4_BetaGamma_Var', 'All_bior4_4_BetaGamma_Power', 'All_bior4_4_BetaGamma_Skewness', 'All_bior4_4_BetaGamma_Entropy', 'All_sym6_Delta_Mean', 'All_sym6_Delta_Median', 'All_sym6_Delta_Min', 'All_sym6_Delta_Max', 'All_sym6_Delta_Var', 'All_sym6_Delta_Power', 'All_sym6_Delta_Skewness', 'All_sym6_Delta_Entropy', 'All_sym6_Theta_Mean', 'All_sym6_Theta_Median', 'All_sym6_Theta_Min', 'All_sym6_Theta_Max', 'All_sym6_Theta_Var', 'All_sym6_Theta_Power', 'All_sym6_Theta_Skewness', 'All_sym6_Theta_Entropy', 'All_sym6_Alpha_Mean', 'All_sym6_Alpha_Median', 'All_sym6_Alpha_Min', 'All_sym6_Alpha_Max', 'All_sym6_Alpha_Var', 'All_sym6_Alpha_Power', 'All_sym6_Alpha_Skewness', 'All_sym6_Alpha_Entropy', 'All_sym6_BetaGamma_Mean', 'All_sym6_BetaGamma_Median', 'All_sym6_BetaGamma_Min', 'All_sym6_BetaGamma_Max', 'All_sym6_BetaGamma_Var', 'All_sym6_BetaGamma_Power', 'All_sym6_BetaGamma_Skewness', 'All_sym6_BetaGamma_Entropy', 'All_db4_Delta_Mean', 'All_db4_Delta_Median', 'All_db4_Delta_Min', 'All_db4_Delta_Max', 'All_db4_Delta_Var', 'All_db4_Delta_Power', 'All_db4_Delta_Skewness', 'All_db4_Delta_Entropy', 'All_db4_Theta_Mean', 'All_db4_Theta_Median', 'All_db4_Theta_Min', 'All_db4_Theta_Max', 'All_db4_Theta_Var', 'All_db4_Theta_Power', 'All_db4_Theta_Skewness', 'All_db4_Theta_Entropy', 'All_db4_Alpha_Mean', 'All_db4_Alpha_Median', 'All_db4_Alpha_Min', 'All_db4_Alpha_Max', 'All_db4_Alpha_Var', 'All_db4_Alpha_Power', 'All_db4_Alpha_Skewness', 'All_db4_Alpha_Entropy', 'All_db4_BetaGamma_Mean', 'All_db4_BetaGamma_Median', 'All_db4_BetaGamma_Min', 'All_db4_BetaGamma_Max', 'All_db4_BetaGamma_Var', 'All_db4_BetaGamma_Power', 'All_db4_BetaGamma_Skewness', 'All_db4_BetaGamma_Entropy', 'Occ_AmpMean', 'Occ_AmpStd', 'Occ_AmpMedian', 'Occ_AmpVar', 'Occ_AmpMax', 'Occ_AmpMin', 'Occ_PeakLat', 'Occ_PeakDur', 'Occ_PhaseDiff', 'Occ_InstFreq', 'Occ_Pentropy', 'Occ_ZeroCross', 'Occ_PFD', 'Occ_Mobility', 'Occ_Activity', 'Occ_LowFreqAmp', 'Occ_zScore', 'Occ_mAmplitude', 'Occ_mLatency', 'Occ_mDuration', 'Occ_mProminence', 'Occ_phaseDatVar', 'Occ_bior2_2_Delta_Mean', 'Occ_bior2_2_Delta_Median', 'Occ_bior2_2_Delta_Min', 'Occ_bior2_2_Delta_Max', 'Occ_bior2_2_Delta_Var', 'Occ_bior2_2_Delta_Power', 'Occ_bior2_2_Delta_Skewness', 'Occ_bior2_2_Delta_Entropy', 'Occ_bior2_2_Theta_Mean', 'Occ_bior2_2_Theta_Median', 'Occ_bior2_2_Theta_Min', 'Occ_bior2_2_Theta_Max', 'Occ_bior2_2_Theta_Var', 'Occ_bior2_2_Theta_Power', 'Occ_bior2_2_Theta_Skewness', 'Occ_bior2_2_Theta_Entropy', 'Occ_bior2_2_Alpha_Mean', 'Occ_bior2_2_Alpha_Median', 'Occ_bior2_2_Alpha_Min', 'Occ_bior2_2_Alpha_Max', 'Occ_bior2_2_Alpha_Var', 'Occ_bior2_2_Alpha_Power', 'Occ_bior2_2_Alpha_Skewness', 'Occ_bior2_2_Alpha_Entropy', 'Occ_bior2_2_BetaGamma_Mean', 'Occ_bior2_2_BetaGamma_Median', 'Occ_bior2_2_BetaGamma_Min', 'Occ_bior2_2_BetaGamma_Max', 'Occ_bior2_2_BetaGamma_Var', 'Occ_bior2_2_BetaGamma_Power', 'Occ_bior2_2_BetaGamma_Skewness', 'Occ_bior2_2_BetaGamma_Entropy', 'Occ_bior4_4_Delta_Mean', 'Occ_bior4_4_Delta_Median', 'Occ_bior4_4_Delta_Min', 'Occ_bior4_4_Delta_Max', 'Occ_bior4_4_Delta_Var', 'Occ_bior4_4_Delta_Power', 'Occ_bior4_4_Delta_Skewness', 'Occ_bior4_4_Delta_Entropy', 'Occ_bior4_4_Theta_Mean', 'Occ_bior4_4_Theta_Median', 'Occ_bior4_4_Theta_Min', 'Occ_bior4_4_Theta_Max', 'Occ_bior4_4_Theta_Var', 'Occ_bior4_4_Theta_Power', 'Occ_bior4_4_Theta_Skewness', 'Occ_bior4_4_Theta_Entropy', 'Occ_bior4_4_Alpha_Mean', 'Occ_bior4_4_Alpha_Median', 'Occ_bior4_4_Alpha_Min', 'Occ_bior4_4_Alpha_Max', 'Occ_bior4_4_Alpha_Var', 'Occ_bior4_4_Alpha_Power', 'Occ_bior4_4_Alpha_Skewness', 'Occ_bior4_4_Alpha_Entropy', 'Occ_bior4_4_BetaGamma_Mean', 'Occ_bior4_4_BetaGamma_Median', 'Occ_bior4_4_BetaGamma_Min', 'Occ_bior4_4_BetaGamma_Max', 'Occ_bior4_4_BetaGamma_Var', 'Occ_bior4_4_BetaGamma_Power', 'Occ_bior4_4_BetaGamma_Skewness', 'Occ_bior4_4_BetaGamma_Entropy', 'Occ_sym6_Delta_Mean', 'Occ_sym6_Delta_Median', 'Occ_sym6_Delta_Min', 'Occ_sym6_Delta_Max', 'Occ_sym6_Delta_Var', 'Occ_sym6_Delta_Power', 'Occ_sym6_Delta_Skewness', 'Occ_sym6_Delta_Entropy', 'Occ_sym6_Theta_Mean', 'Occ_sym6_Theta_Median', 'Occ_sym6_Theta_Min', 'Occ_sym6_Theta_Max', 'Occ_sym6_Theta_Var', 'Occ_sym6_Theta_Power', 'Occ_sym6_Theta_Skewness', 'Occ_sym6_Theta_Entropy', 'Occ_sym6_Alpha_Mean', 'Occ_sym6_Alpha_Median', 'Occ_sym6_Alpha_Min', 'Occ_sym6_Alpha_Max', 'Occ_sym6_Alpha_Var', 'Occ_sym6_Alpha_Power', 'Occ_sym6_Alpha_Skewness', 'Occ_sym6_Alpha_Entropy', 'Occ_sym6_BetaGamma_Mean', 'Occ_sym6_BetaGamma_Median', 'Occ_sym6_BetaGamma_Min', 'Occ_sym6_BetaGamma_Max', 'Occ_sym6_BetaGamma_Var', 'Occ_sym6_BetaGamma_Power', 'Occ_sym6_BetaGamma_Skewness', 'Occ_sym6_BetaGamma_Entropy', 'Occ_db4_Delta_Mean', 'Occ_db4_Delta_Median', 'Occ_db4_Delta_Min', 'Occ_db4_Delta_Max', 'Occ_db4_Delta_Var', 'Occ_db4_Delta_Power', 'Occ_db4_Delta_Skewness', 'Occ_db4_Delta_Entropy', 'Occ_db4_Theta_Mean', 'Occ_db4_Theta_Median', 'Occ_db4_Theta_Min', 'Occ_db4_Theta_Max', 'Occ_db4_Theta_Var', 'Occ_db4_Theta_Power', 'Occ_db4_Theta_Skewness', 'Occ_db4_Theta_Entropy', 'Occ_db4_Alpha_Mean', 'Occ_db4_Alpha_Median', 'Occ_db4_Alpha_Min', 'Occ_db4_Alpha_Max', 'Occ_db4_Alpha_Var', 'Occ_db4_Alpha_Power', 'Occ_db4_Alpha_Skewness', 'Occ_db4_Alpha_Entropy', 'Occ_db4_BetaGamma_Mean', 'Occ_db4_BetaGamma_Median', 'Occ_db4_BetaGamma_Min', 'Occ_db4_BetaGamma_Max', 'Occ_db4_BetaGamma_Var', 'Occ_db4_BetaGamma_Power', 'Occ_db4_BetaGamma_Skewness', 'Occ_db4_BetaGamma_Entropy', 'Ref_AmpMean', 'Ref_AmpStd', 'Ref_AmpMedian', 'Ref_AmpVar', 'Ref_AmpMax', 'Ref_AmpMin', 'Ref_PeakLat', 'Ref_PeakDur', 'Ref_PhaseDiff', 'Ref_InstFreq', 'Ref_Pentropy', 'Ref_ZeroCross', 'Ref_PFD', 'Ref_Mobility', 'Ref_Activity', 'Ref_LowFreqAmp', 'Ref_zScore', 'Ref_mAmplitude', 'Ref_mLatency', 'Ref_mDuration', 'Ref_mProminence', 'Ref_phaseDatVar', 'Ref_bior2_2_Delta_Mean', 'Ref_bior2_2_Delta_Median', 'Ref_bior2_2_Delta_Min', 'Ref_bior2_2_Delta_Max', 'Ref_bior2_2_Delta_Var', 'Ref_bior2_2_Delta_Power', 'Ref_bior2_2_Delta_Skewness', 'Ref_bior2_2_Delta_Entropy', 'Ref_bior2_2_Theta_Mean', 'Ref_bior2_2_Theta_Median', 'Ref_bior2_2_Theta_Min', 'Ref_bior2_2_Theta_Max', 'Ref_bior2_2_Theta_Var', 'Ref_bior2_2_Theta_Power', 'Ref_bior2_2_Theta_Skewness', 'Ref_bior2_2_Theta_Entropy', 'Ref_bior2_2_Alpha_Mean', 'Ref_bior2_2_Alpha_Median', 'Ref_bior2_2_Alpha_Min', 'Ref_bior2_2_Alpha_Max', 'Ref_bior2_2_Alpha_Var', 'Ref_bior2_2_Alpha_Power', 'Ref_bior2_2_Alpha_Skewness', 'Ref_bior2_2_Alpha_Entropy', 'Ref_bior2_2_BetaGamma_Mean', 'Ref_bior2_2_BetaGamma_Median', 'Ref_bior2_2_BetaGamma_Min', 'Ref_bior2_2_BetaGamma_Max', 'Ref_bior2_2_BetaGamma_Var', 'Ref_bior2_2_BetaGamma_Power', 'Ref_bior2_2_BetaGamma_Skewness', 'Ref_bior2_2_BetaGamma_Entropy', 'Ref_bior4_4_Delta_Mean', 'Ref_bior4_4_Delta_Median', 'Ref_bior4_4_Delta_Min', 'Ref_bior4_4_Delta_Max', 'Ref_bior4_4_Delta_Var', 'Ref_bior4_4_Delta_Power', 'Ref_bior4_4_Delta_Skewness', 'Ref_bior4_4_Delta_Entropy', 'Ref_bior4_4_Theta_Mean', 'Ref_bior4_4_Theta_Median', 'Ref_bior4_4_Theta_Min', 'Ref_bior4_4_Theta_Max', 'Ref_bior4_4_Theta_Var', 'Ref_bior4_4_Theta_Power', 'Ref_bior4_4_Theta_Skewness', 'Ref_bior4_4_Theta_Entropy', 'Ref_bior4_4_Alpha_Mean', 'Ref_bior4_4_Alpha_Median', 'Ref_bior4_4_Alpha_Min', 'Ref_bior4_4_Alpha_Max', 'Ref_bior4_4_Alpha_Var', 'Ref_bior4_4_Alpha_Power', 'Ref_bior4_4_Alpha_Skewness', 'Ref_bior4_4_Alpha_Entropy', 'Ref_bior4_4_BetaGamma_Mean', 'Ref_bior4_4_BetaGamma_Median', 'Ref_bior4_4_BetaGamma_Min', 'Ref_bior4_4_BetaGamma_Max', 'Ref_bior4_4_BetaGamma_Var', 'Ref_bior4_4_BetaGamma_Power', 'Ref_bior4_4_BetaGamma_Skewness', 'Ref_bior4_4_BetaGamma_Entropy', 'Ref_sym6_Delta_Mean', 'Ref_sym6_Delta_Median', 'Ref_sym6_Delta_Min', 'Ref_sym6_Delta_Max', 'Ref_sym6_Delta_Var', 'Ref_sym6_Delta_Power', 'Ref_sym6_Delta_Skewness', 'Ref_sym6_Delta_Entropy', 'Ref_sym6_Theta_Mean', 'Ref_sym6_Theta_Median', 'Ref_sym6_Theta_Min', 'Ref_sym6_Theta_Max', 'Ref_sym6_Theta_Var', 'Ref_sym6_Theta_Power', 'Ref_sym6_Theta_Skewness', 'Ref_sym6_Theta_Entropy', 'Ref_sym6_Alpha_Mean', 'Ref_sym6_Alpha_Median', 'Ref_sym6_Alpha_Min', 'Ref_sym6_Alpha_Max', 'Ref_sym6_Alpha_Var', 'Ref_sym6_Alpha_Power', 'Ref_sym6_Alpha_Skewness', 'Ref_sym6_Alpha_Entropy', 'Ref_sym6_BetaGamma_Mean', 'Ref_sym6_BetaGamma_Median', 'Ref_sym6_BetaGamma_Min', 'Ref_sym6_BetaGamma_Max', 'Ref_sym6_BetaGamma_Var', 'Ref_sym6_BetaGamma_Power', 'Ref_sym6_BetaGamma_Skewness', 'Ref_sym6_BetaGamma_Entropy', 'Ref_db4_Delta_Mean', 'Ref_db4_Delta_Median', 'Ref_db4_Delta_Min', 'Ref_db4_Delta_Max', 'Ref_db4_Delta_Var', 'Ref_db4_Delta_Power', 'Ref_db4_Delta_Skewness', 'Ref_db4_Delta_Entropy', 'Ref_db4_Theta_Mean', 'Ref_db4_Theta_Median', 'Ref_db4_Theta_Min', 'Ref_db4_Theta_Max', 'Ref_db4_Theta_Var', 'Ref_db4_Theta_Power', 'Ref_db4_Theta_Skewness', 'Ref_db4_Theta_Entropy', 'Ref_db4_Alpha_Mean', 'Ref_db4_Alpha_Median', 'Ref_db4_Alpha_Min', 'Ref_db4_Alpha_Max', 'Ref_db4_Alpha_Var', 'Ref_db4_Alpha_Power', 'Ref_db4_Alpha_Skewness', 'Ref_db4_Alpha_Entropy', 'Ref_db4_BetaGamma_Mean', 'Ref_db4_BetaGamma_Median', 'Ref_db4_BetaGamma_Min', 'Ref_db4_BetaGamma_Max', 'Ref_db4_BetaGamma_Var', 'Ref_db4_BetaGamma_Power', 'Ref_db4_BetaGamma_Skewness', 'Ref_db4_BetaGamma_Entropy', 'Diff_bior2_2_Delta_Mean', 'Diff_bior2_2_Delta_Median', 'Diff_bior2_2_Delta_Min', 'Diff_bior2_2_Delta_Max', 'Diff_bior2_2_Delta_Var', 'Diff_bior2_2_Delta_Power', 'Diff_bior2_2_Delta_Skewness', 'Diff_bior2_2_Delta_Entropy', 'Diff_bior2_2_Theta_Mean', 'Diff_bior2_2_Theta_Median', 'Diff_bior2_2_Theta_Min', 'Diff_bior2_2_Theta_Max', 'Diff_bior2_2_Theta_Var', 'Diff_bior2_2_Theta_Power', 'Diff_bior2_2_Theta_Skewness', 'Diff_bior2_2_Theta_Entropy', 'Diff_bior2_2_Alpha_Mean', 'Diff_bior2_2_Alpha_Median', 'Diff_bior2_2_Alpha_Min', 'Diff_bior2_2_Alpha_Max', 'Diff_bior2_2_Alpha_Var', 'Diff_bior2_2_Alpha_Power', 'Diff_bior2_2_Alpha_Skewness', 'Diff_bior2_2_Alpha_Entropy', 'Diff_bior2_2_BetaGamma_Mean', 'Diff_bior2_2_BetaGamma_Median', 'Diff_bior2_2_BetaGamma_Min', 'Diff_bior2_2_BetaGamma_Max', 'Diff_bior2_2_BetaGamma_Var', 'Diff_bior2_2_BetaGamma_Power', 'Diff_bior2_2_BetaGamma_Skewness', 'Diff_bior2_2_BetaGamma_Entropy', 'Diff_bior4_4_Delta_Mean', 'Diff_bior4_4_Delta_Median', 'Diff_bior4_4_Delta_Min', 'Diff_bior4_4_Delta_Max', 'Diff_bior4_4_Delta_Var', 'Diff_bior4_4_Delta_Power', 'Diff_bior4_4_Delta_Skewness', 'Diff_bior4_4_Delta_Entropy', 'Diff_bior4_4_Theta_Mean', 'Diff_bior4_4_Theta_Median', 'Diff_bior4_4_Theta_Min', 'Diff_bior4_4_Theta_Max', 'Diff_bior4_4_Theta_Var', 'Diff_bior4_4_Theta_Power', 'Diff_bior4_4_Theta_Skewness', 'Diff_bior4_4_Theta_Entropy', 'Diff_bior4_4_Alpha_Mean', 'Diff_bior4_4_Alpha_Median', 'Diff_bior4_4_Alpha_Min', 'Diff_bior4_4_Alpha_Max', 'Diff_bior4_4_Alpha_Var', 'Diff_bior4_4_Alpha_Power', 'Diff_bior4_4_Alpha_Skewness', 'Diff_bior4_4_Alpha_Entropy', 'Diff_bior4_4_BetaGamma_Mean', 'Diff_bior4_4_BetaGamma_Median', 'Diff_bior4_4_BetaGamma_Min', 'Diff_bior4_4_BetaGamma_Max', 'Diff_bior4_4_BetaGamma_Var', 'Diff_bior4_4_BetaGamma_Power', 'Diff_bior4_4_BetaGamma_Skewness', 'Diff_bior4_4_BetaGamma_Entropy', 'Diff_sym6_Delta_Mean', 'Diff_sym6_Delta_Median', 'Diff_sym6_Delta_Min', 'Diff_sym6_Delta_Max', 'Diff_sym6_Delta_Var', 'Diff_sym6_Delta_Power', 'Diff_sym6_Delta_Skewness', 'Diff_sym6_Delta_Entropy', 'Diff_sym6_Theta_Mean', 'Diff_sym6_Theta_Median', 'Diff_sym6_Theta_Min', 'Diff_sym6_Theta_Max', 'Diff_sym6_Theta_Var', 'Diff_sym6_Theta_Power', 'Diff_sym6_Theta_Skewness', 'Diff_sym6_Theta_Entropy', 'Diff_sym6_Alpha_Mean', 'Diff_sym6_Alpha_Median', 'Diff_sym6_Alpha_Min', 'Diff_sym6_Alpha_Max', 'Diff_sym6_Alpha_Var', 'Diff_sym6_Alpha_Power', 'Diff_sym6_Alpha_Skewness', 'Diff_sym6_Alpha_Entropy', 'Diff_sym6_BetaGamma_Mean', 'Diff_sym6_BetaGamma_Median', 'Diff_sym6_BetaGamma_Min', 'Diff_sym6_BetaGamma_Max', 'Diff_sym6_BetaGamma_Var', 'Diff_sym6_BetaGamma_Power', 'Diff_sym6_BetaGamma_Skewness', 'Diff_sym6_BetaGamma_Entropy', 'Diff_db4_Delta_Mean', 'Diff_db4_Delta_Median', 'Diff_db4_Delta_Min', 'Diff_db4_Delta_Max', 'Diff_db4_Delta_Var', 'Diff_db4_Delta_Power', 'Diff_db4_Delta_Skewness', 'Diff_db4_Delta_Entropy', 'Diff_db4_Theta_Mean', 'Diff_db4_Theta_Median', 'Diff_db4_Theta_Min', 'Diff_db4_Theta_Max', 'Diff_db4_Theta_Var', 'Diff_db4_Theta_Power', 'Diff_db4_Theta_Skewness', 'Diff_db4_Theta_Entropy', 'Diff_db4_Alpha_Mean', 'Diff_db4_Alpha_Median', 'Diff_db4_Alpha_Min', 'Diff_db4_Alpha_Max', 'Diff_db4_Alpha_Var', 'Diff_db4_Alpha_Power', 'Diff_db4_Alpha_Skewness', 'Diff_db4_Alpha_Entropy', 'Diff_db4_BetaGamma_Mean', 'Diff_db4_BetaGamma_Median', 'Diff_db4_BetaGamma_Min', 'Diff_db4_BetaGamma_Max', 'Diff_db4_BetaGamma_Var', 'Diff_db4_BetaGamma_Power', 'Diff_db4_BetaGamma_Skewness', 'Diff_db4_BetaGamma_Entropy'};

% Only uses features as indicated by feature vector
predictorNames = predictorNames(:,logical(minVect(end,:)));

% Extract predictors and response
% This code processes the data into the right shape for training the
% model.
predictors             = inputTable(:, predictorNames);
response               = inputTable.Class;    

[lable, results] = predict(classificationSVM, predictors);

% Compute its accuracy and timing with new data set
a = 0;
resMat.tt = {};
resMat.tf = {};
resMat.ft = {};
resMat.ff = {};

for j = 1:length(table2array(predictors))
    if lable(j) == 1 && response(j) == 1 %truetrue
        resMat.tt(1,end+1) = {j};
    elseif lable(j) == 3 && response(j) == 3 %truefalse
        resMat.tf(1,end+1) = {j};
    elseif lable(j) == 1 && response(j) == 3 %falsetrue
        resMat.ft(1,end+1) = {j};
    elseif lable(j) == 3 && response(j) == 1 %falsefalse
        resMat.ff(1,end+1) = {j};
    end
end

for j = 1:length(table2array(predictors))
    tic;
    results = predict(classificationSVM, predictors(j,:));
    timeClass(j) = toc;
    if results == response(j)
            a = a+1;
    end
end

validationAccuracy2 = a/length(table2array(predictors))
dat = cat(3, datLoom(1:128,:,:), datRandom(1:128,:,:));
for lol = 1:size(dat,3)
filteredData(lol,:) = diySpatialFilter(P,dat(:,:,lol));
end

epoch = [0.600 1.250];
epoch(1) = (1.500 - epoch(1)) * 500;
epoch(2) = (1.500 - epoch(2)) * 500;
epoch(3) = 1.500 * 500;

looms{1} = dat(:,:,cell2mat(resMat.tt(1,:)));
randoms{1} = dat(:,:,cell2mat(resMat.tf(1,:)));
looms{2} = dat(:,:,cell2mat(resMat.ft(1,:)));
randoms{2} = dat(:,:,cell2mat(resMat.ff(1,:)));

figure(1)
figure('Color','white')
hold on
plot(mean(mean(looms{1},3),2), 'LineWidth', 1, 'Color', 'g', 'LineStyle' , '-')
plot(mean(mean(randoms{1},3),2), 'LineWidth', 1, 'Color', 'r', 'LineStyle' , '-')
legend('True Loom','True Random')
xlabel('Channel')
ylabel('Amplitude in \muV/sec');
xlim([0 124])
ylim([-3 4])
xticks([1 10 20 30 40 50 60 70 80 90 100 110 128])
ax = gca;
ax.XGrid = 'on';

figure(2)
figure('Color','white')
hold on
plot(mean(mean(looms{2},3),2), 'LineWidth', 1, 'Color', 'g', 'LineStyle' , '-')
plot(mean(mean(randoms{2},3),2), 'LineWidth', 1, 'Color', 'r', 'LineStyle' , '-')
legend('False Loom', 'False Random')
xlabel('Channel')
ylabel('Amplitude in \muV/sec');
xlim([0 124])
ylim([-3 4])
xticks([1 10 20 30 40 50 60 70 80 90 100 110 128])
ax = gca;
ax.XGrid = 'on';

dat = filteredData';
loom{1} = dat(:,cell2mat(resMat.tt(1,:)));
random{1} = dat(:,cell2mat(resMat.tf(1,:)));
loom{2} = dat(:,cell2mat(resMat.ft(1,:)));
random{2} = dat(:,cell2mat(resMat.ff(1,:)));

figure(3)
figure('Color','white')
plot(loom{1}, 'LineWidth', 1, 'LineStyle' , '-')
xline(epoch(3), 'LineWidth', 2.5);
xline(epoch(1), 'LineStyle', '--');
xline(epoch(2), 'LineStyle', '--');
xlabel('Time in sec')
ylabel('Amplitude in \muV');
xlim([0 850])
ylim([-800 700])
xticks([0:100:800 850])
xticklabels([0:100:800 850]./500-1.5)

figure(4)
figure('Color','white')
plot(loom{2}, 'LineWidth', 1, 'LineStyle' , '-')
xline(epoch(3), 'LineWidth', 2.5);
xline(epoch(1), 'LineStyle', '--');
xline(epoch(2), 'LineStyle', '--');
xlabel('Time in sec')
ylabel('Amplitude in \muV');
xlim([0 850])
ylim([-800 700])
xticks([0:100:800 850])
xticklabels([0:100:800 850]./500-1.5)

figure(5)
figure('Color','white')
plot(random{1}, 'LineWidth', 1, 'LineStyle' , '-')
xline(epoch(3), 'LineWidth', 2.5);
xline(epoch(1), 'LineStyle', '--');
xline(epoch(2), 'LineStyle', '--');
xlabel('Time in sec')
ylabel('Amplitude in \muV');
xlim([0 850])
ylim([-800 700])
xticks([0:100:800 850])
xticklabels([0:100:800 850]./500-1.5)

figure(6)
figure('Color','white')
plot(random{2}, 'LineWidth', 1, 'LineStyle' , '-')
xline(epoch(3), 'LineWidth', 2.5);
xline(epoch(1), 'LineStyle', '--');
xline(epoch(2), 'LineStyle', '--');
xlabel('Time in sec')
ylabel('Amplitude in \muV');
xlim([0 850])
ylim([-800 700])
xticks([0:100:800 850])
xticklabels([0:100:800 850]./500-1.5)

% figure(2)
% pspectrum(mean(mean(loom{1},3),1),500,'persistence','TimeResolution',0.9, 'FrequencyLimits',[2 25])
% figure(3)
% pspectrum(mean(mean(random{1},3),1),500,'persistence','TimeResolution',0.9, 'FrequencyLimits',[2 25])
% figure(4)
% pspectrum(mean(mean(loom{2},3),1),500,'persistence','TimeResolution',0.9, 'FrequencyLimits',[2 25])
% figure(5)
% pspectrum(mean(mean(random{2},3),1),500,'persistence','TimeResolution',0.9, 'FrequencyLimits',[2 25])

figure(7)
figure('Color','white')
hold on
plot(mean(loom{1},2), 'LineWidth', 1, 'Color', 'g', 'LineStyle' , '-')
plot(mean(random{1},2), 'LineWidth', 1, 'Color', 'r', 'LineStyle' , '-')
xline(epoch(3), 'LineWidth', 2.5);
xline(epoch(1), 'LineStyle', '--');
xline(epoch(2), 'LineStyle', '--');
xlabel('Time in sec')
ylabel('Grand Average Amplitude in \muV');
xlim([0 850])
ylim([-40 40])
xticks([0:100:800 850])
xticklabels([0:100:800 850]./500-1.5)
legend('True Loom','True Random','Collision', 'Epoch')

figure(8)
figure('Color','white')
hold on
plot(mean(loom{2},2), 'LineWidth', 1, 'Color', 'g', 'LineStyle' , '-')
plot(mean(random{2},2), 'LineWidth', 1, 'Color', 'r', 'LineStyle' , '-')
xline(epoch(3), 'LineWidth', 2.5);
xline(epoch(1), 'LineStyle', '--');
xline(epoch(2), 'LineStyle', '--');
xlabel('Time in sec')
ylabel('Grand Average Amplitude in \muV');
xlim([0 850])
ylim([-40 40])
xticks([0:100:800 850])
xticklabels([0:100:800 850]./500-1.5)
legend('False Loom', 'False Random', 'Collision', 'Epoch')


figure(9)
figure('Color','white')
pspectrum(mean(loom{1},2),500,'spectrogram','TimeResolution',0.85, 'FrequencyLimits',[2 25])
caxis([-50 30])
colormap jet
figure(10)
figure('Color','white')
pspectrum(mean(random{1},2),500,'spectrogram','TimeResolution',0.85, 'FrequencyLimits',[2 25])
caxis([-50 30])
colormap jet
figure(11)
figure('Color','white')
pspectrum(mean(loom{2},2),500,'spectrogram','TimeResolution',0.85, 'FrequencyLimits',[2 25])
caxis([-50 30])
colormap jet
figure(12)
figure('Color','white')
pspectrum(mean(random{2},2),500,'spectrogram','TimeResolution',0.85, 'FrequencyLimits',[2 25])
caxis([-50 30])
colormap jet

figure(13)
figure('Color','white')
hold on;
%Fres = 1.5081 Hz
a = pspectrum(mean(loom{1},2),500, 'FrequencyLimits',[2 25]);
b = pspectrum(mean(random{1},2),500, 'FrequencyLimits',[2 25]);
c = pspectrum(mean(loom{2},2),500, 'FrequencyLimits',[2 25]);
d = pspectrum(mean(random{2},2),500, 'FrequencyLimits',[2 25]);
plot(mag2db(a), 'LineWidth', 1, 'Color', 'g', 'LineStyle' , '-')
plot(mag2db(b), 'LineWidth', 1, 'Color', 'r', 'LineStyle' , '-')
plot(mag2db(c), 'LineWidth', 1, 'Color', 'g', 'LineStyle' , '--')
plot(mag2db(d), 'LineWidth', 1, 'Color', 'r', 'LineStyle' , '--')
xlabel('Frequency in Hz')
ylabel('Power Spectrum in dB');
legend('True Loom','True Random', 'False Loom', 'False Random')
xlim([0 length(a)])
xticks([0:length(a)/5:length(a)])
xticklabels([2 5 10 15 20 25])
ax = gca;
ax.XGrid = 'on';

%% Greate table
tabelRestt =  balanced2LoomRand(cell2mat(resMat.tt(1,:)),logical(minVect(end,:)));
meantt = mean(table2array(tabelRestt))
stdtt = std(table2array(tabelRestt))
lengthtt = length(table2array(tabelRestt))
tabelRestf =  balanced2LoomRand(cell2mat(resMat.tf(1,:)),logical(minVect(end,:)));
meantf = mean(table2array(tabelRestf))
stdtf = std(table2array(tabelRestf))
lengthtf = length(table2array(tabelRestf))
tabelResft =  balanced2LoomRand(cell2mat(resMat.ft(1,:)),logical(minVect(end,:)));
meanft = mean(table2array(tabelResft))
stdft = std(table2array(tabelResft))
lengthft = length(table2array(tabelResft))
tabelResff =  balanced2LoomRand(cell2mat(resMat.ff(1,:)),logical(minVect(end,:)));
meanff = mean(table2array(tabelResff))
stdff = std(table2array(tabelResff))
lengthff = length(table2array(tabelResff))

clear a b
for i = 1:size(loom{1},2)
[a(:,:,i)] = pspectrum(mean(loom{1,1}(:,i),2),500,'spectrogram','TimeResolution',0.85, 'FrequencyLimits',[2 25]);
end
for i = 1:size(loom{2},2)
b(:,:,i) = pspectrum(mean(random{1,1}(:,i),2),500,'spectrogram','TimeResolution',0.85, 'FrequencyLimits',[2 25]);
end
a = cat(2,a, a(:,end,:));
a = mean(a,3);
a = pow2db(a);
b = cat(2,b, b(:,end,:));
b = mean(b,3);
b = pow2db(b);
a = a-b;

figure(15)
surf(a, 'EdgeColor','none');  
xlim([0 7])
axis xy; axis tight; colormap(jet); view(0,90);
yticks(round([size(a,1)/5:size(a,1)/5:size(a,1)]))
yticklabels([5 10 15 20 25])
xticks([1:1:7])
xticklabels(round([-1.178:0.206:0.058],2))
colorbar
ylabel('Frequency in Hz');
xlabel('Time in s')
c = colorbar;
c.Label.String = 'Power in dB';
caxis([-6 6])
xline(6.61, 'LineWidth', 2.5);

clear a b
for i = 1:size(loom{2},2)
a(:,:,i) = pspectrum(mean(loom{1,2}(:,i),2),500,'spectrogram','TimeResolution',0.85, 'FrequencyLimits',[2 25]);
end
for i = 1:size(random{2},2)
b(:,:,i) = pspectrum(mean(random{1,2}(:,i),2),500,'spectrogram','TimeResolution',0.85, 'FrequencyLimits',[2 25]);
end

figure(16)
a = cat(2,a, a(:,end,:));
a = mean(a,3);
a = pow2db(a);
b = cat(2,b, b(:,end,:));
b = mean(b,3);
b = pow2db(b);
a = a-b;
surf(a, 'EdgeColor','none');  
xlim([0 7])
axis xy; axis tight; colormap(jet); view(0,90);
yticks(round([size(a,1)/5:size(a,1)/5:size(a,1)]))
yticklabels([5 10 15 20 25])
xticks([1:1:7])
xticklabels(round([-1.178:0.206:0.058],2))
colorbar
ylabel('Frequency in Hz');
xlabel('Time in s')
c = colorbar;
c.Label.String = 'Power in dB';
caxis([-6 6])
xline(6.61, 'LineWidth', 2.5)

% clear a
% for i = 1:size(random{1},2)
% a(:,:,i) = pspectrum(mean(random{1,1}(:,i),2),500,'spectrogram','TimeResolution',0.85, 'FrequencyLimits',[2 25]);
% end
% figure(17)
% a = cat(2,a, a(:,end,:));
% a = std(a,0,3);
% a = pow2db(a);
% surf(a, 'EdgeColor','none');  
% xlim([0 7])
% axis xy; axis tight; colormap(jet); view(0,90);
% yticks(round([size(a,1)/5:size(a,1)/5:size(a,1)]))
% yticklabels([5 10 15 20 25])
% xticks([1:1:7])
% xticklabels(round([-1.178:0.206:0.058],2))
% colorbar
% ylabel('Frequency in Hz');
% xlabel('Time in s')
% c = colorbar;
% c.Label.String = 'Power in dB';
% xline(6.61, 'LineWidth', 2.5)
% 
% clear a
% for i = 1:size(random{2},2)
% a(:,:,i) = pspectrum(mean(random{1,2}(:,i),2),500,'spectrogram','TimeResolution',0.85, 'FrequencyLimits',[2 25]);
% end
% figure(18)
% a = cat(2,a, a(:,end,:));
% a = std(a,0,3);
% a = pow2db(a);
% surf(a, 'EdgeColor','none');  
% xlim([0 7])
% axis xy; axis tight; colormap(jet); view(0,90);
% yticks(round([size(a,1)/5:size(a,1)/5:size(a,1)]))
% yticklabels([5 10 15 20 25])
% xticks([1:1:7])
% xticklabels(round([-1.178:0.206:0.058],2))
% colorbar
% ylabel('Frequency in Hz');
% xlabel('Time in s')
% c = colorbar;
% c.Label.String = 'Power in dB';
% xline(6.61, 'LineWidth', 2.5)
