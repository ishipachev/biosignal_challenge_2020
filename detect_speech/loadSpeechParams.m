function params = loadSpeechParams()
%LOADPARAMS Summary of this function goes here
%   Detailed explanation goes here

params.wavsFolder = '../data/wavs';
params.featsFolder = 'features_speech';
params.checkpointFolder = 'checkpoints_speech';
params.GTPath = '../data/reference_data.mat';
params.tgFolder = '../data/processed_labels/picked_only_vows';
params.tgTierName = 'MAU2';  %tier sign we used to label data, not common
params.tgIntervalName = 's'; %speech sign we use to label data, not common


%% Labeled data set splitting options
params.rng = 42;    % fix random generator, comment if randomness is needed
params.trnProportion = 1; % set to 1, if you want to train on all files
                          % set to 0, if you want to split files by names
                          % provided by two options below
%set filenames to train on, can work with trnProp together
% params.trnNames = ["R09_0235.WAV", ...
%                    "R09_0234.WAV"];
% OR use it this way
% params.trnNames = loadSpeechTrnFilenames();

%set filenames to train on, can work with trnProp together
% params.valNames = ["R09_0235.WAV", ...
%                    "R09_0234.WAV"];
% OR use it this way
params.valNames = loadSpeechValFilenames();

%%
params.extendWindowMul = 5;
params.constShift = 0;
params.sequenceLength = 400;

params.train.maxEpochs = 2;
params.train.miniBatchSize = 16;
params.train.RateDropFactor = 1;
params.train.RateDropPeriod = 4;

params.afeOpt.windowSize = 256;
params.afeOpt.overlapLength = 128;
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

