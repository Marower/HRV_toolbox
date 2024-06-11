function [iorSQI, basSQI] = SQI_frequencyBased (ECG, fs)
% SQIs taken from: Nardelli, Mimma, et al. "A tool for the real-time 
% evaluation of ECG signal quality and activity: Application to submaximal
% treadmill test in horses." Biomedical Signal Processing and Control 56
% (2020): 101666.

[pxx, f] = pwelch(ECG, [], [], [], fs);
df = mean(diff(f));

P_Integral1to40 = sum(pxx(f>1&f<40)*df);
P_Integral0to40 = sum(pxx(f<40)*df);

basSQI = P_Integral1to40 / P_Integral0to40;

P_Integral5to40 = sum(pxx(f>5&f<40)*df);
P_IntegralAll = sum(pxx*df);

iorSQI = P_Integral5to40 / (P_IntegralAll- P_Integral5to40);