function [errRate, evalDur, trueDur] = evalNet(speechNet, evalIdx, params)
%COUNTVALIDATEALL Summary of this function goes here
%   Detailed explanation goes here

fileList = dir(params.wavsFolder);
fileList = fileList(3:end);

load("../data/reference_data.mat", 'true_dur');
% params = loadparams();
errRate = NaN(numel(evalIdx), 1);
evalDur = NaN(numel(evalIdx), 1);
trueDur = NaN(numel(evalIdx), 1);
file_cnt = 1;
for i=evalIdx
  filename = fullfile(fileList(i).folder, fileList(i).name);
  
  [f, ~] = exctractOrLoadFeatures(filename, params.featsFolder, params);
  
  dur = countSpeechDur(speechNet, f, params);
  trdur = true_dur(i);
  
  errRate(file_cnt) = 1 - abs(dur/trdur - 1);
  evalDur(file_cnt) = dur;
  trueDur(file_cnt) = trdur;
  
  if rem(file_cnt, 10) == 0
    fprintf("Processed %d, out of %d\n", file_cnt, numel(evalIdx));
  end
  
  file_cnt = file_cnt + 1;
end
  
end
