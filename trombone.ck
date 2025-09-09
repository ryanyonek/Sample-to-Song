// Input MIDI notes with txt file
// Transposing Sampler, convert the midi to the rate of the sample
// file output while loop
// helper functions (parsing the txt file)
// sample effects, make it sound like music

"sample.wav" => string filename;


// Chugraph to play the sample
class Sampler extends Chugraph
{
    // outlet is Chugraph's equivalent of the dac
    // signal chain
    SndBuf buffer => ADSR ampEnv => Dyno dyno => NRev rev => Pan2 pan => outlet;
    (5::ms, 3::ms,0.0, 5::ms) => ampEnv.set;
    0.9 => dyno.thresh;
    1::ms => dyno.attackTime; 
    buffer.samples() => buffer.pos;
    0.075 => rev.mix;
    -0.3 => pan.pan;

    // opens the sample .wav file
    fun void open(string filename)
    {
        buffer.read(filename);
    }

    fun void play(int semitones, int startPos, dur length, float volume)
    {
        // changes the buffer position to be ready to play
        startPos => buffer.pos;

        // set envelope values (attackTime, decayTime, sustainLevel, releaseTime)
        (5::ms, 5::ms, volume, 5::ms) => ampEnv.set;
        
        // starts the envelope and sample together
        ampEnv.keyOn();
    
        // calls the transpose function and chucks it to the sound buffer's rate
        transpose(1, semitones) => buffer.rate;

        // play the note for the passed amount of time
        length => now;
        
        // stop the sound
        ampEnv.keyOff();

        // give time for the release
        ampEnv.releaseTime() => now;

        // stop the sample
        buffer.samples() => buffer.pos;
    }

    // MIDI to frequency
    fun float transpose(float frequency, int semitones)
    {
        1.0594630943592952645618252949463 => float semitone;
        frequency => float result;
        if (semitones > 0) {
            for(1 => int j; j <= semitones; j++) {
                result * semitone => result;
            }
        }
        else if(semitones < 0) {
            for(1 => int j; j <= Math.abs(semitones); j++) {
                result * (1 / semitone) => result;
            }
        }   
        return result;    
    }
}

// audio output file

Sampler sampler => dac => WvOut waveOut => blackhole;

/* Uncomment to save audio output to a new file
"audio_output_new.wav" => waveOut.wavFilename;
*/

// open the sample
sampler.open(filename);

// set the volume
0.9 => sampler.gain;

// 1 = 4 measures, 2 = 2 measures, 3 = 4 beats, 4 = 1 measure, 6 = half note, 12 = quarter, 24 = eighth, 48 = sixteenth
9::second => dur beat;

<<<(me.args())>>>;



// Reading the txt file
FileIO io;
StringTokenizer tok;

// Parsing the command line argument to find the correct .txt file

if (Std.atoi(me.arg(0)) == 1) {
    <<< io.open("trombone_1.txt", FileIO.READ) >>>;
}

if (Std.atoi(me.arg(0)) == 2) {
    <<< io.open("trombone_2.txt", FileIO.READ) >>>;
}

if (Std.atoi(me.arg(0)) == 3) {
    <<< io.open("trombone_3.txt", FileIO.READ) >>>;
}

if (Std.atoi(me.arg(0)) == 4) {
    <<< io.open("trombone_4.txt", FileIO.READ) >>>;
}

// parsing through the text file
while(io.more())
{
    // line by line
    io.readLine() => string line;

    // finds comment
    if (line.find("//") == 0) {
        line => ProcessComment;
    }
    // finds rest
    else if (line.find("R") == 0) {
        line => ProcessRest;
    }
    // finds note
    else {
        line => ProcessNote;
    }
}
0 => io.seek;


// shows the commented measure on the console
// no musical time passing
fun void ProcessComment(string line) {
    <<< line >>>;
}

// pass time without playing a pitch
fun void ProcessRest(string line) {
    tok.set(line);
    tok.next() => string rest;
    tok.next() => Std.atoi => int div;
    <<< rest, div >>>;
    beat / div => now;
    5::ms => now;
}

// pass time and play note
fun void ProcessNote(string line) {
    tok.set(line);
    tok.next() => Std.atoi => int note;
    tok.next() => Std.atoi => int div;
    <<< note, div >>>;
    0 => int startPosition;
    0.0 => float extraDuration;
    float vol;
    [0.0,0.0,0.0] @=> float array[];
    ProcessExtras(tok) @=> array;
    array[0] => Std.ftoi => extraDuration;
    array[1] => Std.ftoi => startPosition;
    array[2] => vol;
    dur extraDur;
    if (extraDuration == 0) {
        beat * 0 => extraDur; 
    }
    else {
        beat / extraDuration => extraDur;
    }
    sampler.play(note, /*44100*/ 4000 * startPosition, (beat / div) + extraDur, vol);
}

// extra characters in the line after the note and duration
fun float[] ProcessExtras(StringTokenizer tok) {
    [0.0,0.0,0.0] @=> float arr[];
    while(tok.more()) {
        tok.next() => string extra;
        // Extended Duration
        if (extra.find("E") == 0) {
            extra.substring(1) => Std.atof => arr[0];
        }
        // "Tah" Articulation
        if (extra.find("T") == 0) {
            extra.substring(1) => Std.atof => arr[1];
        }
        // Legato Articulation
        if (extra.find("L") == 0) {
            extra.substring(1) => Std.atof => arr[1];
        }
        // Volume
        if (extra.find("V") == 0) {
            extra.substring(1) => Std.atof => arr[2];
        }
    }
    return arr;
}