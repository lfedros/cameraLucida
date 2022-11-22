function plot_RFregress(aveResp ,receptiveField, staRF,psRF,RFtype,expVar, predResp)

    clSTA = max(abs(makeVec(staRF)));
    if isnan(clSTA); clSTA = 0.00001;end;
    clPS = max(abs(makeVec(psRF)));
    if isnan(clPS); clPS = 0.00001;end;

    subplot(2,3,1:3); plot(aveResp, 'k'); hold on;
    plot(predResp, 'r')
    axis tight; title([RFtype, sprintf(' exp var = %03f', expVar)]);formatAxes
    
    subplot(2,3,4);Ret.plotSTRF(receptiveField);
    formatAxes; axis image
    
    subplot(2,3,5);imagesc(staRF);
    axis image; title('sta');colormap(BlueWhiteRed); axis image;formatAxes
    caxis([-clSTA, clSTA]);
    
    subplot(2,3,6);imagesc(psRF);
    axis image; title('smooth psinv');colormap(BlueWhiteRed); axis image;formatAxes
    caxis([-clPS, clPS]);
    
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