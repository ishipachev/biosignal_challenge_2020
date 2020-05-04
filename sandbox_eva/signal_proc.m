% Biosignals contest
% Signal processing draft
% YP

% TODO: experiment with various window lengths and shifts
win_len  = 512;                    
[signal,fs] = audioread('../data/wavs/R09_0004.wav'); 

% Mean-subtracting filtering
% TODO: check if consequently leads to FTT distortion
signal      = signal-mean(signal); 
% Standardization
sig=signal./max(abs(signal));

N  = length(sig);              
win_shift  = 256;
Z = []; E = [];

% Extracting fundamental frequency F0
% https://linguistics.stackexchange.com/questions/20894/what-is-the-difference-between-formant-frequencies-and-pitch-frequency
% Can be used as a separate independent feature
% @Yeva suggested reading: Hayward, Katrina. 2013. Experimental phonetics: An introduction.
start_index = 20;      % upper limit for fundamental freq F0 fmax=fs/start_index
threshold = 0.7;      % TO BE REVIEWED: threshold for deciding speech/silence
F0 = []; ss = 0;

for start = 0:win_shift:N,     
    if  (start+win_len < N)
        % Selecting a window segment
        segment = sig(start+1:start+win_len);
    end;
    % Calculating sero-crossing rate and energy
    Z = [Z zcr(segment,fs)];     
    E = [E rms(segment,fs)];
    % Auto-correlation fun to extract F0
    acf = xcorr(segment,'coeff');
    [max_acf, pos_acf] = max(acf(win_len+start_index:end));
    ss=[ss max_acf];
    if max_acf < threshold   % for no speech segments
        F0    = [F0 0];
    else % for not silent segments
        F0    = [F0 fs/(pos_acf+start_index)];
    end
end

t=win_shift*[0:length(Z)-1]/fs;
figure()
subplot(4,1,1); 
plot([0:N-1]/fs,sig,'k'); 
axis tight, ylabel('signal');

subplot(4,1,2); 
% TODO: check hujnya with timeline
plot(t, Z,'k'); 
axis tight, ylabel('ZCR [Hz]');

subplot(4,1,3); 
plot(t,E,'k'); 
axis tight, ylabel('RMS [dB]'); xlabel('---> time [s]')

E1=ones(256,1)*E; e=E1(:); Z1=ones(256,1)*Z; ppn=Z1(:); 
%yy=e>mean(e) & ppn>mean(ppn); 
%yy=e>mean(e);
yy=e>mean(e) | e>(mean(e)-std(e)) & ppn>mean(ppn); 
subplot(4, 1, 4), plot([0:length(yy)-1]/fs,1.05*yy), xlabel('Speech-silence detection'); axis tight
% Speech-silence detection works huevo

figure()
t=win_shift*[0:length(F0)-1]/fs;
subplot(3,1,1); 
plot([0:N-1]/fs,sig,'k'); 
axis tight; ylabel('signal');

subplot(3,1,2); 
plot(t,ss(1:length(t)),'k'); 
axis tight; ylabel('Z/N'); hold on
line([0 t(end)],[threshold threshold]);

subplot(3,1,3); 
plot(t,F0,'k'); 
axis tight, ylabel('F0');
hold on, plot(t,medfilt1(F0,5),'r'), hold off, xlabel('---> cas [s]')

clear all, clc
figure()
[sig,fs]=audioread('../data/wavs/R09_0004.wav');
win_len  = 512;                    
sig = sig./max(abs(sig));
E = 10*log10(filter(ones(1,win_len)/win_len, 1, sig.^2));  % log to transform to dB unit
I = filter(ones(1,win_len)/win_len, 1, abs(sig));

zcr=[0; filter(ones(1,win_len)/win_len, 1,abs(diff(sig>0)))*(fs/2)];
yy=E>mean(E)|E>(mean(E)-std(E))&zcr>mean(zcr);
t = [1:1:length(sig)]./fs;

subplot(411), plot(t,E) 
subplot(412), plot(t,I)
subplot(413), plot(t,zcr) 
subplot(414), plot(t,yy), hold on
plot(t,sig)
% vse hujnja 
% i ja hujnja
% i obe hujni takie
% chto aksioma Eskobara

% TODOs:
% * Envelope detector for ZCR and Energy estimations - too much noise
%     - Triangular method is a good baseline
% * Play with magic constants:
%     - base (F0 estim)
%     - window length and shift (should be increased due to high frequency of the inpur signal)
% * First 4 formants extraction 
%     - manual check with the spectogram visualization
% * literature search on frequency filtering (FTT)
%     - what are the typical noise frequencies
% * parameters estimation for thresholding the mumbling and hissing sounds AND background noise
%     - should be easily detectable from the energy envelope
%     - choice of method for threshold estimation?
%         ^ manual? (easy, fast, BIASED)
%         ^ easy and robust clustering methods (Random forest? Non-linearity might be an issue. K-means? might be a good option
% * choice of final model input and output
%     - time-series input over all the signal OR just a chosen segments where speech is detected
%     - time independent segments (every separate segment is a separate data-point?)
%     - Is it worth paying much attention to the structure (YES, if fundamental frequency is a big deal)
% * to not collapse because we are still cool and have a lot of time
%     - wink wink
%     - хрю-хрю

















