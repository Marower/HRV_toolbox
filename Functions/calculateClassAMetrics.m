function [RAS, PQ1, PQ24, PQ3] = calculateClassAMetrics (RR)
% Based on:
% Adjei, Tricia, Wilhelm von Rosenberg, Takashi Nakamura, 
% Theerasak Chanwimalueang, and Danilo P. Mandic. "The classA framework: 
% HRV based assessment of SNS and PNS dynamics without LF-HF controversies."
% Frontiers in physiology 10 (2019): 505.

% Input:
% RR - uniformly 4Hz sampled RR intervals

%Frame work 1:
% 1. Create a scatter plot of first differences within HRV
% x = (4x[n+2] - 3x[n+1] - x[n+3]) / 2
% y = (4x[n+1] - 3x[n] - x[n+2)) / 2

NN = RR(:,2);

x(length(NN)-3) = 0;
y(length(NN)-3) = 0;

for n = 1:(length(NN)-3)
    x(n) = (4*NN(n+2) - 3*NN(n+1) - NN(n+3)) / 2;
    y(n) = (4*NN(n+1) - 3*NN(n) - NN(n+2)) / 2;
end
maxRR_t = RR (end,1);
RR = RR (1:(end-3),:);

% scatter (x,y);

% 2. Calculate in the anti-clockwise direction the angle that each point in
% the scatter plot makes with the abscissa

angles = (atan2(y, x) * 180) / pi;

% "The ClassA analyses to obtain PQ1, PQ24 and RAS were undertaken within a 
% 10-s window, with a 1-s increment, whilst the ClassA analyses to obtain 
% PQ3 were computed in a 60-s window with a 1-s increment, whereby HRV 
% signals were coarse-grained to a τ of seven." 

% Hardcoded sample frequency of 4

% First undertake PQ1, PQ24 and RAS
if (length(angles)>40)
    N = ceil(RR(end,1)-10);
    
    RAS(N+1) = 0;
    PQ1(N+1) = 0;
    PQ24(N+1) = 0;
    %Make 10s window with 1-s increment   
    windowLength = 10;
    for i=0:N
        selection = (RR(:,1)>i) & (RR(:,1)<(i+windowLength)); 
        % 3. Calculate RAS as sum of angles divided by number of data-points
        RAS(i+1) = sum (angles(selection)) / sum(selection);
        
        % 4. Calculate PQ1 as number of points which fall within the first quadrant
        % divide by total number of points
        
        PQ1(i+1) = sum ((x(selection)>0) & (y(selection)>0)) / sum(selection);
        
        % 5. Calculate PQ24 as number of points which fall within the second and 
        % fourth quadrant divide by total number of points
        
        PQ24(i+1) = (sum ((x(selection)<0) & (y(selection)>0)) ...
            + sum ((x(selection)>0) & (y(selection)<0))) / sum(selection);
    end
else
    disp "Minimum length of data to calculate RAS PQ1 and PQ24 is 10seconds - 40 samples"
    RAS = [];
    PQ1 = [];
    PQ24 = [];
end

% Calculate PQ3
TS =  7; % Trisha et al. used temporal scale = 7.
if (length(x)>240)
    windowSize = 60;
    N = ceil(RR(end,1)-windowSize);
    PQ3(N+1) = 0;

    for i=0:N
        selection = (RR(:,1)>i) & (RR(:,1)<(i+windowLength)); 
        SampleCount = floor(sum(selection)/TS);

        x_cg(SampleCount) = 0;
        y_cg(SampleCount) = 0;
        % Cours-grain the HRV signal to access the signal at a higher temporal
        % scale:
        x_sel = x(selection);
        y_sel = y(selection);
        for j=1:SampleCount
            indexes = (((j-1)*7)+1):j*7;
            x_cg(j) = sum(x_sel(indexes))/TS;
            y_cg(j) = sum(y_sel(indexes))/TS;
        end 
        % 6. Calculate PQ3       
        PQ3(i+1) = sum ((x_cg<0) & (y_cg<0)) / SampleCount;
    end
else
    disp "Minimum length of data to calculate PQ3 is 60seconds - 240 samples"
    PQ3 = [];
end

if (floor(maxRR_t) - floor(RR(end,1)))>0
    RAS = [RAS,nan];
    PQ1 = [PQ1,nan];
    PQ24 = [PQ24,nan];
    PQ3 = [PQ3,nan];
end