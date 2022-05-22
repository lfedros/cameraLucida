function spines = map_spine_retino(spines, ret)

spines.ele = interp2(ret.map_x_um', ret.map_y_um, ret.map_ele, spines.x_um, spines.y_um);
spines.azi = interp2(ret.map_x_um', ret.map_y_um, ret.map_azi, spines.x_um, spines.y_um);
spines.angle = interp2(ret.map_x_um', ret.map_y_um, ret.map_angle, spines.x_um, spines.y_um);
spines.angle_axial = interp2(ret.map_x_um', ret.map_y_um, ret.map_angle_axial, spines.x_um, spines.y_um);

theta = spines.soma_ori;

R = [cosd(theta) sind(theta); -sind(theta) cosd(theta)];
coords = [spines.azi', spines.ele'];
rot_coords = R*coords';

spines.azi_rot= rot_coords(1,:);
spines.ele_rot = rot_coords(2,:);

%%
if ~isempty(spines.soma_ori)
    
    prefOri = spines.soma_ori;
    prefOri(prefOri<0) = prefOri(prefOri<0)+180;
    % [tree_deg.isoOriX, tree_deg.isoOriY] = cameraLucida.map_oriLine(micronsSomaX, micronsSomaY, retX, retY, prefOri,1);
    
    [walk, origin] =walkThetaCortex(ret.map_azi, ret.map_ele, prefOri);
    walkOp =walkThetaCortex(ret.map_azi, ret.map_ele, prefOri+180);
    
    if size(walk, 1)>1
        walk = extrapolate_walk(walk);
    else
        [~, walk] = extrapolate_walk(flip(walkOp,1));
    end
    
    if size(walkOp, 1)>1
        walkOp = extrapolate_walk(walkOp);
        
    else
        [~,walkOp] = extrapolate_walk(flip(walk,1));
    end
    
    walk(isnan(walk(:,1)), :) = [];
    walk(isnan(walk(:,2)), :) = [];
        
    walkOp(isnan(walkOp(:,1)), :) = [];
    walkOp(isnan(walkOp(:,2)), :) = [];
    
    
    isoOri_IJ(:,2) = walk(:,2);
    isoOri_IJ(:,1) = walk(:,1);
    isoOriOp_IJ(:,2) = walkOp(:,2);
    isoOriOp_IJ(:,1) = walkOp(:,1);
    
    walk = cat(1,  flip(walk,1), walkOp(2:end,:));
    
    spines.isoOri(:, 1) = interp1(1:numel(ret.map_x_um), ret.map_x_um, walk(:,2));
    spines.isoOri(:, 2) = interp1(1:numel(ret.map_y_um), ret.map_y_um, walk(:,1));
    
%     spines.oriDoubleWedge = thetaWedge(walk, 45, origin, size(ret.map_azi));
    
    
end



%%

figure; 
histogram(spines.angle*180/pi, -180:30:180);
xlabel('Angle around the soma')
formatAxes

end