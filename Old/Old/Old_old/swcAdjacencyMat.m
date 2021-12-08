function dA = swcAdjacencyMat(parent)
%% buids the adjacency matrix for a graph specified by the 'parent' info in an swc file

nn = numel(parent);

dA = zeros(nn, nn);

for iN = 2:nn
    
    dA(iN, parent(iN)) = 1;
    
end

end