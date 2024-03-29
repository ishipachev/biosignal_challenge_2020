function [syl, dur] = articulation_rate(sig, fs)
%% Solution relies on 44100 frequency sample rate

commonFolder = '../common';
sylsFolder = '../detect_syllabuses';
speechFolder = '../detect_speech';
optFname = 'trainOpt.mat';
wcNetFname = 'net_checkpoint*.mat';

addpath(commonFolder);

%% Syllabus
addpath(sylsFolder);
bestnetFolder = 'net';
% fprintf("Syls net: %s\n", bestnetFolder);
load(fullfile(sylsFolder, bestnetFolder, optFname), 'params');

netNameStruct = dir(fullfile(sylsFolder, bestnetFolder, wcNetFname));
netFname = fullfile(netNameStruct.folder, netNameStruct.name);
load(netFname, 'net');

s = soundNormalize(sig, fs);
f = extract(params.afe, s);
f = featNormalize(f);

sylsCnt = getScore(net, f, params);

rmpath(sylsFolder);
%% Speech duration
addpath(speechFolder);

bestnetFolder = 'net';
% fprintf("Speech net: %s\n", bestnetFolder);
load(fullfile(speechFolder, bestnetFolder, optFname), 'params');

netNameStruct = dir(fullfile(speechFolder, bestnetFolder, wcNetFname));
netFname = fullfile(netNameStruct.folder, netNameStruct.name);
load(netFname, 'net');

s = soundNormalize(sig, fs);
f = extract(params.afe, s);
f = featNormalize(f);

speechDur = getScore(net, f, params);

rmpath(speechFolder);
%%

syl = sylsCnt;
dur = speechDur;

rmpath(commonFolder);

end