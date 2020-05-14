function [] = plotErrRate(errRate, evalScore, trueScore, d, epochNum, cpname)

  figure;
  subplot(3,1,1);
  plot([ evalScore, trueScore ]);
%   [~,name,~] = fileparts(cpname);
  namestr = sprintf("Value calculated among all evaluation files; cpname: %s, epoch %d", cpname, epochNum); 
  title(namestr, 'Interpreter', 'none');
  xlabel("File number");
  ylabel("Value, seconds");
  legend("Detected", "True value");
  grid on;

%   figure;
  subplot(3,1,2);
  plot(errRate(:,1));
  title("Accuracy rate across files");
  xlabel("File idx");
  ylabel("Accuracy");
  grid on;
  
  subplot(3,1,3);
  plot(d);
  title("Proportional signed difference");
  xlabel("File idx");
  ylabel("Diff");
  grid on;

end

