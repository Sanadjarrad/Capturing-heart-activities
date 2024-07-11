function evaluateMetrics(filename)

    [signal, fs] = audioread(filename);
    signal = signal(:);  

    duration = length(signal) / fs;
    t = linspace(0, duration, length(signal));
    
    filter = cheby(); 
    filteredSignal = filter(signal); 

    % List of wavelets to process
    waveletNames = {'db4', 'db5', 'db8', 'db10', 'sym4', 'sym5' 'sym8', 'sym10','coif2','coif3', 'coif4', 'coif5'};
    nLevels = 10;

    allMetrics = cell(length(waveletNames) + 2, 6); 
    rowLabels = cell(length(waveletNames) + 2, 1);

    originalMetrics = [immse(signal, signal), sqrt(immse(signal, signal)), snr(signal), psnr(signal, signal, max(abs(signal))), max((signal - signal).^2);
                       immse(signal, filteredSignal), sqrt(immse(signal, filteredSignal)), snr(signal, signal - filteredSignal), psnr(signal, filteredSignal, max(abs(signal))), max((signal - filteredSignal).^2)];
    
    allMetrics(1:2, 2:6) = num2cell(originalMetrics);
    allMetrics{1, 1} = 'Original';
    allMetrics{2, 1} = 'Filtered';

    idx = 3; 
    for wavelet = waveletNames
        wt = modwt(signal, wavelet{1}, nLevels);
        for level = 1:nLevels
            originalCoefficients = wt(level, :);
            denoisedCoefficients = wdenoise(originalCoefficients, ...
                'Wavelet', wavelet{1}, ...
                'DenoisingMethod', 'SURE', ...
                'ThresholdRule', 'Soft', ...
                'NoiseEstimate', 'LevelDependent');
            wt(level, :) = denoisedCoefficients;  
        end

        denoisedSignal = imodwt(wt, wavelet{1});
        denoisedSignal = denoisedSignal(:);  

        denoisedMetrics = [immse(signal, denoisedSignal), sqrt(immse(signal, denoisedSignal)), snr(signal, signal - denoisedSignal), psnr(signal, denoisedSignal, max(abs(signal))), max((signal - denoisedSignal).^2)];
        allMetrics{idx, 1} = [wavelet{1}];
        allMetrics(idx, 2:6) = num2cell(denoisedMetrics);
        idx = idx + 1;
    end

    figure('Name', 'Denoising Metrics by Wavelet', 'NumberTitle', 'off', 'Position', [100, 100, 800, 600]);
    colNames = {'Signal Type', 'MSE', 'RMSE', 'SNR (dB)', 'PSNR (dB)', 'Max Squared Error'};
    t = uitable('Data', allMetrics, 'ColumnName', colNames, 'RowName', {}, ...
                'Units', 'Normalized', 'Position', [0, 0, 1, 1]);
    t.FontSize = 14;
    t.FontName = 'Arial';

end




