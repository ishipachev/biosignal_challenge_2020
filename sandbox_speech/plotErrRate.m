function [] = plotErrRate(errRate, evalDur, trueDur, d, epochNum, cpname)

  figure;
  subplot(3,1,1);
  plot([ evalDur, trueDur ]);
%   [~,name,~] = fileparts(cpname);
  namestr = sprintf("Speech duration in files: cpname: %s, epoch %d", cpname, epochNum); 
  title(namestr, 'Interpreter', 'none');
  xlabel("File number");
  ylabel("Duration, seconds");
  legend("Detected", "True value");
  grid on;

%   figure;
  subplot(3,1,2);
  plot(errRate(:,1));
  title("Error rate across files");
  xlabel("File number");
  ylabel("Error rate");
  grid on;
  
  subplot(3,1,3);
  plot(d);
  title("Proportional signed difference");
  xlabel("File number");
  ylabel("Diff");
  grid on;

end

