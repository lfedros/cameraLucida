function [tree_deg] = load_visual_morph(db, morph, prefOri, doPlot)

%if nargin < 2
if nargin <4
doPlot = 0; 
end

if nargin <3 || isempty(prefOri)
prefOri = [];
end
%% Step 1: load swc reconstruction, if needed

if ~isfield(morph, 'X')|| isempty(morph)
    
%     [tree_um,~,~] = load_morph(db,'morph'); % [pixels]
    
    warning('Morph was not provided, reloading...');
tree_deg = [];
return;
else
    tree_um = morph;
end

%% Step 2: scale reconstruction to um and center to the soma
ret_path = build_path(db, 'ret');

try
load(ret_path);
catch
     warning('Retinotopy not found...');
tree_deg = [];
    return;
end

% find soma coordinates
Y_pos = db.retino.somaYX(1); % [px]
X_pos = db.retino.somaYX(2); % [px] in ij coordinates
micronsSomaX = micronsX - micronsX(X_pos); % [um] 
micronsSomaY = -micronsY + micronsY(Y_pos); % [um] convert from ij to xy coordinates

% center retinotopy
soma_retX = retX(Y_pos, X_pos);
soma_retY = retY(Y_pos, X_pos);

retX = retX - soma_retX; % [um]
retY = retY - soma_retY ; % [um]
retY = -retY; % invert elevation map

soma_retY = -soma_retY;
%% Step 5: create visual space plot

% warp dendritic tree
X = tree_um.X; 
Y = tree_um.Y; % in xy framework

% pre-alloc
j = zeros(length(X), 1);
i = zeros(length(X), 1); 
% transform data
for n = 1:length(X)
    [~ , j(n, 1)] = min( abs (micronsSomaX - X(n) ));
    [~ , i(n, 1)] = min( abs (micronsSomaY - Y(n) ));
end

% we re-mapped [j i] as [X Y]
% so we have it in the correct, standardized format

% previous error made: used [j i] and not [i j] in loop below
% correction:  [i j] as [X Y] 

% pre-alloc
A = zeros(length(j),1);
E = zeros(length(j),1);
for n = 1:length(j)
    A(n,1) = retX(i(n), j(n));
    E(n,1) = retY( i(n), j(n));
end

tree_deg = tree_um;
tree_deg.X = A; %- A(1);
tree_deg.Y = E; % - E(1);
tree_deg.D = ones(length(A),1)*0.1;
tree_deg.R = ones(length(A),1)*0.1;
tree_deg.retX = retX;
tree_deg.retY = retY;
tree_deg.micronsSomaX =micronsSomaX;
tree_deg.micronsSomaY =micronsSomaY;
tree_deg.micronsX =micronsX;
tree_deg.micronsY =micronsY;
tree_deg.soma_E = soma_retY;
tree_deg.soma_A = soma_retX;

% tree_deg.dbVis = dbVis;


%% map isoOri in cortex
    
if ~isempty(prefOri)
    
prefOri(prefOri<0) = prefOri(prefOri<0)+180;
% [tree_deg.isoOriX, tree_deg.isoOriY] = cameraLucida.map_oriLine(micronsSomaX, micronsSomaY, retX, retY, prefOri,1);

walk =cameraLucida.walkThetaCortex(retX, retY, prefOri, [Y_pos, X_pos]);
walkOp =cameraLucida.walkThetaCortex(retX, retY, prefOri+180, [Y_pos, X_pos]);

if size(walk, 1)>1
walk = extrapolate_walk(walk);
else
[~, walk] = extrapolate_walk(flip(walkOp,1));
end

if size(walkOp, 1)>1
walkOp = extrapolate_walk(walkOp);
else
[~,walkOp] = extrapolate_walk(flip(walk,1));
end

tree_deg.isoOri_IJ(:,2) = walk(:,2);
tree_deg.isoOri_IJ(:,1) = walk(:,1);
tree_deg.isoOriOp_IJ(:,2) = walkOp(:,2);
tree_deg.isoOriOp_IJ(:,1) = walkOp(:,1);

walk = cat(1,  flip(walk,1), walkOp(2:end,:));

tree_deg.isoOri(:, 1) = interp1(1:numel(micronsSomaX), micronsSomaX, walk(:,2));
tree_deg.isoOri(:, 2) = interp1(1:numel(micronsSomaY), micronsSomaY, walk(:,1));

tree_deg.oriDoubleWedge = thetaWedge(walk, 5, db.retino.somaYX, size(retX));
tree_deg.oriWedge = thetaWedge(tree_deg.isoOri_IJ, 5, db.retino.somaYX, size(retX));
tree_deg.oriOpWedge = thetaWedge(tree_deg.isoOriOp_IJ, 5, db.retino.somaYX, size(retX));


end

%% map vertical isoline in cortex


walk =cameraLucida.walkThetaCortex(retX, retY, -90, [Y_pos, X_pos]);
walkOp =cameraLucida.walkThetaCortex(retX, retY, 90, [Y_pos, X_pos]);

