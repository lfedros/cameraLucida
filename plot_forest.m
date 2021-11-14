function plot_forest(trees, plot_type)

if nargin <2
    plot_type= 'subP';
end

nSubP = numel(trees);

nCols = 10;
nRows = ceil(nSubP/nCols);


figure('Color', 'w')

maxR = 0;

for iP = 1:nSubP
    
    tree(iP) = resample_tree(trees(iP).morph(1), 10);
    
    maxZ(iP) = max(tree(iP).Z);
    maxR = max(maxR, max(abs([tree(iP).X; tree(iP).Y])));
    
end

[~, sort_idx] =  sort(maxZ, 'ascend');
maxZ = max(maxZ);

switch plot_type
    
    case 'subP'
        
        for iP = 1:nSubP
            
            
            subplot(nRows, nCols, iP)
            hold on;
            plot_tree_lines(tree(sort_idx(iP)), [],[],[],'-3l');
            xlabel('ML[um] ');
            ylabel('RC[um] ');
            formatAxes
            set(gca, 'Visible', 'off');
            xlim([-maxR, maxR])
            ylim([-maxR, maxR])
            zlim([0, maxZ])
            view(0,180);
        end
        
    case 'canvas'
        
        maxZ = maxZ+50;
        maxR = maxR+50;
        
        for iP = 1:nSubP
            
            col = mod(iP,10);
            row = floor(iP/10);
            
            tree(sort_idx(iP)).Z = tree(sort_idx(iP)).Z + row*maxZ;
            tree(sort_idx(iP)).X = tree(sort_idx(iP)).X + col*maxR;
            
            hold on;
            plot_tree_lines(tree(sort_idx(iP)), [],[],[],'-3l');
            xlabel('ML[um] ');
            ylabel('RC[um] ');
            formatAxes
            set(gca, 'Visible', 'off');
            %         xlim([-maxR, maxR])
            %         ylim([-maxR, maxR])
            %         zlim([0, maxZ])
            view(0,180);
            
        end
end

xlim([-maxR, maxR*nCols])
ylim([-maxR, maxR])
zlim([0, maxZ*nRows])


end