function plot_ori_tuning(tuning, line_c, yval)

oriResp = tuning.aveOriPeak([1:6, 1]);
oriRespSe = tuning.seOriPeak([1:6, 1]);

oris = unique(tuning.oris, 'stable');
oris = [oris, oris(1)+180];

respTun = tuning.ori_fit_vm;
oriPt = tuning.ori_fit_pt;

errorbar(oris, oriResp,oriRespSe/sqrt(2), 'o', 'Color', line_c, 'MarkerFaceColor', line_c); hold on;
plot(oriPt, respTun , 'Color', line_c, 'LineWidth', 1); hold on

xlim([-100 100])

if nargin < 3
    ylim([min(-0.3), max(oriResp)])
else
    ylim(yval);
end
set(gca, 'XTick', [-90 0 90], 'YTick', [0 1]);axis square
formatAxes

end