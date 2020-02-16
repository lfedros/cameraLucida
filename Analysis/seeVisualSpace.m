% visualize neurons in retinotopy
% 2020 N Ghani and LF Rossi

load('neuronData.mat');
n = length(neuronData);

%% Step 1: make plot with center of neuron (soma) in visual space
for i = 1 : n
    hold on;
    scatter( neuronData(i).retX( neuronData(i).somaCortex(1) ), neuronData(i).retY( neuronData(i).somaCortex(2) ), 300, neuronData(i).colorID, 'filled');
end

xlim([-135 0]);
ylim([-35 35]);
xlabel('Azimuth [degrees]');
ylabel('Elevation [degrees]');
set(gca, 'fontname', 'Te X Gyre Heros'); % due to Linux compatability issue with Helvetica
set(gca, 'linewidth', 1.5);

hmap(1:256,1) = linspace(0,1,256);
hmap(:,[2 3]) = 0.7; % reduce HSV brightness to 70%
huemap = hsv2rgb(hmap);
colormap(huemap);
caxis([-90 90]);
hcb = colorbar; 
str = '$$ \theta $$'; % label colorbar with theta in LaTeX font
title(hcb, str, 'Interpreter', 'latex');
set(hcb, 'linewidth', 1.5);

close all;

%% Step 2: make plot with convex hull of neuron in visual space
figure;
for i = 1 : n
    neuronData(i).AE.X = neuronData(i).AE.X + neuronData(i).retX( neuronData(i).somaCortex(1) );
    neuronData(i).AE.Y = neuronData(i).AE.Y + neuronData(i).retY( neuronData(i).somaCortex(2) ); 
    hold on;
    chull_tree( neuronData(i).AE, [], neuronData(i).colorID);
end
xlim([-135 0]);
ylim([-35 35]);
xlabel('Azimuth [degrees]');
ylabel('Elevation [degrees]');
set(gca, 'fontname', 'Te X Gyre Heros'); % due to Linux compatability issue with Helvetica
set(gca, 'linewidth', 1.5);

hmap(1:256,1) = linspace(0,1,256);
hmap(:,[2 3]) = 0.7; % reduce HSV brightness to 70%
huemap = hsv2rgb(hmap);
colormap(huemap);
caxis([-90 90]);
hcb = colorbar; 
str = '$$ \theta $$'; % label colorbar with theta in LaTeX font
title(hcb, str, 'Interpreter', 'latex');
set(hcb, 'linewidth', 1.5);



    