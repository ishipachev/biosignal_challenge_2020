function [] = plotErrRate(errRate, evalDur, trueDur, epochNum, cpname)

  figure;
  subplot(2,1,1);
  plot([ evalDur, trueDur ]);
%   [~,name,~] = fileparts(cpname);
  namestr = sprintf("Speech duration in files: cpname: %s, epoch %d", cpname, epochNum); 
  title(namestr, 'Interpreter', 'none');
  xlabel("File number");
  ylabel("Duration, seconds");
  legend("Detected", "True value");
  grid on;

%   figure;
  subplot(2,1,2);
  plot(errRate(:,1));
  title("Error rate across files");
  xlabel("File number");
  ylabel("Error rate");
  grid on;

end

