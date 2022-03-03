function [new_walk, extrap_walk] = extrapolate_walk(walk, sz)

if nargin < 2
sz = [1, 512];
end

%extrapolate to edge of image
start =walk(1,:);
last = walk(end,:);


fit_walk = fitlm(walk(:,2)-last(2), walk(:, 1)-last(1), 'y ~ -1 + x1');
% fit_walk = fitlm(walk(:,2), walk(:, 1), 'y ~ -1 + x1');

if last(2)>=start(2) % upper rigth quad & bottom rigth quad

extrap_j = last(2):sz(2);
extrap_j = extrap_j-last(2);
extrap_path = predict(fit_walk, extrap_j');
extrap_walk = [extrap_path,extrap_j'];


elseif last(2)<start(2) % bottomleft quad & upper left quad
extrap_j = sz(1):last(2);
extrap_j = extrap_j-last(2);
extrap_path = predict(fit_walk, extrap_j');
extrap_walk = flip([extrap_path,extrap_j'],1);


end

extrap_walk = bsxfun(@plus, extrap_walk, last);

extrap_walk(extrap_walk(:,1)>sz(2)+range(sz)/10 | extrap_walk(:,2)>sz(2)+range(sz)/10, :) = [];
extrap_walk(extrap_walk(:,1)<sz(1)-range(sz)/10 | extrap_walk(:,2)<sz(1)-range(sz)/10, :) = [];

new_walk = cat(1, walk, extrap_walk);

end