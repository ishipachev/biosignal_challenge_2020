function s = soundNormalize(s, fs)
%Function to normalize the output sound
  s = s / max(abs(s));
%   s = s / median(abs(s));

%   f0 = pitch(s, fs);
  
end