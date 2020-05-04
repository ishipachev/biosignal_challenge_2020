[t, fs] = audioread('data/R09_0242.wav');
% sound(t,fs);
nsemitones = -3;
%%
audioOut = shiftPitch(t,nsemitones);
sound(audioOut,fs)
