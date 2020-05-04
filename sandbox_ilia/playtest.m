[t, fs] = audioread('../data/wavs/R09_0004.wav');
% sound(t, fs);

%% eva's cutoff
% [signal,fs] = audioread('eva/R09_0004.wav'); 
% 
% signal      = signal-mean(signal); 
% sig=signal./max(abs(signal));
% 
% % Visualizing only the first second
% t = [0:length(sig)-1]/fs;
% %Choosing only the first second record
% [~, idx] = find(t>1, 1);
% 
% sig = sig(1:idx);
% t = t(1:idx)';

%%
timelim_sec = 2;
timelim_cnt = timelim_sec * fs;
t = t(1:timelim_cnt);


% Create and set up an audioFeatureExtractor object
extractor = audioFeatureExtractor("SampleRate",fs, ...
  "linearSpectrum",true,"melSpectrum",true, ...
  "barkSpectrum",true,"erbSpectrum",true, ...
  "mfcc",true,"mfccDelta",true, ...
  "mfccDeltaDelta",true,"gtcc",true, ...
  "gtccDelta",true,"gtccDeltaDelta",true, ...
  "spectralCentroid",true,"spectralCrest",true, ...
  "spectralDecrease",true,"spectralEntropy",true, ...
  "spectralFlatness",true,"spectralFlux",true, ...
  "spectralKurtosis",true,"spectralRolloffPoint",true, ...
  "spectralSkewness",true,"spectralSlope",true, ...
  "spectralSpread",true,"pitch",true, ...
  "harmonicRatio",true);

% Extract features from audio data
features = extract(extractor,t);

% Display output summary
info(extractor);

F = features';

%%
A = normalize(F, 2, 'range');
imagesc(A);

%%
%шестая фича прям торчит в то, что нам нужно
cutoff = 699:711;

figure;
subplot(2, 1, 1);
imagesc(A(cutoff,:));
subplot(2, 1, 2);
plot(t);

%%
% cutoff_lspec = 1:514;
cutoff_lspec = 1:80;

figure();
subplot(2, 1, 1);
imagesc(A(cutoff_lspec,:));
subplot(2, 1, 2);
plot(t);

%%
% cutoff_lspec = 1:514;
cutoff_lspec = 514:620;

figure();
subplot(2, 1, 1);
imagesc(A(cutoff_lspec,:));
subplot(2, 1, 2);
plot(t);

%%
cutoff_lspec = 621:633;

figure();
subplot(2, 1, 1);
imagesc(A(cutoff_lspec,:));
subplot(2, 1, 2);
plot(t);