function Hd = chebyOneLowPass
%GETFILTER Returns a discrete-time filter System object.

% MATLAB Code
% Generated by MATLAB(R) 9.14 and DSP System Toolbox 9.16.
% Generated on: 20-Apr-2024 20:58:06

N     = 15;    % Order
Fpass = 200;    % Passband Frequency
Apass = 0.5;      % Passband Ripple (dB)
Fs    = 48000;  % Sampling Frequency

h = fdesign.lowpass('n,fp,ap', N, Fpass, Apass, Fs);

Hd = design(h, 'cheby1', ...
    'SystemObject', true,...
    UseLegacyBiquadFilter=true);

