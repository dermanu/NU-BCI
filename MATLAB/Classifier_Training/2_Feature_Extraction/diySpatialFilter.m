function [filteredData] = diySpatialFilter(P,data)

%% Weighten the Data according to the spatial pattern square
weightened = data.*(P.^2);
%weightened = data;

%% Create mean response
meanWei = mean(weightened,1);

%% Correlation between mean response and single channels
for i = 1:size(weightened,1)
    C = corrcoef(weightened(i,:), meanWei);
    correlation(i) = C(1,2);
end
% Find the highest coorlations
[~, maxIdx] = maxk(correlation,5);

% Create the mean of them
filteredData = mean(weightened(maxIdx,:));

end

