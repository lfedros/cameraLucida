function tree = load_morph(db, type, doPlot)

% 2020 N Ghani and LF Rossi

if nargin < 3
doPlot = 0; 
end
%% Step 1: load swc reconstruction

morph_path = build_path(db, type);

try
[tree,~,~] = load_tree(morph_path,'r'); % [pixels]
catch
    tree = [];
    return;
end
%% Step 2: scale reconstruction to um and center to the soma

tree = tree_in_um(tree, db);

%% Step 3: plot, if requested

if doPlot
    figure('Color', 'w')
    hold on;
    plot_tree_lines(tree, [],[],[],'-3l');
    xlabel('ML[um] ');
    ylabel('RC[um] ');
    formatAxes
end


end





