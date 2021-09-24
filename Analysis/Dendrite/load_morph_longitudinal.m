function tree_seq = load_morph_longitudinal(db, doPlot)

% 2020 N Ghani and LF Rossi

if nargin < 2
    doPlot = 0;
end
%% Step 1: load swc reconstruction

morph_path = build_path(db, 'morph_seq');

for iM = 1: numel(morph_path)
    
    [tree_seq{iM},~,~] = load_tree(morph_path{iM},'r'); % [pixels]
    tree_seq{iM} = tree_in_um(tree_seq{iM}, db);
    idx = strfind( morph_path{iM}, 'tracing_cut_');
    if ~isempty(idx)
    tree_seq{iM}.date = morph_path{iM}(idx+12:end-4);
    else
            tree_seq{iM}.date = [];

    end
end


%% Step 3: plot, if requested

if doPlot
    
    nCuts = numel(tree_seq);
    
    switch db.morph.dendrotomy{2}
        case 'para'
            line_c = [1 0 0];
        case 'orth'
            line_c = [0 0.5 1];
            
    end
    figure('Color', 'white'); 
    
    subplot(1, nCuts, 1)
    
    plot_tree_lines(tree_seq{1}, [],[],[],'-3l'); hold on
    lim = max([abs(tree_seq{1}.X); abs(tree_seq{1}.Y)]);
        xlim([-lim lim])
    ylim([-lim lim])
    for iC = 1:nCuts-1
        subplot(1, nCuts, iC +1)
        
        plot_tree_lines(tree_seq{1}, line_c,[],[],'-3l'); hold on
        plot_tree_lines(tree_seq{iC +1}, [],[],[],'-3l');
        lim = max([abs(tree_seq{1}.X); abs(tree_seq{1}.Y)]);
            xlim([-lim lim])
    ylim([-lim lim])
    end
    
    
end
end





