function stitch_den = stitch_dendrite(dendrite)

%% create fov image in common reference

Ly = max(abs(cat(2, dendrite(:).fov_y_um)));
Lx = max(abs(cat(2, dendrite(:).fov_x_um)));

x_um = -Lx:0.2:Lx;
y_um = -Ly:0.2:Ly;

for iD = 1: numel(dendrite)

    
    se = strel('disk', 20);
    this_den =  imtophat(dendrite(iD).meanImg, se);
   
    this_den =  mat2gray(this_den./max(this_den(:)), [0.02, 1]);

    dendrite(iD).img_ref = interp2(dendrite(iD).fov_x_um', dendrite(iD).fov_y_um, this_den, x_um', y_um, 'linear',NaN);

end

stitch_den.img = nanmax(cat(3, dendrite(:).img_ref),[],3);

nan_idx = isnan(stitch_den.img);

stitch_den.img = imadjust(stitch_den.img);

stitch_den.img(nan_idx) = NaN;


stitch_den.x_um = x_um;
stitch_den.y_um = y_um;
figure; imagesc(stitch_den.x_um, stitch_den.y_um, stitch_den.img);
axis image; hold on
formatAxes
colormap(1-gray);

% spines_x_um = double(cat(2, dendrite(:).X));
% spines_y_um = double(cat(2, dendrite(:).Y));
% plot(spines_x_um, spines_y_um, 'or');