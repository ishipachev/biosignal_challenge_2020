[t, fs] = audioread('../data/wavs/R09_0242.wav');
% sound(t,fs);
nsemitones = -3;

audioOut = shiftPitch(t,nsemitones);
sound(audioOut,fs)
