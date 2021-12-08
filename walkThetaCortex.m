function walk = walkThetaCortex(retX, retY, theta, start)
% theta is counterclockwise anlge in visual space

if theta < 0
    theta = theta+360;
elseif theta >360
    theta = theta -360;
end

if nargin < 4
    
    start  = find(retX.^2+retY.^2 == 0);
    [start(1), start(2)] = ind2sub([size(retX,1),size(retX,2)], start);
    
end

retX = retX-retX(start(1), start(2));
retY = retY-retY(start(1), start(2));

walk = start;
walkout = false;

while ~walkout
    [~, from, to] =thetaCortex(retX, retY, theta, start);
    walk = cat(1, walk, to);
    start = to;
    if isempty(to)
        walkout = true;
    end
end


% figure; plot(extrap_walk(:,1), extrap_walk(:,2));hold on
% plot(walk(:,1), walk(:,2))
%
% % % % 
% figure; 
% imagesc(retX); hold on
% plot(walk(:,2), walk(:,1), '--k');

end