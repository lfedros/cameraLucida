function combo_px_map = clusta_syn(combo_px_map, scale, norm_flag)

if nargin<3
    norm_flag = 1;
end

if nargin<2
    scale = [0 30 2];
end


% mean image
img = combo_px_map.mimg;
x_um = combo_px_map.x_um;
y_um = combo_px_map.y_um;
% pixel signal
sig_x_um = combo_px_map.sig_x_um;
sig_y_um = combo_px_map.sig_y_um;
sig_den_id = combo_px_map.sig_den_id;
% isoOri line coordinates
isoOri = combo_px_map.isoOri;

%% for orientation
% angle_axial = combo_px_map.angle_axial_um; %[- pi/2 pi/2]
angle_axial = combo_px_map.angle_axial_rel; %[- pi/2 pi/2]

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

if norm_flag
    ori = angle(combo_px_map.sig_ori_norm)*180/(2*pi); %[-90 90]
    amp = abs(combo_px_map.sig_ori_norm);

%     dir_ori = angle(combo_px_map.sig_dir_norm)*180/(pi); %[-90 90]
%     ori_ori = unwrap_angle(dir_ori - pi/2)/2;

else
    ori = angle(combo_px_map.sig_ori)*180/(2*pi); %[-90 90]
    amp = abs(combo_px_map.sig_ori);
end

ori(ori<0) = ori(ori<0) +180; %[0 180]

d_ori = ori - soma_ori ; %[-180 180]
d_ori(d_ori>90) = d_ori(d_ori>90)-180;
d_ori(d_ori<-90) = d_ori(d_ori<-90)+180; %[-90 90]
d_ori = abs(d_ori); %[0 90]

nan_idx_ori= isnan(d_ori);
angle_axial(nan_idx_ori) = [];
d_ori(nan_idx_ori) = [];
sig_x_um(nan_idx_ori) = [];
sig_y_um(nan_idx_ori) = [];
amp(nan_idx_ori) = [];
sig_den_id(nan_idx_ori) = [];

%%
rel_angle = unwrap_angle(angle_axial);
rel_angle = abs(rel_angle);
parallel_idx= rel_angle <= pi/4;
ortho_idx = rel_angle >pi/4;

%%
dd_all = single(pdist([sig_x_um(:), sig_y_um(:), sig_den_id(:)*1000], 'euclidean'));
do_all = pdist(ori, 'euclidean');
do_all(do_all >=90) = do_all(do_all >=90) -180; %[-90 90]

dd_ortho = single(pdist([sig_x_um(ortho_idx), sig_y_um(ortho_idx), sig_den_id(ortho_idx)*1000], 'euclidean'));
do_ortho = pdist(ori(ortho_idx), 'euclidean');
do_ortho(do_ortho >=90) = do_ortho(do_ortho >=90) -180; %[-90 90]
ortho_num= sum(ortho_idx);

dd_para = single(pdist([sig_x_um(parallel_idx), sig_y_um(parallel_idx), sig_den_id(parallel_idx)*1000], 'euclidean'));
do_para = pdist(ori(parallel_idx), 'euclidean');
do_para(do_para >=90) = do_para(do_para >=90) -180; %[-90 90]
para_num= sum(parallel_idx);


d_edges = scale(1):scale(3):scale(2);

[all_clust,clust_bins]=  clusta_hist(dd_all, do_all, d_edges);
ortho_clust=  clusta_hist(dd_ortho, do_ortho, d_edges);
para_clust=  clusta_hist(dd_para, do_para, d_edges);

%%

nDen = max(sig_den_id);

for iDen = 1:nDen

this_den_idx = sig_den_id == iDen;
dd_all = single(pdist([sig_x_um(this_den_idx), sig_y_um(this_den_idx)], 'euclidean'));
do_all = pdist(ori(this_den_idx), 'euclidean');
do_all(do_all >=90) = do_all(do_all >=90) -180; %[-90 90]

dd_ortho = single(pdist([sig_x_um(this_den_idx & ortho_idx), sig_y_um(this_den_idx &ortho_idx)], 'euclidean'));
do_ortho = pdist(ori(this_den_idx & ortho_idx), 'euclidean');
do_ortho(do_ortho >=90) = do_ortho(do_ortho >=90) -180; %[-90 90]

dd_para = single(pdist([sig_x_um(this_den_idx & parallel_idx), sig_y_um(this_den_idx & parallel_idx)], 'euclidean'));
do_para = pdist(ori(this_den_idx & parallel_idx), 'euclidean');
do_para(do_para >=90) = do_para(do_para >=90) -180; %[-90 90]

oned_all_clust(:, iDen)=  clusta_hist(dd_all, do_all, d_edges);
oned_ortho_clust(:, iDen)=  clusta_hist(dd_ortho, do_ortho, d_edges);
oned_para_clust(:, iDen)=  clusta_hist(dd_para, do_para, d_edges);

oned_ortho_num(iDen)= sum(this_den_idx & ortho_idx);
oned_para_num(iDen) = sum(this_den_idx & parallel_idx);

iDen
end

%%

% clust_bins = edges(1:end-1);
% [~, ~, para_dist_bin]= histcounts(dd_para(:), edges);
% [~, ~, ortho_dist_bin]= histcounts(dd_ortho(:), edges);
% [~, ~, all_dist_bin]= histcounts(dd_all(:), edges);
% 
% for iB = 1:numel(edges)-1
%     para_clust(iB) = circ_r(do_para(para_dist_bin == iB)*2*pi/180);
%     ortho_clust(iB) = circ_r(do_ortho(ortho_dist_bin == iB)*2*pi/180);
%     all_clust(iB) = circ_r(do_all(all_dist_bin == iB)*2*pi/180);
% iB
% end

figure;
plot(clust_bins, para_clust, 'r');
hold on
plot(clust_bins, ortho_clust, 'b');
plot(clust_bins, all_clust, 'k');

formatAxes
axis square

%%

combo_px_map.para_clust = para_clust;
combo_px_map.ortho_clust = ortho_clust;
combo_px_map.all_clust = all_clust;
combo_px_map.clust_bins = clust_bins;
combo_px_map.oned_para_clust = oned_para_clust;
combo_px_map.oned_ortho_clust = oned_ortho_clust;
combo_px_map.oned_all_clust = oned_all_clust;
combo_px_map.para_num = para_num;
combo_px_map.ortho_num = ortho_num;
combo_px_map.oned_para_num = oned_para_num;
combo_px_map.oned_ortho_num = oned_ortho_num;



end