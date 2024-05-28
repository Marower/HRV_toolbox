function [LFiA, HFiA] = calculateInstantaneousAmplitude (RR)
% Based on: 
% von Rosenberg, Wilhelm, Theerasak Chanwimalueang, Tricia Adjei, 
% Usman Jaffer, Valentin Goverdovsky, and Danilo P. Mandic. 
% "Resolving ambiguities in the LF/HF ratio: LF-HF scatter plots for 
% the categorization of mental and physical stress from HRV." 
% Frontiers in physiology 8 (2017): 360.

% Input:
% RR - uniformly 4Hz sampled RR intervals in ms

% 1. Bandpass-filter the NNI into two bands, the LF and the HF
LF = bandpass(RR,[0.04 0.15],4);
HF = bandpass(RR,[0.15 0.4],4);
windowLength = 300;
N = ceil(RR(end,1)-windowLength);

LFiA(N+1) = 0;
HFiA(N+1) =0;

% 300 sec windows with 1 sec step
for i = 0:N
    % 2. Apply the Hilbert transform
    selection = (RR(:,1)>i) & (RR(:,1)<(i+windowLength)); 
    LF_h = hilbert(LF(selection));
    HF_h = hilbert(HF(selection));
    
    % 3. Calculate amplitude of complex values
    LF_a = abs(LF_h);
    HF_a = abs(HF_h);
 
    % 5. Exlude the 20% largest and smallest values, to remove outliers
    LF_sorted = sort(LF_a);
    HF_sorted = sort(HF_a);
    LF_removed = LF_sorted(ceil(length(LF_sorted)*0.2):ceil(length(LF_sorted)*0.8));
    HF_removed = HF_sorted(ceil(length(HF_sorted)*0.2):ceil(length(HF_sorted)*0.8));
    
    %Calculate the mean for every time window
    LFiA(i+1) = mean(LF_removed);
    HFiA(i+1) = mean(HF_removed);
end