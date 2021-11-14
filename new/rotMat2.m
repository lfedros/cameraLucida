function [R] = rotMat2(theta, deg_flag)

if nargin < 2
    deg_flag = 1;
end

if deg_flag

R = [cosd(theta) -sind(theta); sind(theta) cosd(theta)];

else
    
R = [cos(theta) -sin(theta); sin(theta) cos(theta)];
    
end


end