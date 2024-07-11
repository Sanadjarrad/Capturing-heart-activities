# Capturing-heart-activities
This repository contains code for extracting human pulse using MATLAB. additionally, it contains a simple voice recorder app built using android studio. This project utilizes wavelet-based techniques to effectively clean and denoise a signal captured through the voice recorder application. Post processing, the heart rate is calculated from the denoised filtered signal. this signal is then evaluated against an EKG (VERNIER GO DIRECT EKG), the files used for evaluations are inside folders starting with "Synced" 

- Synced Raw EKG data refers to the csv files of the EKG data that was captured while simultaneously recording with the phone

- Synced Mono recordings refers to the .wav files that was captured while simultaneously recording with the EKG

- Stereo Audio Recordings contains recordings captured in double-channel format, these are files in stored in .pcm format, which the current implementation of the code does not process. 

- Matlab Code contains the main Matlab code

- Flawed EKG recordings contains a number of EKG recordings that were recorded with the test strips upside down, these files were excluded from the development process.

- EKG Recordings contains reference EKG recordings used for testing 

- EKG Raw Data (CSV) contains the CSV files for the EKG recordings used for testing
