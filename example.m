ECG = load('ECG.mat').ECG;
FS = 500;
addpath './Functions/'
% detect R peaks in signal
% This code required Python and py-ecg-detectors package: 
% https://pypi.org/project/py-ecg-detectors/
% pip install py-ecg-detectors
% (+numpy and scipy)

%% HRV analysis
detector = "two_averaged";
R = double(detectRPeaks (ECG(:,2), FS, detector)');

RR = [R(2:end)/FS,removeEctopicBeats(diff(R/FS)*1000)];

% Remove suspicious detections
RR = RR(~(RR(:,2)>2000 | RR(:,2)<300),:);

% Calculatre SDNN for given windows:
SSDN10 = calculateSSDN (RR,10);
SSDN60 = calculateSSDN (RR,60);
SSDN300 = calculateSSDN (RR,300);

% Resampele nonuniformly RR intervals into uniformly 4Hz sampled data
clear RR_us
[RR_us(:,2),RR_us(:,1)] = resample(RR(:,2),RR(:,1),4, "spline");
RR_us(:,2) = lowpass(RR_us(:,2),1,4);

% Do not extrapolate
RR_us = RR_us(RR_us(:,1)<max(RR(:,1)),:);

% ussage:
[LFi, HFi] = calculateInstantaneousAmplitude (RR_us);

[RAS, PQ1, PQ24, PQ3] = calculateClassAMetrics (RR_us);

%Example of time alighment of diffren window data:
result = table;
result.time = (0:ceil(max(RR(:,1))))';
result.SSDN10 = [nan(1,10),SSDN10]';
result.SSDN60 = [nan(1,60),SSDN60]';
result.SSDN300 = [nan(1,300),SSDN300]';

result.LFi = [nan(1,300),LFi]';
result.HFi = [nan(1,300),HFi]';

result.RAS = [nan(1,10),RAS]';
result.PQ1 = [nan(1,10),PQ1]';
result.PQ24 = [nan(1,10),PQ24]';

result.PQ3 = [nan(1,60),PQ3]';

%% SQI evaluation
detector = "wqrs";
R_1 = double(detectRPeaks (ECG(:,2), FS, detector)');

detector = "pan_tompkins";
R_2 = double(detectRPeaks (ECG(:,2), FS, detector)');

[bSQI, iSQI_fD] = SQI_peakDetectionBased (R_1, R_2, 0.05*FS);

[iorSQI, basSQI, pSQI] = SQI_frequencyBased (ECG(:,2), FS);

[SQI, hosSQI, sSQI, kSQI] = SQI_higherOrderStatistics(ECG(:,2));

% SQIs function provide one estimation for provide signal

%% Adaptive filtration

noise = rand(length(ECG(:,2)),1);
Noise = 0.001*noise;
sig = ECG(:,2)+Noise;

[Signal, error] = LMS_filtration (sig, Noise, 10);

ax(1) = subplot (3,1,1);
plot (sig)
ax(2) = subplot (3,1,2);
plot (Noise)
ax(3) = subplot (3,1,3);
plot(error)
linkaxes(ax,'x')