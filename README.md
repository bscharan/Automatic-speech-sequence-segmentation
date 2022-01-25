# Automatic-speech-sequence-segmentation
The Main Aim of this project is to segment and cluster an audio sample based on speaker when number of speakers are not known before hand. Main challenge in the process of speaker recognition is separting audio based on speaker.It can enhance the readability of an automatic speech transcription by structuring the audio stream into speaker turns and, when used together with speaker recognition systems, by providing the speaker's true identity.Other challenges are due to multiple speakers present at the time instant

for more details about project visit https://bscharan.github.io/DSP320_project_website/



before executing code make sure input "wav" and code are in same folder

executing code;
navigate to code folder
open main.m in matlab..
replace [data,fs] = audioread('merge.wav'); merge.wav with your input wav file..

you can fix number of speakers in line 2 or
you can calculate number of speakers best fit automatically , execute kmean_un .
