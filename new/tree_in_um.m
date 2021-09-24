function tree = tree_in_um(tree, db)
%% scale reconstruction to um and center to the soma

[fov_x, fov_y] = ppbox.zoom2fov(db.morph.zoom, [], db.morph.expRef{2}); %hardcoded 512*512, add extraction of pxsize of recording

% center dendritic tree
tree.X = tree.X -tree.X(1); % [px]
tree.Y = -tree.Y +tree.Y(1); % [px] convert the y from ij to xy
tree.Y = tree.Y* ( fov_y/(512*db.morph.upSamp)); % [um]
tree.X = tree.X* ( fov_x/(512*db.morph.upSamp)); % [um]
tree.Z = tree.Z* db.morph.zStep; 

Rt1 = [1, 0, 0; 0, cosd(db.morph.tilt(1)), -sind(db.morph.tilt(1)); 0, sind(db.morph.tilt(1)), cosd(db.morph.tilt(1))];
Rt2 = [cosd(db.morph.tilt(2)), 0, sind(db.morph.tilt(2));0 ,1, 0 ;-sind(db.morph.tilt(2)), 0, cosd(db.morph.tilt(2))];

% coord = [tree.X, tree.Y, tree.Z];
% coord= (Rt1*coord');
% tree.X = coord(1,:)';
% tree.Y = coord(2,:)';
% tree.Z = coord(3,:)';

tree = resample_tree( tree, 1); % resample with uniform spacing


end