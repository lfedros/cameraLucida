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
    
    [Ly, Lx] = size(dendrite(iD).meanImg);

    umperpx_X = umperpx_X/Lx;
    umperpx_Y = umperpx_Y/Ly;

    [umperpx_X_soma,  umperpx_Y_soma] = ppbox.zoom2fov(dendrite(iD).soma.zoomFactor);
    umperpx_X_soma = umperpx_X_soma/1000;
    umperpx_Y_soma = umperpx_Y_soma/1000;
    
    dendrite(iD).soma.x_rel = (-dendrite(iD).soma.xpose + dendrite(iD).refpos(2))*umperpx_X_soma;
    dendrite(iD).soma.y_rel = (-dendrite(iD).soma.ypose + dendrite(iD).refpos(4))*umperpx_Y_soma;

    dendrite(iD).fov_x_um = (1:Lx)*umperpx_X - dendrite(iD).refpos(3)*umperpx_X ;
    dendrite(iD).fov_y_um = (1:Ly)*umperpx_Y - dendrite(iD).refpos(1)*umperpx_Y ;

    dendrite(iD).fov_x_um = dendrite(iD).fov_x_um + dendrite(iD).soma.x_rel;
    dendrite(iD).fov_y_um = dendrite(iD).fov_y_um + dendrite(iD).soma.y_rel;

    dendrite(iD).X = dendrite(iD).fov_x_um(dendrite(iD).centreMass(:,2));
    dendrite(iD).Y = dendrite(iD).fov_y_um(dendrite(iD).centreMass(:,1));
    
    dendrite(iD).Fitpars(:,1) = -dendrite(iD).Fitpars(:,1) +360;
    
    figure; imagesc(dendrite(iD).fov_x_um,dendrite(iD).fov_y_um, dendrite(iD).meanImg); pause;
end


%% create fov image in common reference

Ly = max(abs(cat(2, dendrite(:).fov_y_um)));
Lx = max(abs(cat(2, dendrite(:).fov_x_um)));

x_um = -Lx:0.2:Lx;
y_um = -Ly:0.2:Ly;

for iD = 1: numel(neuron.db.spine_seq)

    dendrite(iD).img_ref = interp2(dendrite(iD).fov_x_um', dendrite(iD).fov_y_um, dendrite(iD).meanImg, x_um', y_um, 'linear',NaN);

end

all_den_img = nanmax(cat(3, dendrite(:).img_ref),[],3);

figure; imagesc(x_um, y_um, all_den_img);axis image; hold on

spines_x_um = double(cat(2, dendrite(3).X));
spines_y_um = double(cat(2, dendrite(3).Y));
plot(spines_x_um, spines_y_um, 'or');
end