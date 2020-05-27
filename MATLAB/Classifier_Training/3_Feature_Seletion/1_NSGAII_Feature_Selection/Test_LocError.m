% clear
% clc
% 
% load('Head_Model_10K.mat')
% load('Dataset1.mat', 'y')
% load('Dataset1.mat', 'loc_xyz')
% 
% Instance = 35;

%Error Source 1
test_s1=LocError(M,vert,y(:,1:150,Instance),loc_xyz(1,:,Instance));

% test_s1=LocError_MSP(M,vert,y(:,1:150,Instance),loc_xyz(1,:,Instance),QG,face);
electrodes_s1 = round(ones(size(y,1),1));
tic
error_s1 = test_s1.localization_error(electrodes_s1)
toc