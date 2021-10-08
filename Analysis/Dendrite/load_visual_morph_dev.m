function [tree_deg] = load_visual_morph_dev(neuron, prefOri, doPlot, doSave)

if nargin <4
doSave = 0; 
end

if nargin <3
doPlot = 0; 
end

if nargin <2 || isempty(prefOri)
prefOri = [];
end

db = neuron.db;
morph = neuron.morph;
tuning = neuron.tuning;

n_trees = numel(morph); 

[ret_file, ret_path] = build_path(db, 'ret');


%% if the data were already processed, load them

for iSeq = 1:n_trees
    load_saved(iSeq) = exist(fullfile(ret_path, db.ret_seq{iSeq}), 'file');
end

if ~doSave && prod(load_saved)~=0
    for iSeq = 1:n_trees
        tree_deg(iSeq) = load(fullfile(ret_path,db.ret_seq{iSeq}));
    end
    return;
end

%% Step 2: load the retinotopic mapping, otherwise return empty

try
load(fullfile(ret_path, ret_file));
catch
     warning('Retinotopy not found...');
     for iSeq = 1:n_trees
         tree_deg(iSeq) = [];
     end
    return;
end

%% Step 3: align retinotopy to the somatic location

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

isoOri_IJ(:,2) = walk(:,2);
isoOri_IJ(:,1) = walk(:,1);
isoOriOp_IJ(:,2) = walkOp(:,2);
isoOriOp_IJ(:,1) = walkOp(:,1);

walk = cat(1,  flip(walk,1), walkOp(2:end,:));

isoOri(:, 1) = interp1(1:numel(micronsSomaX), micronsSomaX, walk(:,2));
isoOri(:, 2) = interp1(1:numel(micronsSomaY), micronsSomaY, walk(:,1));

oriDoubleWedge = thetaWedge(walk, 5, db.retino.somaYX, size(retX));
oriWedge = thetaWedge(isoOri_IJ, 5, db.retino.somaYX, size(retX));
oriOpWedge = thetaWedge(isoOriOp_IJ, 5, db.retino.somaYX, size(retX));


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

vertical_IJ(:,2) = walk(:,2);
vertical_IJ(:,1) = walk(:,1);
verticalOp_IJ(:,2) = walkOp(:,2);
verticalOp_IJ(:,1) = walkOp(:,1);

walk = cat(1,  flip(walk,1), walkOp(2:end,:));

isoVertical(:, 1) = interp1(1:numel(micronsSomaX), micronsSomaX, walk(:,2));
isoVertical(:, 2) = interp1(1:numel(micronsSomaY), micronsSomaY, walk(:,1));

verticalDoubleWedge = thetaWedge(walk, 5, db.retino.somaYX, size(retX));
verticalWedge = thetaWedge(vertical_IJ, 5, db.retino.somaYX, size(retX));
verticalOpWedge = thetaWedge(verticalOp_IJ, 5, db.retino.somaYX, size(retX));


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

horiz_IJ(:,2) = walk(:,2);
horiz_IJ(:,1) = walk(:,1);
horizOp_IJ(:,2) = walkOp(:,2);
horizOp_IJ(:,1) = walkOp(:,1);

walk = cat(1,  flip(walk,1), walkOp(2:end,:));

isoHoriz(:, 1) = interp1(1:numel(micronsSomaX), micronsSomaX, walk(:,2));
isoHoriz(:, 2) = interp1(1:numel(micronsSomaY), micronsSomaY, walk(:,1));

horizDoubleWedge = thetaWedge(walk, 5, db.retino.somaYX, size(retX));
horizWedge = thetaWedge(horiz_IJ, 5, db.retino.somaYX, size(retX));
horizOpWedge = thetaWedge(horizOp_IJ, 5, db.retino.somaYX, size(retX));


%% Step 5: convert cortical trees to visual trees
for iSeq = 1:n_trees
% warp dendritic tree
X = morph(iSeq).X; 
Y = morph(iSeq).Y; % in xy framework

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

tree_deg(iSeq).dA = morph(iSeq).dA;
tree_deg(iSeq).X = A; %- A(1);
tree_deg(iSeq).Y = E; % - E(1);
tree_deg(iSeq).D = ones(length(A),1)*0.1;
tree_deg(iSeq).R = ones(length(A),1)*0.1;
tree_deg(iSeq).rnames = morph(iSeq).rnames;
tree_deg(iSeq).names = db.ret_seq{iSeq};
tree_deg(iSeq).retX = retX;
tree_deg(iSeq).retY = retY;
tree_deg(iSeq).micronsSomaX =micronsSomaX;
tree_deg(iSeq).micronsSomaY =micronsSomaY;
tree_deg(iSeq).micronsX =micronsX;
tree_deg(iSeq).micronsY =micronsY;
tree_deg(iSeq).soma_E = soma_retY;
tree_deg(iSeq).soma_A = soma_retX;

tree_deg(iSeq).isoOri_IJ = isoOri_IJ;
tree_deg(iSeq).isoOriOp_IJ = isoOriOp_IJ;
tree_deg(iSeq).isoOri= isoOri;

tree_deg(iSeq).oriDoubleWedge = oriDoubleWedge;
tree_deg(iSeq).oriWedge = oriWedge;
tree_deg(iSeq).oriOpWedge = oriOpWedge;

tree_deg(iSeq).vertical_IJ = vertical_IJ;
tree_deg(iSeq).verticalOp_IJ = verticalOp_IJ;
tree_deg(iSeq).isoVertical =isoVertical;

tree_deg(iSeq).verticalDoubleWedge = verticalDoubleWedge;
tree_deg(iSeq).verticalWedge = verticalWedge;
tree_deg(iSeq).verticalOpWedge = verticalOpWedge;

tree_deg(iSeq).horiz_IJ = horiz_IJ;
tree_deg(iSeq).horizOp_IJ = horizOp_IJ;
tree_deg(iSeq).isoHoriz = isoHoriz;

tree_deg(iSeq).horizDoubleWedge = horizDoubleWedge;
tree_deg(iSeq).horizWedge = horizWedge;
tree_deg(iSeq).horizOpWedge = horizOpWedge;

end
% tree_deg.dbVis = dbVis;

%% Step 4: save if requested

if doSave
    
    for iSeq = 1:n_trees
        this_tree = tree_deg(iSeq);
        save(fullfile(ret_path, db.ret_seq{iSeq}), '-struct', 'this_tree');
    end
    
end


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
plot_tree_lines(morph);


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





