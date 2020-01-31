% Center of Mass Theta Analysis

[rtree, order] = sort_tree(tree,'-LO');
[sect, vec] = dissect_tree(rtree);

B = B_tree ( tree );
[a,b] = find( B==1 );
test = ipar_tree( tree, '-s' );
[m,n] = size( sect ); 
sect_val = reshape( sect, m*n , 1 );
sect_val = unique( sect_val );

% example

branch_mem = cell(1);
for i = 1:length( sect_val )
    branch_mem{i} = nonzeros ( test ( sect_val( i,1 ), :) );
end

% find start + end nodes

thetaMap = zeros( length(X), 1);
for n = 1:length( branch_mem )
    test_branch = branch_mem{1,n};
    p = polyfit( X(test_branch), Y(test_branch), 1 );
    theta = atan(p(1)).*(180/pi);
    thetaMap(test_branch) = theta;
end
