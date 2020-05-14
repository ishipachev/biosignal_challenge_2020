params = loadSylsParams();
[trnIdx, valIdx, perfIdx] = splitLabeledData(params);
net = netTrain(trnIdx, valIdx, params);
%%
% gpuDevice(1);
% pause(5);
[errMat, diffMat] = netValidate(perfIdx, params);

figure;
plot(diffMat);
title('diffMat');
grid on;
% params;

%%