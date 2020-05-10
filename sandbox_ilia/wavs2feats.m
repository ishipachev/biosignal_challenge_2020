function [featsTrn, ... 
          maskTrn, ...
          featsVal, ... 
          maskVal, ...
          s_trn, ...
          s_val] = wavs2feats(wavsFolder, featsFolder, tgFolder, numFiles)
% Transoforms wavs files into train and validation features with masks

% ads = audioDatastore(wavFolder);
filelist = dir(wavsFolder);
filelist = filelist(3:numFiles+2);

params = loadparams();


% sfl = randperm(numFiles);
sfl = [3 10 11 14 1 2 4 5 6 7 8 9 16 17 18 19 20    12 13 15 14];
valSize = floor(params.valProportion * numFiles);
trainSize = numFiles - valSize;

filesTrn = filelist(sfl(1:trainSize));
filesVal = filelist(sfl(trainSize+1:end));


[featsTrn, maskTrn, s_trn] = list2feats(filesTrn, featsFolder, tgFolder, params);
[featsVal, maskVal, s_val] = list2feats(filesVal, featsFolder, tgFolder, params);

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

% function [f, s] = exctractOrLoadFeatures(filename, featsFolder, params)
%   
%   [pathstr, name, ext] = fileparts(filename);
%   matfile = fullfile(featsFolder, [name '.mat']);
%   
%   if exist(matfile, 'file')
%     filedata = load(matfile);
%     if isequaln(filedata.afeOpt, params.afeOpt) && (params.afeOpt.recompute == false)
%       f = filedata.f;
%       s = filedata.s;
%       return;
%     end
%   end
%   
%   %%else cases  
%   [s, fs] = audioread(filename);
%   assert(params.afeOpt.fs == fs, ...
%     "Sample rate of feature extractor doesn't match sample rate of file");
%   s = soundNormalize(s);
%   f = extract(params.afe, s);
%   f = featNormalize(f);
%   
%   afeOpt = params.afeOpt;
%   save(matfile, 'f', 'afeOpt', 's');
%   
% end

%Function to normalize the output
% function s = soundNormalize(s)
%   s = s / max(abs(s));
% end

%Function to normalize features
% function f = featNormalize(f)
%   warning("Правильно ли?");
%   f = normalize(f);
% end
