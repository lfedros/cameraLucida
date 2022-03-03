function [tree, basal_tree, apical_tree] = load_morph(db, target, doPlot, doSave, reLoad)


if nargin < 3
    doPlot = 0;
end

if nargin < 4
    doSave = 0;
end


if nargin < 5
    reLoad = 0;
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
    morph_path_basal = [morph_path(1:end-4), '_basal.swc'];
    morph_path_apical = [morph_path(1:end-4), '_apical.swc'];

    pxFlag = 0;
    if exist(morph_path, 'file') && exist(morph_path_basal, 'file') && exist(morph_path_apical, 'file') &&  ~reLoad
        [tree(iTree),~,~] = load_tree(morph_path,'r');
        [basal_tree(iTree),~,~] = load_tree(morph_path_basal,'r');
        [apical_tree(iTree),~,~] = load_tree(morph_path_apical,'r');

    else
        try % if not, try loading the neutube tree in pixels
            morph_path_neut = [morph_path(1:end-12), '.swc'];
            [tree(iTree),~,~] = load_tree(morph_path_neut,'r');
            if ~isempty(db.morph.apicalNode)
                
               coords = [tree(iTree).X(:), ...
                    tree(iTree).Y(:),...
                    tree(iTree).Z(:)];
                
                for iA = 1:numel(db.morph.apicalNode)
                  
                     node = [tree(1).X(db.morph.apicalNode(iA)), ...
                    tree(1).Y(db.morph.apicalNode(iA)),...
                    tree(1).Z(db.morph.apicalNode(iA))];
                
                dist = bsxfun(@minus, coords, node);
                dist = sqrt(sum(dist.^2,2));
                
                [~, node_idx] = min(dist);
                    
                [sub(:,iA), ~] = sub_tree(tree(iTree), node_idx);
                    
                end
                sub = sum(sub,2)>0;
                basal_tree(iTree) = delete_tree(tree(iTree), find(sub));
                apical_tree(iTree) = delete_tree(tree(iTree), find(~sub));
                                
                clear sub;
            else
                basal_tree(iTree) = struct;
                apical_tree(iTree) = struct;

            end
            
            pxFlag = 1;
            doSave = 1;
        catch
            tree = [];
            basal_tree = [];
            apical_tree = [];

            return;
        end
    end
   
    
end


%% Step 2: scale reconstruction to um and center to the soma

for iTree = 1:n_trees
    if pxFlag
        tree(iTree) = tree_in_um(tree(iTree), db);
        basal_tree(iTree) = tree_in_um(basal_tree(iTree), db);
        apical_tree(iTree) = tree_in_um(apical_tree(iTree), db);

        % tree.D(:) = 5; % override Neutube diameter which maybe meaningless
        % tree.D(:) = 15;
    end
end

%% Step 3: save if requested
for iTree = 1:n_trees
    if doSave
        morph_path = fullfile(morph_folder, target{iTree}); % path to tree in microns
        morph_path_basal = [morph_path(1:end-4), '_basal.swc'];
        morph_path_apical = [morph_path(1:end-4), '_apical.swc'];
        
         tree(iTree).type = 'all';
    basal_tree(iTree).type = 'basal';
    apical_tree(iTree).type = 'apical';
        
        swc_tree(tree(iTree), morph_path);
        swc_tree(basal_tree(iTree), morph_path_basal);
        swc_tree(apical_tree(iTree), morph_path_apical);

    end
end
%% Step 4: plot, if requested

if doPlot
    figure('Color', 'w');
    for iTree = 1:n_trees
        xy = subplot(2, n_trees, iTree);
        hold on;
        all = resample_tree(tree(iTree),20);
        bsl = resample_tree(basal_tree(iTree),20);
        plot_tree_lines_LFR(all, [1 0 0],[],[],'-3l');
        plot_tree_lines_LFR(bsl, [0 0 0],[],[],'-3l');
        
        xlabel('ML[um] ');
        ylabel('RC[um] ');
        formatAxes
        
        
        xz =        subplot(2, n_trees, n_trees+ iTree);
        hold on;
        plot_tree_lines_LFR(all, [1 0 0],[],[],'-3l');
        plot_tree_lines_LFR(bsl, [0 0 0],[],[],'-3l');
        
        view(0,180)
        xlabel('ML[um] ');
        ylabel('RC[um] ');
        formatAxes
        linkaxes([xy, xz], 'x');
        
    end
end



end





