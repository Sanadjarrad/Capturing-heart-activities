# Capturing-heart-activities
This repository contains code for extracting human pulse using MATLAB. additionally, it contains a simple voice recorder app built using android studio. This project utilizes wavelet-based techniques to effectively clean and denoise a signal captured through the voice recorder application. Post processing, the heart rate is calculated from the denoised filtered signal. this signal is then evaluated against an EKG (VERNIER GO DIRECT EKG), the files used for evaluations are inside folders starting with "Synced".

## Project Structure
- /"Synced Raw EKG data" refers to the csv files of the EKG data that was captured while simultaneously recording with the phone

- /"Synced Mono" recordings refers to the .wav files that was captured while simultaneously recording with the EKG

- /"Stereo Audio" Recordings contains recordings captured in double-channel format, these are files in stored in .pcm format, which the current implementation of the code does not process. 

- /"Matlab Code" contains the main Matlab code

- /"Flawed EKG recordings" contains a number of EKG recordings that were recorded with the test strips upside down, these files were excluded from the development process.

- /"EKG Recordings" contains reference EKG recordings used for testing 

- /"EKG Raw Data (CSV)" contains the CSV files for the EKG recordings used for testing

## How to Set Up the Test

### Prerequisites
1. Install Android Studio.
2. Install MATLAB for processing the audio data.
3. Ensure you have ADB (Android Debug Bridge) installed for transferring files.
4. Set up WiFi debugging on your phone for connecting to Android Studio.

## Steps to Run the Test
## 1. Clone the Repository

Open a terminal or command prompt and navigate to the directory where you want to save the project.
Run the following command to clone the repository:
```
git clone <repository-url>
```
Replace <repository-url> with the actual URL of the Git repository.
Navigate to the project directory:
cd Extracting-Pulse
