function cnt = countSyls(sylNet, features, params)

mask = classify(sylNet, features.');
mask = double(mask);
mask = mask.' - 1;

cnt = nnz(diff(mask) == 1);

end

%% Helper functions

% postprocessing function, excluding extremely short periods
function m = postProc(m, params)
  d = diff(m);
  up = find(d, 1);
  down = find(d, -1);
  
  hopLength = params.afeOpt.windowSize - params.afeOpt.overlapLength;
  vowWin = (up - down) * hopLength / params.afeOpt.fs;
  dropMask = vowWin < params.minVowLen;
  
  %bad, but still
  for i=1:numel(up)
    m(up(i) - 1 : down(i) + 1) = 0;
  end
end

