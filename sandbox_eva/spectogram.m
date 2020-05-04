% Spectogram generator
[signal,fs] = audioread('../data/wavs/R09_0004.wav'); 

signal      = signal-mean(signal); 
sig=signal./max(abs(signal));

% Visualizing only the first second
t = [0:length(sig)-1]/fs;
%Choosing only the first second record
[~, idx] = find(t>1, 1);

sig = sig(1:idx);
t = t(1:idx);

figure()
% Wideband spectrogram
subplot(2,1,1);
spectrogram(sig,hamming(32),30,1024,fs,'yaxis');
colormap(jet);
title('wideband spectrogram');
xlabel('');
ylabel('frequence [Hz]');

% Narrowband spectrogram
subplot(2,1,2); 
spectrogram(sig, hamming(512),500,1024,fs,'yaxis');
colormap(jet);
title('narrowband spectrogram')
xlabel('------> time [ms]');
ylabel('frequence [Hz]')