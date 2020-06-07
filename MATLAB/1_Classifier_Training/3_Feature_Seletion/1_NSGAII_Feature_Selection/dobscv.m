% DOBSCV Create cross-validation partition for data.
% 
%   C = DOBSCV(X, Y, N) partitions a data set X into N folds in such a way
%   that a balanced distribution in feature space is maintained for each 
%   class, in addition to stratification based on the label Y.
% 
% Limitations:
%   DOBSCV is a distance based algorithm. Hence, this algorithm does not
%   scale well with the size of the data set.
% 
% Example:
%   x = rand(8, 6)              % 8 samples with 6 numerical features 
%   y = randi(3, 8, 1)          % polynomial label in a column vector
%   n = 3                       % partition the data set into 3 folds
%   rnd(2001)                   % for reproducibility
%   x2 = zscore(x)              % we use Euclidean dist inside -> normalize
%   cv = dobscv(x2, y, n)
% 
% Reference: 
%   Study on the impact of partition-induced dataset shift on k-fold 
%   cross-validation by Zeng, Xinchuan & Martinez, Tony R. 
%
% See also CVPARTITION, CROSSVAL.

function solution = dobscv(x, y, n)
% Argument validation
validateattributes(x, {'numeric'}, {'2d'})
validateattributes(y, {'numeric', 'char', 'string'}, {'column'})
validateattributes(n, {'numeric'}, {'scalar', 'positive', 'nonnan', 'finite'})
assert(size(x, 1) == size(y, 1), 'Count of rows in x and y must match')
assert(round(n) == n, 'The count of folds must be a whole number')

% Initialization
solution = nan(size(y));
classes = unique(y)';
fold = 1; % Fold sizes should be similar -> we track the next fold to use

for class=classes
    i = find(y==class);
    i = i(randperm(length(i)));
    x2 = x'; % Transposed for better cache locality
    while ~isempty(i)
        % Find the nearest neighbours to the first sample
        distance = sum((x2(:, i) - x2(:, i(1))).^2);
        [~, i2] = sort(distance);

        % Assign the samples into the folds
        nrow = min(n, length(i));
        i2 = i2(1:nrow);
        solution(i(i2)) = mod1(fold:fold+nrow-1, n);
        fold = fold+nrow;
      
        % Remove the assigned samples from the list
        i(i2) = []; 
    end 
end
