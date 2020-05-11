function [featsTrn, ... 
          maskTrn, ...
          featsVal, ... 
          maskVal, ...
          s_trn, ...
          s_val] = wavs2feats(trnIdx, valIdx, params)
% Transoforms wavs files into train and validation features with masks

% ads = audioDatastore(wavFolder);
filelist = dir(params.wavsFolder);
filelist = filelist(3:end);

% params = loadparams();


% sfl = randperm(numFiles);
% sfl = [3 10 11 14 1 2 4 5 6 7 8 9 16 17 18 19 20    12 13 15 14];
% valSize = floor(params.valProportion * params.numFiles);
% trainSize = params.numFiles - valSize;

% filesTrn = filelist(sfl(1:trainSize));
% filesVal = filelist(sfl(trainSize+1:end));
filesTrn = filelist(trnIdx);
filesVal = filelist(valIdx);

[featsTrn, maskTrn, s_trn] = list2feats(filesTrn, params.featsFolder, params.tgFolder, params);
[featsVal, maskVal, s_val] = list2feats(filesVal, params.featsFolder, params.tgFolder, params);

end

%% Helper Functions
function [feats, mask, full_s] = list2feats(fileList, featsFolder, tgFolder, params)
  N = numel(fileList);
  feats = [];
  mask = [];
  full_s = [];
  for i = 1:N
    filename = fullfile(fileList(i).folder, fileList(i).name);
    
%     [s, fs] = audioread(filename);
%     assert(params.afe.SampleRate == fs, ...
%       "Sample rate of feature extractor doesn't match sample rate of file"); 
%     s = soundNormalize(s);
%     
%     
%     f = extract(params.afe, s);
%     f = featNormalize(f);
    [f, s] = exctractOrLoadFeatures(filename, featsFolder, params);
    
    full_s = [full_s; s];
    feats = [feats; f];
    [folder, name, ext] = fileparts(filename);
    addition = '_manual';
    ext = '.TextGrid';
    tgFilename = fullfile(tgFolder, [name addition ext]);
    
    mask = [mask; tg2mask(tgFilename, params.afeOpt.fs, numel(s), params)];    
  end
  
%   feats = featNormalize(feats);
end
