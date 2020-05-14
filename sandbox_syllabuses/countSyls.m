function cnt = countSyls(sylNet, features, params)

mask = classify(sylNet, features.');
mask = double(mask);
mask = mask.' - 1;

mask = postProc(mask, params);

cnt = nnz(diff(mask) == 1);

end

%% Helper functions

% postprocessing function, excluding extremely short periods
function m = postProc(m, params)
  hopLength = params.afeOpt.windowSize - params.afeOpt.overlapLength;

  minStart = floor(0.02 * params.afeOpt.fs / hopLength);
  m(1:minStart) = 0;
  m(end-minStart:end) = 0;
  
  d = diff(m);
  up = find(d==1);
  down = find(d==-1);
  
  if numel(up) ~= numel(down)
    return
  end
  
  vowWin = abs((down - up)) * hopLength / params.afeOpt.fs;
  dropMask = vowWin < 0.02;
  
  %bad, but still
  for i=1:numel(up)
    if dropMask(i)
      m(up(i) - 1 : down(i) + 1) = 0;
    end
  end
end

