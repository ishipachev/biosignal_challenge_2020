function [syl, dur] = articulation_rate(sig, fs)

sylsFolder = '../sandbox_syllabuses';
speechFolder = '../sandbox_speech';
optFname = 'trainOpt.mat';
wcNetFname = 'net_checkpoint*.mat';

%% Syllabus
addpath(sylsFolder);
bestnetFolder = 'bestnet_last/9';
% fprintf("Syls net: %s\n", bestnetFolder);
load(fullfile(sylsFolder, bestnetFolder, optFname), 'params');

netNameStruct = dir(fullfile(sylsFolder, bestnetFolder, wcNetFname));
netFname = fullfile(netNameStruct.folder, netNameStruct.name);
load(netFname, 'net');

s = soundNormalize(sig);
f = extract(params.afe, s);
f = featNormalize(f);

sylsCnt = runNet(net, f, params);

rmpath(sylsFolder);

%% Speech duration
addpath(speechFolder);

bestnetFolder = 'bestnet_last/2';
% fprintf("Speech net: %s\n", bestnetFolder);
load(fullfile(speechFolder, bestnetFolder, optFname), 'params');

netNameStruct = dir(fullfile(speechFolder, bestnetFolder, wcNetFname));
netFname = fullfile(netNameStruct.folder, netNameStruct.name);
load(netFname, 'net');

s = soundNormalize(sig);
f = extract(params.afe, s);
f = featNormalize(f);

speechDur = runNet(net, f, params);

rmpath(speechFolder);
%%

syl = sylsCnt;
dur = speechDur;

end