function [avgAng, dendOri_s] = CorticoMorphoShuffle( neuronData )

tree_D   = cell(18,1);
tree1_D  = cell(18,1);
thetaBox = cell(18,1);
avgAng   = cell(18,1);
for i = 1 : 18
    [tree_D{i,1}, tree1_D{i,1}, ~, ~] = RetinoMap_D( neuronData(i).name, neuronData(i).dbVis );
    [thetaBox{i,1}] = DendriteBox_Moment( tree1_D{i,1}, 'test' );
    obj1 = CircHist(thetaBox{i,1}.theta_deg, -5:10:360-5, 'areAxialData', true);
    avgAng{i,1} = obj1.avgAng;
    close all;
end

dendOri_s = cell2mat(avgAng);
% wrap these values around [-90 90]
ii = dendOri_s > 90;
dendOri_s(ii,1) = dendOri_s(ii,1) - 180;
ii = dendOri_s < -90;
dendOri_s(ii,1) = dendOri_s(ii,1) + 180;

end