function tree = load_morph(db, target, doPlot, doSave)


if nargin < 3
    doPlot = 0;
end

if nargin < 4
    doSave = 0;
end
%% Step 1: load swc reconstruction

[~, morph_folder] = build_path(db);

if iscell(target)
    n_trees = numel(target);
else
    n_trees = 1;
    target = {target};
end

% tree = struct('dA', 'X', 'Y', 'Z', 'D', 'R', 'rnames', 'name');

for iTree = 1:n_trees
    
    morph_path = fullfile(morph_folder, target{iTree}); % path to tree in microns
    
    pxFlag = 0;
    if exist(morph_path, 'file')
        [tree(iTree),~,~] = load_tree(morph_path,'r'); % if not, try loading the neutube tree in pixels

    else
        try
            morph_path_neut = [morph_path(1:end-12), '.swc'];
            [tree(iTree),~,~] = load_tree(morph_path_neut,'r'); % if not, try loading the neutube tree in pixels
            pxFlag = 1;
            doSave = 1;
        catch
            tree = [];
            return;
        end
    end
end


%% Step 2: scale reconstruction to um and center to the soma

for iTree = 1:n_trees
    if pxFlag
        tree(iTree) = tree_in_um(tree(iTree), db);
        % tree.D(:) = 5; % override Neutube diameter which maybe meaningless
        % tree.D(:) = 15;
    end
end

%% Step 3: save if requested
for iTree = 1:n_trees
    if doSave
        morph_path = fullfile(morph_folder, target{iTree}); % path to tree in microns
        swc_tree(tree(iTree), morph_path);
    end
end
%% Step 4: plot, if requested

if doPlot
    figure('Color', 'w')
    hold on;
    plot_tree_lines(tree, [],[],[],'-3l');
    xlabel('ML[um] ');
    ylabel('RC[um] ');
    formatAxes
end



end





