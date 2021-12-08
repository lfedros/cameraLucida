function tree_poolTuning(neuron)

nDb = numel(neuron);

for iDb = 1:nDb
    
    centeredTunePars = neuron.tuning.tunePars;
    centeredTunePars = 0;
    oriPt = -90:1:90;
    poolOriTune(:,iDb) = oritune(tunePars, -90:1:90);

end





end