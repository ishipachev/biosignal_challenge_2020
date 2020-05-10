filerange = 21:100;

[errRate, sylCnt, trueSylCnt] = evalNet(net, filerange, params);
%%

plotCpsVal(errMat, "lala");

plotErrRate(errRate, sylCnt, trueSylCnt, 4, 'lala');

fprintf("Error: %f%%\n", 100*(mean(errRate(:,1))));

