function [bSQI, iSQI_fD] = SQI_peakDetectionBased (Rindexes_firstDetector, Rindexes_secondDetector, treshold)
%     [1] Behar Joachim, Oster Julien, Qiao Li, Clifford Gari D. Signal Quality
%     During Arrhythmia and its Application to False Alarm Reduction. 
%     IEEE Transactions on Biomedical Engineering. 60(6). 1660-6. 2013.
%
%     [2] Li, Qiao, Roger G. Mark, and Gari D. Clifford. "Robust heart rate estimation 
%     from multiple asynchronous noisy sources using signal quality indices and 
%     a Kalman filter." Physiological measurement 29.1 (2008): 15.

% ussualy treshold = 0.05s (provide value in samples round(0.05*fs))

Nmatched = sum(abs(Rindexes_firstDetector-Rindexes_secondDetector)<treshold);

NDMF = length(Rindexes_firstDetector);
NSecondDetector = length(Rindexes_secondDetector);

bSQI = Nmatched / (NDMF + NSecondDetector - Nmatched);

RR = diff(Rindexes_firstDetector);

RR_15percentile = prctile(RR,15);
RR_85percentile = prctile(RR,85);

iSQI_fD = RR_15percentile / RR_85percentile;