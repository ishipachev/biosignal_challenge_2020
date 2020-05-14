function [syl, dur] = articulation_rate(sig, fs)

sylsFolder = '../sandbox_ilia';
speechFolder = '../sandbox_speech';
optFname = 'trainOpt.mat';
wcNetFname = 'net_checkpoint*.mat';

%% Syllabus
% addpath(sylsFolder);
% bestnetFolder = 'bestnet_last/9';
% fprintf("Syls net: %s\n", bestnetFolder);
% load(fullfile(sylsFolder, bestnetFolder, optFname), 'params');
% 
% netNameStruct = dir(fullfile(sylsFolder, bestnetFolder, wcNetFname));
% netFname = fullfile(netNameStruct.folder, netNameStruct.name);
% load(netFname, 'net');

% sylNet = net;
% s = soundNormalize(sig);
% f = extract(params.afe, s);
% f = featNormalize(f);

% sylsCnt = countSyls(net, f, params);
fprintf("Syls HUI");
sylsCnt = 0;

rmpath(sylsFolder);
%% Speech duration
addpath(speechFolder);

bestnetFolder = 'bestnet_last/2';
fprintf("Speech net: %s\n", bestnetFolder);
load(fullfile(speechFolder, bestnetFolder, optFname), 'params');

netNameStruct = dir(fullfile(speechFolder, bestnetFolder, wcNetFname));
netFname = fullfile(netNameStruct.folder, netNameStruct.name);
% fprintf("Speech Net: %s", netFname);
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