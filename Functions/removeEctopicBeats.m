function cleaned_rr_intervals = removeEctopicBeats(rr_intervals)
    % Set a threshold for detecting ectopic beats (replace with your threshold value)
    threshold = 50; % Adjust as needed
    
    % Initialize cleaned RR intervals
    cleaned_rr_intervals = rr_intervals;
    
    % Find ectopic beats based on threshold
    ectopic_beats = abs(cleaned_rr_intervals - movmean(cleaned_rr_intervals,5)) > threshold;

    % Remove ectopic beats by setting their values to NaN
    cleaned_rr_intervals(ectopic_beats) = NaN;

    % Interpolate NaN values to fill in missing RR intervals
    cleaned_rr_intervals = fillmissing(cleaned_rr_intervals, 'linear');
end
 