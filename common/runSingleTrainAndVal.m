function [net, errMat] = runSingleTrainAndVal(params)

[trnIdx, valIdx, perfIdx] = splitLabeledData(params);
[net, cpFolder] = netTrain(trnIdx, valIdx, params);
[errMat, diffMat] = netValidate(perfIdx, cpFolder, params);

figure;
plot(diffMat);
title('Accuracy (diffMat)');
xlabel('Epochs');
ylabel('Score, %');
grid on;

end