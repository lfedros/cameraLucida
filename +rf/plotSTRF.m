function plotSTRF(receptiveField)

scaleMax = max(abs(receptiveField(:)));
    for pixRow = 1:size(receptiveField,1)
        for pixCol = 1:size(receptiveField,2)
            
            thisTrace = squeeze(receptiveField(pixRow, pixCol, :))./scaleMax;
            plot(pixCol+(1:size(receptiveField,3))/ ...
                (size(receptiveField,3)*1.1), ...
                size(receptiveField,1)-pixRow+thisTrace, 'k');
            hold on;
            
            thisTracePos = thisTrace;
            thisTracePos(thisTrace<1/3) = NaN;
            plot(pixCol+(1:size(receptiveField,3))/ ...
                (size(receptiveField,3)*1.1), ...
                size(receptiveField,1)-pixRow+thisTracePos, 'r', ...
                'LineWidth', 2.0);
            
            thisTraceNeg = thisTrace;
            thisTraceNeg(thisTrace>-1/3) = NaN;
            plot(pixCol+(1:size(receptiveField,3))/ ...
                (size(receptiveField,3)*1.1), ...
                size(receptiveField,1)-pixRow+thisTraceNeg, 'b', ...
                'LineWidth', 2.0);
            
        end
    end
    ylim([-0.1 size(receptiveField,1)])
    title('Raw Ca-correlated average');
    set(gca, 'XTick', [], 'YTick', []);
    axis tight;


end