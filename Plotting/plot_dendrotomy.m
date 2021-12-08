function plot_dendrotomy(neuron)

if nargin < 2
rel_flag = 1; 
end

nCut = numel(neuron.morph);

m = figure('Position',[120 113 816 830], 'Color', 'w'); 

t = figure('Position', [955 114 816 830], 'Color', 'w'); 

nCols = 2;

nRows = ceil(nCut/nCols);

isoOri = neuron.rot_cortex(1).isoOri;


b = robustfit(isoOri(:,1), isoOri(:,2), [], [], 'off');
% 
% start = isoOri(1,1);
% last  = isoOri(1,2); 
% if start >last
% isoOri = flip(isoOri,1);
% end
% 
%  newIso(:,1) = [makeVec(isoOri(1,1)-200:isoOri(1,1)-10); isoOri(:,1); makeVec(isoOri(end,1)+10:isoOri(end,1)+200)];
%     newIso(:,2) = [makeVec(isoOri(1,1)-200:isoOri(1,1)-10)*b;  isoOri(:,2); makeVec(isoOri(end,1)+10:isoOri(end,1)+200)*b];
% 
%        
% isoOri = newIso;
isoOri_ang = rad2deg(atan(b))-90;
R = [cosd(isoOri_ang) sind(isoOri_ang); -sind(isoOri_ang) cosd(isoOri_ang)];
isoOri = (R*isoOri')';

for iCut = 1:nCut
    
db = neuron.db;
% retino = neuron.retino(iCut);


morph = neuron.morph(1);
morph_cut = neuron.morph(iCut);
tuning = neuron.tuning(1);
rot_cortex = neuron.rot_cortex(1);
rot_cortex_cut = neuron.rot_cortex(iCut);
tuning_cut = neuron.tuning(iCut);

if  iCut >1
tuning_cut_rel = neuron.tuning(iCut).relative;

end

%% maps sectors of prefOri

R1 = rotMat2(45);
R2 = rotMat2(-45);

nans = isnan(sum(isoOri , 2));

isoLine = isoOri (~nans, :);
% 
slope = isoLine(1:5,1)\isoLine(1:5,2);
% 
    if isoLine(1,1) < isoLine(5,1) 
    
        primo = [-10000, -10000*slope];
    else
                primo = [10000, 10000*slope];

    end
        
       slope = isoLine(end-4:end,1)\isoLine(end-4:end,2);
% 
    if isoLine(end-4,1) < isoLine(end,1) 
    
        ultimo = [10000, 10000*slope];
    else
                ultimo = [-10000, -10000*slope];

    end 
        
        
        %
%     primo = [-10000, -10000*slope];
%     ultimo = [10000, 10000*slope];
% else
%        primo =[10000, 10000*slope];
%     ultimo =  [-10000, -10000*slope];
% end

isoLine = cat(1, primo, isoLine, ultimo);

ccw = R1*isoLine';
cw = R2*isoLine';

sector = cat(1, ccw', flip(cw'));
orth_sector =  cat(1, ccw', cw');
%%




 figure(m);
 
 morph.X  = rot_cortex.X;
  morph.Y  = rot_cortex.Y;

  morph_cut.X  = rot_cortex_cut.X;
  morph_cut.Y  = rot_cortex_cut.Y;

    subplot(nCut, nCols, 1+nCols*(iCut-1))
    
    hold on;
    
    patch(sector(:,1), sector(:,2), [1 0 0 ], 'EdgeColor', 'none', 'FaceAlpha', 0.05);
        patch(orth_sector(:,1), orth_sector(:,2), [0 0.5 1], 'EdgeColor', 'none', 'FaceAlpha', 0.05);

   switch db.morph.dendrotomy{2}
       case 'para'
%                plot_tree_lines(neuron(thisCut(iCut)).morph, [1 0 0],[],[],'-3l');
       line_c = [1 0 0];
       case 'orth'
%                plot_tree_lines(neuron(thisCut(iCut)).morph, [0 0.5 1],[],[],'-3l');
       line_c = [0 0.5 1];

   end

 if iCut>1
   plot_tree_lines_LFR(morph, line_c,[],[],'-3l'); hold on

   plot_tree_lines_LFR(morph_cut, [],[],[],'-3l'); 
    lim = max([abs(morph.X); abs(morph.Y)]);


