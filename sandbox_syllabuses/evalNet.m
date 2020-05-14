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
  
%   f = file2features(filename, params);
  cnt = countSyls(sylNet, f, params);
  true_cnt = true_syl(i);
  
  errRate(file_cnt) = 1 - abs(cnt/true_cnt - 1);
%   errRate(file_cnt) = abs(cnt/true_cnt - 1);
  sylCnt(file_cnt) = cnt;
  trueSylCnt(file_cnt) = true_cnt;
  
  if rem(file_cnt, 10) == 0
    fprintf("Processed %d, out of %d\n", file_cnt, numel(evalIdx));
  end
  
  file_cnt = file_cnt + 1;
end
  
end



% function cnt = countSyls(sylNet, features, params)
% 
% mask = classify(sylNet, features.');
% mask = double(mask);
% mask = mask.' - 1;
% 
% cnt = nnz(diff(mask) == 1);
% 
% end

% postprocessing function, excluding extremely short periods
% function m = postProc(m, params)
%   d = diff(m);
%   up = find(d, 1);
%   down = find(d, -1);
%   
%   hopLength = params.afeOpt.windowSize - params.afeOpt.overlapLength;
%   vowWin = (up - down) * hopLength / params.afeOpt.fs;
%   dropMask = vowWin < params.minVowLen;
%   
%   %bad, but still
%   for i=1:numel(up)
%     m(up(i) - 1 : down(i) + 1) = 0;
%   end
% end

% function f = file2features(filename, params)
%   [s, fs] = audioread(filename);
%   assert(params.afe.SampleRate == fs, ...
%       "Sample rate of feature extractor doesn't match sample rate of file"); 
%   s = soundNormalize(s);
%   
%   f = extract(params.afe, s);
%   f = featNormalize(f);
% end