function [ toda, correlation, lags ] = tdoa( s1, s2, maxlag )
%TODA Compute toda
%   s1 and s2 must be either row- or columnvectors

% Length of signals
l1 = length(s1);
l2 = length(s2);


% Zero padding
N  = max([l1,l2,maxlag]); % length for zero padding
if length(s1) < N
    s1(N) = 0;
end
if length(s2) < N
    s2(N) = 0;
end

% Generate lags
lags = -maxlag:maxlag;

% Compute Correlation
% allocation for correlation
if iscolumn(s1)
    correlation = zeros(length(lags),1);
elseif isrow(s1)
    correlation = zeros(1,length(lags));
end
lagInd = 0; % Index for correlation
for actLag = lags
    lagInd = lagInd + 1;
    if actLag < 0
        % s2 is shifted from the left onto s1
        correlation(lagInd) = sum( s1(1:l2+actLag) .* conj(s2(-actLag+1:l2)) );
    else
        % s1 is shifted from the left onto s2
        correlation(lagInd) = sum( s1(actLag+1:l1) .* conj(s2(1:l1-actLag)) );
    end
end

% Find toda
[~, index] = max(abs(correlation));
toda = lags(index);

end