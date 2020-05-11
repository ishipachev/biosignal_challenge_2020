function [syl, dur] = articulation_rate(sig, fs)

sylsFolder = '../sandbox_ilia';
speechFolder = '../sandbox_speech';
optFname = 'trainOpt.mat';
wcNetFname = 'net_checkpoint*.mat';

%% Syllabus
addpath(sylsFolder);
% disp('lolo');
% cd ..
bestnetFolder = 'bestnet/4';
load(fullfile(sylsFolder, bestnetFolder, optFname), 'params');

netNameStruct = dir(fullfile(sylsFolder, bestnetFolder, wcNetFname));
netFname = fullfile(netNameStruct.folder, netNameStruct.name);
load(netFname, 'net');

% sylNet = net;
s = soundNormalize(sig);
f = extract(params.afe, s);
f = featNormalize(f);

sylsCnt = countSyls(net, f, params);

rmpath(sylsFolder);
%% Speech duration
addpath(speechFolder);

bestnetFolder = 'bestnet/2';
load(fullfile(speechFolder, bestnetFolder, optFname), 'params');

netNameStruct = dir(fullfile(speechFolder, bestnetFolder, wcNetFname));
netFname = fullfile(netNameStruct.folder, netNameStruct.name);
load(netFname, 'net');

% speechNet = net;
% load('NETNET.mat');
% speechNet = NETNET
s = soundNormalize(sig);
f = extract(params.afe, s);
f = featNormalize(f);

speechDur = countSpeechDur(net, f, params);

rmpath(speechFolder);
%%

syl = sylsCnt;
dur = speechDur;

end