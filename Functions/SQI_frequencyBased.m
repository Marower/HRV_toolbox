function [iorSQI, basSQI, pSQI] = SQI_frequencyBased (ECG, fs)
% iorSQI, basSQI taken from: Nardelli, Mimma, et al. "A tool for the real-time 
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

% pSQI from: Liu, Chengyu, et al. "Signal quality assessment and 
% lightweight QRS detection for wearable ECG SmartVest system." 
% IEEE Internet of Things Journal 6.2 (2018): 1363-1374.

P_Integral5to15 = sum(pxx(f>5&f<15)*df);
P_Integral5to45 = sum(pxx(f>5&f<45)*df);

pSQI = P_Integral5to15 / P_Integral5to45;