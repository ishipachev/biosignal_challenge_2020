function [syl, dur] = articulation_rate(sig, fs)

sylsFolder = '../sandbox_ilia';
speechFolder = '../sandbox_speech';
optFname = 'trainOpt.mat';
wcNetFname = 'net_checkpoint*.mat';

%% Syllabus
addpath(sylsFolder);
disp('lolo');
% cd ..
bestnetFolder = 'bestnet/4';
load(fullfile(sylsFolder, bestnetFolder, optFname), 'params');

netNameStruct = dir(fullfile(sylsFolder, bestnetFolder, wcNetFname));
netFname = fullfile(netNameStruct.folder, netNameStruct.name);
load(netFname, 'net');

sylNet = net;
s = soundNormalize(sig);
f = extract(params.afe, s);
f = featNormalize(f);

sylsCnt = countSyls(sylNet, f, params);

rmpath(sylsFolder);
%% Speech duration
addpath(speechFolder);

bestnetFolder = 'bestnet/3';
load(fullfile(speechFolder, bestnetFolder, optFname), 'params');

netNameStruct = dir(fullfile(speechFolder, bestnetFolder, wcNetFname));
netFname = fullfile(netNameStruct.folder, netNameStruct.name);
load(netFname, 'net');

speechNet = net;
s = soundNormalize(sig);
f = extract(params.afe, s);
f = featNormalize(f);

speechDur = countSpeechDur(speechNet, f, params);

rmpath(speechFolder);
%%

syl = sylsCnt;
dur = speechDur;

end