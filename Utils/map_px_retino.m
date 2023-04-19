function [combo_px_map] = map_px_retino(ret, combo_px_map, norm_flag)

if nargin <3
    norm_flag = 1; 
end

if ~isempty(combo_px_map.soma_pref_ori)
    soma_ori = combo_px_map.soma_pref_ori;
%             soma_ori = combo_px_map.pref_ori_norm;

else
    if norm_flag
        soma_ori = combo_px_map.pref_ori_norm;
    else
        soma_ori = combo_px_map.pref_ori;
    end
end

%% map pixel position in retinotopy, relative to soma
% azimuth and elevation ret
combo_px_map.ele = interp2(ret.map_x_um', ret.map_y_um, ret.map_ele, combo_px_map.sig_x_um, combo_px_map.sig_y_um);
combo_px_map.azi = interp2(ret.map_x_um', ret.map_y_um, ret.map_azi, combo_px_map.sig_x_um, combo_px_map.sig_y_um);
% visual angle and orientation
combo_px_map.angle = interp2(ret.map_x_um', ret.map_y_um, ret.map_angle, combo_px_map.sig_x_um, combo_px_map.sig_y_um);
combo_px_map.angle_axial = interp2(ret.map_x_um', ret.map_y_um, ret.map_angle_axial, combo_px_map.sig_x_um, combo_px_map.sig_y_um);

%% retinotopic coordinates aligned to pref ori
% if ~isempty(combo_px_map.soma_pref_ori)
%     soma_ori = combo_px_map.soma_pref_ori;
% else
%     soma_ori = combo_px_map.pref_ori_norm;
% 
% end
% prefOri is measured anti-clockwise from horizontal
R = [cosd(soma_ori ) sind(soma_ori ); -sind(soma_ori ) cosd(soma_ori )]; % clockwise rotation
coords = [combo_px_map.azi, combo_px_map.ele];
rot_coords = R*coords';

combo_px_map.azi_rot= rot_coords(1,:);
combo_px_map.ele_rot = rot_coords(2,:);



%% map isoOrientation line
soma_ori = unwrap_angle(soma_ori, 1, 1);

ori_groove = ret.map_angle_axial - soma_ori*pi/180; 
ori_groove(:) = unwrap_angle(ori_groove(:), 1, 0);

[~, ori_vec_idx] = min(abs(ori_groove(:)));

[ori_vec_i, ori_vec_j] = ind2sub(size(ret.map_azi), ori_vec_idx);

ori_vec_x_um = ret.map_x_um(ori_vec_j);
ori_vec_y_um = ret.map_y_um(ori_vec_i);

um_tan_ori = ori_vec_y_um/ori_vec_x_um;

combo_px_map.isoOri = [];
combo_px_map.isoOri(:, 1) = ret.map_x_um;
combo_px_map.isoOri(:, 2) = ret.map_x_um*um_tan_ori;
out = combo_px_map.isoOri(:, 2) > max(ret.map_y_um) | combo_px_map.isoOri(:, 2) < min(ret.map_y_um);
combo_px_map.isoOri(out, :) = [];

[X, Y] = meshgrid(ret.map_x_um, ret.map_y_um);
ret.map_angle_axial_um = atan(Y./X);
ret.map_angle_axial_um_rel = ret.map_angle_axial_um - atan(um_tan_ori); 
ret.map_angle_axial_um_rel(:) = unwrap_angle(ret.map_angle_axial_um_rel(:), 1, 0);

combo_px_map.angle_axial_um = interp2(ret.map_x_um', ret.map_y_um, ret.map_angle_axial_um, combo_px_map.sig_x_um, combo_px_map.sig_y_um);
combo_px_map.angle_axial_um_rel = interp2(ret.map_x_um', ret.map_y_um, ret.map_angle_axial_um_rel, combo_px_map.sig_x_um, combo_px_map.sig_y_um);

combo_px_map.angle_axial_rel = combo_px_map.angle_axial;
combo_px_map.angle_axial_rel(:)= unwrap_angle(combo_px_map.angle_axial_rel(:) - soma_ori*pi/180,1);

%% shuffle ortho and para dendrites by rotating morphology relative to map
nSh = 1000; 

angle_sh = rand(nSh,1)*360;

for iSh = 1:nSh

R = [cosd(angle_sh(iSh)) sind(angle_sh(iSh)); -sind(angle_sh(iSh)) cosd(angle_sh(iSh))]; % clockwise rotation
coords = [combo_px_map.sig_x_um, combo_px_map.sig_y_um];
rot_coords = R*coords';

sh_sig_x_um= rot_coords(1,:);
sh_sig_y_um = rot_coords(2,:);

% % azimuth and elevation ret
% combo_px_map.ele = interp2(ret.map_x_um', ret.map_y_um, ret.map_ele, sh.sig_x_um, sh.sig_y_um);
% combo_px_map.azi = interp2(ret.map_x_um', ret.map_y_um, ret.map_azi, sh.sig_x_um, sh.sig_y_um);
% visual angle and orientation
combo_px_map.sh.angle_axial_um_rel(iSh, :) = interp2(ret.map_x_um', ret.map_y_um, ret.map_angle_axial_um_rel, sh_sig_x_um, sh_sig_y_um);
combo_px_map.sh.angle_axial_rel(iSh, :) = interp2(ret.map_x_um', ret.map_y_um, ret.map_angle_axial, sh_sig_x_um, sh_sig_y_um);
combo_px_map.sh.angle_axial_rel(iSh, :) = unwrap_angle(combo_px_map.sh.angle_axial_rel(iSh, :)  - soma_ori*pi/180,1);
end

%%

% figure; 
% % a = zeros(size(ori_groove));
% % a(ori_vec_idx) = 100;
% % imagesc(imgaussfilt(a,10)); hold on
% % plot(ori_vec_j, ori_vec_i, 'og');
% imagesc(ret.map_x_um, ret.map_y_um, ori_groove>-0.1 & ori_groove<0.1);
%  figure; imagesc(ret.map_x_um, ret.map_y_um, ret.map_angle_axial_um <0.1 &  ret.map_angle_axial_um>-0.1); hold on
% plot(combo_px_map.isoOri(:,1), combo_px_map.isoOri(:,2), '--')


%% combo_px_map.isoOri = [];

% prefOri(prefOri<0) = prefOri(prefOri<0)+180;
% 
% [walk, origin] =walkThetaCortex(ret.map_azi, ret.map_ele, prefOri);
% walkOp =walkThetaCortex(ret.map_azi, ret.map_ele, prefOri+180);
% 
% if size(walk, 1)>1
%     walk = extrapolate_walk(walk);
% else
%     [~, walk] = extrapolate_walk(flip(walkOp,1));
% end
% 
% if size(walkOp, 1)>1
%     walkOp = extrapolate_walk(walkOp);
% 
% else
%     [~,walkOp] = extrapolate_walk(flip(walk,1));
% end
% 
% walk(isnan(walk(:,1)), :) = [];
% walk(isnan(walk(:,2)), :) = [];
% 
% walkOp(isnan(walkOp(:,1)), :) = [];
% walkOp(isnan(walkOp(:,2)), :) = [];
% 
% 
% isoOri_IJ(:,2) = walk(:,2);
% isoOri_IJ(:,1) = walk(:,1);
% isoOriOp_IJ(:,2) = walkOp(:,2);
% isoOriOp_IJ(:,1) = walkOp(:,1);
% 
% walk = cat(1,  flip(walk,1), walkOp(2:end,:));
% 
% 
% combo_px_map.isoOri(:, 1) = interp1(1:numel(ret.map_x_um), ret.map_x_um, walk(:,2));
% combo_px_map.isoOri(:, 2) = interp1(1:numel(ret.map_y_um), ret.map_y_um, walk(:,1));

end