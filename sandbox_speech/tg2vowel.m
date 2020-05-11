folder_out = '../data/processed_labels/raw_only_vows';
folder_in = '../data/raw_labels_syls/';

files = dir(folder_in);

%%
for i=3:numel(files)    %from 3 -- skip . and ..
  f = files(i);
  tg_fname = fullfile(f.folder, f.name);
  tg = tgRead(tg_fname);
  
  tgNew = tg2v(tg);
  [filepath, name, ext] = fileparts(f.name);
  fnameNew = [name '_v' ext];
  fnameNewFull = fullfile(folder_out, fnameNew);
  tgWrite(tgNew, fnameNewFull, 'text');
end

%% Helper Function
%conver all vowels to vowel with 'v' name and 
%drop the rest
function tgnew = tg2v(tg)
  tname = tgGetTierName(tg, 1);
  
  tvow = tgFindLabels(tg, tname, 'vowel');
  tdip = tgFindLabels(tg, tname, 'diphthong');
  
  tgnew = tg;
  
  cidx = cell2mat([tvow tdip]);
  tgnew.tier{1}.T1 = tg.tier{1}.T1(cidx);
  tgnew.tier{1}.T2 = tg.tier{1}.T2(cidx);
  tgnew.tier{1}.Label = tg.tier{1}.Label(cidx);
  
  s = numel(tgnew.tier{1}.Label); 
  for i=1:s
    tgnew.tier{1}.Label{i}='v'; 
  end
  
end