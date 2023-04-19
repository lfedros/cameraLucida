function plot_forest(trees, plot_type, res)

if nargin <2
    plot_type= 'subP';
end

if nargin <3
   res = 20;
end


nSubP = numel(trees);

nCols = 10;
nRows = ceil(nSubP/nCols);


figure('Color', 'w', 'Position', [80 131 1285 666])

maxR = 0;

for iP = 1:nSubP
    
    tree(iP) = resample_tree(trees(iP).morph(1), res);
    basal_tree(iP) = resample_tree(trees(iP).morph_basal(1), res);
    apical_tree(iP) = resample_tree(trees(iP).morph_apical(1), res);

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
            plot_tree_lines_LFR(tree(sort_idx(iP)), [0.5 0 0],[],[],'-3l');
            plot_tree_lines_LFR(tree(sort_idx(iP)), [0 0 0],[],[],'-3l');

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
            
            col = mod(iP,nCols);
            if col ==0
                col = nCols; 
            end
            row = ceil(iP/nCols);
            
            tree(sort_idx(iP)).Z = tree(sort_idx(iP)).Z + row*maxZ;
            tree(sort_idx(iP)).X = tree(sort_idx(iP)).X + (col-1)*2*maxR;
            
            basal_tree(sort_idx(iP)).Z = basal_tree(sort_idx(iP)).Z + row*maxZ;
            basal_tree(sort_idx(iP)).X = basal_tree(sort_idx(iP)).X + (col-1)*2*maxR;
            
            apical_tree(sort_idx(iP)).Z = apical_tree(sort_idx(iP)).Z + row*maxZ;
            apical_tree(sort_idx(iP)).X = apical_tree(sort_idx(iP)).X + (col-1)*2*maxR;
    
            
            hold on;
%             plot_tree_lines_LFR(tree(sort_idx(iP)), [0.5 0 0],[],[],'-3l');
            plot_tree_lines_LFR(basal_tree(sort_idx(iP)), [0 0 0],[],[],'-3l');
            plot_tree_lines_LFR(apical_tree(sort_idx(iP)), [0 0.2 0.7],[],[],'-3l');

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

xlim([-maxR, maxR*2*(nCols+1)])
ylim([-maxR, maxR])
zlim([0, maxZ*(nRows+1)])


end