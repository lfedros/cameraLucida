function [testResp, trainingResp, testStim, trainingStim] = kfoldSplit(resp, stim, k)
% is is a nT by nN matric of responses

% resp = makeVec(resp);

dur = size(resp,1);

lims = round(linspace(1, dur, k+1));

allT = 1:dur;
testStim = cell(k,1);
testResp = cell(k,1);
trainingStim = cell(k,1);
trainingResp = cell(k,1);

for ik = 1: k
    
    testT = lims(ik):lims(ik+1);
    trainingT = setdiff(allT, testT);
    
    testResp{ik} = resp(testT,:);
    trainingResp{ik} = resp(trainingT,:);
    
    testStim{ik} = stim(:, :, testT);
    trainingStim{ik} = stim(:,:, trainingT);
    
end
end