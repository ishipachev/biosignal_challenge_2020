filerange = 21:100;

[errRate, sylCnt, trueSylCnt] = evalNet(net, filerange, params);
%%

plotCpsVal(errMat, "lala");

plotErrRate(errRate, sylCnt, trueSylCnt, 4, 'lala');

fprintf("Error: %f%%\n", 100*(mean(errRate(:,1))));


%%
tgFolder = params.tgFolder;

fileList = dir(tgFolder);
fileList = fileList(3:end);
N = numel(fileList);

D = NaN(N, 1);
B = NaN(N, 1);
total = 0;
for i=1:N
  tgFilename = fullfile(fileList(i).folder, fileList(i).name);
  tg = tgRead(tgFilename);
  tname = 'MAU';
  tierIndex = tgI(tg, 'MAU');

  tgt = tg.tier{tierIndex};

  tvow = tgFindLabels(tg, tname, 'v');

  cidx = cell2mat(tvow);

  T1 = tgt.T1(cidx);
  T2 = tgt.T2(cidx);
  
  total = total + numel(T1);
  
  B(i) = T1(1);
  D(i) = min(T2 - T1);
end  
