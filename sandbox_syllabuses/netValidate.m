function [errMat, diffMat] = netValidate(evalIdx, params)


  foldername = getPastNetwork(params);
  [errMat, diffMat] = evalCpDir(foldername, evalIdx, params);
  plotCpsVal(errMat, foldername);
  
  appendStats(errMat, diffMat, foldername);
end

%% Helper functions

% function [meanErr, stdErr, maxErr, errMat] = evalCpDir(foldername, filerange, params)
function [errMat, diffMat] = evalCpDir(foldername, evalIdx, params)
  list = dir(foldername);
  list = list(3:end);
  listC = natsortfiles({list.name});
  epochNum = numel(list) - 1; %minus option file
  errMat = NaN(numel(evalIdx), epochNum); 
  diffMat = NaN(numel(evalIdx), epochNum);
  for ep=1:epochNum
    cpname = fullfile(list(ep).folder, listC{ep});
    load(cpname, 'net');
    
    fprintf("Validating net for %d epoch..., cpname: %s\n", ep, cpname);
    [errRate, evalCnt, trueCnt] = evalNet(net, evalIdx, params);
    
    errMat(:, ep) = errRate;
    d = (evalCnt - trueCnt) ./ trueCnt;
    diffMat(:, ep) = d;
    
%     plotErrRate(errRate, evalCnt, trueCnt, ep, cpname);
    fprintf("Error: %f%%\n", 100*(mean(errRate(:,1))));

  end
end

function [] = appendStats(errMat, diffMat, foldername)

  trainOptFile = fullfile(foldername, 'trainOpt.mat');
  errMeans = mean(errMat);
  save(trainOptFile, 'errMat', 'errMeans', 'diffMat', '-append');
end


function foldername = getPastNetwork(params)
  cpFolder = dir(params.checkpointFolder);
  isdir = [cpFolder(:).isdir];
  isdir(1:2) = false;
  fidx = find(isdir);
  maxFolderNum = 0;
  for i=fidx
    num = str2num(cpFolder(i).name);
    maxFolderNum = max(maxFolderNum, num);
  end
  
  fname = num2str(maxFolderNum);
  foldername = fullfile(params.checkpointFolder, fname);
end