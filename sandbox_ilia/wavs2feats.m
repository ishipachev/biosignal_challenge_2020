function [featsTrn, ... 
          maskTrn, ...
          featsVal, ... 
          maskVal] = wavs2feats(wavsFolder, tgFolder, numFiles)
% Transoforms wavs files into train and validation features with masks

% ads = audioDatastore(wavFolder);
filelist = dir(wavsFolder);
filelist = filelist(3:numFiles+2);

params = loadparams();


sfl = randperm(numFiles);
valSize = floor(params.valProportion * numFiles);
trainSize = numFiles - valSize;

filesTrn = filelist(sfl(1:trainSize));
filesVal = filelist(sfl(trainSize+1:end));


[featsTrn, maskTrn] = list2feats(filesTrn, tgFolder, params);
[featsVal, maskVal] = list2feats(filesVal, tgFolder, params);

end

%% Helper Functions
function [feats, mask] = list2feats(fileList, tgFolder, params)
  N = numel(fileList);
  feats = [];
  mask = [];
  for i = 1:N
    filename = fileList(i).name;
    [s, fs] = audioread(filename);
    assert(params.afe.SampleRate == fs, ...
      "Sample rate of feature extractor doesn't match sample rate of file"); 
    s = soundNormalize(s);

    feats = [feats extract(params.afe, s)];
    
    [folder, name, ext] = fileparts(filename);
    addition = '_manual';
    ext = '.TextGrid';
    tgFilename = fullfile(tgFolder, [name addition ext]);
    
    mask = [mask tg2mask(tgFilename, fs, numel(s))];    
  end
  
end

%Function to normalize the output
function s = soundNormalize(s)
  s = s / max(abs(s));
end

%Function to normalize features
function f = featNormalize(f)
  f = normalize(f, 2);
end
