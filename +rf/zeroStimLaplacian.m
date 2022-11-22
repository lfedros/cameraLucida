function L = zeroStimLaplacian(stimFrames)

[xPx, yPx, ~] = size(stimFrames);
nPx = xPx*yPx;

l = zeros(xPx+2, yPx+2);
l(2,2) = 4;
l(2,[1 3]) = -1;
l([1 3], 2) = -1;
l = l(:);

L = zeros((xPx+2)*(yPx+2), nPx);

toTile = 1:(xPx+2)*(yPx+2);
toTile = reshape(toTile, (xPx+2),(yPx+2));
toTile = toTile(2:end-1, 2:end-1);

for iPx = 1:nPx
    L(:, iPx) = circshift(l, toTile(iPx)-toTile(1));  
end

L = reshape(L, xPx+2, yPx+2, nPx);
L = L(2:end-1, 2:end-1, :);

peaks = find(L==4); 

corners = peaks([1 xPx, nPx-xPx+1, nPx]);
sides = peaks([1:xPx, nPx-xPx+1:nPx, 1:xPx:nPx, xPx:xPx:nPx]);

L(sides) = 3; 
L(corners) = 2;

end