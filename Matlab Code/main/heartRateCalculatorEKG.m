function heartRate = heartRateCalculatorEKG(ekgSignal, fs)
    % Calculate heart rate manually from the EKG signal with 
    % specific min peak height and min peak distance 
    %
    % This code is designed specifically for the EKG data captured in this
    % project
    % 
    % ecgSignal - EKG array
    % fs - sampling frequency of the EKG signal

    threshold = 0.3;

    minPeakDistance = round(0.4 * fs); %

    peakCount = 0;
    lastPeak = 0; 
    p = []; 

    % Count heart rate
    for i = 1:length(ekgSignal)
        if (ekgSignal(i) > threshold) && (i > lastPeak + minPeakDistance)
            peakCount = peakCount + 1;
            lastPeak = i; 
            p = [p, i]; 
        end
    end
    heartRate = peakCount;
  
end

