function [f, s] = exctractOrLoadFeatures(filename, featsFolder, params)
% Extract features from .wav file or load them if they already calculated
  [pathstr, name, ext] = fileparts(filename);
  matfile = fullfile(featsFolder, [name '.mat']);
  
  if exist(matfile, 'file')
    filedata = load(matfile);
    if isequaln(filedata.afeOpt, params.afeOpt) && (params.afeOpt.recompute == false)
      f = filedata.f;
      s = filedata.s;
      return;
    end
  end
  
  %%else cases  
  [s, fs] = audioread(filename);
  
  assert(params.afeOpt.fs == fs, ...
    "Sample rate of feature extractor doesn't match sample rate of file");
  s = soundNormalize(s);
  f = extract(params.afe, s);
  f = featNormalize(f);
  
  afeOpt = params.afeOpt;
  save(matfile, 'f', 'afeOpt', 's');
  
end

