function [soma, den] = compare_soma_den(neuron)

% Computes:
% - soma pref dir and ori
% - combo den pref dir and ori
% - individual den pref dir and ori
% - tuning curves
% - tuning curves centred at 0
% - tuning curves relative to the soma


%% compare single dendrites with soma
den = neuron.combo_px_map;

if isempty(neuron.soma)
    % if soma was not recorded
     soma_vs_den= [];
     return;
else

    % define ori and dir bins
    tun_oris = [];
    tun_dirs = [];
    oris = []; 
    dirs = [];

    % SOMA
    soma = neuron.soma;
   
    % COMBO DEN
    
    den.prefOri = pref_ori;
    den.prefDir = pref_dir;
    den.prefDir_Ori = pref_dir_ori;
    den.ori_fit_vm = tuning_fit_ori;
    den.ori_fit_vm_centred =  tuning_fit_ori_centred;
    den.ori_pars = den.ori_pars;
    den.ori_pars_centred = den.ori_pars_centred;
    den.ori_pars_rel = den.ori_pars;
    den.ori_pars_rel(1) = den.ori_pars_relative(1) - soma.ori_pars(1); 
    den.ori_fit_vm_rel = mfun.vonMises(den.ori_pars_rel, tun_oris);
    den.aveOriPeak = den.ori_bin_amp;
    [~, Op] = min(abs(unique(den.ori_bin) - den.prefOri));
    den.aveOriPeak_centred = circshift(soma.aveOriPeak_centred, 4-Op);
    [~, Op] = min(abs(unique(den.ori_bin) - soma.prefOri));
    den.aveOriPeak_rel = circshift(soma.aveOriPeak_centred, 4-Op);

    % INDIVIDUAL DEN

for iD = 1: nDendrites
    signal(iD).ori_pars_rel =signal(iD).ori_pars;
    signal(iD).ori_pars_rel(1) = signal(iD).ori_pars_rel(1) - soma.ori_pars(1);

    if signal(iD).ori_pars_rel(1) <-180
        signal(iD).ori_pars_rel(1) = signal(iD).ori_pars_rel(1) +360;
    elseif signal(iD).ori_pars_rel(1) >= 180
        signal(iD).ori_pars_rel(1) = signal(iD).ori_pars_rel(1) -360;
    end

    signal(iD).tuning_fit_ori_rel = mfun.vonMises(signal(iD).ori_pars_rel, tun_oris);

end

end

for iD = 1: nDendrites
    signal(iD).ori_pars_rel_den =signal(iD).ori_pars;
    signal(iD).ori_pars_rel_den(1) = signal(iD).ori_pars_rel(1) - den.ori_pars(1);

    if signal(iD).ori_pars_rel(1) <-180
        signal(iD).ori_pars_rel(1) = signal(iD).ori_pars_rel(1) +360;
    elseif signal(iD).ori_pars_rel(1) >= 180
        signal(iD).ori_pars_rel(1) = signal(iD).ori_pars_rel(1) -360;
    end

    signal(iD).tuning_fit_ori_rel_den = mfun.vonMises(signal(iD).ori_pars_rel_den, tun_oris);

    signal(iD).ori_pars_centred =signal(iD).ori_pars;
    signal(iD).ori_pars_centred(1) = 0;
    signal(iD).tuning_fit_ori_centred = mfun.vonMises(signal(iD).ori_pars_centred, tun_oris);

end


end