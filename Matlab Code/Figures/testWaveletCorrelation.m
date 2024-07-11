function testWaveletCorrelation(filename)
    [signal, ~] = audioread(filename);
    filter = cheby();  
    filteredSignal = filter(signal);
    filteredSignal = filteredSignal / norm(filteredSignal);
    wavelets = {'db4', 'db5', 'db8', 'db10', 'sym4', 'sym5' 'sym8', 'sym10','coif2','coif3', 'coif4', 'coif5'};
    numWavelets = length(wavelets);
    correlationsSignal = zeros(numWavelets, 1);

    for i = 1:numWavelets
        [phi, psi, x] = wavefun(wavelets{i}, 10);  % wavelet function
        psi = psi / norm(psi); 
        
        % compute cross-correlation with signal
        crossCorrSignal = xcorr(filteredSignal, psi, 'none');
        correlationsSignal(i) = max(abs(crossCorrSignal)) / (norm(filteredSignal) * norm(psi));
        
    end

    figure;
    bar(correlationsSignal);
    set(gca, 'XTickLabel', wavelets, 'XTick', 1:numWavelets);
    title('Normalized Cross-Correlation Coefficients with Entire Filtered Signal');
    xlabel('Wavelet Type');
    ylabel('Normalized Cross-Correlation Coefficient');
end




