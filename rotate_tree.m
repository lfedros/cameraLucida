function rot_tree = rotate_tree(tree, theta)
if isempty(tree)
rot_tree = [];
    return;
end

rot_tree = tree;

% rotate coordinates clockwise by theta
R = [cosd(theta) sind(theta); -sind(theta) cosd(theta)];
coords = [tree.X, tree.Y];
rot_coords = R*coords';

rot_tree.X = rot_coords(1,:)';
rot_tree.Y = rot_coords(2,:)';

rot_tree.stats = tree_angular_stats(rot_tree);

end

%%plot_Density2D(coords(:,1), coords(:,2), 1, 0.1, [20 20], false, 1);
%%plot_Density2D(rot_coords(1,:)', rot_coords(2,:)', 1, 0.1, [20 20], false, 1);