params = loadparams();
[trnIdx, valIdx, perfIdx] = splitLabeledData(params);
net = netTrain(trnIdx, valIdx, params);
%%
errMat = netValidate(perfIdx, params);
beep;
% params;

%%