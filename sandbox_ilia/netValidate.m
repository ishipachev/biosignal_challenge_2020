wavsFolder = '../data/wavs';
featsFolder = '../data/features';

filerange = 21:100;
sylNet = speechDetectNet;

err_rate = countValidateAll(sylNet, wavsFolder, featsFolder, filerange, params);

figure;
plot(err_rate(:,2:3));
title("Number of syllabus in files");
xlabel("File number");
ylabel("Number of syllabus");
legend("Detected", "True value");
grid on;

figure;
plot(err_rate(:,1));
title("Error rate across files");
xlabel("File number");
ylabel("Error rate");
grid on;


fprintf("Error: %f%%\n", 100*(mean(err_rate(:,1))));


%%hard files

