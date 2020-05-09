function binMask = tg2mask(tgFilename, fs, duration)
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
for i = 1:numel(T1)
  binMask(floor(T1(i) * fs):ceil(T2(i) * fs)) = true;
end

end