function plot_dir_tuning(tuning,line_c, yval)

dirResp = tuning.avePeak([1:12, 1]);
dirRespSe = tuning.sePeak([1:12, 1]);

dirs = unique(tuning.dirs, 'stable');
dirs = [dirs, dirs(1)+360];

respTun = tuning.fit_vm;
dirPt = tuning.fit_pt;

errorbar(dirs, dirResp,dirRespSe, 'o', 'Color',line_c, 'MarkerFaceColor', line_c); hold on;
plot(dirPt, respTun , 'Color', line_c, 'LineWidth', 1); hold on

xlim([-10 370])

if nargin < 3
    ylim([min(-0.3), max(dirResp)])
else
    ylim(yval);
end

set(gca, 'XTick', [0 180 360], 'YTick', [0 1]);axis square
formatAxes

end