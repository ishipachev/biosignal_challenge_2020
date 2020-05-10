function errMat = netValidate(params)

  filerange = 21:100;

%   err_rate = evalNet(sylNet, filerange, params);

  foldername = getPastNetwork(params);
  errMat = evalCpDir(foldername, filerange, params);
  plotCpsVal(errMat, foldername);

end
% fprintf("Error: %f%%\n", 100*(mean(err_rate(:,1))));

%% Helper functions

% function [meanErr, stdErr, maxErr, errMat] = evalCpDir(foldername, filerange, params)
function errMat = evalCpDir(foldername, filerange, params)
  list = dir(foldername);
  list = list(3:end);
  epochNum = numel(list) - 1; %minus option file
%   meanErr = NaN(epochNum, 1); stdErr = NaN(epochNum, 1); maxErr = NaN(epochNum, 1);
  errMat = NaN(numel(filerange), epochNum); 
  for ep=1:epochNum
    cpname = fullfile(list(ep).folder, list(ep).name);
    load(cpname, 'net');
    
    fprintf("Validating net for %d epoch...\n", ep);
    [errRate, sylCnt, trueSylCnt] = evalNet(net, filerange, params);
    
    errMat(:, ep) = errRate;
    
    plotErrRate(errRate, sylCnt, trueSylCnt, ep, cpname);
  end
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
  idx = find(isdir, true, 'last');
  foldername = fullfile(params.checkpointFolder, cpFolder(idx).name);
end