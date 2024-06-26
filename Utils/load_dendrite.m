function [dendrite, soma, stitch] = load_dendrite(neuron)

%% loads data saved in the dendrite.mat file, with following variables
%            ANOVA: [1×1 struct]
%             Basl: [177×36×8 double]
%      Fitpars_Dir: [3×177×5 double]
%      Fitpars_Ori: [3×177×4 double]
%           RANOVA: [1×1 struct]
%           all_ws: {177×1 cell}
%     best_combAll: {177×1 cell}
%       centreMass: [1×1 struct]
%          meanImg: [512×512 double]
%           refpos: []
%         response: [177×38×8 double]
%      response_tc: [177×38×8×60 double]
%             soma: [1×1 struct]
%            xpixs: {1×177 cell}
%            ypixs: {1×177 cell}
%       zoomFactor: 14

%%


% load the data from each imaged dendrite
[~, neuron.db.spine_folder] = build_path(neuron.db);
sprintf('Loading dendrites from %s', neuron.db.spine_folder);

nDendrites =  numel(neuron.db.spine_seq);
for iD = 1: nDendrites
    foo = load(fullfile(neuron.db.spine_folder, neuron.db.spine_seq{iD}));
    if ~isfield(foo, 'all_ws')
        try
            foo.all_ws = ones(numel(foo.ANOVA), 1);
            foo.best_combAll = ones(numel(foo.ANOVA), 1);
        catch
            warning(sprintf('%s s2p rois not found', neuron.db.spine_seq{iD}))

        end
    end
    dendrite(iD) = foo;
    clear foo
%     figure; 
%     imagesc(dendrite(iD).meanImg);
%     axis image
end

for iD = 1: nDendrites

    try
        load(fullfile(neuron.db.spine_folder, neuron.db.pix_map{iD}));
        try
            pxAmp_ori = abs(px_map.ori);
            pxAng_ori = angle(px_map.ori);
            pxAng_ori = -pxAng_ori; % invert mpep angles
            px_map.ori = pxAmp_ori.*exp(1i*pxAng_ori);

            pxAmp_dir = abs(px_map.dir);
            pxAng_dir= angle(px_map.dir);
            pxAng_dir = -pxAng_dir; % invert mpep angles
            px_map.dir = pxAmp_dir.*exp(1i*pxAng_dir);

        catch

            pxAmp_ori = abs(px_map.all_st.ori);
            pxAng_ori = angle(px_map.all_st.ori);
            pxAng_ori = -pxAng_ori; % invert mpep angles
            px_map.ori = pxAmp_ori.*exp(1i*pxAng_ori);

            pxAmp_dir = abs(px_map.all_st.dir);
            pxAng_dir= angle(px_map.all_st.dir);
            pxAng_dir = -pxAng_dir; % invert mpep angles
            px_map.dir = pxAmp_dir.*exp(1i*pxAng_dir);

            px_map.mimg = px_map.all_st.mimg;
        end

        dendrite(iD).pixelMap = px_map;
    catch
        warning(sprintf('%s pxMap not found', neuron.db.pix_map{iD}))


    end
end

%% if exist, load somatic responses
[vis_file, vis_path] = build_path(neuron.db, 'vis');

% if data for soma recs don't exist, return
if exist(fullfile(vis_path, vis_file), 'file')
    resps = load(fullfile(vis_path, vis_file));

    soma = retune(resps, [], 'date');

    soma.dir_pars_vm_centred = soma.dir_pars_vm;
    soma.dir_pars_vm_centred(1) = 0;
    soma.fit_vm_centred = mfun.vonMises2(soma.dir_pars_vm_centred, soma.fit_pt);
    soma.avePeak_centred = soma.avePeak;
    [~, Dp] = min(abs(unique(soma.dirs) - soma.prefDir));
    soma.avePeak_centred = circshift(soma.avePeak_centred, 7-Dp);

    soma.ori_pars_vm_centred = soma.ori_pars_vm;
    soma.ori_pars_vm_centred(1) = 0;
    soma.ori_fit_vm_centred = mfun.vonMises(soma.ori_pars_vm_centred, soma.ori_fit_pt*2);
    soma.aveOriPeak_centred = soma.aveOriPeak;
    [~, Op] = min(abs(unique(soma.oris) - soma.prefOri));
    soma.aveOriPeak_centred = circshift(soma.aveOriPeak_centred, 4-Op);

else
    soma = [];
    warning(sprintf('%s somatic resps not found', vis_file))

end


