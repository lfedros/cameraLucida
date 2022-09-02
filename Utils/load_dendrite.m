function dendrite = load_dendrite(neuron)

% load the data from each imaged dendrite
[~, spine_folder] = build_path(neuron.db);

nDendrites =  numel(neuron.db.spine_seq);
for iD = 1: nDendrites

    dendrite(iD) = load(fullfile(spine_folder, neuron.db.spine_seq{iD}));
    try
    load(fullfile(spine_folder, neuron.db.pix_map{iD}));
    dendrite(iD).pixelMap = px_map;
    end
end

% convert position in pixels to positions in microns referenced to the
% zstack
for iD = 1: numel(neuron.db.spine_seq)

    [umperpx_X,  umperpx_Y] = ppbox.zoom2fov(dendrite(iD).zoomFactor);
    
    [Ly, Lx] = size(dendrite(iD).meanImg);

    umperpx_X = umperpx_X/Lx;
    umperpx_Y = umperpx_Y/Ly;

    [umperpx_X_soma,  umperpx_Y_soma] = ppbox.zoom2fov(dendrite(iD).soma.zoomFactor);
    umperpx_X_soma = umperpx_X_soma/1024;
    umperpx_Y_soma = umperpx_Y_soma/1024;
    
    %distance of fov ref point from soma in zstack
    dendrite(iD).soma.x_rel = (-dendrite(iD).soma.xpose + dendrite(iD).refpos(2))*umperpx_X_soma; % refpos(2) is X in imageJ;  soma.xpose is soma X position in ImageJ
    dendrite(iD).soma.y_rel = (-dendrite(iD).soma.ypose + dendrite(iD).refpos(4))*umperpx_Y_soma; % refpos(4) is Y in imageJ

    % distance of fov from ref point in s2P
    dendrite(iD).fov_x_um = (1:Lx)*umperpx_X - dendrite(iD).refpos(3)*umperpx_X ; % refpos(3) is X in S2P
    dendrite(iD).fov_y_um = (1:Ly)*umperpx_Y - dendrite(iD).refpos(1)*umperpx_Y ; % refpos(1) is Y in S2P

    % distance of fov from soma
    dendrite(iD).fov_x_um = dendrite(iD).fov_x_um + dendrite(iD).soma.x_rel;
    dendrite(iD).fov_y_um = dendrite(iD).fov_y_um + dendrite(iD).soma.y_rel;

    dendrite(iD).X = dendrite(iD).fov_x_um(int32(dendrite(iD).centreMass(:,2)));
    dendrite(iD).Y = dendrite(iD).fov_y_um(int32(dendrite(iD).centreMass(:,1)));
    
     dendrite(iD).Fitpars_Dir(:,1) = -dendrite(iD).Fitpars_Dir(:,1) +360;
     dendrite(iD).Fitpars_Ori(:,1) = -dendrite(iD).Fitpars_Ori(:,1) +180;

     dendrite(iD).SigInd = dendrite(iD).anovaStat<=0.05;

%     figure; imagesc(dendrite(iD).fov_x_um,dendrite(iD).fov_y_um, dendrite(iD).meanImg); pause;
end


%% create fov image in common reference

stitch_den = stitch_dendrite(dendrite);
end