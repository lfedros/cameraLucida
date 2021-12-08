function [envelopeEdges, envelope,  envelope_se, lm] = intervalReg(X,Y, edges)

X = X(:); Y = Y(:);

nQuant = numel(edges);

[~,~,idx] = histcounts(X, edges); 


for iQ = 1:nQuant-1
    
    chosenY = Y(idx == iQ);
    chosenX = X(idx == iQ);
    
    if ~isempty(chosenY)
        envelope(iQ) = NaN;
        envelope_se(iQ) = NaN;
    end
    envelope(iQ) = mean(chosenY);
    envelope_se(iQ) = std(chosenY)/sqrt(numel(chosenY));
    envelopeEdges(iQ)= mean(chosenX);

end

envelope_se(isnan(envelope)) = [];
envelopeEdges(isnan(envelope)) = [];
envelope(isnan(envelope)) = [];

lm = fitlm(envelopeEdges, envelope);

% rf = robustfit(envelopeEdges, envelope);
% 
% minN=prctile(neuropRoiTrace(iCell,:),minNp);
%     maxN=prctile(neuropRoiTrace(iCell,:),maxNp);
%     discrNeuro=round(numN*(neuropRoiTrace(iCell,:)-minN)/(maxN-minN));
%     %discrNeuro are the discretized values of neuropil between minN and
%     % maxN, with numN elements
%     
%     for iN=1:numN
%         lowCell(iCell,iN)= prctile(cellRoiTrace(iCell,discrNeuro==iN),pCell);
%     end
%     
%     fitNeuro(iCell,:)=(1:numN).*(maxN-minN)/numN+minN;
%     corrFactor(iCell,:) = robustfit(fitNeuro(iCell,:),lowCell(iCell,:));

end