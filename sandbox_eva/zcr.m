% Zero-cross rate
% https://www.asee.org/documents/zones/zone1/2008/student/ASEE12008_0044_paper.pdf
function out=ZCR(segment,fs);
zcr = sum(abs(diff(segment>0)));             
out = zcr*fs/(2*length(segment));