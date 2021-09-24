function plot_dendrotomy(neuron, rel_flag)

if nargin < 2
rel_flag = 1; 
end

nDb = numel(neuron);

nCut = 0;

for  iDb = 1: nDb
    if ~isempty(neuron(iDb).tuning_cut)
        nCut = nCut+1;
        thisCut(nCut) = iDb;
    end
end

if nCut >1
figure('Position',[403 42 1014 954], 'Color', 'w'); 
else
figure('Position',[443 438 989 407], 'Color', 'w'); 

end

nCols = 4;
nRows = ceil(nCut/nCols);
for iCut = 1:nCut
    
clear toPlot
db = neuron(thisCut(iCut)).db;
retino = neuron(thisCut(iCut)).retino;
morph = neuron(thisCut(iCut)).morph;
morph_cut = neuron(thisCut(iCut)).morph_cut;
tuning = neuron(thisCut(iCut)).tuning;
rot_cortex = neuron(thisCut(iCut)).rot_cortex;
rot_cortex_cut = neuron(thisCut(iCut)).rot_cortex_cut;

if rel_flag
tuning_cut = neuron(thisCut(iCut)).tuning_cut.relative;
else
tuning_cut = neuron(thisCut(iCut)).tuning_cut;
end

 
    subplot(nCut, nCols, 1+nCols*(iCut-1))
    
    hold on;
   switch db.morph.dendrotomy{2}
       case 'para'
%                plot_tree_lines(neuron(thisCut(iCut)).morph, [1 0 0],[],[],'-3l');
       line_c = [1 0 0];
       case 'orth'
%                plot_tree_lines(neuron(thisCut(iCut)).morph, [0 0.5 1],[],[],'-3l');
       line_c = [0 0.5 1];

   end

 if ~isempty(morph_cut)
   plot_tree_lines(morph, line_c,[],[],'-3l'); hold on

    plot_tree_lines(morph_cut, [],[],[],'-3l'); 
    lim = max([abs(morph.X); abs(morph.Y)]);


% oriColor = hsv_downtoned(180);
% colorID = neuron(thisCut(iCut)).tuning.prefOri; %[-90 90]
% % colorID(colorID<0) = colorID(colorID<0)+180; % axial
% colorID = colorID+90;
% oriColor = oriColor(round(colorID), :);
else

   plot_tree_lines(morph, [],[],[],'-3l');
    lim = max([abs(morph.X); abs(morph.Y)]);


end
plot(retino.isoOri(:,1), retino.isoOri(:,2), '--','Color', [0 1 0.5]);

    xlim([-lim lim])
    ylim([-lim lim])

    xlabel('ML[um] ');
    ylabel('RC[um] ');
    formatAxes


%% polar plot of dendrite density

    subplot(nCut, nCols, 2 +nCols*(iCut-1))

hbins = neuron(thisCut(iCut)).rot_cortex.ang_bins;
centeredDist= circGaussFilt(rot_cortex.ang_density,1);

centeredDist_cut= circGaussFilt(rot_cortex_cut.ang_density,1);

trims_dist = (centeredDist*rot_cortex.ang_L - centeredDist_cut*rot_cortex_cut.ang_L)/rot_cortex.ang_L;

% figure; 
% plot(centeredDist*rot_cortex.ang_L); hold on
% plot(centeredDist_cut*rot_cortex_cut.ang_L);

trims_dist(trims_dist<0) = 0; 

