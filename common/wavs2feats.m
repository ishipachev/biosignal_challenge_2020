function [featsTrn, ... 
          maskTrn, ...
          featsVal, ... 
          maskVal, ...
          s_trn, ...
          s_val] = wavs2feats(trnIdx, valIdx, params)
% Transoforms wavs files into train and validation features with masks
% which can be feeded to net

filelist = dir(params.wavsFolder);
filelist = filelist(3:end);

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
    
    [f, s] = exctractOrLoadFeatures(filename, featsFolder, params);
    
    full_s = [full_s; s];
    feats = [feats; f];
    
    [~, name, ~] = fileparts(filename);
    addition = '_manual';
    ext = '.TextGrid';
    tgFilename = fullfile(tgFolder, [name addition ext]);
    
    mask = [mask; tg2mask(tgFilename, params.afeOpt.fs, numel(s), params)];    
  end
  
end
