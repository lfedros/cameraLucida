%% Find Radial Coordinates

function [thetaRadialMap] = RadialBox( tree )

dA = tree.dA;
X = tree.X;
Y = tree.Y;
nodeNear = zeros(length(X),1);
for i = 2:length(X)
    nodeNear(i,1) = find(dA(i,:)==1);
end

start_coor = [X(2:end), Y(2:end)];
end_coor = [X(nodeNear(2:end)), Y(nodeNear(2:end))];
diffY = end_coor(:,2)-start_coor(:,2);
diffX = end_coor(:,1)-start_coor(:,1);
[theta_axial, ~] = cart2pol(diffX, diffY); % [rad]
theta_axial = theta_axial.*(180/pi);
thetaRadialMap = [0; theta_axial];

end



