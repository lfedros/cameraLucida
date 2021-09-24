function plot_tuning(tune, c)

if nargin < 2
    c = [0 0 0];
end

figure('color', 'w', 'Position', [238 112 1621 866]);

nStim = numel(tune(1).dirs);

toPlot = numel(tune);

for iPl = 1:toPlot
    
 
    for iStim = 1: nStim
        
        subplot(toPlot, nStim+5 , (iPl-1)*(nStim+5) + iStim)
        shadePlot(tune(iPl).time, tune(iPl).aveResp(iStim,:), tune(iPl).seResp(iStim,:), [0 0 0]); hold on
%         shadePlot(tune(iPl).time, tune_abl(iPl).aveResp(iStim,:), tune_abl(iPl).seResp(iStim,:), color); hold on
        
        xlim([min(tune(iPl).time),max(tune(iPl).time)])
        ylim([min(tune(iPl).aveResp(:)), max(max(tune(iPl).aveResp(:)),2)])
        %         ylim([-0.5 5])
        set(gca, 'Xtick', [], 'YTick', [],'visible', 'off')
        formatAxes
    end
    hold on
    plot([-1, -1], [1, 2] , 'k')
    
    subplot(toPlot, nStim+5, (iPl-1)*(nStim+5) + [nStim+1: nStim+3])
    
    errorbar(0:30:390, tune(iPl).avePeak([1:12,1, 13]), ...
        tune(iPl).sePeak([1:12,1, 13]), 'ok'); hold on   
    plot(tune(iPl).fit_pt, tune(iPl).fit_vm, 'Color', c, 'LineWidth', 2)
    
%     errorbar(0:30:390, [tune_abl(iPl).avePeak(1:12), tune_abl(iPl).avePeak([1, 13])], ...
%         [tune_abl(iPl).sePeak(1:12), tune_abl(iPl).sePeak([1, 13])], 'o', 'Color', color); hold on
%     plot(tune(iPl).fit_pt, tune_abl(iPl).fit_vm, '-','Color', color,  'LineWidth', 2)
    
    formatAxes
    set(gca, 'YColor', 'none','YTick', [], 'XTick', [0:90:360, 390], 'XTickLabel', {0:90:360, 'Bk'});
    xlim([-10 , 400])
    ylim([min(tune(iPl).avePeak) - mean(tune(iPl).sePeak), max(tune(iPl).avePeak) + max(tune(iPl).sePeak)])
    
    
    subplot(toPlot, nStim+5, (iPl-1)*(nStim+5) + [nStim+4: nStim+5])
    
    errorbar(-90:30:120, [tune(iPl).aveOriPeak([1:6, 1]); tune(iPl).avePeak([13])], ...
        [tune(iPl).seOriPeak([1:6, 1]); tune(iPl).sePeak([13])], 'ok'); hold on   
    plot(tune(iPl).ori_fit_pt, tune(iPl).ori_fit_vm, 'Color', c, 'LineWidth', 2)
    
%     errorbar(0:30:210, [tune_abl(iPl).aveOriPeak([1:6, 1]); tune_abl(iPl).avePeak([13])], ...
%         [tune_abl(iPl).seOriPeak([1:6, 1]); tune_abl(iPl).sePeak([13])], 'o', 'Color', color); hold on
%     plot(tune(iPl).ori_fit_pt, tune_abl(iPl).ori_fit_vm, '-','Color', color,  'LineWidth', 2)
%     
    formatAxes
    set(gca, 'YColor', 'none','YTick', [], 'XTick', [-90:90:90, 120], 'XTickLabel', {-90:90:90, 'Bk'});
    xlim([-100 , 130])
    ylim([min(tune(iPl).avePeak) - mean(tune(iPl).sePeak), max(tune(iPl).avePeak) + max(tune(iPl).sePeak)])
   
end

end