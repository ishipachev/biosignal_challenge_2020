tgFolder = '../data/processed_labels/picked_only_vows';
wavFolder = '../data/wavs';

%%
ads = audioDatastore(wavFolder);

%%
fname = 'R09_0006.wav';
fullfname = fullfile(wavFolder, fname);

[s_trn, fs] = audioread(fullfname); 
s_trn = soundNormalize(s_trn);

windowSize = 256;
overlapLength = 128;

afe = audioFeatureExtractor('SampleRate',fs, ...
    'Window',hann(windowSize,"Periodic"), ...
    'OverlapLength',overlapLength, ...
    ...
    'spectralCentroid',true, ...
    'spectralCrest',true, ...
    'spectralEntropy',true, ...
    'spectralFlux',true, ...
    'spectralKurtosis',true, ...
    'spectralRolloffPoint',true, ...
    'spectralSkewness',true, ...
    'spectralSlope',true, ...
    'harmonicRatio',true);
  
featuresTraining = extract(afe,s_trn);
featuresTraining = featNormalize(featuresTraining);

[numWindows,numFeatures] = size(featuresTraining);

[folder, name, ext] = fileparts(fullfname);
addition = '_manual';
ext = '.TextGrid';
tgFilename = fullfile(tgFolder, [name addition ext]);

maskTraining = tg2mask(tgFilename, fs, numel(s_trn));

%%
fname = 'R09_0012.wav';
fullfname = fullfile(wavFolder, fname);

[s_val, fs] = audioread(fullfname); 
s_val = soundNormalize(s_val);

windowSize = 256;
overlapLength = 128;

afe = audioFeatureExtractor('SampleRate',fs, ...
    'Window',hann(windowSize,"Periodic"), ...
    'OverlapLength',overlapLength, ...
    ...
    'spectralCentroid',true, ...
    'spectralCrest',true, ...
    'spectralEntropy',true, ...
    'spectralFlux',true, ...
    'spectralKurtosis',true, ...
    'spectralRolloffPoint',true, ...
    'spectralSkewness',true, ...
    'spectralSlope',true, ...
    'harmonicRatio',true);
  
featuresValidation = extract(afe, s_val);
featuresValidation = featNormalize(featuresValidation);

[folder, name, ext] = fileparts(fullfname);
addition = '_manual';
ext = '.TextGrid';
tgFilename = fullfile(tgFolder, [name addition ext]);

maskValidation = tg2mask(tgFilename, fs, numel(s_val));
%%


%Get Train Mask as categorical array
windowLength = numel(afe.Window);
hopLength = windowLength - afe.OverlapLength;
range = (hopLength) * (1:size(featuresTraining,1)) + hopLength;
maskMode = zeros(size(range));
for index = 1:numel(range)
    maskMode(index) = mode(maskTraining( (index-1)*hopLength+1:(index-1)*hopLength+windowLength ));
end
maskTraining = maskMode.';
maskTrainingCat = categorical(maskTraining);

%Get Validation Mask as categorical array
% maskValidation = maskTraining;
% featuresValidation = featuresTraining;
% warning('Copy Mask Validation as Mask Training');

range = (hopLength) * (1:size(featuresValidation,1)) + hopLength;
maskMode = zeros(size(range));
for index = 1:numel(range)
    maskMode(index) = mode(maskValidation( (index-1)*hopLength+1:(index-1)*hopLength+windowLength ));
end
maskValidation = maskMode.';
maskValidationCat = categorical(maskValidation);

sequenceLength = 800;
sequenceOverlap = round(0.75*sequenceLength);

trainFeatureCell = helperFeatureVector2Sequence(featuresTraining',sequenceLength,sequenceOverlap);
trainLabelCell = helperFeatureVector2Sequence(maskTrainingCat',sequenceLength,sequenceOverlap);


%% Define net structure
layers = [ ...    
    sequenceInputLayer( size(featuresValidation,2) )    
    bilstmLayer(200,"OutputMode","sequence")   
    bilstmLayer(200,"OutputMode","sequence")   
    fullyConnectedLayer(2)   
    softmaxLayer   
    classificationLayer      
    ];
  
maxEpochs = 20;
miniBatchSize = 4;
options = trainingOptions("adam", ...
    "MaxEpochs",maxEpochs, ...
    "MiniBatchSize",miniBatchSize, ...
    "Shuffle","every-epoch", ...
    "Verbose",0, ...
    "SequenceLength",sequenceLength, ...
    "ValidationFrequency",floor(numel(trainFeatureCell)/miniBatchSize), ...
    "ValidationData",{featuresValidation.',maskValidationCat.'}, ...
    "Plots","training-progress", ...
    "LearnRateSchedule","piecewise", ...
    "LearnRateDropFactor",0.1, ...
    "LearnRateDropPeriod",5);
  
doTraining = true;
if doTraining
   [speechDetectNet,netInfo] = trainNetwork(trainFeatureCell,trainLabelCell,layers,options);
    fprintf("Validation accuracy: %f percent.\n", netInfo.FinalValidationAccuracy);
else
    load speechDetectNet
end

%%
EstimatedVADMask = classify(speechDetectNet,featuresValidation.');
EstimatedVADMask = double(EstimatedVADMask);
EstimatedVADMask = EstimatedVADMask.' - 1;

figure
cm = confusionchart(maskValidation,EstimatedVADMask,"title","Validation Accuracy");
cm.ColumnSummary = "column-normalized";
cm.RowSummary = "row-normalized";

figure;
hold on;
plot(s_val(1:128:end));
plot(EstimatedVADMask);
hold off;

%% Helper Functions

%Function to normalize the output
function s = soundNormalize(s)
  s = s;
end

%Function to normalize features
function f = featNormalize(f)
  f = normalize(f, 2);
end
  
% Convert Feature Vectors to Sequences
function [sequences,sequencePerFile] = helperFeatureVector2Sequence(features,featureVectorsPerSequence,featureVectorOverlap)
    if featureVectorsPerSequence <= featureVectorOverlap
        error('The number of overlapping feature vectors must be less than the number of feature vectors per sequence.')
    end

    if ~iscell(features)
        features = {features};
    end
    hopLength = featureVectorsPerSequence - featureVectorOverlap;
    idx1 = 1;
    sequences = {};
    sequencePerFile = cell(numel(features),1);
    for ii = 1:numel(features)
        sequencePerFile{ii} = floor((size(features{ii},2) - featureVectorsPerSequence)/hopLength) + 1;
        idx2 = 1;
        for j = 1:sequencePerFile{ii}
            sequences{idx1,1} = features{ii}(:,idx2:idx2 + featureVectorsPerSequence - 1); %#ok<AGROW>
            idx1 = idx1 + 1;
            idx2 = idx2 + hopLength;
        end
    end
end