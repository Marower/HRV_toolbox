function [SQI, hosSQI, sSQI, kSQI] = SQI_higherOrderStatistics(ECG)
% SQIs taken from: Nardelli, Mimma, et al. "A tool for the real-time 
% evaluation of ECG signal quality and activity: Application to submaximal
% treadmill test in horses." Biomedical Signal Processing and Control 56
% (2020): 101666.

% Good Kurtossis and scewness equations:
% C. Liu et al., "Signal Quality Assessment and Lightweight QRS Detection 
% for Wearable ECG SmartVest System," in IEEE Internet of Things Journal, 
% vol. 6, no. 2, pp. 1363-1374, April 2019, doi: 10.1109/JIOT.2018.2844090.

kSQI = kurtosis(ECG);
sSQI = skewness(ECG);
hosSQI = abs(sSQI) * (kSQI/5);

if (hosSQI>0.8)
    SQI = 'G';
elseif (hosSQI>0.5)
    SQI = 'A';
else
    SQI = 'U';
end