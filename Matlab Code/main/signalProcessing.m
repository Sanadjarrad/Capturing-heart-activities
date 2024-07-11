function [denoisedSignal, fs] = signalProcessing(filename)
    % Filters and decomposes an audio file using low pass Infinite Impulse
    % Response (IIR) filter, Maximal Overlap Discrete Wavelet Transform
    % (MODWT), Multiresolution anlysis (MRA)and Wavelet Denoising through soft thresholding.
    % Results are plotted and displayed
    %
    % Args:
    %   filename - String containing the path to the file.
    %
    % Returns:
    %   denoisedSignal - Matrix of processed and denoised audio signal.
    %   fs - Sampling rate of the audio file.

    [signal, fs] = audioread(filename);
    duration = length(signal) / fs;
    % Time vector
    t = linspace(0, duration, length(signal));

    filter = chebyOneLowPass();
    filteredSignal = filter(signal);

    signalFFT = fft(signal);
    freqVecSignal = (0:length(signalFFT)-1) * fs / length(signalFFT);
    ampSpecSignal = abs(signalFFT/length(signal));

    filteredSignalFFT = fft(filteredSignal);
    freqVecFilteredSignal = (0:length(filteredSignalFFT)-1) * fs / length(filteredSignalFFT);
    ampSpecFilteredSignal = abs(filteredSignalFFT/length(filteredSignalFFT));

    % perform MODWT
    wavelet = 'sym5';
    nLevels = 10;
    wt = modwt(filteredSignal, wavelet, nLevels);
    mra = modwtmra(wt, wavelet);

    totalEnergy = sum(mra(:).^2);
    energies = zeros(nLevels+1, 1); 
    frequencies = zeros(nLevels+1, 2);

    for k = 1:nLevels+1
        frequencies(k, :) = [(fs/2) / (2^k), (fs/2) / (2^(k-1))];
        levelEnergy2 = sum(mra(k, :).^2);
        energies(k) = levelEnergy2; 
    end

    relativeEnergies = (energies / totalEnergy) * 100; 
    decompositionTable = array2table([(1:nLevels+1)', frequencies(:,1), frequencies(:,2), energies, relativeEnergies], ...
        'VariableNames', {'Level', 'FrequencyLower (Hz)', 'FrequencyUpper (Hz)', 'TotalEnergy', 'RelativeEnergy (%)'});
    figure('Name', 'Decomposition Table before denoising', 'NumberTitle', 'off', 'Position', [10, 10, 800, 600]);
    uitable('Data', decompositionTable{:,:}, ...
            'ColumnName', decompositionTable.Properties.VariableNames, ...
            'Units', 'Normalized', 'Position', [0, 0, 1, 1]);
    str = sprintf('Sample Rate: %d Hz\nDuration: %.2f s', fs, duration);
    annotation('textbox', [0.15, 0.95, 0.1, 0.05], 'String', str, 'FontSize', 10, 'FontName', 'Helvetica', 'EdgeColor', 'none', 'HorizontalAlignment', 'left');

    figure('Name', 'Wavelet Coefficients After Denoising', 'NumberTitle', 'off', 'Color', 'w');
    set(gcf, 'Position', [100, 100, 800, 1200]);
    for level = 1:nLevels
        ax = subplot(nLevels, 1, level);
        hold on;

        % Original signal coefficients
        plot(t, mra(level, :), 'LineWidth', 1.5, 'Color', [0, 0.4470, 0.7410], 'DisplayName', 'Original');

        % Perform denoising
        mra(level, :) = wdenoise(mra(level, :), ...
            'Wavelet', wavelet, ...
            'DenoisingMethod', 'SURE', ...
            'ThresholdRule', 'Soft', ...
            'NoiseEstimate', 'LevelDependent');

        plot(t, mra(level, :), 'LineWidth', 1.5, 'Color', [0.8500, 0.3250, 0.0980], 'DisplayName', 'Denoised');

        title(['Level ', num2str(level)]);
        xlabel('Time (s)');
        ylabel('Amplitude');
        set(ax, 'FontSize', 12, 'FontName', 'Arial');
        legend('show', 'Location', 'northeast');
        grid on;

        hold off;
    end
    sgtitle('Denoised Wavelet Coefficients Analysis', 'FontSize', 16, 'FontWeight', 'bold', 'FontName', 'Helvetica');

    denoisedSignal = imodwt(mra, wavelet);

    % Extract approximation coefficients(final level)
    approximationCoefficients = wt(end, :);
    approximationComponents = zeros(size(wt));
    approximationComponents(end, :) = approximationCoefficients;
    approximationSignal = modwtmra(approximationComponents, wavelet);

    % Denoised Signal FFT
    denoisedSignalFFT = fft(denoisedSignal);
    freqVecDenoisedSignal = (0:length(denoisedSignalFFT)-1) * fs / length(denoisedSignalFFT);
    ampSpecDenoisedSignal = abs(denoisedSignalFFT/length(denoisedSignalFFT));

    % Convert to dB scale
    ampSpecSignalDB = 20*log10(ampSpecSignal);
    ampSpecFilteredSignalDB = 20*log10(ampSpecFilteredSignal);
    ampSpecDenoisedSignalDB = 20*log10(ampSpecDenoisedSignal);

    figureTimeDomain = figure('Name', 'Time-Domain Signals', 'NumberTitle', 'off', 'Color', 'w');
    set(figureTimeDomain, 'Position', [100, 100, 1000, 800]);
    annotation(figureTimeDomain,'textbox', [0.3, 0.94, 0.4, 0.05], 'String', 'Signal processing phases in the Time Domain', ...
           'HorizontalAlignment', 'center', 'FontSize', 16, 'FontWeight', 'bold', 'EdgeColor', 'none');

    subplot(3, 2, 1);
    plot(t, signal, 'LineWidth', 1.5);
    title('Original Audio Signal');
    xlabel('Time (s)');
    ylabel('Amplitude');
    grid on;

    subplot(3, 2, 2);
    plot(t, filteredSignal, 'LineWidth', 1.5);
    title('After Low-Pass Filtering');
    xlabel('Time (s)');
    ylabel('Amplitude');
    grid on;

    subplot(3, 2, 3);
    plot(t, denoisedSignal, 'LineWidth', 1.5);
    title('Denoised Reconstructed Signal');
    xlabel('Time (s)');
    ylabel('Amplitude');
    grid on;

    subplot(3, 2, 4);
    plot(t, approximationSignal, 'LineWidth', 1.5, 'Color', [128/255, 179/255, 255/255])
    title('Approximation (Low-Frequency Component)');
    xlabel('Time (s)');
    ylabel('Amplitude');
    grid on;

    subplot(3, 2, 5:6);
    plot(t, filteredSignal, 'Color', [0, 0.4470, 0.7410], 'LineWidth', 1.5, 'DisplayName', 'Filtered Signal');
    hold on;
    plot(t, denoisedSignal, 'Color', [0.9290 0.6940 0.1250] , 'LineWidth', 1.5, 'DisplayName', 'Denoised Signal');
    hold off;
    legend('show');
    title('Filtered vs. Denoised Signal');
    xlabel('Time (s)');
    ylabel('Amplitude');
    grid on;

    figure('Name', 'Frequency-Domain Signals', 'NumberTitle', 'off', 'Color', 'w');
    set(gcf, 'Position', [920, 500, 800, 1200]);
    
    subplot(3, 1, 1);
    plot(freqVecSignal, ampSpecSignalDB(1:length(freqVecSignal)), 'LineWidth', 1.5);
    title('Original Signal in Frequency Domain (dB)');
    xlabel('Frequency (Hz)');
    ylabel('Magnitude (dB)');
    xlim([0, fs/2]);
    grid on;
    
    subplot(3, 1, 2);
    plot(freqVecFilteredSignal, ampSpecFilteredSignalDB(1:length(freqVecFilteredSignal)), 'LineWidth', 1.5);
    title('Filtered Signal in Frequency Domain (dB)');
    xlabel('Frequency (Hz)');
    ylabel('Magnitude (dB)');
    xlim([0, fs/2]);
    grid on;

    subplot(3, 1, 3);
    plot(freqVecDenoisedSignal, ampSpecDenoisedSignalDB(1:length(freqVecDenoisedSignal)), 'LineWidth', 1.5);
    title('Denoised Signal in Frequency Domain (dB)');
    xlabel('Frequency (Hz)');
    ylabel('Magnitude (dB)');
    xlim([0, fs/2]);
    grid on;
    
end
