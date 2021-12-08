function BW = thetaWedge(walk, theta, centre, sz)


centred_walk = bsxfun(@minus, walk, centre);

centred_walk(:,1) = -centred_walk(:,1);

% rotate coordinates couterclockwise by theta
R = [cosd(theta) -sind(theta); sind(theta) cosd(theta)];
ccw_walk = (R*centred_walk')';

% rotate coordinates clockwise by theta
R = [cosd(theta) sind(theta); -sind(theta) cosd(theta)];
cw_walk = (R*centred_walk')';

all_walk = cat(1, ccw_walk , flip(cw_walk,1), ccw_walk(1,:));
all_walk(:,1) = -all_walk(:,1);
all_walk = bsxfun(@plus, all_walk, centre);

% create 2D wedge of pixels
BW = poly2mask(all_walk(:,2), all_walk(:,1), sz(1), sz(2));

end