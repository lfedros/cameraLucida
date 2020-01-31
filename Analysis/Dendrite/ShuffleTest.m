function [avg_hist_s] = ShuffleTest ( n_shuffles )

% SHUFFLETEST will repeat iterations of SHUFFLEDIR

histData_f = cell(1);
prefDir = cell(1);
avgAng = cell(1);
thetaData_s = cell(1);
% 
% % create corresp db for num of shuffles
% % create 1 matrix 10x10
% n_cells = length ( db.prefDir );
% rng('shuffle');
% b = mod(bsxfun(@plus, randperm( n_cells ), transpose(randperm( n_shuffles ))), 10 ) + 1;

histData = load( 'C:\Users\Experiment\cameraLucida\Density\thetaMaps.mat');
thetaMaps = histData.thetaMaps;

dbData = load('db.mat');
db = dbData.db;

for i = 1 : n_shuffles
    fname = strcat('iter_',num2str(i));
%     db.prefDir = db.prefDir( b(i,:) );
    [thetaData_s{i, 1}, histData_f{i,1}, prefDir{i,1}, avgAng{i,1} ] = ShuffleDir ( thetaMaps, db, fname );
end

% save('histData_f','histData_f');
% save('prefDir','prefDir');
% save('avgAng','avgAng');

avg_hist_s = reshape( cell2mat(histData_f), 36, n_shuffles );
avg_hist_s = mean( avg_hist_s, 2 );

end
