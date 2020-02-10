% DENSITYPLOT 	average density plot of all neurons 
% 
% See also: DENSITYNEURON
% 2020 N Ghani and LF Rossi


load('neuronData.mat'); % load data
n = length(neuronData);
densityNeuron( neuronData, 1:n ); % non-shuffle in visual space
print( 'AE' , '-dpng' );
densityNeuron( neuronData, randperm(n) ); % shuffle in visual space
print( 'AE_shuffle', '-dpng' );