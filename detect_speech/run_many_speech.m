paramsSyls = loadSpeechParams();
%%

runSingleTrainAndVal(paramsSyls);

paramsSyls.sequenceLength = 800;
runSingleTrainAndVal;
paramsSyls.sequenceLength = 1600;
runSingleTrainAndVal;
paramsSyls.sequenceLength = 3200;
runSingleTrainAndVal;
paramsSyls.sequenceLength = 200;
runSingleTrainAndVal;
paramsSyls.sequenceLength = 400;


paramsSyls.train.RateDropFactor = 0.25;
paramsSyls.train.RateDropPeriod = 4;
runSingleTrainAndVal;

paramsSyls.train.maxEpochs = 4;
paramsSyls.train.miniBatchSize = 16;
runSingleTrainAndVal;
paramsSyls.train.RateDropFactor = 1;
paramsSyls.train.RateDropPeriod = 4;


paramsSyls.net.layerSize = 100;
runSingleTrainAndVal;
paramsSyls.net.layerSize = 300;
runSingleTrainAndVal;
paramsSyls.net.layerSize = 400;
runSingleTrainAndVal;
paramsSyls.net.layerSize = 200;

paramsSyls.net.dropout = 0.1;
runSingleTrainAndVal;
paramsSyls.net.dropout = 0.5;
runSingleTrainAndVal;
paramsSyls.net.dropout = 0.2;

paramsSyls.train.miniBatchSize = 8;
runSingleTrainAndVal;
paramsSyls.train.miniBatchSize = 4;
runSingleTrainAndVal;
paramsSyls.train.miniBatchSize = 16;











