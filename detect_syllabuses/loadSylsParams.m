function params = loadSylsParams()
%LOADPARAMS Summary of this function goes here
%   Detailed explanation goes here

params.wavsFolder = '../data/wavs';
params.featsFolder = 'features_syls';
params.checkpointFolder = 'checkpoints_syls';
params.GTPath = '../data/reference_data.mat';
params.tgFolder = '../data/processed_labels/picked_only_vows';
params.tgTierName = 'MAU';
params.tgIntervalName = 'v';

params.rng = 46;

params.valProportion = 1/5;
params.extendWindowMul = 0; 
params.constShift = 0;

params.sequenceLength = 800;

params.train.maxEpochs = 2;
params.train.miniBatchSize = 16;
params.train.RateDropFactor = 1;
params.train.RateDropPeriod = 4;

params.afeOpt.windowSize = 128;
params.afeOpt.overlapLength = 64;
params.afeOpt.fs = 44100;
params.afeOpt.recompute = false;

params.net.layerSize = 200;
params.net.dropout = 0.2;

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
  
% without first layer
params.net.layers = [ ...
% this commented layer defined futher in netTrain
%   sequenceInputLayer( size(featuresValidation,2) ) 
  bilstmLayer(params.net.layerSize,"OutputMode","sequence")
  dropoutLayer(params.net.dropout)
  bilstmLayer(params.net.layerSize,"OutputMode","sequence")
  dropoutLayer(params.net.dropout)
  fullyConnectedLayer(2)
  softmaxLayer
  classificationLayer
  ];

end

