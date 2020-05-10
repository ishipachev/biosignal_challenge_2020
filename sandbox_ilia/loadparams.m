function params = loadparams()
%LOADPARAMS Summary of this function goes here
%   Detailed explanation goes here

params.numFiles = 20;

params.afeOpt.windowSize = 128;
params.afeOpt.overlapLength = 64;
params.afeOpt.fs = 44100;
params.afeOpt.recompute = false;

params.valProportion = 1/5;
params.extendWindowMul = 3;
% params.constShift = params.windowSize * 10;
params.constShift = 0;

params.rng = 46;
params.sequenceLength = 50;
params.train.maxEpochs = 6;
params.train.miniBatchSize = 32;

params.train.RateDropFactor = 1;
params.train.RateDropPeriod = 4;
% params.train.InitialLearnRate = 0.01;


params.afe = audioFeatureExtractor('SampleRate',params.afeOpt.fs, ...
    'Window',hann(params.afeOpt.windowSize,"Periodic"), ...
    'OverlapLength',params.afeOpt.overlapLength, ...  % 'gtcc', true,... % 'gtccDeltaDelta', true, ...
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

