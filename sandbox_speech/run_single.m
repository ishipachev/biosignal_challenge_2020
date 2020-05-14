[trnIdx, valIdx, perfIdx] = splitLabeledData(params);
net = netTrain(trnIdx, valIdx, params);
[errMat, diffMat] = netValidate(perfIdx, params);

figure;
plot(diffMat);
title('diffMat');
grid on;

Big_Cnt = Big_Cnt + 1;