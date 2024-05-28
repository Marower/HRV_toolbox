function [SSDN] = calculateSSDN (RR, windowLength)
N = ceil ((RR(end,1)-windowLength));
if (N>0)
    SSDN (N+1) = 0;
    for i=0:N
        selection = (RR(:,1)>i) & (RR(:,1)<(i+windowLength)); 
        SSDN(i+1) = std(RR(selection,2));
    end
else
    SSDN = std(RR(:,2));
end