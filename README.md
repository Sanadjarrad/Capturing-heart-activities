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

# How to Set Up the Test

### Prerequisites
1. Install Android Studio.
2. Install MATLAB for processing the audio data.
3. Ensure you have ADB (Android Debug Bridge) installed for transferring files.
4. Set up WiFi debugging on your phone for connecting to Android Studio.

## Steps to Run the Test

## 1. Clone the Repository

Open a terminal or command prompt and navigate to the directory where you want to save the project.
### I. Run the following command to clone the repository:
```
git clone https://github.com/Sanadjarrad/Capturing-heart-activities.git
```
### II. Navigate to the project directory:
```
cd Extracting-Pulse
```

## 2. Connect Your Phone via WiFi

1. Enable Developer Options on your phone and turn on Wireless Debugging.
2. Open Android Studio and ensure it detects your phone under Devices.
3. Connect to your phone via WiFi:
   - Go to the Device Manager in Android Studio.
   - Pair your phone using the wireless debugging option.

## 3. Open the voiceRecorderApp in Android Studio

1. In Android Studio, click on Open or Open Existing Project.
2. Navigate to the voiceRecorderApp/ folder within the project directory and select it.
3. Wait for the project to sync and resolve all dependencies.

## 4. Build and Run the Application

1. Build the project by selecting Build > Make Project.
2. Run the application on your connected device by clicking Run > Run 'app' or using the Run button.

## 5. Record Audio

1. Place the phone's bottom speakers directly on your apical pulse point (illustration to be included in the repository).
2. Launch the application on your phone and start recording.
3. Record for exactly 1 minute to collect sufficient data (the application will stop recording automatically at 1 minute).
![apical](https://github.com/user-attachments/assets/c526f8b3-34bc-4f8d-b8c9-0fabe387ce13)

## 6. Retrieve the Recording

1. After recording, the audio file is saved on your device at the following path:
```
/storage/emulated/0/Android/data/com.example.voicerecorderapp/files/Music/testRecordingFileNew.WAV
```
2. Use the following ADB command to extract the file from your device to your computer:
```
adb pull /storage/emulated/0/Android/data/com.example.voicerecorderapp/files/Music/testRecordingFileNew.WAV ./testRecordingFileNew.WAV
```
3. Save the testRecordingFileNew.WAV file to the directory where you plan to run the MATLAB scripts.

## 7. Analyze in MATLAB

1. Ensure the recording file is in the same directory as the MATLAB script.
2. Open MATLAB and navigate to the project directory.
3. Locate the "Matlab Code/main/signalProcessing.m" file.
4. Pass the file name (not the full path) as a parameter to the signalProcessing function. Example:
fileName = 'testRecordingFileNew.WAV';
signalProcessing(fileName);
5. Run the script. The signalProcessing function will process the audio file and analyze the collected apical pulse data.


## Tools and Dependencies

1. Android Studio: For running the voiceRecorderApp.
2. MATLAB: For analyzing the audio recordings.
3. ADB (Android Debug Bridge): For transferring files between the Android device and your computer.
4. Git: For version control.
