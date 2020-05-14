function [errMat, diffMat] = netValidate(evalIdx, params)

%   filerange = 21:100;

%   err_rate = evalNet(sylNet, filerange, params);

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
%   meanErr = NaN(epochNum, 1); stdErr = NaN(epochNum, 1); maxErr = NaN(epochNum, 1);
  errMat = NaN(numel(evalIdx), epochNum); 
  diffMat = NaN(numel(evalIdx), epochNum);
  for ep=1:epochNum
    cpname = fullfile(list(ep).folder, listC{ep});
    load(cpname, 'net');
    
    fprintf("Validating net for %d epoch..., cpname: %s\n", ep, cpname);
    [errRate, sylCnt, trueSylCnt] = evalNet(net, evalIdx, params);
    
    errMat(:, ep) = errRate;
    d = (sylCnt - trueSylCnt) ./ trueSylCnt;
    diffMat(:, ep) = d;
    
%     plotErrRate(errRate, sylCnt, trueSylCnt, ep, cpname);
    fprintf("Error: %f%%\n", 100*(mean(errRate(:,1))));

  end
end

function [] = appendStats(errMat, diffMat, foldername)

  trainOptFile = fullfile(foldername, 'trainOpt.mat');
  errMeans = mean(errMat);
  save(trainOptFile, 'errMat', 'errMeans', 'diffMat', '-append');
end


% function [] = plotErrRate(errRate, sylCnt, trueSylCnt, epochNum, cpname)
% 
%   figure;
%   subplot(2,1,1);
%   plot([ sylCnt, trueSylCnt ]);
% %   [~,name,~] = fileparts(cpname);
%   namestr = sprintf("Syls in files: cpname: %s, epoch %d", cpname, epochNum); 
%   title(namestr, 'Interpreter', 'none');
%   xlabel("File number");
%   ylabel("Number of syllabus");
%   legend("Detected", "True value");
%   grid on;
% 
% %   figure;
%   subplot(2,1,2);
%   plot(errRate(:,1));
%   title("Error rate across files");
%   xlabel("File number");
%   ylabel("Error rate");
%   grid on;
% 
% end

% function [] = plotNetTrainStats(errMat, foldername)
%   figure;
%   boxplot(errMat);
% %   [~,name,~] = fileparts(foldername);
%   titilestr = sprintf("Error per epoch, folder %s", foldername);
%   title(titilestr, 'Interpreter', 'none');
%   xlabel("Epoch number");
%   ylabel("Error");
%   grid on;
% end


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
  
%   warning("Remove!"); maxFolderNum = 14;
  fname = num2str(maxFolderNum);
  foldername = fullfile(params.checkpointFolder, fname);
end