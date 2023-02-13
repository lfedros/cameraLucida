function plot_soma_responses(neuron, rel_flag)

if nargin < 2
    rel_flag = 1;
end

h = figureLFR;
set(h,'PaperOrientation','landscape');

nCols = 12;
nRows = 1;
    
    db = neuron(1).db;
   
    tuning = neuron.soma;
    
    
    
    hold on;
    line_c = [0 0 0];
    
    
    %% plot stimulus responses
    
    yval(1) = min([tuning.aveResp(:); tuning.aveResp(:)]);
    yval(2) = max([tuning.aveResp(:); tuning.aveResp(:)]);
    
    [~, peak_ori] = max(tuning.avePeak(1:12)) ;
    stim_vals = 1:12;
    stim_vals = circshift(stim_vals, 7-peak_ori);
    d_dir_vals = -180:30:150;
    for iStim = 1:12
        
        subplot(1, nCols, iStim)
        
        plot_stim_response(tuning, stim_vals(iStim),  line_c, yval);
             
            xlabel(sprintf('%d', d_dir_vals(iStim)));
            set(get(gca,'XLabel'),'Visible','on')
            set (gca, 'Box', 'off', 'TickDir', 'out', 'TickLength', [0.015 0.015], 'Fontsize', 8)
    if iStim ==6
        title('(\\Delta pref dir)')
    end
    end
    %% plot direction tuning
    
h = figureLFR;
set(h,'PaperOrientation','landscape');   
subplot(1, 2, 1)
    
    yval(1) = min(tuning.avePeak(:));
    yval(2) = max(tuning.avePeak(:));
    
    plot_dir_tuning(tuning,  line_c, yval);
    
        
        xlabel('Direction')
    ylabel('Norm resp')
        set (gca, 'Box', 'off', 'TickDir', 'out', 'TickLength', [0.015 0.015], 'Fontsize', 8)

    % title(sprintf('%d', round(neuron.tuning.prefDir)));
    
    %% plot orientation tuning
    
    subplot(1, 2, 2)
    
    yval(1) = min(tuning.aveOriPeak(:));
    
    yval(2) = max(tuning.aveOriPeak(:));
    
    plot_ori_tuning(tuning,  line_c, yval);
    
    
  
        xlabel('Orientation')
    
    ylabel('Norm resp')
    % title(sprintf('%d', round(neuron.tuning.prefOri)));
    formatAxes
        set (gca, 'Box', 'off', 'TickDir', 'out', 'TickLength', [0.015 0.015], 'Fontsize', 8)

    

% saveTo = fullfile(db.data_repo, 'Results');
% 
% if ~exist(saveTo, 'dir')
%     mkdir saveTo
% end
% 
%     
    
    %     print(fullfile(saveTo,[db.animal, '_', num2str(db.neuron_id), '_dendrotomy']) , '-painters', '-dpdf', '-fillpage');
%     print(fullfile(saveTo,[db.animal, '_', num2str(db.neuron_id), '_long_resp']), '-painters', '-dpdf','-fillpage');
    
    






%%



% toPlot = numel(sort_cut);
% figure('color', 'w', 'Position', [238 112 1621 866]);
% for iPl = 1:toPlot
%
%     iDb = sort_cut(iPl);
%
%     if oricut(iDb) == 1
%         color = [1 0 0];
%     else
%         color = [0 0.5 1];
%
%     end
%     for iStim = 1: nStim
%
%         subplot(toPlot, nStim+5 , (iPl-1)*(nStim+5) + iStim)
%         shadePlot(tune(iDb).time, tune(iDb).aveResp(iStim,:), tune(iDb).seResp(iStim,:), [0 0 0]); hold on
%         shadePlot(tune(iDb).time, tune_abl(iDb).aveResp(iStim,:), tune_abl(iDb).seResp(iStim,:), color); hold on
%
%         xlim([min(tune(iDb).time),max(tune(iDb).time)])
%         ylim([min(tune(iDb).aveResp(:)), max(max(tune(iDb).aveResp(:)),2)])
%         %         ylim([-0.5 5])
%         set(gca, 'Xtick', [], 'YTick', [],'visible', 'off')
%         formatAxes
%     end
%     hold on
%     plot([-1, -1], [1, 2] , 'k')
%
%     subplot(toPlot, nStim+5, (iPl-1)*(nStim+5) + [nStim+1: nStim+3])
%
%     errorbar(0:30:390, [tune(iDb).avePeak(1:12), tune(iDb).avePeak([1, 13])], ...
%         [tune(iDb).sePeak(1:12), tune(iDb).sePeak([1, 13])], 'ok'); hold on
%     plot(tune(iDb).fit_pt, tune(iDb).fit_vm, '-k', 'LineWidth', 2)
%
%     errorbar(0:30:390, [tune_abl(iDb).avePeak(1:12), tune_abl(iDb).avePeak([1, 13])], ...
%         [tune_abl(iDb).sePeak(1:12), tune_abl(iDb).sePeak([1, 13])], 'o', 'Color', color); hold on
%     plot(tune(iDb).fit_pt, tune_abl(iDb).fit_vm, '-','Color', color,  'LineWidth', 2)
%
%     formatAxes
%     set(gca, 'YColor', 'none','YTick', [], 'XTick', [0:90:360, 390], 'XTickLabel', {0:90:360, 'Bk'});
%     xlim([-10 , 400])
%     ylim([min(tune(iDb).avePeak) - mean(tune(iDb).sePeak), max(tune(iDb).avePeak) + max(tune(iDb).sePeak)])
%
%
%     subplot(toPlot, nStim+5, (iPl-1)*(nStim+5) + [nStim+4: nStim+5])
%
%     errorbar(0:30:210, [tune(iDb).aveOriPeak([1:6, 1]); tune(iDb).avePeak([13])], ...
%         [tune(iDb).seOriPeak([1:6, 1]); tune(iDb).sePeak([13])], 'ok'); hold on
%     plot(tune(iDb).ori_fit_pt, tune(iDb).ori_fit_vm, '-k', 'LineWidth', 2)
%
%     errorbar(0:30:210, [tune_abl(iDb).aveOriPeak([1:6, 1]); tune_abl(iDb).avePeak([13])], ...
%         [tune_abl(iDb).seOriPeak([1:6, 1]); tune_abl(iDb).sePeak([13])], 'o', 'Color', color); hold on
%     plot(tune(iDb).ori_fit_pt, tune_abl(iDb).ori_fit_vm, '-','Color', color,  'LineWidth', 2)
%
%     formatAxes
%     set(gca, 'YColor', 'none','YTick', [], 'XTick', [0:90:180, 210], 'XTickLabel', {0:90:180, 'Bk'});
%     xlim([-10 , 220])
%     ylim([min(tune(iDb).avePeak) - mean(tune(iDb).sePeak), max(tune(iDb).avePeak) + max(tune(iDb).sePeak)])
%
% end
%


end