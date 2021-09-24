i = 0;

if ispc
     data_repo = '\\zserver.cortexlab.net\Lab\Share\Naureen';
else
end
%% Single neuron electroporation datasets

i = i+1;
db(i).animal = 'FR068';
db(i).neuron_id = 1;
db(i).data_repo = data_repo;
db(i).tilt = [1.800967143, 2.201579204]; % (rc, ml)

i = i+1;
db(i).animal = 'FR087';
db(i).neuron_id = 1;
db(i).data_repo = data_repo;
db(i).tilt = [1.374790804, 1.023856411]; % (rc, ml)

i = i+1;
db(i).animal = 'FR090';
db(i).neuron_id = 1;
db(i).data_repo = data_repo;
db(i).tilt = [0.6703031461, 0.4772609728]; % (rc, ml)

i = i+1;
db(i).animal = 'FR090';
db(i).neuron_id = 2;
db(i).data_repo = data_repo;
db(i).tilt = [0.5036700684, 0]; % (rc, ml)

i = i+1;
db(i).animal = 'FR092';
db(i).neuron_id = 1;
db(i).data_repo = data_repo;
db(i).tilt = [0.315168242, 0]; % (rc, ml)

i = i+1;
db(i).animal = 'FR101';
db(i).neuron_id = 1;
db(i).data_repo = data_repo;
db(i).tilt = [3.475381031, 0]; % (rc, ml)

i = i+1;
db(i).animal = 'FR103';
db(i).neuron_id = 1;
db(i).data_repo = data_repo;
db(i).tilt = [1.925801441, 0]; % (rc, ml)

i = i+1;
db(i).animal = 'FR109';
db(i).neuron_id = 1;
db(i).data_repo = data_repo;
db(i).tilt = [0.5214456942, 0]; % (rc, ml)

i = i+1;
db(i).animal = 'FR115';
db(i).neuron_id = 1;
db(i).data_repo = data_repo;
db(i).tilt = [3.31271438, 0]; % (rc, ml)

i = i+1;
db(i).animal = 'FR128';
db(i).neuron_id = 1;
db(i).data_repo = data_repo;
db(i).tilt = [1.929513652,-1.281423529]; % (rc, ml)

i = i+1;
db(i).animal = 'FR130';
db(i).neuron_id = 1;
db(i).data_repo = data_repo;
db(i).tilt = [3.213414699,0]; % (rc, ml)

i = i+1;
db(i).animal = 'FR141';
db(i).neuron_id = 1;
db(i).data_repo = data_repo;
db(i).tilt = [4.086896883,3.08253402]; % (rc, ml)

i = i+1;
db(i).animal = 'FR141';
db(i).neuron_id = 2;
db(i).data_repo = data_repo;
db(i).tilt = [3.95565363,6.654985646]; % (rc, ml)

i = i+1;
db(i).animal = 'FR140';
db(i).neuron_id = 1;
db(i).data_repo = data_repo;
db(i).tilt = [0,1.257666364]; % (rc, ml)

i = i+1;
db(i).animal = 'FR146';
db(i).neuron_id = 1;
db(i).data_repo = data_repo;
db(i).tilt = [0,0]; % (rc, ml)

i = i+1;
db(i).animal = 'FR146';
db(i).neuron_id = 2;
db(i).data_repo = data_repo;
db(i).tilt = [0,0]; % (rc, ml)

% i = i+1;
% db(i).animal = 'FR148';
% db(i).neuron_id = 1;
% db(i).data_repo = data_repo;
% db(i).tilt = [0,0]; % (rc, ml)

i = i+1;
db(i).animal = 'FR150';
db(i).neuron_id = 1;
db(i).data_repo = data_repo;
db(i).tilt = [0,0]; % (rc, ml)

%% Sparse labelling datasets

i = i+1;
db(i).animal = 'FR171';
db(i).neuron_id = 11;
db(i).zStackRef = {'FR171', '2020-09-25', 1};
db(i).data_repo = data_repo;
db(i).tilt = [0,0]; % (rc, ml)

i = i+1;
db(i).animal = 'FR171';
db(i).neuron_id = 3;
db(i).zStackRef = {'FR171', '2020-09-19', 1};
db(i).data_repo = data_repo;
db(i).tilt = [0,0]; % (rc, ml)

i = i+1;
db(i).animal = 'FR171';
db(i).neuron_id = 5;
db(i).zStackRef = {'FR171', '2020-09-19', 1};
db(i).data_repo = data_repo;
db(i).tilt = [0,0]; % (rc, ml)

i = i+1;
db(i).animal = 'FR172';
db(i).neuron_id = 4;
db(i).zStackRef = {'FR175', '2020-10-29', 5};
db(i).data_repo = data_repo;
db(i).tilt = [0,0]; % (rc, ml)

i = i+1;
db(i).animal = 'FR172';
db(i).neuron_id = 5;
db(i).zStackRef = {'FR175', '2020-10-29', 5};
db(i).data_repo = data_repo;
db(i).tilt = [0,0]; % (rc, ml)

i = i+1;
db(i).animal = 'FR172';
db(i).neuron_id = 6;
db(i).zStackRef = {'FR175', '2020-10-29', 5};
db(i).data_repo = data_repo;
db(i).tilt = [0,0]; % (rc, ml)

i = i+1;
db(i).animal = 'FR172';
db(i).neuron_id = 7;
db(i).zStackRef = {'FR175', '2020-10-29', 5};
db(i).data_repo = data_repo;
db(i).tilt = [0,0]; % (rc, ml)

i = i+1;
db(i).animal = 'FR175';
db(i).neuron_id = 2;
db(i).zStackRef = {'FR175', '2020-12-07', 2};
db(i).data_repo = data_repo;
db(i).tilt = [0,0]; % (rc, ml)

i = i+1;
db(i).animal = 'FR175';
db(i).neuron_id = 3;
db(i).zStackRef = {'FR175', '2020-12-07', 2};
db(i).data_repo = data_repo;
db(i).tilt = [0,0]; % (rc, ml)

i = i+1;
db(i).animal = 'FR175';
db(i).neuron_id = 4;
db(i).zStackRef = {'FR175', '2020-12-07', 2};
db(i).data_repo = data_repo;
db(i).tilt = [0,0]; % (rc, ml)

i = i+1;
db(i).animal = 'FR175';
db(i).neuron_id = 5;
db(i).zStackRef = {'FR175', '2020-11-30', 7};
db(i).data_repo = data_repo;
db(i).tilt = [0,0]; % (rc, ml)

i = i+1;
db(i).animal = 'FR175';
db(i).neuron_id = 7;
db(i).zStackRef = {'FR175', '2020-12-07', 13};
db(i).data_repo = data_repo;
db(i).tilt = [0,0]; % (rc, ml)

i = i+1;
db(i).animal = 'FR175';
db(i).neuron_id = 8;
db(i).zStackRef = {'FR175', '2020-10-29', 12};
db(i).data_repo = data_repo;
db(i).tilt = [0,0]; % (rc, ml)



