function [bSQI, iSQI_fD] = SQI_peakDetectionBased (Rindexes_firstDetector, Rindexes_secondDetector, treshold)
%     [1] Behar Joachim, Oster Julien, Qiao Li, Clifford Gari D. Signal Quality
%     During Arrhythmia and its Application to False Alarm Reduction. 
%     IEEE Transactions on Biomedical Engineering. 60(6). 1660-6. 2013.
%
%     [2] Li, Qiao, Roger G. Mark, and Gari D. Clifford. "Robust heart rate estimation 
%     from multiple asynchronous noisy sources using signal quality indices and 
%     a Kalman filter." Physiological measurement 29.1 (2008): 15.

% ussualy treshold = 0.05s (provide value in samples round(0.05*fs))

% Determine which vector is smaller
if length(Rindexes_firstDetector) < length(Rindexes_secondDetector)
    smallVector = Rindexes_firstDetector;
    largeVector = Rindexes_secondDetector;
else
    smallVector = Rindexes_secondDetector;
    largeVector = Rindexes_firstDetector;
end

% Initialize an array to store the pairs
pairs = zeros(length(smallVector), 2);

% Initialize an array to keep track of used indices in the larger vector
usedIndices = false(1, length(largeVector));

% Pair the closest values
for i = 1:length(smallVector)
    minDiff = Inf;
    minIndex = -1;
    for j = 1:length(largeVector)
        if ~usedIndices(j)
            difference = abs(smallVector(i) - largeVector(j));
            if difference < minDiff
                minDiff = difference;
                minIndex = j;
            end
        end
    end
    pairs(i, :) = [smallVector(i), largeVector(minIndex)];
    usedIndices(minIndex) = true;
end


Nmatched = sum(abs(pairs(:,1)-pairs(:,2))<treshold);

NDMF = length(Rindexes_firstDetector);
NSecondDetector = length(Rindexes_secondDetector);

bSQI = Nmatched / (NDMF + NSecondDetector - Nmatched);

RR = diff(Rindexes_firstDetector);

RR_15percentile = prctile(RR,15);
RR_85percentile = prctile(RR,85);

iSQI_fD = RR_15percentile / RR_85percentile;