if size(walk, 1)>1
walk = extrapolate_walk(walk);
else
[~, walk] = extrapolate_walk(flip(walkOp,1));
end

if size(walkOp, 1)>1
walkOp = extrapolate_walk(walkOp);
else
[~,walkOp] = extrapolate_walk(flip(walk,1));
end

tree_deg.vertical_IJ(:,2) = walk(:,2);
tree_deg.vertical_IJ(:,1) = walk(:,1);
tree_deg.verticalOp_IJ(:,2) = walkOp(:,2);
tree_deg.verticalOp_IJ(:,1) = walkOp(:,1);

walk = cat(1,  flip(walk,1), walkOp(2:end,:));

tree_deg.isoVertical(:, 1) = interp1(1:numel(micronsSomaX), micronsSomaX, walk(:,2));
tree_deg.isoVertical(:, 2) = interp1(1:numel(micronsSomaY), micronsSomaY, walk(:,1));

tree_deg.verticalDoubleWedge = thetaWedge(walk, 5, db.retino.somaYX, size(retX));
tree_deg.verticalWedge = thetaWedge(tree_deg.vertical_IJ, 5, db.retino.somaYX, size(retX));
tree_deg.verticalOpWedge = thetaWedge(tree_deg.verticalOp_IJ, 5, db.retino.somaYX, size(retX));


%% map horizontal isoline in cortex


walk =cameraLucida.walkThetaCortex(retX, retY, -180, [Y_pos, X_pos]);
walkOp =cameraLucida.walkThetaCortex(retX, retY, 0, [Y_pos, X_pos]);

if size(walk, 1)>1
walk = extrapolate_walk(walk);
else
[~, walk] = extrapolate_walk(flip(walkOp,1));
end

if size(walkOp, 1)>1
walkOp = extrapolate_walk(walkOp);
else
[~,walkOp] = extrapolate_walk(flip(walk,1));
end

tree_deg.horiz_IJ(:,2) = walk(:,2);
tree_deg.horiz_IJ(:,1) = walk(:,1);
tree_deg.horizOp_IJ(:,2) = walkOp(:,2);
tree_deg.horizOp_IJ(:,1) = walkOp(:,1);

walk = cat(1,  flip(walk,1), walkOp(2:end,:));

tree_deg.isoHoriz(:, 1) = interp1(1:numel(micronsSomaX), micronsSomaX, walk(:,2));
tree_deg.isoHoriz(:, 2) = interp1(1:numel(micronsSomaY), micronsSomaY, walk(:,1));

tree_deg.horizDoubleWedge = thetaWedge(walk, 5, db.retino.somaYX, size(retX));
tree_deg.horizWedge = thetaWedge(tree_deg.horiz_IJ, 5, db.retino.somaYX, size(retX));
tree_deg.horizOpWedge = thetaWedge(tree_deg.horizOp_IJ, 5, db.retino.somaYX, size(retX));



%% Step 4: plot, if requested


if doPlot

    
% plot countour lines
figure;
elLines = - 35:5:35;
azLines = - 35:5:35;
subplot(1,2,1);
contour(micronsSomaX, micronsSomaY , retX ,azLines, 'r','LineWidth',1);
hold on;
contour(micronsSomaX, micronsSomaY , retY, elLines, 'Color', [0.3 0.3 0.3],'LineWidth',1);
oriColor = hsv(180);
oriColor = oriColor(round(prefOri), :);
plot(tree_deg.isoOri(:,1), tree_deg.isoOri(:,2), 'Color', oriColor);

% plot dendritic tree 
hold on;
plot_tree_lines(tree_um);


xlabel('ML [um] ');
ylabel('RC [um] '); 
set(gca, 'fontsize', 12); 
axis image

% add title
title('Cortical Space');

subplot(1,2,2);

% plot contour lines
hold on;

[retGridX, retGridY] = meshgrid(-35:35, makeVec(-35:35));
contour(-35:35, -35:35, retGridX, azLines, 'Color', 'r'); hold on
contour(-35:35, -35:35, retGridY, elLines, 'Color', [0.3 0.3 0.3]); hold on

% plot dendritic tree
plot_tree_lines(tree_deg);

xlabel('Azimuth [deg] ');
ylabel('Elevation [deg] ');
set(gca, 'fontsize', 12); 
axis([-15 15 -15 15]);

% add title
title('Visual Space');
set(gca, 'fontname', 'Te X Gyre Heros');  % due to Linux compatability issue with Helvetica font
end
% %% Step 7: save final image (cortical space v. visual space)
% 
% img_1 = strcat( folder_name , '_retino');
% print(img_1, '-dtiff');

% %% Step 8: save outputs [dendritic trees as structs]
% 
% XY_tree = strcat(folder_name, '_XY');
% AE_tree = strcat(folder_name, '_AE');
% save( XY_tree, 'tree' );
% save( AE_tree, 'tree1' ); 

end





