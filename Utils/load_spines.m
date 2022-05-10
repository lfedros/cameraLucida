function dendrite = load_dendrite(neuron)

% load the data from each imaged dendrite
[~, spine_folder] = build_path(neuron.db);

nDendrites =  numel(neuron.db.spine_seq);
for iD = 1: nDendrites

    dendrite(iD) = load(fullfile(spine_folder, neuron.db.spine_seq{iD}));

end

% convert position in pixels to positions in microns referenced to the
% zstack
for iD = 1: numel(neuron.db.spine_seq)

    [umperpx_X,  umperpx_Y] = ppbox.zoom2fov(dendrite(iD).zoomFactor);
    umperpx_X = umperpx_X/512;
    umperpx_Y = umperpx_Y/512;

    [umperpx_X_soma,  umperpx_Y_soma] = ppbox.zoom2fov(dendrite(iD).soma.zoomFactor);
    umperpx_X_soma = umperpx_X_soma/1000;
    umperpx_Y_soma = umperpx_Y_soma/1000;

    dendrite(iD).X = dendrite(iD).centreMass(:,1)*umperpx_X...
        + (dendrite(iD).soma.xpose - dendrite(iD).xpose)*umperpx_X_soma;

    dendrite(iD).Y = dendrite(iD).centreMass(:,2)*umperpx_Y...
        + (dendrite(iD).soma.ypose - dendrite(iD).ypose)*umperpx_Y_soma;

     for iS = 1: numel(dendrite(iD).Fitpars)
        
       dendrite(iD).Fitpars{iS}(1) = -dendrite(iD).Fitpars{iS}(1) +360;
    end
end

end