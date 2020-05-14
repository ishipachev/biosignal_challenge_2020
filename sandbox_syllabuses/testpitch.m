[t, fs] = audioread('../data/wavs/R09_0004.wav');
sound(t, fs);

nsemitones = -3;

audioOut = shiftPitch(t, nsemitones);
sound(audioOut, fs)