function [all_clust, clust_bins] =  clusta_hist(dd, do, d_edges)

clust_bins = d_edges(1:end-1);

[~, ~, all_dist_bin]= histcounts(dd(:), d_edges);

all_clust = NaN(size(clust_bins));

for iB = 1:numel(d_edges)-1
    count = circ_r(do(all_dist_bin == iB)*2*pi/180);
    if ~isempty(count)
    all_clust(iB) = count;
    end
end

end