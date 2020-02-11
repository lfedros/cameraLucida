function [] = PlotCorticalView( tree, thetaMap_V, fname, analysis_type )

% PLOTCORTICALVIEW 	plots visual space data in cortical space view
%  
%		INPUTS:
%       [1] tree            = neuron reconstruction             [struct]
%       [2] thetaMap_V      = theta distribution                [struct]
%       [3] fname           = folder name                       [string]
%       [3] analysis_type   = 'seg' OR 'box'                    [string]
%               'seg' = segment-by-segment (dendrite branches)
%               'box' = box-by-box (resampling in microns) 
%
%       OUTPUTS:
%       [1] image of cortical neuron with visual space data     [.tif]
%       
%       DEPENDENCIES:
%       [1] treestoolbox    = Hermann Cuntz [2011]
%
%       REFERENCES:
%       [1] Cuntz H, Forstner F, Borst A, Häusser M (2010). One rule to grow them all: A general theory of neuronal branching and its practical application. PLoS Comput Biol 6(8): e1000877.
%
% 2020 N Ghani 

switch analysis_type
    case 'seg'
        img_1 = strcat(fname, '_seg_X');
    case 'box'
        img_1 = strcat(fname, '_box_X');
end

%% Step 1: create colormap 
hmap(1:256,1) = linspace(0,1,256);
hmap(:,[2 3]) = 0.7; % reduce HSV brightness to 70%
huemap = hsv2rgb(hmap);

%% Step 2: plot dendritic tree
figure; 
HP = plot_tree ( tree , thetaMap_V , [], [], [], []);
set (HP, 'edgecolor','none');
colormap(huemap);
caxis([-90 90])
title        ('Theta Colormap'); 
xlabel       ('x [\mum]');
ylabel       ('y [\mum]');
view         (2);
grid         on;
axis         image;
hcb = colorbar; 
str = '$$ \theta $$'; % label colorbar with theta in LaTeX font
title(hcb, str, 'Interpreter', 'latex');

%% Step 3: save plots
print(img_1, '-dtiff');
axis_cleaner;
title('');
img_2 = strcat(img_1, '_c'); % '_c' where c = cortical space
print(img_2, '-dtiff');
% close all;

end


