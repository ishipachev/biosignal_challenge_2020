params = loadparams();
net = netTrain(params);
errMat = netValidate(params);
% params;

%%