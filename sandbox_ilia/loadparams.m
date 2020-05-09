function params = loadparams()
%LOADPARAMS Summary of this function goes here
%   Detailed explanation goes here

params.numFiles = 19;

params.windowSize = 128;
params.overlapLength = 64;
params.fs = 44100;
params.valProportion = 1/5;

params.extendWindowMul = 3;
% params.constShift = params.windowSize * 10;
params.constShift = 0;

params.rng = 46;
params.sequenceLength = 800;
params.train.maxEpochs = 8;
params.train.miniBatchSize = 4;

params.afe = audioFeatureExtractor('SampleRate',params.fs, ...
    'Window',hann(params.windowSize,"Periodic"), ...
    'OverlapLength',params.overlapLength, ...
    ...
    'spectralCentroid',true, ...
    'spectralCrest',true, ...
    'spectralDecrease',true, ... %added 
    'spectralEntropy',true, ...
    'spectralFlatness',true, ... %added
    'spectralFlux',true, ...
    'spectralKurtosis',true, ...
    'spectralRolloffPoint',true, ...
    'spectralSkewness',true, ...
    'spectralSlope',true, ...
    'spectralSpread',true, ... %added
    'harmonicRatio',true);
  


end

