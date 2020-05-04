function rms_dB = RMS(segment,fs);
out = sqrt(sum(segment.^2)./length(segment));
rms_dB = 20*log10(out);
