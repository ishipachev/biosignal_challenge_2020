function binMask = tg2mask(tgFilename, fs, duration, params)
%TG2MASK Summary of this function goes here
%   Detailed explanation goes here
tg = tgRead(tgFilename);
tname = 'MAU';
tierIndex = tgI(tg, 'MAU');

tgt = tg.tier{tierIndex};

tvow = tgFindLabels(tg, tname, 'v');

cidx = cell2mat(tvow);

T1 = tgt.T1(cidx);
T2 = tgt.T2(cidx);

binMask = zeros(duration, 1);
win = params.windowSize * params.extendWindowMul;
shift = params.constShift;
for i = 1:numel(T1)
  start_idx = max(floor(T1(i) * fs) - win, 1) + shift;
  end_idx = min(ceil(T2(i) * fs) + win, numel(binMask)) + shift; 
  binMask(start_idx : end_idx) = true;
end

end