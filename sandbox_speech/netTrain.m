function speechDurNet = netTrain(trnIdx, valIdx, params)

cpFolder = getCpFolder(params);
% numFiles = params.numFiles;
rng(params.rng);

[featuresTraining, ...
 maskTraining, ...
 featuresValidation, ...
 maskValidation, ...
 ~, ...
 s_val] = wavs2feats(trnIdx, valIdx, params);

%% Get structures adjusted for a learning procedure

afe = params.afe;

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

range = (hopLength) * (1:size(featuresValidation,1)) + hopLength;
maskMode = zeros(size(range));
for index = 1:numel(range)
  maskMode(index) = mode(maskValidation( (index-1)*hopLength+1:(index-1)*hopLength+windowLength ));
end
maskValidation = maskMode.';
maskValidationCat = categorical(maskValidation);
sequenceLength = params.sequenceLength;
sequenceOverlap = round(0.75*sequenceLength);

trainFeatureCell = helperFeatureVector2Sequence(featuresTraining',sequenceLength,sequenceOverlap);
trainLabelCell = helperFeatureVector2Sequence(maskTrainingCat',sequenceLength,sequenceOverlap);


%% Define net structure
layers = [ ...
  sequenceInputLayer( size(featuresValidation,2) )
  bilstmLayer(params.net.layerSize,"OutputMode","sequence")
  dropoutLayer(params.net.dropout)
  bilstmLayer(params.net.layerSize,"OutputMode","sequence")
  dropoutLayer(params.net.dropout)
%   fullyConnectedLayer(100)
  fullyConnectedLayer(2)
  softmaxLayer
  classificationLayer
  ];

options = trainingOptions("adam", ...
  "MaxEpochs",params.train.maxEpochs, ...
  "MiniBatchSize",params.train.miniBatchSize, ...
  "Shuffle","every-epoch", ...     %"Shuffle", "never",
  "Verbose",0, ...
  "SequenceLength",sequenceLength, ...
  "ValidationFrequency",floor(numel(trainFeatureCell)/params.train.miniBatchSize), ...
  "ValidationData",{featuresValidation.',maskValidationCat.'}, ...
  "Plots","training-progress", ...
  "ExecutionEnvironment", "gpu", ...
  "LearnRateSchedule","piecewise", ... %); %, ...
  "LearnRateDropFactor", params.train.RateDropFactor, ...
  "LearnRateDropPeriod", params.train.RateDropPeriod, ...
  "CheckpointPath", cpFolder);


doTraining = true;
if doTraining
  [speechDurNet, netInfo] = trainNetwork(trainFeatureCell,trainLabelCell,layers,options);
  fprintf("Validation accuracy: %f percent.\n", netInfo.FinalValidationAccuracy);
else
  %     load speechDetectNet
end

%Save
trainOptFile = fullfile(cpFolder, 'trainOpt.mat');
save(trainOptFile, 'layers', 'params');

%%
EstimatedVADMask = classify(speechDurNet, featuresValidation.');
EstimatedVADMask = double(EstimatedVADMask);
EstimatedVADMask = EstimatedVADMask.' - 1;

figure
cm = confusionchart(maskValidation,EstimatedVADMask,"title","Validation Accuracy");
cm.ColumnSummary = "column-normalized";
cm.RowSummary = "row-normalized";

figure;
hold on;
plot(s_val(1:params.afeOpt.overlapLength:end));
plot(EstimatedVADMask, 'LineWidth', 2);
plot(maskValidation * 0.8, 'g', 'LineWidth', 2);
hold off;

end

%% Helper Functions

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

% Get next empty folder to store checkpoints
function fullfoldername = getCpFolder(params)
  cpFolder = dir(params.checkpointFolder);
  isdir = [cpFolder(:).isdir];
  isdir(1:2) = false;
  fidx = find(isdir);
  maxFolderNum = 0;
  for i=fidx
    num = str2num(cpFolder(i).name);
    maxFolderNum = max(maxFolderNum, num);
  end
  
  foldername = num2str(maxFolderNum + 1);
  fullfoldername = fullfile(params.checkpointFolder, foldername);
  if exist(fullfoldername, 'dir')
    error("Folder for checkpoints already exists");
  end
  mkdir(fullfoldername);
end
