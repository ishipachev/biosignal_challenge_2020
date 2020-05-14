function val = loadGT(params)

load(params.GTPath, 'true_dur');
val = true_dur;

end

