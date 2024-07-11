function heartRate = heartRateCalculator(signal, fs)
    % Calculate heart rate from a signal by identifying peaks and measuring
    % the average time between them.
    %
    % Args:
    %   signal - Array containing heart signal data.
    %   fs - Sampling rate of the signal in Hz.
    %
    % Returns:
    %   heartRate - Estimated heart rate in beats per minute (BPM).

    minPeakHeight = mean(signal) * 50;
    minPeakDistance = fs * 0.5;

    [x, peaks] = findpeaks(signal, 'MinPeakHeight', minPeakHeight, 'MinPeakDistance', minPeakDistance);
    
    peakIntervals = diff(peaks) / fs;
    
    avgInterval = mean(peakIntervals);
    
    heartRate = 60 / avgInterval;
end
