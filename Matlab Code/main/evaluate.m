function evaluate(FileNameEKG, signal, ekgFs, audioFs)
    % evaluate processes the EKG data, visualises it and compares it with 
    % The google pixel 8 heart recording
    %
    % Args:
    %   fileNameEKG - String path to the EKG CSV file.
    %   signal - filtered audio signal array.
    %   ekgFs - EKG data sample rate in Hz.
    %   audioFs - sampling rate of audio.
    %
    % The function generates multiple plots to visualize EKG signals in the time and
    % frequency domains, the processed audio signal, and a comparison of heart rates.

    % Load EKG data
    opts = detectImportOptions(FileNameEKG);
    opts.VariableNamingRule = 'preserve';
    data = readtable(FileNameEKG, opts);

    % Extract signal and time values
    ekgSignal = data.('Data Set 1:EKG(mV)');
    time = data.('Data Set 1:Time(s)'); 
    % Check that data set 1 matches your data set, 
    % Vernier graphical analysis stores data in different columns when
    % restarting experiments, thus some EKG recordings might contain data
    % values in a different set in the same csv file eg: 2 or 3 ...etc

    % Frequency domain calculations for EKG
    ekgSignalFFT = fft(ekgSignal);
    fullSpecEKG = abs(ekgSignalFFT / length(ekgSignal));
    freqSpecEKG = fullSpecEKG(1:length(ekgSignal)/2+1);
    freqSpecEKG(2:end-1) = 2*freqSpecEKG(2:end-1);
    freqVecEKG = ekgFs * (0:(length(ekgSignal)/2)) / length(ekgSignal);

    [ekgPeaks, ekgLocs] = findpeaks(ekgSignal, 'MinPeakHeight', max(ekgSignal) * 0.6, 'MinPeakDistance', round(0.3 * ekgFs));

    [signalPeaks, audioLocs] = findpeaks(signal, 'MinPeakHeight', mean(signal) * 50, 'MinPeakDistance', audioFs * 0.5);

    timeVecSignal = linspace(0, (length(signal)-1) / audioFs, length(signal));

    normalizedEKG = (ekgSignal - min(ekgSignal)) / (max(ekgSignal) - min(ekgSignal));
    normalizedSignal = (signal - min(signal)) / (max(signal) - min(signal));

    evaluationFigure = figure('Name', 'EKG and Phone Signal Analysis', 'NumberTitle', 'off', 'Position', [100, 100, 1200, 900]);
    annotation(evaluationFigure, 'textbox', [0.3, 0.94, 0.4, 0.05], 'String', 'Evaluation of heartbeat calculation','HorizontalAlignment', 'center', 'FontSize', 16, 'FontWeight', 'bold', 'EdgeColor', 'none');

    % EKG signal in time domain
    subplot(4, 1, 1);
    plot(time, ekgSignal, 'b', 'LineWidth', 1.5);
    xlabel('Time (s)');
    ylabel('EKG (mV)');
    title('Original EKG Signal', 'FontSize', 12);
    grid on;
    
    % EKG peaks
    subplot(4, 1, 2);
    plot(time, ekgSignal, 'b', 'LineWidth', 1.5);
    hold on;
    plot(time(ekgLocs), ekgPeaks, 'v', 'MarkerFaceColor', 'green', 'MarkerEdgeColor', 'green');
    hold off;
    xlabel('Time (s)');
    ylabel('EKG (mV)');
    title('Original EKG Signal with Peaks', 'FontSize', 12);
    grid on;
    
    % EKG signal in frequency domain
    subplot(4, 1, 3);
    plot(freqVecEKG, freqSpecEKG);
    xlabel('Frequency (Hz)');
    ylabel('|Amplitude|');
    title('Frequency Domain of EKG', 'FontSize', 12);
    grid on;
    
    % Phone recording peaks
    subplot(4, 1, 4);
    plot(timeVecSignal, signal, 'Color', [0, 0.4470, 0.7410], 'LineWidth', 1.5);
    hold on;
    plot(timeVecSignal(audioLocs), signalPeaks, 'v', 'MarkerFaceColor', 'green', 'MarkerEdgeColor', 'green');
    hold off;
    xlabel('Time (s)');
    ylabel('Amplitude');
    title('Audio Recording Signal with Peaks', 'FontSize', 12);
    grid on;

    % Calculate heart rates 
    ekgHeartRate = heartRateCalculatorEKG(ekgSignal, ekgFs); 
    phoneHeartRate = heartRateCalculator(signal, audioFs);  
    diffPercent = ((ekgHeartRate - phoneHeartRate) / ekgHeartRate) * 100;
    
    combinedHeartFigure = figure('Name', 'Phone heart rate evaluation', 'NumberTitle', 'off', 'Position', [100, 100, 1200, 600]);
    annotation(combinedHeartFigure, 'textbox', [0.3, 0.94, 0.4, 0.05], 'String', 'Heart Rate Recording and Comparison','HorizontalAlignment', 'center', 'FontSize', 16, 'FontWeight', 'bold', 'EdgeColor', 'none');

    % EKG and Phone captured audio plot
    subplot(2, 1, 1);
    plot(time, normalizedEKG, 'LineWidth', 1.5, 'Color', [0, 0.4470, 0.7410], 'DisplayName', 'Normalized EKG');
    hold on;
    plot(timeVecSignal, normalizedSignal, 'LineWidth', 1.5, 'Color', [0.9290 0.6940 0.1250], 'DisplayName', 'Normalized Audio');
    hold off;
    xlabel('Time (s)');
    ylabel('Normalized Amplitude');
    title('Combined EKG and Pixel 8 Heart Recording');
    legend('show');
    grid on;

    % heart rate comparison
    subplot(2, 1, 2);
    b = bar([ekgHeartRate, phoneHeartRate], 0.4);
    set(gca, 'XTickLabel', {'EKG Heart Rate', 'Phone Heart Rate'});
    ylabel('Heart Rate (BPM)');
    title(sprintf('Heart Rate Comparison\nEKG: %.2f BPM, Phone: %.2f BPM\nDifference: %.2f BPM (%.2f%%)', ekgHeartRate, phoneHeartRate, ekgHeartRate - phoneHeartRate, diffPercent));
    b.FaceColor = 'flat';
    b.CData(1,:) = [0, 0.4470, 0.7410];
    b.CData(2,:) = [0.9290 0.6940 0.1250];
    set(combinedHeartFigure, 'Color', 'w');

end

