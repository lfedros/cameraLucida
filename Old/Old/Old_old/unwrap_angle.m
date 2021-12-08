function alpha = unwrap_angle(alpha, axial_flag, deg_flag)
%  alpha = unwrap_angle(alpha, axial_flag, deg_flag)
% unwraps angular data in the intervals [-180 180] or [-pi pi]
% or [-90 90] and [-pi/2 pi/2] in the case of axial data

if nargin <2
    axial_flag = 0;
end

if nargin <3
    deg_flag = 0;
end

if deg_flag
    
    if axial_flag
        
%         while sum(alpha>90 & alpha <-90) >0
            
            alpha(alpha>=90) = alpha(alpha>=90) -180;
            alpha(alpha<-90) = alpha(alpha<-90) +180;
%         end
    else
%         while sum(alpha>180 & alpha <-180) >0
            
            alpha(alpha>=180) = alpha(alpha>=180) -360;
            alpha(alpha<-180) = alpha(alpha<-180) +360;
%         end
    end
    
else
    if axial_flag
%         while sum(alpha> pi/2 & alpha <-pi/2) >0
            
            alpha(alpha>=pi/2) = alpha(alpha>=pi/2) -pi;
            alpha(alpha<-pi/2) = alpha(alpha<-pi/2) +pi;
%         end
    else
%         while sum(alpha>pi & alpha <-pi) >0
            
            alpha(alpha>=pi) = alpha(alpha>=pi) -2*pi;
            alpha(alpha<-pi) = alpha(alpha<-pi) +2*pi;
%         end
    end
end

end