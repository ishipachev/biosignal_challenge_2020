function [trnIdx, valIdx, perfIdx] = splitLabeledData(params)
% Get list of files to train network, to validate it during the training
% And list of files to calculate total performance

labeled = dir(params.tgFolder);
labeled = labeled(3:end); %cut off . and ..
labelNum = numel(labeled);
strList = strings(labelNum, 1);
for i=1:labelNum
  fname = labeled(i).name;
  fname = fname(1:8); %cutting off only first part like 'R09_0018'
  strList(i) = fname;
end

labelIdx = NaN(labelNum,1);
allWavs = dir(params.wavsFolder);
allWavs = allWavs(3:end);
wavsNum = numel(allWavs);
lcnt = 1;
for i=1:wavsNum
  fname = allWavs(i).name;
  if contains(fname, strList(lcnt))
    labelIdx(lcnt) = i;
    lcnt = lcnt + 1;
  end
  if lcnt > labelNum
    break;
  end
    
end

perfIdx = setdiff(1:wavsNum, labelIdx);

% trnIdx = labelIdx([1 2 3 4 5 6 7 8 9 10 11 14 16 18 19 20 22 23 24 25 26 27 28]);
% valIdx = setdiff(labelIdx, trnIdx);

trnIdx = labelIdx;
valIdx = labelIdx(end-2:end);

end

