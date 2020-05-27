function [trnIds, valIds, perfIds] = splitLabeledData(params)
% Get list of indicies of files to train network, to validate it during the training
% And list of indicies of files to calculate total performance

labeled = dir(params.tgFolder);
labeled = labeled(3:end); %cut off . and ..
labelNum = numel(labeled);
strList = strings(labelNum, 1);
for i=1:labelNum
  fname = labeled(i).name;
  fname = fname(1:8); %cutting off only first part like 'R09_0018'
  strList(i) = fname;
end

labeledIds = NaN(labelNum,1);
labeledFnames = strings;
allWavs = dir(params.wavsFolder);
allWavs = allWavs(3:end);
wavsNum = numel(allWavs);
lcnt = 1;
for i=1:wavsNum
  fname = allWavs(i).name;
  if contains(fname, strList(lcnt))
    labeledIds(lcnt) = i;
    labeledFnames(lcnt) = fname;
    lcnt = lcnt + 1;
  end
  if lcnt > labelNum
    break;
  end
    
end

%% 
labeledSize = numel(labeledFnames);
trnIds = [];
valIds = [];

if isfield(params, 'trnProportion')
  if isscalar(params.trnProportion) && isnumeric(params.trnProportion) %set as proportion
    if params.trnProportion ~= 0
      trnNum = floor(labeledSize * params.trnProportion);
      trnIds = randperm(labeledSize, trnNum); 
      valIds = setdiff(1:labeledSize, trnIds);
    end
  else
    error("params.trnProp set to unsupported type");
  end
end

if isfield(params, 'trnNames')
  if isstring(params.trnNames)
    [~, trnNamedIds] = intersect(labeledFnames, params.trnNames);
    trnIds = union(trnIds, trnNamedIds); %union in case we also use trnProp
  else
    error("params.trnNames set to unsupported type or empty");
  end
end

if isfield(params, "valNames")
  if isstring(params.valNames)
    [~, valNamedIds] = intersect(labeledFnames, params.valNames);
    valIds = union(valIds, valNamedIds); %union in case we also use trnProp
  else
    error("params.valNames set to unsupported type or empty");
  end
end    

if isempty(trnIds)
  error("Lists of labeled train files is empty");
end
  
if isempty(valIds)
  error("List of labeled validation files is empty");
end
  

%% Right way to split data (except perfIdx )

perfIds = setdiff(1:wavsNum, labeledIds); %monitor performance on non labeled data
trnIds = labeledIds(trnIds); %get indicies related to all files, not to labeled group
valIds = labeledIds(valIds);

%% Hardcoded split used for contest

% perfIds = setdiff(1:wavsNum, labeledIds); %monitor performance on non labeled data
% trnIds = labeledIds;
% valIds = labeledIds(end-2:end);

end

