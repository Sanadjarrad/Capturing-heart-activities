
% 
%  ##### Main driver code for Project #####
%
%
%

% File Paths
audioFileName = '/Users/sanadjarrad/desktop/Computer Science Year 3/Final Year Project (CM3203)/Extracting Pulse/Synced Mono Recordings/Controlled/apicalWithShirtSyncedTwo.WAV';
ekgFileName = '/Users/sanadjarrad/desktop/Computer Science Year 3/Final Year Project (CM3203)/Extracting Pulse/Synced Raw EKG Data/heartRecordingSyncedTwo.csv';   

% Process audio file and return denoised signal and its sample rate
% Displays:
%
% 
% # Time domain plot of original audio signal
% # Frequency domain plot of original audio signal
% # Time domain plot of filtered audio signal using a Chebyshev
%  Impulse Response (IIR) Low-pass filter 
% # Frequency domain plot of filtered audio signal
% # Time domain plot comparing filtered signal to denoised
% # Time domain plot of the reconstructed signal from wavelet coefficients
% # Time domain plot of approximation level
% # Denoised wavelet coefficients 
% # Wavelet decomposition table showing energy distribution across levels
% # Time domain plot of the denoised signal 
% # Frequency domain plot of the denoised signal
% # Time domain plot comparing filtered signal to wavelet denoised 
% (reconstructed) signal
%
%

[denoisedSignal, fs] = signalProcessing(audioFileName);
audioSampleRate = fs;   
ekgSampleRate = 500;

% Evaluate ECG results and processed phone recording signal
% displays:
%
% # Time domain plot of EKG signal 
% # Frequency domain plot of EKG signal
% # Time domain plot of EKG signal 
% # Time domain plot of processed audio signal with peaks
% # Bar graph comparing calculated heart rate from phone and EKG
% # Differnce in calculated heart rate between phone and EKG (%)
%
%
evaluate(ekgFileName, denoisedSignal, ekgSampleRate, audioSampleRate);



