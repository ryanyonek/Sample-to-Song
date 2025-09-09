# Sample-to-Song
## Background
I used the music programming language ChucK and a single audio sample of myself playing trombone to create a computerized audio playback of Vienna Teng's composition **"The Hymn of Acxiom"**. This project showcases the ability of a music programming language to create a musically complex song with volume, note length, and pitch components stemming from a single sample note.

**Final Output:** https://github.com/user-attachments/assets/6e7828cf-0fa1-48e4-a99c-52371a34edbe

**Sheet Music Reference:** [Hymn_of_Acxiom-Score_and_Parts.pdf](https://github.com/user-attachments/files/22237740/Hymn_of_Acxiom-Score_and_Parts.pdf)

I highly recommend you check out the inspiration for this work ->
**Vienna Teng's Original Song:** https://www.youtube.com/watch?v=QF-7WiLykGM

Learn more about **ChucK** here: https://chuck.cs.princeton.edu/
Video tutorial series by Clint Hoagland here: https://www.youtube.com/watch?v=toFvb6uqiDc&list=PL-9SSIBe1phI_r3JsylOZXZyAXuEKRJOS

## Usage
### Install Required Software
Download a local version of ChucK, default Chugins, and MiniAudicle (the ChucK IDE). You can also use VS Code or similar IDE to run as well.
Download through this URL: https://chuck.cs.princeton.edu/release/ 

### Clone the Repository
Clone the repository to your local machine.
git clone https://github.com/ryanyonek/Sample-to-Song.git

### Running the Code
1. Open the folder of the repository.
2. Run this command in the terminal: chuck score.ck.
3. Follow along with the console output or the sheet music reference.

## Components
- **sample.wav:** a .WAV file I recorded to use as the note and sound basis for the project.
- **trombone.ck:** where the magic happens. Contains all of the operations done on the sample and text files, including the transposing sampler.
- **Transposing Sampler:** a Chugraph used to transpose the sample to create many different pitches.
- **.txt files:** each text file is a different part of the quartet of digital trombones. Each file contains all of the musical information needed to create the song: pitch, duration, and volume. Comments, rests, and notes are all processed differently.
- **score.ck:** the score file is used to organize the parts. It creates a thread for each part, so the audio output of each part is executed concurrently (so the music lines up in real time).
- **Making it sound like real music:** converting the MIDI to audio through a signal chain, creating an envelope, adding effects (reverb, gain, etc.).
- **audio_output.wav**: the audio output of the program.




