filename = 'R09_0004'; %without extention


tgpath = '../data/raw_labels_syls';
wavpath = '../data/wavs';

tgfile = fullfile(tgpath, [filename '.TextGrid']);
wavfile = fullfile(wavpath, [filename '.wav']);
[snd, fs] = audioread(wavfile);
sound(snd, fs);
t = 0: 1/fs: (length(snd)-1)/fs;
%%

tg = tgRead(tgfile);
figure, tgPlot(tg);

%%
tname = 'MAU';
tgt = tg.tier{1,1};

label = {'vowel', 'diphthong'};
% labels = {'vowel'};
% labels = {'diphthong'};

tvow = tgFindLabels(tg, tname, 'vowel');
tdip = tgFindLabels(tg, tname, 'diphthong');


newtg = tg;

% for cutname=[tvow tdip]
cidx = cell2mat([tvow tdip]);
newtg.tier{1}.T1 = tgt.T1(cidx);
newtg.tier{1}.T2 = tgt.T2(cidx);
newtg.tier{1}.Label = tgt.Label(cidx);

%changing label to something shorter
s = numel(newtg.tier{1}.Label); for i=1:s; newtg.tier{1}.Label{i}='v'; end
% newtg.tier{1}.Label(:) = 'v';
% end
