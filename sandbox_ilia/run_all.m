params = loadparams();
[trnIdx, valIdx, perfIdx] = splitLabeledData(params);
net = netTrain(trnIdx, valIdx, params);
%%
% gpuDevice(1);
pause(5);
errMat = netValidate(perfIdx, params);
beep;
% params;

%%