polarhistogram('BinEdges', cat(2, hbins', hbins(1)+2*pi), ...
    'BinCounts', centeredDist,  'DisplayStyle', 'stairs', 'EdgeColor', [0 0 0]);
hold on;
polarhistogram('BinEdges', cat(2, hbins', hbins(1)+2*pi), ...
    'BinCounts', trims_dist,  'DisplayStyle', 'stairs', 'EdgeColor', line_c);

polarplot([tuning.prefOri*pi/180 tuning.prefOri*pi/180+pi], [max(centeredDist) max(centeredDist)], 'Color', [0 1 0.5]);
set(gca, 'RTick', [], 'ThetaTick', [0 90 180 270]);
formatAxes

%% plot direction tuning

    subplot(nCut, nCols, 3 +nCols*(iCut-1))

dirResp = tuning.avePeak([1:12, 1]);
dirRespSe = tuning.sePeak([1:12, 1]);

dirResp_cut = tuning_cut.avePeak([1:12, 1]);
dirRespSe_cut = tuning_cut.sePeak([1:12, 1]);

dirs = unique(tuning.dirs, 'stable');
dirs = [dirs, dirs(1)+360];

respTun = tuning.fit_vm;
dirPt = tuning.fit_pt;

respTun_cut = tuning_cut.fit_vm;


errorbar(dirs, dirResp,dirRespSe, 'o', 'Color', [0.7 0.7 0.7], 'MarkerFaceColor', [0.7 0.7 0.7]); hold on;
plot(dirPt, respTun , 'Color', [0.7 0.7 0.7], 'LineWidth', 1); hold on

errorbar(dirs, dirResp_cut,dirRespSe_cut, 'o', 'Color', line_c, 'MarkerFaceColor', line_c); hold on;
plot(dirPt, respTun_cut , 'Color', line_c, 'LineWidth', 1); hold on

xlim([-10 370])
% ylim([-0.1 1.2])
set(gca, 'XTick', [0 180 360], 'YTick', [0 1]);axis square
if iCut == nCut

xlabel('Direction')
end
ylabel('Norm resp')

% title(sprintf('%d', round(neuron.tuning.prefDir)));
formatAxes 

%% plot orientation tuning

    subplot(nCut, nCols, 4+nCols*(iCut-1))

oriResp = tuning.aveOriPeak([1:6, 1]);
oriRespSe = tuning.seOriPeak([1:6, 1]);

oriResp_cut = tuning_cut.aveOriPeak([1:6, 1]);
oriRespSe_cut = tuning_cut.seOriPeak([1:6, 1]);

oris = unique(tuning.oris, 'stable');
oris = [oris, oris(1)+180];

respTun = tuning.ori_fit_vm;
oriPt = tuning.ori_fit_pt;

respTun_cut = tuning_cut.ori_fit_vm;

errorbar(oris, oriResp,oriRespSe/sqrt(2), 'o', 'Color', [0.7 0.7 0.7], 'MarkerFaceColor', [0.7 0.7 0.7]); hold on;
plot(oriPt, respTun , 'Color', [0.7 0.7 0.7], 'LineWidth', 1); hold on

errorbar(oris, oriResp_cut,oriRespSe_cut/sqrt(2), 'o', 'Color', line_c, 'MarkerFaceColor', line_c); hold on;
plot(oriPt, respTun_cut, 'Color', line_c, 'LineWidth', 1); hold on

xlim([-100 100])
% ylim([-0.1 1.2])
set(gca, 'XTick', [-90 0 90], 'YTick', [0 1]);axis square

if iCut == nCut
xlabel('Orientation')
end
ylabel('Norm resp')
% title(sprintf('%d', round(neuron.tuning.prefOri)));
formatAxes 


end

saveTo = fullfile(db.data_repo, 'Results');

if ~exist(saveTo, 'dir')
mkdir saveTo
end

if nCut ==1


%     print(fullfile(saveTo,[db.animal, '_', num2str(db.neuron_id), '_dendrotomy']) , '-painters', '-dpdf', '-fillpage');
%     print(fullfile(saveTo,[db.animal, '_', num2str(db.neuron_id), '_dendrotomy']) ,  '-dpng');
    print(fullfile(saveTo,[db.animal, '_', num2str(db.neuron_id), '_dendrotomy']) , '-dpdf', '-painters');

else

%     print(fullfile(saveTo,'dendrotomy_examples') ,  '-dpng');
        print(fullfile(saveTo,'dendrotomy_examples') ,  '-dpdf', '-painters');


end

end