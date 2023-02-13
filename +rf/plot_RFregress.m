function plot_RFregress(aveResp ,receptiveField, staRF,psRF,RFtype,expVar, predResp)

types = {'on', 'off', 'onoff'};

% colormaps
red = [1 0 .5];
blue = [0 .5 1];
black = [1 1 1].*0.5;
grad = linspace(0,1,100)';
reds = red.*flip(grad) + [1 1 1].*grad;
blacks = black.*flip(grad) + [1 1 1].*grad;
cm_ON = [blacks; flip(reds(1:end-1,:),1)];
blues = blue.*flip(grad) + [1 1 1].*grad;
cm_OFF = flip([blacks; flip(blues(1:end-1,:),1)],1);
cm_mean = [blues; flip(reds(1:end-1,:),1)];
colormaps = {cm_ON, cm_OFF, cm_mean};

staRF = imgaussfilt(staRF, 1);

    clSTA = max(abs(makeVec(staRF)));
    if isnan(clSTA); clSTA = 0.00001;end;
    clPS = max(abs(makeVec(psRF)));
    if isnan(clPS); clPS = 0.00001;end;

    subplot(2,3,1:3); plot(aveResp, 'k'); hold on;
    plot(predResp, 'r')
    axis tight; title([RFtype, sprintf(' exp var = %03f', expVar)]);formatAxes
    
    subplot(2,3,4);Ret.plotSTRF(receptiveField);
    formatAxes; axis image
    
    sta=subplot(2,3,5);
    imagesc(staRF);
    axis image; title('sta');axis image;formatAxes
    caxis([-clSTA, clSTA]);
        colormap(sta, colormaps{strcmp(types, RFtype)})
%         colormap(BlueWhiteRed_burnLFR); 

    srf= subplot(2,3,6);
    imagesc(psRF);
    axis image; title('smooth psinv');axis image;formatAxes
    caxis([-clPS, clPS]);
    colormap(srf, colormaps{strcmp(types, RFtype)})
%         colormap(BlueWhiteRed_burnLFR); 
    
    %                 subplot(2,4,7);imagesc(rRF{iExp,iPlane}(:,:,iN, iType));
    %                 axis image; title('ridge');colormap(BlueWhiteRed); axis image;formatAxes
    %                 caxis([-max(abs(makeVec(rRF{iExp,iPlane}(:,:,iN, iType)))), max(abs(makeVec(rRF{iExp,iPlane}(:,:,iN, iType))))]);
    %
    %
    %                 subplot(2,4,8);imagesc(aldRF{iExp,iPlane}(:,:,iN, iType));
    %                 axis image; title('ALDsf');colormap(BlueWhiteRed); axis image;formatAxes
    %                 caxis([-max(abs(makeVec(aldRF{iExp,iPlane}(:,:,iN, iType)))), max(abs(makeVec(aldRF{iExp,iPlane}(:,:,iN, iType))))]);
    %

end