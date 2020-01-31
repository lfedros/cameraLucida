
% initialise matrix size

dA1 = (tree1.dA)';
dA2 = (tree2.dA)';

[m , ~] = size(dA1);
[n , ~] = size(dA2);

mergeA = zeros( m + n - 1);
mergeA( 1:m , 1:m ) = dA1;
mergeA( m + 1: m + n - 1 , m + 1: m + n - 1 ) = dA2( 2:n, 2:n );

% made it zeros, not ones
mergeA( : , 1) = 0;
dA = sparse(mergeA);

X = [tree1.X ; tree2.X( 2:end ) ];
Y = [tree1.Y ; tree2.Y( 2:end ) ];

figure; 
gplot(dA, [X, Y], 'k'); hold on; axis image
