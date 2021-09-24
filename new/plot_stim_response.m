function plot_stim_response(tuning, iStim, line_c, yval)


 shadePlot(tuning.time, tuning.aveResp(iStim,:), tuning.seResp(iStim,:), line_c); hold on


 xlim([min(tuning.time),max(tuning.time)])
 
 if nargin <4
      ylim([min(tuning.aveResp(:)), max(tuning.aveResp(:))])
 else
    ylim(yval);
 end
%  ylim([-0.5 5])
 set(gca, 'Xtick', [], 'YTick', [],'visible', 'off')
 formatAxes


end