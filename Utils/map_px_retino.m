function [combo_px_map] = map_px_retino(ret, combo_px_map)


%% map pixel map px position

% 
combo_px_map.ele = interp2(ret.map_x_um', ret.map_y_um, ret.map_ele, combo_px_map.sig_x_um, combo_px_map.sig_y_um);
combo_px_map.azi = interp2(ret.map_x_um', ret.map_y_um, ret.map_azi, combo_px_map.sig_x_um, combo_px_map.sig_y_um);

combo_px_map.angle = interp2(ret.map_x_um', ret.map_y_um, ret.map_angle, combo_px_map.sig_x_um, combo_px_map.sig_y_um);
combo_px_map.angle_axial = interp2(ret.map_x_um', ret.map_y_um, ret.map_angle_axial, combo_px_map.sig_x_um, combo_px_map.sig_y_um);

theta = combo_px_map.soma_ori;

R = [cosd(theta) sind(theta); -sind(theta) cosd(theta)];
coords = [combo_px_map.azi, combo_px_map.ele];
rot_coords = R*coords';

combo_px_map.azi_rot= rot_coords(1,:);
combo_px_map.ele_rot = rot_coords(2,:);

%%
if ~isempty(combo_px_map.soma_ori)
    
    prefOri = combo_px_map.soma_ori;
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
    
    combo_px_map.isoOri(:, 1) = interp1(1:numel(ret.map_x_um), ret.map_x_um, walk(:,2));
    combo_px_map.isoOri(:, 2) = interp1(1:numel(ret.map_y_um), ret.map_y_um, walk(:,1));
    
%     spines.oriDoubleWedge = thetaWedge(walk, 45, origin, size(ret.map_azi));
    
    
end

% figure; 
% histogram(combo_px_map.angle*180/pi, -180:30:180);
% xlabel('Angle around the soma')
% formatAxes


end