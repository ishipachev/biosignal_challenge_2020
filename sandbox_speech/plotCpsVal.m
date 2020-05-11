function [] = plotCpsVal(errMat, foldername)
  figure;
  boxplot(errMat);
%   [~,name,~] = fileparts(foldername);
  titilestr = sprintf("Error per epoch, folder %s", foldername);
  title(titilestr, 'Interpreter', 'none');
  xlabel("Epoch number");
  ylabel("Error");
  grid on;
end

