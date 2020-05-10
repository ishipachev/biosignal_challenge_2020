function [errRate, sylCnt, trueSylCnt] = evalNet(sylNet, filerange, params)
%COUNTVALIDATEALL Summary of this function goes here
%   Detailed explanation goes here

fileList = dir(params.wavsFolder);
fileList = fileList(3:end);

load("../data/reference_data.mat", 'true_syl');
% params = loadparams();
errRate = NaN(numel(filerange), 1);
sylCnt = NaN(numel(filerange), 1);
trueSylCnt = NaN(numel(filerange), 1);
file_cnt = 1;
for i=filerange
  filename = fullfile(fileList(i).folder, fileList(i).name);
  
  [f, ~] = exctractOrLoadFeatures(filename, params.featsFolder, params);
  
%   f = file2features(filename, params);
  cnt = countSyls(sylNet, f);
  true_cnt = true_syl(i);
  
%   errRate(file_cnt) = 1 - abs(cnt/true_cnt - 1);
  errRate(file_cnt) = abs(cnt/true_cnt - 1);
  sylCnt(file_cnt) = cnt;
  trueSylCnt(file_cnt) = true_cnt;
  
  fprintf("Processed %d, out of %d\n", file_cnt, numel(filerange));
  file_cnt = file_cnt + 1;
end
  
end



function cnt = countSyls(sylNet, features)

mask = classify(sylNet, features.');
mask = double(mask);
mask = mask.' - 1;

cnt = nnz(diff(mask) == 1);

end

% function f = file2features(filename, params)
%   [s, fs] = audioread(filename);
%   assert(params.afe.SampleRate == fs, ...
%       "Sample rate of feature extractor doesn't match sample rate of file"); 
%   s = soundNormalize(s);
%   
%   f = extract(params.afe, s);
%   f = featNormalize(f);
% end