% oriColor = hsv_downtoned(180);
% colorID = neuron(thisCut(iCut)).tuning.prefOri; %[-90 90]
% % colorID(colorID<0) = colorID(colorID<0)+180; % axial
% colorID = colorID+90;
% oriColor = oriColor(round(colorID), :);
else

   plot_tree_lines_LFR(morph, [],[],[],'-3l');
    lim = max([abs(morph.X); abs(morph.Y)]);


end
plot(isoOri(:,1), isoOri(:,2), '--','Color', [0 1 0.5]);

    xlim([-lim lim])
    ylim([-lim lim])

    xlabel('ML[um] ');
    ylabel('RC[um] ');
    formatAxes


%% polar plot of dendrite density
 figure(m);

    subplot(nCut, nCols, 2 +nCols*(iCut-1))

hbins = neuron.rot_cortex(1).ang_bins_aligned;
centeredDist= circGaussFilt(rot_cortex.ang_density_aligned,1);

centeredDist_cut= circGaussFilt(rot_cortex_cut.ang_density_aligned,1)*rot_cortex_cut.ang_L/rot_cortex.ang_L;

%%

 if iCut>1

% trims_dist = (centeredDist*rot_cortex.ang_L - centeredDist_cut*rot_cortex_cut.ang_L)/rot_cortex.ang_L;
% trims_dist(trims_dist<0) = 0; 

 polarhistogram('BinEdges', cat(2, hbins', hbins(1)+2*pi), ...
    'BinCounts', centeredDist,   'EdgeColor','none','FaceColor', line_c, 'FaceAlpha', 1);hold on

polarhistogram('BinEdges', cat(2, hbins', hbins(1)+2*pi), ...
    'BinCounts', centeredDist_cut,   'EdgeColor','none','FaceColor', [0 0 0], 'FaceAlpha', 1);hold on
hold on;
 else
      polarhistogram('BinEdges', cat(2, hbins', hbins(1)+2*pi), ...
    'BinCounts', centeredDist,   'EdgeColor','none','FaceColor', [0 0 0], 'FaceAlpha', 1);hold on
 end

% polarplot([tuning.prefOri*pi/180 tuning.prefOri*pi/180+pi], [max(centeredDist) max(centeredDist)], 'Color', [0 1 0.5]);
polarplot([0 0+pi], [max(centeredDist) max(centeredDist)], 'Color', [0 1 0.5]);

set(gca, 'RTick', [], 'ThetaTick', [0 90 180 270]);
formatAxes
set(gca, 'RTick', [], 'ThetaTick', [0 90 180 270]);
set(gca, 'RTick', [], 'ThetaTick', [0 90 180 270]);

set(gca,  'ThetaZeroLocation', 'top');

    
 

%% plot direction tuning

figure(t);

subplot(nCut, nCols, 1 +nCols*(iCut-1))

dirResp = tuning.avePeak([1:12, 1]);
dirRespSe = tuning.sePeak([1:12, 1]);

dirResp_cut = tuning_cut.avePeak([1:12, 1]);
dirRespSe_cut = tuning_cut.sePeak([1:12, 1]);

dirs = unique(tuning.dirs, 'stable');
dirs = [dirs, dirs(1)+360];

respTun = tuning.fit_vm;
dirPt = tuning.fit_pt;

respTun_cut = tuning_cut.fit_vm;

plot([0 380], [0 0], '--', 'Color', [0.3 0.3 0.3]); hold on

if iCut>1
    respTun_cut_rel = tuning_cut_rel.fit_vm;

errorbar(dirs, dirResp,dirRespSe, 'o', 'Color', [0.7 0.7 0.7], 'MarkerFaceColor', [0.7 0.7 0.7]); hold on;
plot(dirPt, respTun , 'Color', [0.7 0.7 0.7], 'LineWidth', 1); hold on

errorbar(dirs, dirResp_cut,dirRespSe_cut, 'o', 'Color', line_c, 'MarkerFaceColor', line_c); hold on;

plot(dirPt, respTun_cut_rel ,'--', 'Color', line_c, 'LineWidth', 1); hold on
plot(dirPt, respTun_cut , 'Color', line_c, 'LineWidth', 1); hold on

else
    
    errorbar(dirs, dirResp,dirRespSe, 'o', 'Color', [0 0 0], 'MarkerFaceColor', [0 0 0]); hold on;
plot(dirPt, respTun , 'Color', [0 0 0], 'LineWidth', 1); hold on


end
ylim([min(dirResp) - 2*mean(dirRespSe), max(dirResp) + 2*mean(dirRespSe)])
xlim([-10 370])

set(gca, 'XTick', [0 180 360], 'YTick', [0 1]);axis square
if iCut == nCut

xlabel('Direction')
end
ylabel('Norm resp')

% title(sprintf('%d', round(neuron.tuning.prefDir)));
formatAxes 

%% plot orientation tuning

figure(t);

subplot(nCut, nCols, 2+nCols*(iCut-1))

respTun = tuning.ori_fit_vm;
oriPt = tuning.ori_fit_pt;
[~, pkloc] = max(respTun);

oriResp = tuning.aveOriPeak([1:6, 1]);
oriRespSe = tuning.seOriPeak([1:6, 1]);

oriResp = [oriResp; tuning.avePeak(13)];
oriRespSe = [oriRespSe; tuning.sePeak(13)];

oriResp_cut = tuning_cut.aveOriPeak([1:6, 1]);
oriRespSe_cut = tuning_cut.seOriPeak([1:6, 1]);

oriResp_cut = [oriResp_cut; tuning_cut.avePeak(13)];
oriRespSe_cut = [oriRespSe_cut; tuning_cut.sePeak(13)];

oris = unique(tuning.oris, 'stable');
oris = [oris, oris(1)+180];
oris = oris - oriPt(pkloc);
oris(oris<-90) = oris(oris<-90) +180;
oris(oris>=90) = oris(oris>=90) -180;

% oriPt = oris(1):0.5:oris(end);
pars = tuning.ori_pars_vm; 
pars(1) = 0;
respTun = mfun.vonMises(pars, oriPt*2);

pars = tuning_cut.ori_pars_vm; 
dOri =  unwrap_angle(tuning.prefOri - tuning_cut.prefOri,1,1); %[-pi/2, pi/2] -->[0, pi/2]
pars(1) =  -dOri; 
respTun_cut = mfun.vonMises(pars, oriPt*2);






plot([-90 125], [0 0], '--', 'Color', [0.3 0.3 0.3]); hold on

oris = [oris, 125];

if iCut>1

    pars = tuning_cut_rel.ori_pars_vm; 
pars(1) = 0; 
respTun_cut_rel = mfun.vonMises(pars, oriPt*2);

errorbar(oris, oriResp,oriRespSe, 'o', 'Color', [0.7 0.7 0.7], 'MarkerFaceColor', [0.7 0.7 0.7]); hold on;
plot(oriPt, respTun , 'Color', [0.7 0.7 0.7], 'LineWidth', 1); hold on

errorbar(oris, oriResp_cut,oriRespSe_cut, 'o', 'Color', line_c, 'MarkerFaceColor', line_c); hold on;
plot(oriPt, respTun_cut_rel,'--', 'Color', line_c, 'LineWidth', 1); hold on
plot(oriPt, respTun_cut, 'Color', line_c, 'LineWidth', 1); hold on

else
    errorbar(oris, oriResp,oriRespSe, 'o', 'Color', [0 0 0], 'MarkerFaceColor', [0 0 0]); hold on;
plot(oriPt, respTun , 'Color', [0 0 0], 'LineWidth', 1); hold on
    
end

set(gca, 'YTick', [0 1],'XTick', [-90:90:90, 125], 'XTickLabel', {-90:90:90, 'bsl'});

ylim([min(oriResp) - 2*mean(oriRespSe), max(oriResp) + 2*mean(oriRespSe)])
xlim([-100 135])
% ylim([-0.1 1.2])
% set(gca, 'XTick', [-90 0 90], 'YTick', [0 1]);axis square

if iCut == nCut
xlabel('\Delta pref orientation')
end
ylabel('Norm resp')
% title(sprintf('%d', round(neuron.tuning.prefOri)));
formatAxes 


end

saveTo = fullfile(db.data_repo, 'Results');

if ~exist(saveTo, 'dir')
mkdir saveTo
end

figure(t);
%     print(fullfile(saveTo,[db.animal, '_', num2str(db.neuron_id), '_dendrotomy']) , '-painters', '-dpdf', '-fillpage');
%     print(fullfile(saveTo,[db.animal, '_', num2str(db.neuron_id), '_dendrotomy']) ,  '-dpng');
    print(fullfile(saveTo,[db.animal, '_', num2str(db.neuron_id), '_tuning']) , '-dpdf', '-painters');

    figure(m);
    print(fullfile(saveTo,[db.animal, '_', num2str(db.neuron_id), '_morph']) , '-dpdf', '-painters');


end