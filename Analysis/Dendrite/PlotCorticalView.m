%% plot visual space theta values on cortical neuron projection

%%

function [] = PlotCorticalView( tree, thetaMap_V, fname, analysis_type )

switch analysis_type
    case 'seg'
        img_1 = strcat(fname, '_seg_X');
    case 'box'
        img_1 = strcat(fname, '_box_X');
end

% resample tree for 5 micron spacing
% comment out this section for soma box plots
% [rtree, ~] = sort_tree( tree ,'-LO');

% reduce hsv brightness
hmap(1:256,1) = linspace(0,1,256);
hmap(:,[2 3]) = 0.7; % brightness
huemap = hsv2rgb(hmap);

figure; 
% in soma box plots, tree is used NOT rtree
HP = plot_tree ( tree , thetaMap_V , [], [], [], []);
set (HP, 'edgecolor','none');
colormap(huemap);
caxis([-90 90])
% colorbar;
title        ('Theta Colormap');
xlabel       ('x [\mum]');
ylabel       ('y [\mum]');
view         (2);
grid         on;
axis         image;
% hcb = colorbar;
% str = '$$ \theta $$';
% title(hcb, str, 'Interpreter', 'latex');

% print plots
print(img_1, '-dtiff');
axis_cleaner;
title('');
img_2 = strcat(img_1, '_c');
print(img_2, '-dtiff');
close all;

end


