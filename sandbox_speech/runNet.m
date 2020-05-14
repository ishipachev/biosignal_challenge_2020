function cnt = runNet(speechNet, features, params)

mask = classify(speechNet, features.');
mask = double(mask);
mask = mask.' - 1;

hopLength = params.afeOpt.windowSize - params.afeOpt.overlapLength;
cnt = sum(mask) * hopLength / params.afeOpt.fs;

% cnt = nnz(diff(mask) == 1);

end