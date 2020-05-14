function [errRate, evalVal, trueVal] = evalNet(net, evalIdx, params)
%COUNTVALIDATEALL Summary of this function goes here
%   Detailed explanation goes here

fileList = dir(params.wavsFolder);
fileList = fileList(3:end);

gt_val = loadGT(params);

errRate = NaN(numel(evalIdx), 1);
evalVal = NaN(numel(evalIdx), 1);
trueVal = NaN(numel(evalIdx), 1);

file_cnt = 1;
for i=evalIdx
  filename = fullfile(fileList(i).folder, fileList(i).name);
  
  [f, ~] = exctractOrLoadFeatures(filename, params.featsFolder, params);
  
  val = getScore(net, f, params);
  
  errRate(file_cnt) = 1 - abs(val/gt_val(i) - 1);
  evalVal(file_cnt) = val;
  trueVal(file_cnt) = gt_val(i);
  
  if rem(file_cnt, 10) == 0
    fprintf("Processed %d, out of %d\n", file_cnt, numel(evalIdx));
  end
  
  file_cnt = file_cnt + 1;
end
  
end
