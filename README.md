# HRV toolbox

## HRV Frameworks
### [LFiA, HFiA] = calculateInstantaneousAmplitude (RR)
Based on: 
 von Rosenberg, Wilhelm, Theerasak Chanwimalueang, Tricia Adjei, Usman Jaffer, Valentin Goverdovsky, and Danilo P. Mandic. "Resolving ambiguities in the LF/HF ratio: LF-HF scatter plots for the categorization of mental and physical stress from HRV." Frontiers in physiology 8 (2017): 360.

### [RAS, PQ1, PQ24, PQ3] = calculateClassAMetrics (RR)
Based on:
 Adjei, Tricia, Wilhelm von Rosenberg, Takashi Nakamura, Theerasak Chanwimalueang, and Danilo P. Mandic. "The classA framework: HRV based assessment of SNS and PNS dynamics without LF-HF controversies." Frontiers in physiology 10 (2019): 505.

## Signal Quality Indexes
### [SQI, hosSQI, sSQI, kSQI] = SQI_higherOrderStatistics(ECG)
From: 
 G. D. Clifford, J. Behar, Q. Li and I. Rezek, "Signal quality indices and data fusion for determining clinical acceptability of electrocardiograms", Physiol. Meas., vol. 33, no. 9, pp. 1419-1433, 2012.

### [iorSQI, basSQI, pSQI] = SQI_frequencyBased (ECG, fs)
Taken from: 
 Nardelli, Mimma, et al. "A tool for the real-time evaluation of ECG signal quality and activity: Application to submaximal treadmill test in horses." Biomedical Signal Processing and Control 56 (2020): 101666.

### [bSQI, iSQI_fD] = SQI_peakDetectionBased (Rindexes_firstDetector, Rindexes_secondDetector, treshold)
From: 
 Behar Joachim, Oster Julien, Qiao Li, Clifford Gari D. Signal Quality During Arrhythmia and its Application to False Alarm Reduction. IEEE Transactions on Biomedical Engineering. 60(6). 1660-6. 2013.

## Minor functions:
### [SSDN] = calculateSSDN (RR, windowLength)
### R = detectRPeaks (ECG, FS, detector)
### cleaned_rr_intervals = removeEctopicBeats(rr_intervals)
