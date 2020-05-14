function [errRate, sylCnt, trueSylCnt] = evalNet(sylNet, evalIdx, params)
%COUNTVALIDATEALL Summary of this function goes here
%   Detailed explanation goes here

fileList = dir(params.wavsFolder);
fileList = fileList(3:end);

load("../data/reference_data.mat", 'true_syl');
% params = loadparams();
errRate = NaN(numel(evalIdx), 1);
sylCnt = NaN(numel(evalIdx), 1);
trueSylCnt = NaN(numel(evalIdx), 1);
file_cnt = 1;
for i=evalIdx
  filename = fullfile(fileList(i).folder, fileList(i).name);
  
  [f, ~] = exctractOrLoadFeatures(filename, params.featsFolder, params);
  
  cnt = countSyls(sylNet, f, params);
  true_cnt = true_syl(i);
  
  errRate(file_cnt) = 1 - abs(cnt/true_cnt - 1);
  sylCnt(file_cnt) = cnt;
  trueSylCnt(file_cnt) = true_cnt;
  
  if rem(file_cnt, 10) == 0
    fprintf("Processed %d, out of %d\n", file_cnt, numel(evalIdx));
  end
  
  file_cnt = file_cnt + 1;
end
  
end
