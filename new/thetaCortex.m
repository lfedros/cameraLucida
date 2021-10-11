function [dirCort, from, to] = thetaCortex(retX, retY, theta, zero)

% theta is counterclockwise anlge in visual space

if nargin >3
    
    retX = retX-retX(zero(1), zero(2));
    retY = retY-retY(zero(1), zero(2));  
    
else
    
    zero  = find(retX.^2+retY.^2 == 0);
    [zero(1), zero(2)] = ind2sub([size(retX,1),size(retX,2)], zero);
    

end

[nx, ny] = size(retX);

thetaRad = deg2rad(theta); %[0 2*pi]
[angleRet, rRet] = cart2pol(retX(:), retY(:)); %[-pi, pi]

x = 1:size(retX,2);
y = 1:size(retX,1);

[X, Y] = meshgrid(x-x(zero(2)), y-zero(1));
rRet = sqrt(X.^2 + Y.^2);

tol = pi/36;

aMap = reshape(angleRet,nx,ny);
dir = thetaRad;
% dir = -thetaRad+2*pi; % invert, convert mpep directions to conventional ones
dir(dir>pi) = dir(dir> pi) - 2*pi; %[-pi pi]

% opDir = dir + pi; %[0 2*pi];
% opDir(opDir>pi) = opDir(opDir> pi) - 2*pi;%[-pi pi]

% dirMap = ((aMap-dir)> -tol & (aMap-dir)< tol) | ((aMap-opDir)> -tol & (aMap-opDir)< tol);
% aMap = aMap -dir;
% aMap(aMap<-pi) = aMap(aMap<-pi) + 2*pi;
% aMap(aMap>=pi) = aMap(aMap>=pi) - 2*pi;


dirMap = unwrap_angle(aMap-dir);
dirMap = (dirMap> -tol & dirMap< tol);

rDir = rRet;
rDir(~dirMap) = NaN;
rDir (rDir ==0) = NaN;

[dist, closest] = min(rDir(:));
if dist <50
[i_to, j_to] = ind2sub([nx, ny], closest);
else
    i_to = [];
    j_to = [];
end
% ic = nx-ic +1;

centre = find(rRet ==0); 
[i_from, j_from] = ind2sub([nx, ny], centre);
% icc = nx-icc+1;

% figure;
% imagesc(dirMap);axis image;hold on; 
% plot(j_to, i_to, 'or'); 
% plot(j_from, i_from, 'og'); hold on;


dirCort = cart2pol(j_to-j_from, i_from-i_to);
from = [i_from, j_from];
to = [i_to, j_to];

end