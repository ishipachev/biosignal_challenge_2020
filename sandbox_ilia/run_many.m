params = loadparams();

%%
[trnIdx, valIdx, perfIdx] = splitLabeledData(params);
net = netTrain(trnIdx, valIdx, params);
%%
[errMat, diffMat] = netValidate(perfIdx, params);

figure;
plot(diffMat);
title('diffMat');

%%
params.sequenceLength = 800
run_single;
params.sequenceLength = 1600
run_single;
params.sequenceLength = 3200
run_single;
params.sequenceLength = 200
run_single;
params.sequenceLength = 400


params.train.RateDropFactor = 0.25
params.train.RateDropPeriod = 4
run_single;


%%
Big_Cnt = 0;
params.train.maxEpochs = 4;
params.train.miniBatchSize = 16;
% run_single;
params.train.RateDropFactor = 1
params.train.RateDropPeriod = 4


params.net.layerSize = 100
run_single;
params.net.layerSize = 300
run_single;
params.net.layerSize = 400
run_single;
params.net.layerSize = 200

params.net.dropout = 0.1
run_single;
params.net.dropout = 0.5
run_single;
params.net.dropout = 0.2

params.train.miniBatchSize = 8
run_single;
params.train.miniBatchSize = 4
run_single;
params.train.miniBatchSize = 16