%% convert position in pixels to positions in microns referenced to the zstack
for iD = 1: numel(neuron.db.spine_seq)

    [umperpx_X,  umperpx_Y] = ppbox.zoom2fov(dendrite(iD).zoomFactor, neuron.db.mic2p,  neuron.db.morph.expRef{2});

    [Ly, Lx] = size(dendrite(iD).meanImg);

    umperpx_X = umperpx_X/Lx;
    umperpx_Y = umperpx_Y/Ly;

    if isfield(dendrite(iD).soma, 'umperpx')
        umperpx_X_soma = dendrite(iD).soma.umperpx;
        umperpx_Y_soma = dendrite(iD).soma.umperpx;
    else
    [umperpx_X_soma,  umperpx_Y_soma] = ppbox.zoom2fov(dendrite(iD).soma.zoomFactor, neuron.db.mic2p);
    umperpx_X_soma = umperpx_X_soma/1024;
    umperpx_Y_soma = umperpx_Y_soma/1024;
    end
    %distance of fov ref point from soma in zstack
    dendrite(iD).soma.x_rel = (-dendrite(iD).soma.xpose + dendrite(iD).refpos(2))*umperpx_X_soma; % refpos(2) is X in imageJ;  soma.xpose is soma X position in ImageJ
    dendrite(iD).soma.y_rel = (-dendrite(iD).soma.ypose + dendrite(iD).refpos(4))*umperpx_Y_soma; % refpos(4) is Y in imageJ

    % distance of fov from ref point in s2P
    dendrite(iD).fov_x_um = (1:Lx)*umperpx_X - dendrite(iD).refpos(3)*umperpx_X ; % refpos(3) is X in S2P
    dendrite(iD).fov_y_um = (1:Ly)*umperpx_Y - dendrite(iD).refpos(1)*umperpx_Y ; % refpos(1) is Y in S2P

    % distance of fov from soma
    dendrite(iD).fov_x_um = dendrite(iD).fov_x_um + dendrite(iD).soma.x_rel;
    dendrite(iD).fov_y_um = dendrite(iD).fov_y_um + dendrite(iD).soma.y_rel;


end

%%


for iD = 1: numel(neuron.db.spine_seq)
    if isfield(dendrite(iD), 'all_ws')

        dendrite(iD).X = dendrite(iD).fov_x_um(int32(dendrite(iD).centreMass.y)); % changed
        dendrite(iD).Y = dendrite(iD).fov_y_um(int32(dendrite(iD).centreMass.x));

        %      dendrite(iD).SigInd = dendrite(iD).ANOVA<=0.05;
        nS = numel(dendrite(iD).ANOVA);
        % nS = numel(dendrite(iD).RANOVA);s

        for iS = 1:nS

            [~, dendrite(iD).bestCombo(iS)] = max(dendrite(iD).all_ws(iS,:));

            if size(dendrite(iD).response,2) >13
                blank = 37;
            else
                blank = 13;
            end
            these_stim = [ [1:12] + (dendrite(iD).bestCombo(iS)-1)*12, blank];

            resps = squeeze(dendrite(iD).response(iS, these_stim,:));

            this_anova = anova1(resps', 1:13, 'off');
            dendrite(iD).SigInd(iS) = this_anova <=0.05;

            %      dendrite(iD).SigInd(iS) = dendrite(iD).ANOVA{iS}.Pval{1} <=0.05;
            %           dendrite(iD).SigInd(iS) = sum(dendrite(iD).RANOVA{iS}.pValue <=0.005)>0;

            if blank ==13
                dendrite(iD).pars_dir(iS, :) = dendrite(iD).Fitpars_Dir( iS,:);
                dendrite(iD).pars_ori(iS, :) = dendrite(iD).Fitpars_Ori( iS,:);
            else
                dendrite(iD).pars_dir(iS, :) = dendrite(iD).Fitpars_Dir(dendrite(iD).bestCombo(iS), iS,:);
                dendrite(iD).pars_ori(iS, :) = dendrite(iD).Fitpars_Ori(dendrite(iD).bestCombo(iS), iS,:);
            end


        end


        dendrite(iD).pars_dir(:,1) = -dendrite(iD).pars_dir(:,1) +360;
        dendrite(iD).pars_ori(:,1) = -dendrite(iD).pars_ori(:,1) +180;

        %     figure; imagesc(dendrite(iD).fov_x_um,dendrite(iD).fov_y_um, dendrite(iD).meanImg); pause;
    end
end


%% create fov image in common reference
stitch = stitch_dendrite(dendrite,1);
end