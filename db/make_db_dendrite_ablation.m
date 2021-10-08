i =0;

%% FR184 neuron 1 (FOV2)

i = i+1;

db(i).animal           = 'FR184';
db(i).mouse_name    = {'FR184', 'FR184'};
db(i).mouse_name_s2p    = {'FR184', 'FR184'};
db(i).date          = {'2021-03-22', '2021-03-24'};
db(i).date_s2p      = {'2021-03-22', '2021-03-24'};
db(i).expts         = {[3], [5 6 7]};
db(i).expID         = {[1], [2]};
db(i).plane         = [2, 2];
db(i).starterID     = 1;
db(i).stimList      = {[6:7:84, 85], [1:13]};
db(i).respWin       = [0 3];

db_abl(i).animal           = 'FR184';
db_abl(i).mouse_name    = {'FR184','FR184', 'FR184'};
db_abl(i).mouse_name_s2p    = {'FR184','FR184', 'FR184'};
db_abl(i).date              = {'2021-04-01', '2021-04-09', '2021-04-12'};
db_abl(i).date_s2p      = {'2021-04-01','2021-04-09', '2021-04-09'};
db_abl(i).expts         = {[5 6 7 9 10],  [ 13 14 9 10],  [ 13 14 9 10]}; 
db_abl(i).expID         = {[3]   ,   [2] , [3]};
db_abl(i).plane         = [2, 2, 2];
db_abl(i).starterID     = 1;
db_abl(i).stimList      = {[1:13],[1:13],[1:13]};
db_abl(i).ncut_dendrites     = [3  1];
db_abl(i).respWin       = [0 3];


%% FR184 neuron 2

i = i+1;

db(i).animal           = 'FR184';
db(i).mouse_name    = {'FR184', 'FR184'};
db(i).mouse_name_s2p    = {'FR184', 'FR184'};
db(i).date          = {'2021-03-22', '2021-03-24'};
db(i).date_s2p      = {'2021-03-22', '2021-03-24'};
db(i).expts         = {[3], [5 6 7]};
db(i).expID         = {[1], [2]};
db(i).plane         = [6, 6];
db(i).starterID     = 2;
db(i).stimList      = {[1:7:84, 85], [1:13]};
db(i).respWin       = [0 3];

db_abl(i).animal           = 'FR184';
db_abl(i).mouse_name    = {'FR184','FR184', 'FR184'};
db_abl(i).mouse_name_s2p    = {'FR184','FR184', 'FR184'};
db_abl(i).date              = {'2021-04-01', '2021-04-09', '2021-04-12'};
db_abl(i).date_s2p      = {'2021-04-01','2021-04-09', '2021-04-09'};
db_abl(i).expts         = {[5 6 7 9 10],  [ 13 14 9 10],  [ 13 14 9 10]}; 
db_abl(i).expID         = {[3]   ,   [1] , [4]};
db_abl(i).plane         = [6, 6, 6];
db_abl(i).starterID     = 2;
db_abl(i).stimList      = {[1:13],[1:13],[1:13]};
db_abl(i).ncut_dendrites     = [3  2];
db_abl(i).respWin       = [0 3];
%% FR184 neuron 7

i = i+1;

db(i).animal           = 'FR184';
db(i).mouse_name    = {'FR184','FR184'};
db(i).mouse_name_s2p    = {'FR184','FR184'};
db(i).date          = {'2021-03-22', '2021-03-24'};
db(i).date_s2p      = {'2021-03-22', '2021-03-24'};
db(i).expts         = {[3], [5 6 7]};
db(i).expID         = {[1], [2]};
db(i).plane         = [9, 9];
db(i).starterID     = 7;
db(i).stimList      = {[1:7:84, 85], [1:13]};
db(i).respWin       = [0 3];

db_abl(i).animal           = 'FR184';
db_abl(i).mouse_name    = {'FR184','FR184','FR184'};
db_abl(i).mouse_name_s2p    = {'FR184','FR184','FR184'};
db_abl(i).date              = {'2021-04-01', '2021-04-09', '2021-04-12'};
db_abl(i).date_s2p      = {'2021-04-01','2021-04-09', '2021-04-09'};
db_abl(i).expts         = {[5 6 7 9 10],  [ 13 14 9 10],  [ 13 14 9 10]}; 
db_abl(i).expID         = {[3]   ,   [2] , [3]};
db_abl(i).plane         = [9, 9, 9];
db_abl(i).starterID     = 7;
db_abl(i).stimList      = {[1:13],[1:13],[1:13]};
db_abl(i).ncut_dendrites     = [3  1];
db_abl(i).respWin       = [0 3];
%% FR184 neuron 8 (FOV1)

%% FR184 neuron 9

%% FR184 neuron 12

i = i+1;

db(i).animal           = 'FR184';
db(i).mouse_name    = {'FR184','FR184','FR184'};
db(i).mouse_name_s2p    = {'FR184','FR184','FR184'};
db(i).date          = {'2021-03-22', '2021-03-22', '2021-03-24'};
db(i).date_s2p      = {'2021-03-22', '2021-03-22','2021-03-24'};
db(i).expts         = {[1], [1],[1 2 3]};
db(i).expID         = {[1],[1], [2]};
db(i).plane         = [5, 5, 5];
db(i).starterID     = 12;
db(i).stimList      = {[6:7:84, 85], [5:7:84, 85],[1:13]}; %also responds to stim 5
db(i).respWin       = [0 3];


db_abl(i).animal           = 'FR184';
db_abl(i).mouse_name    = {'FR184','FR184','FR184'};
db_abl(i).mouse_name_s2p    = {'FR184','FR184','FR184'};
db_abl(i).date              = {'2021-04-01', '2021-04-09', '2021-04-12'};
db_abl(i).date_s2p      = {'2021-04-01','2021-04-09', '2021-04-09'};
db_abl(i).expts         = {[1 2 4],  [8 10 11 12 17 18 19],  [8 10 11 12 17 18 19]}; 
db_abl(i).expID         = {[2]   , [4] , [7]};
db_abl(i).plane         = [5, 5, 5];
db_abl(i).starterID     = 12;
db_abl(i).stimList      = {[1:13],[1:13],[1:13]};
db_abl(i).ncut_dendrites     = [3  1];
db_abl(i).respWin       = [0 3];
%% FR184 neuron 13

i = i+1;

db(i).animal           = 'FR184';
db(i).mouse_name    = {'FR184','FR184'};
db(i).mouse_name_s2p    = {'FR184','FR184'};
db(i).date          = {'2021-03-22', '2021-03-24'};
db(i).date_s2p      = {'2021-03-22', '2021-03-24'};
db(i).expts         = {[1], [1 2 3]};
db(i).expID         = {[1], [3]};
db(i).plane         = [5, 5];
db(i).starterID     = 13;
db(i).stimList      = {[6:7:84, 85], [1:13]}; %also responds to stim 5
db(i).respWin       = [0 3];

db_abl(i).animal           = 'FR184';
db_abl(i).mouse_name    = {'FR184','FR184','FR184'};
db_abl(i).mouse_name_s2p    = {'FR184','FR184','FR184'};
db_abl(i).date              = {'2021-04-01', '2021-04-09', '2021-04-12'};
db_abl(i).date_s2p      = {'2021-04-01','2021-04-09', '2021-04-09'};
db_abl(i).expts         = {[1 2 4],  [8 10 11 12 17 18 19],  [8 10 11 12 17 18 19]}; 
db_abl(i).expID         = {[3]   , [3] , [5]};
db_abl(i).plane         = [5, 5,5];
db_abl(i).starterID     = 13;
db_abl(i).stimList      = {[1:13],[1:13],[1:13]};
db_abl(i).ncut_dendrites     = [3  1];
db_abl(i).respWin       = [0 3];



%% FR184 neuron 15

i = i+1;

db(i).animal           = 'FR184';
db(i).mouse_name    = {'FR184','FR184'};
db(i).mouse_name_s2p    = {'FR184','FR184'};
db(i).date          = {'2021-03-22', '2021-03-24'};
db(i).date_s2p      = {'2021-03-22', '2021-03-24'};
db(i).expts         = {[1], [1 2 3]};
db(i).expID         = {[1], [1]};
db(i).plane         = [8, 8];
db(i).starterID     = 15;
db(i).stimList      = {[4:7:84, 85], [1:13]};
db(i).respWin       = [0 3];

db_abl(i).animal           = 'FR184';
db_abl(i).mouse_name    = {'FR184','FR184','FR184','FR184'};
db_abl(i).mouse_name_s2p    = {'FR184','FR184','FR184','FR184'};
db_abl(i).date              = {'2021-04-01', '2021-04-09', '2021-04-09','2021-04-12'};
db_abl(i).date_s2p      = {'2021-04-01','2021-04-09', '2021-04-09','2021-04-09'};
db_abl(i).expts         = {[1 2 4],  [8 10 11 12 17 18 19],  [8 10 11 12 17 18 19],[8 10 11 12 17 18 19]}; 
db_abl(i).expID         = {[1]   , [1] , [2] ,[6]};
db_abl(i).plane         = [8, 8, 8, 8];
db_abl(i).starterID     = 15;
db_abl(i).stimList      = {[1:13],[1:13],[1:13],[1:13]};
db_abl(i).ncut_dendrites     = [3  2];
db_abl(i).respWin       = [0 3];


%% FR184 neuron 16

i = i+1;

db(i).animal           = 'FR184';
db(i).mouse_name    = {'FR184','FR184'};
db(i).mouse_name_s2p    = {'FR184','FR184'};
db(i).date          = {'2021-03-22', '2021-03-24'};
db(i).date_s2p      = {'2021-03-22', '2021-03-24'};
db(i).expts         = {[1], [1 2 3]};
db(i).expID         = {[1], [2]};
db(i).plane         = [8, 8];
db(i).starterID     = 16;
db(i).stimList      = {[5:7:84, 85], [1:13]};  %also responds to stim 6
db(i).respWin       = [0 3];

db_abl(i).animal           = 'FR184';
db_abl(i).mouse_name    = {'FR184','FR184','FR184'};
db_abl(i).mouse_name_s2p    = {'FR184','FR184','FR184'};
db_abl(i).date              = {'2021-04-01', '2021-04-09', '2021-04-12'};
db_abl(i).date_s2p      = {'2021-04-01','2021-04-09', '2021-04-09'};
db_abl(i).expts         = {[1 2 4],  [8 10 11 12 17 18 19],  [8 10 11 12 17 18 19]}; 
db_abl(i).expID         = {[2]   , [4] , [7]};
db_abl(i).plane         = [8, 8,8 ];
db_abl(i).starterID     = 16;
db_abl(i).stimList      = {[1:13],[1:13],[1:13]};
db_abl(i).ncut_dendrites     = [3  1];
db_abl(i).respWin       = [0 3];


%% FR184 neuron 18 (FOV3)

i = i+1;

db(i).animal           = 'FR184';
db(i).mouse_name    = {'FR184','FR184'};
db(i).mouse_name_s2p    = {'FR184','FR184'};
db(i).date          = {'2021-03-23','2021-03-23'};
db(i).date_s2p      = {'2021-03-23','2021-03-23'};
db(i).expts         = {[2],[2]};
db(i).expID         = {[1],[1]};
db(i).plane         = [6, 6];
db(i).starterID     = 18;
db(i).stimList      = {[4:7:84, 85], [5:7:84, 85]}; 
db(i).respWin       = [0 3];

db_abl(i).animal           = 'FR184';
db_abl(i).mouse_name    = {'FR184','FR184','FR184'};
db_abl(i).mouse_name_s2p    = {'FR184','FR184','FR184'};
db_abl(i).date              = {'2021-04-01','2021-04-01','2021-04-01'};
db_abl(i).date_s2p      = {'2021-04-01','2021-04-01','2021-04-01'};
db_abl(i).expts         = {[12 13 14],  [12 13 14],  [12 13 14]}; 
db_abl(i).expID         = {[1]   , [2], [3]};
db_abl(i).plane         = [2, 2, 2];
db_abl(i).starterID     = 18;
db_abl(i).stimList      = {[1:13],[1:13],[1:13]};
db_abl(i).ncut_dendrites     = [3  2];
db_abl(i).respWin       = [0 3];
%% FR184 neuron 22 (FOV4) 

i = i+1;

db(i).animal           = 'FR184';
db(i).mouse_name    = {'FR184','FR184'};
db(i).mouse_name_s2p    = {'FR184','FR184'};
db(i).date          = {'2021-03-23', '2021-03-26'};
db(i).date_s2p      = {'2021-03-23', '2021-03-26'};
db(i).expts         = {[4], [6]};
db(i).expID         = {[1], [1]};
db(i).plane         = [2, 2];
db(i).starterID     = 22;
db(i).stimList      = {[1:7:84, 85], [1:13]};
db(i).respWin       = [0 3];

db_abl(i).animal           = 'FR184';
db_abl(i).mouse_name    = {'FR184','FR184'};
db_abl(i).mouse_name_s2p    = {'FR184','FR184'};
db_abl(i).date              = {'2021-04-01', '2021-04-09'};
db_abl(i).date_s2p      = {'2021-04-01','2021-04-09'};
db_abl(i).expts         = {[11],  [ 4 5 6 7]}; 
db_abl(i).expID         = {[1]   ,   [2] };
db_abl(i).plane         = [3, 2];
db_abl(i).starterID     = 22;
db_abl(i).stimList      = {[1:13],[1:13]};
db_abl(i).ncut_dendrites     = [3  1];
db_abl(i).respWin       = [0 3];


%% FR184 neuron 23
i = i+1;

db(i).animal           = 'FR184';
db(i).mouse_name    = {'FR184','FR184'};
db(i).mouse_name_s2p    = {'FR184','FR184'};
db(i).date          = {'2021-03-23', '2021-03-26'};
db(i).date_s2p      = {'2021-03-23', '2021-03-26'};
db(i).expts         = {[4], [6]};
db(i).expID         = {[1], [1]};
db(i).plane         = [5, 5];
db(i).starterID     = 23;
db(i).stimList      = {[1:7:84, 85], [1:13]};
db(i).respWin       = [0 3];

db_abl(i).animal           = 'FR184';
db_abl(i).mouse_name    = {'FR184','FR184','FR184','FR184','FR184','FR184','FR184','FR184','FR184'};
db_abl(i).mouse_name_s2p    = {'FR184','FR184','FR184','FR184','FR184','FR184','FR184','FR184','FR184'};
db_abl(i).date              = {'2021-04-01', '2021-04-01','2021-04-06','2021-04-07','2021-04-07','2021-04-09','2021-04-12','2021-04-12','2021-04-13'};
db_abl(i).date_s2p      = {'2021-04-01','2021-04-01','2021-04-06','2021-04-06','2021-04-06','2021-04-09', '2021-04-12','2021-04-12','2021-04-13'};
db_abl(i).expts         = {[11], [18 19], [14 2 3 4], [14 2 3 4], [14 2 3 4], [ 4 5 6 7], [14 15 16], [14 15 16],  [3 4]};
db_abl(i).expID         = {[1]   , [1],     [1],     [2],         [3],         [2] ,        [1],      [3],  [1]};
db_abl(i).plane         = [5, 3, 3, 3, 3, 4, 3, 3, 4];
db_abl(i).starterID     = 23;
db_abl(i).stimList      = {[1:13], [1:13], [1:7:84, 85], [1:13], [1:13], [1:13], [1:13], [1:13], [1:13]};
db_abl(i).ncut_dendrites     = [3  1];
db_abl(i).respWin       = [0 3];

% db_abl(i).animal           = 'FR184';
% db_abl(i).mouse_name    = {'FR184','FR184','FR184','FR184','FR184','FR184','FR184'};
% db_abl(i).mouse_name_s2p    = {'FR184','FR184','FR184','FR184','FR184','FR184','FR184'};
% db_abl(i).date              = {'2021-04-01', '2021-04-01','2021-04-06','2021-04-07','2021-04-07','2021-04-09','2021-04-12'};
% db_abl(i).date_s2p      = {'2021-04-01','2021-04-01','2021-04-06','2021-04-06','2021-04-06','2021-04-09', '2021-04-12'};
% db_abl(i).expts         = {[11], [18 19], [14 2 3 4], [14 2 3 4], [14 2 3 4], [ 4 5 6 7],  [11 13 15 16]};
% db_abl(i).expID         = {[1]   , [1],     [1],     [2],         [3],         [2] ,         [4]};
% db_abl(i).plane         = [5, 3, 3, 3, 3, 4, 3];
% db_abl(i).starterID     = 23;
% db_abl(i).stimList      = {[1:13], [1:13], [1:7:84, 85], [1:13], [1:13], [1:13], [1:13]};
% db_abl(i).ncut_dendrites     = [3  1];
% db_abl(i).respWin       = [0 3];


% db_abl(i).animal           = 'FR184';
% db_abl(i).mouse_name    = {'FR184','FR184','FR184'};
% db_abl(i).mouse_name_s2p    = {'FR184','FR184','FR184'};
% db_abl(i).date              = {'2021-04-07','2021-04-07','2021-04-09'};%,'2021-04-12','2021-04-12'};
% db_abl(i).date_s2p      = {'2021-04-06','2021-04-06','2021-04-09'};%, '2021-04-12','2021-04-12'};
% db_abl(i).expts         = {[14 2 3 4], [14 2 3 4], [ 4 5 6 7]}; %, [11 13 15 16], [11 13 15 16]};
% db_abl(i).expID         = {   [2],         [3],         [2] };%,        [2],      [4]};
% db_abl(i).plane         = [ 3, 3, 4];
% db_abl(i).starterID     = 23;
% db_abl(i).stimList      = { [1:13], [1:13], [1:13]};%, [1:13], [1:13]
% db_abl(i).ncut_dendrites     = [3  1];
% db_abl(i).respWin       = [0 3];
% 


%% FR184 neuron 27

i = i+1;

db(i).animal           = 'FR184';
db(i).mouse_name    = {'FR184','FR184','FR184'};
db(i).mouse_name_s2p    = {'FR184','FR184','FR184'};
db(i).date          = {'2021-04-06','2021-04-06','2021-04-07'};
db(i).date_s2p      = {'2021-04-06','2021-04-06','2021-04-06'};
db(i).expts         = {[14 2 3 4],[14 2 3 4],[14 2 3 4]};
db(i).expID         = {[1], [1],[4]};
db(i).plane         = [4,4, 4];
db(i).starterID     = 27;
db(i).stimList      = {[7:7:84, 85],[5:7:84, 85], [1:13]};
db(i).respWin       = [0 3];

db_abl(i).animal           = 'FR184';
db_abl(i).mouse_name    = {'FR184','FR184'};
db_abl(i).mouse_name_s2p    = {'FR184','FR184'};
db_abl(i).date              = {'2021-04-09','2021-04-12'};
db_abl(i).date_s2p      = {'2021-04-09', '2021-04-12'};
db_abl(i).expts         = { [ 4 5 6 7], [14 15 16]};
db_abl(i).expID         = {[4] ,        [2]};
db_abl(i).plane         = [4, 4, 4];
db_abl(i).starterID     = 27;
db_abl(i).stimList      = {[1:13] , [1:13]};
db_abl(i).ncut_dendrites     = [3  2];
db_abl(i).respWin       = [0 3];


%% FR187 neuron 2 (FOV1)

i = i+1;

db(i).animal           = 'FR187';
db(i).mouse_name    = {'FR187','FR187'};
db(i).mouse_name_s2p    = {'FR187','FR187'};
db(i).date          = {'2021-03-22', '2021-03-23'};
db(i).date_s2p      = {'2021-03-22', '2021-03-23'};
db(i).expts         = {[3], [1 2]};
db(i).expID         = {[1], [1]};
db(i).plane         = [4, 4];
db(i).starterID     = 2;
db(i).stimList      = {[1:7:84, 85], [1:13]};
db(i).respWin       = [0 3];

% db_abl(i).animal           = 'FR187';
% db_abl(i).mouse_name    = {'FR187','FR187','FR187','FR187'};%,'FR187'};
% db_abl(i).mouse_name_s2p    = {'FR187','FR187','FR187','FR187'};%,'FR187'};
% db_abl(i).date              = {'2021-03-31', '2021-03-31','2021-04-06','2021-04-12'};%,'2021-04-13'};
% db_abl(i).date_s2p      = {'2021-03-31','2021-03-31','2021-04-06','2021-04-12'};%,'2021-04-12'};
% db_abl(i).expts         = {[1 2 3], [1 2 3], [1], [6 7]};%, [6 7]};
% db_abl(i).expID         = {[1]    , [2],     [1], [1]};%,   [2]};
% db_abl(i).plane         = [4, 4, 4, 4];
% db_abl(i).starterID     = 2;
% db_abl(i).stimList      = {[1:13], [1:13], [1:13],[1:13]};%,[1:13]};
% db_abl(i).ncut_dendrites     = [3  2];
% db_abl(i).respWin       = [0 3];

db_abl(i).animal           = 'FR187';
db_abl(i).mouse_name    = {'FR187','FR187','FR187','FR187','FR187'};
db_abl(i).mouse_name_s2p    = {'FR187','FR187','FR187','FR187','FR187'};
db_abl(i).date              = {'2021-03-31', '2021-03-31','2021-04-06','2021-04-12','2021-04-13'};
db_abl(i).date_s2p      = {'2021-03-31','2021-03-31','2021-04-06','2021-04-12','2021-04-12'};
db_abl(i).expts         = {[1 2 3], [1 2 3], [1], [6 7], [6 7]};
db_abl(i).expID         = {[1]    , [2],     [1], [1],   [2]};
db_abl(i).plane         = [4, 4, 4, 4,4];
db_abl(i).starterID     = 2;
db_abl(i).stimList      = {[1:13], [1:13], [1:13],[1:13],[1:13]};
db_abl(i).ncut_dendrites     = [3  2];
db_abl(i).respWin       = [0 3];
%% FR187 neuron 3 (FOV2)

i = i+1;

db(i).animal           = 'FR187';
db(i).mouse_name    = {'FR187','FR187'};
db(i).mouse_name_s2p    = {'FR187','FR187'};
db(i).date          = {'2021-03-22', '2021-03-24'};
db(i).date_s2p      = {'2021-03-22', '2021-03-24'};
db(i).expts         = {[2], [2]};
db(i).expID         = {[1], [1]};
db(i).plane         = [7 2];
db(i).starterID     = 3;
db(i).stimList      = {[4:7:84, 85],[1:13]};
db(i).respWin       = [0 4];

db_abl(i).animal           = 'FR187';
db_abl(i).mouse_name    = {'FR187','FR187','FR187','FR187','FR187','FR187','FR187'};
db_abl(i).mouse_name_s2p    = {'FR187','FR187','FR187','FR187','FR187','FR187','FR187'};
db_abl(i).date              = {'2021-03-31', '2021-04-09', '2021-04-13', '2021-04-29',  '2021-05-04',  '2021-05-04','2021-05-08'};
db_abl(i).date_s2p      = {'2021-03-31', '2021-04-09', '2021-04-13', '2021-04-13',  '2021-05-04',  '2021-05-04','2021-05-08'};
db_abl(i).expts         = {[4 6 7], [2 3 4 5], [4 5 6 3 4 5 7],  [4 5 6 3 4 5 7], [3 4 5 6 7 8 9], [3 4 5 6 7 8 9], [ 3 4 5 6]};
db_abl(i).expID         = {[1], [1], [2], [5], [2], [6], [2]};
db_abl(i).plane         = [2 2 2 2 2 2 2];
db_abl(i).starterID     = 3;
db_abl(i).stimList      = {[1:13], [1:13], [1:13], [1:13], [1:13], [1:13], [1:13]};
db_abl(i).ncut_dendrites     = [3  1];
db_abl(i).respWin       = [0 4];

%% FR187 neuron 5

i = i+1;

db(i).animal           = 'FR187';
db(i).mouse_name    = {'FR187','FR187'};
db(i).mouse_name_s2p    = {'FR187','FR187'};
db(i).date          = {'2021-03-22', '2021-03-24'};
db(i).date_s2p      = {'2021-03-22', '2021-03-24'};
db(i).expts         = {[2], [1]};
db(i).expID         = {[1], [1]};
db(i).plane         = [10 5];
db(i).starterID     = 5;
db(i).stimList      = {[7:7:84, 85], [1:13]};
db(i).respWin       = [0 3];

% db_abl(i).animal           = 'FR187';
% db_abl(i).mouse_name    = {'FR187','FR187','FR187','FR187'};%,'FR187'};%,'FR187','FR187','FR187'};
% db_abl(i).mouse_name_s2p    = {'FR187','FR187','FR187','FR187'};%,'FR187'};%,'FR187','FR187','FR187'};
% db_abl(i).date              = {'2021-03-31', '2021-04-09','2021-04-09', '2021-04-13'};%, '2021-04-29'};%,  '2021-05-04',  '2021-05-04','2021-05-08'};
% db_abl(i).date_s2p      = {'2021-03-31', '2021-04-09', '2021-04-09', '2021-04-13'};%, '2021-04-13'};%,  '2021-05-04',  '2021-05-04','2021-05-08'};
% db_abl(i).expts         = {[4 6 7], [2 3 4 5], [2 3 4 5], [4 5 6 3 4 5 7]};%,  [4 5 6 3 4 5 7]};%, [3 4 5 6 7 8 9], [3 4 5 6 7 8 9], [ 3 4 5 6]};
% db_abl(i).expID         = {[2], [2], [4], [3]};%, [6]};%, [3], [6], [3]};
% db_abl(i).plane         = [4 4 4 4];% 4 4 4];
% db_abl(i).starterID     = 5;
% db_abl(i).stimList      = {[1:13], [1:13], [1:13], [1:13]};%, [1:13]};%, [1:13], [1:13], [1:13]};
% db_abl(i).ncut_dendrites     = [3  1];
% db_abl(i).respWin       = [0 3];

db_abl(i).animal           = 'FR187';
db_abl(i).mouse_name    = {'FR187','FR187','FR187','FR187','FR187','FR187','FR187','FR187'};
db_abl(i).mouse_name_s2p    = {'FR187','FR187','FR187','FR187','FR187','FR187','FR187','FR187'};
db_abl(i).date              = {'2021-03-31', '2021-04-09','2021-04-09', '2021-04-13', '2021-04-29',  '2021-05-04',  '2021-05-04','2021-05-08'};
db_abl(i).date_s2p      = {'2021-03-31', '2021-04-09', '2021-04-09', '2021-04-13', '2021-04-13',  '2021-05-04',  '2021-05-04','2021-05-08'};
db_abl(i).expts         = {[4 6 7], [2 3 4 5], [2 3 4 5], [4 5 6 3 4 5 7],  [4 5 6 3 4 5 7], [3 4 5 6 7 8 9], [3 4 5 6 7 8 9], [ 3 4 5 6]};
db_abl(i).expID         = {[2], [2], [4], [3] [6], [3], [6], [3]};
db_abl(i).plane         = [4 4 4 4 4 4 4 4];
db_abl(i).starterID     = 5;
db_abl(i).stimList      = {[1:13], [1:13], [1:13], [1:13], [1:13], [1:13], [1:13], [1:13]};
db_abl(i).ncut_dendrites     = [3  1];
db_abl(i).respWin       = [0 3];
%% FR187 neuron 6

i = i+1;

db(i).animal           = 'FR187';
db(i).mouse_name    = {'FR187', 'FR187', 'FR187'};
db(i).mouse_name_s2p    = {'FR187', 'FR187', 'FR187'};
db(i).date          = {'2021-03-22', '2021-03-22','2021-03-24'};
db(i).date_s2p      = {'2021-03-22', '2021-03-22','2021-03-24'};
db(i).expts         = {[2], [2], [1]};
db(i).expID         = {[1], [1], [1]};
db(i).plane         = [10 10 5];
db(i).starterID     = 6;
db(i).stimList      = {[7:7:84, 85], [1:7:84, 86], [1:13]};
db(i).respWin       = [0 3];

% db_abl(i).animal           = 'FR187';
% db_abl(i).mouse_name    = {'FR187','FR187','FR187','FR187','FR187'};%,'FR187'};%,'FR187','FR187'};%,'FR187','FR187','FR187','FR187','FR187','FR187'};
% db_abl(i).mouse_name_s2p    = {'FR187','FR187','FR187','FR187','FR187'};%,'FR187'};%,'FR187','FR187'};%,'FR187','FR187','FR187','FR187','FR187','FR187'};
% db_abl(i).date              = {'2021-03-31', '2021-03-31','2021-04-09','2021-04-09','2021-04-09'};%, '2021-04-13'};%, '2021-04-29',  '2021-04-29'};%,'2021-05-04','2021-05-04','2021-05-04',  '2021-05-04','2021-05-08', '2021-05-08'};
% db_abl(i).date_s2p      = {'2021-03-31', '2021-03-31','2021-04-09','2021-04-09', '2021-04-09'};%, '2021-04-13'};%, '2021-04-13',  '2021-04-13'};%,'2021-05-04','2021-05-04','2021-05-04',  '2021-05-04','2021-05-08', '2021-05-08'};
% db_abl(i).expts         = {[4 6 7], [4 6 7],[2 3 4 5],[2 3 4 5], [2 3 4 5]};%, [4 5 6 3 4 5 7]};%,  [4 5 6 3 4 5 7], [4 5 6 3 4 5 7]};%, [3 4 5 6 7 8 9],[3 4 5 6 7 8 9], [3 4 5 6 7 8 9], [3 4 5 6 7 8 9], [ 3 4 5 6], [ 3 4 5 6]};
% db_abl(i).expID         = {[2], [3],[2], [3], [4]};%, [3]};%, [6], [4]};%, [1],[5],[3], [6], [3], [1]};
% db_abl(i).plane         = [4 4 4 4 4];% 4];% 4 4 ];%4 4 4 4 4 4];
% db_abl(i).starterID     = 6;
% db_abl(i).stimList      = {[1:13], [1:13], [1:13], [1:13], [1:13]};%, [1:13]};%, [1:13], [1:13]};%, [1:13], [1:13], [1:13], [1:13], [1:13], [1:13]};
% db_abl(i).ncut_dendrites     = [3  2];
% db_abl(i).respWin       = [0 3];

db_abl(i).animal           = 'FR187';
db_abl(i).mouse_name    = {'FR187','FR187','FR187','FR187','FR187','FR187','FR187','FR187','FR187','FR187','FR187','FR187','FR187','FR187'};
db_abl(i).mouse_name_s2p    = {'FR187','FR187','FR187','FR187','FR187','FR187','FR187','FR187','FR187','FR187','FR187','FR187','FR187','FR187'};
db_abl(i).date              = {'2021-03-31', '2021-03-31','2021-04-09','2021-04-09','2021-04-09', '2021-04-13', '2021-04-29',  '2021-04-29','2021-05-04','2021-05-04','2021-05-04',  '2021-05-04','2021-05-08', '2021-05-08'};
db_abl(i).date_s2p      = {'2021-03-31', '2021-03-31','2021-04-09','2021-04-09', '2021-04-09', '2021-04-13', '2021-04-13',  '2021-04-13','2021-05-04','2021-05-04','2021-05-04',  '2021-05-04','2021-05-08', '2021-05-08'};
db_abl(i).expts         = {[4 6 7], [4 6 7],[2 3 4 5],[2 3 4 5], [2 3 4 5], [4 5 6 3 4 5 7],  [4 5 6 3 4 5 7], [4 5 6 3 4 5 7], [3 4 5 6 7 8 9],[3 4 5 6 7 8 9], [3 4 5 6 7 8 9], [3 4 5 6 7 8 9], [ 3 4 5 6], [ 3 4 5 6]};
db_abl(i).expID         = {[2], [3],[2], [3], [4], [3], [6], [4], [1],[5],[3], [6], [3], [1]};
db_abl(i).plane         = [4 4 4 4 4 4 4 4 4 4 4 4 4 4];
db_abl(i).starterID     = 6;
db_abl(i).stimList      = {[1:13], [1:13], [1:13], [1:13], [1:13], [1:13], [1:13], [1:13], [1:13], [1:13], [1:13], [1:13], [1:13], [1:13]};
db_abl(i).ncut_dendrites     = [3  2];
db_abl(i).respWin       = [0 3];


%% FR187 neuron 7 (FOV3)
% 
% i = i+1;
% 
% db(i).animal           = 'FR187';
% db(i).mouse_name    = {'FR187','FR187'};
% db(i).mouse_name_s2p    = {'FR187', 'FR187'};
% db(i).date          = {'2021-03-24', '2021-03-25', '2021-03-25'};
% db(i).date_s2p      = {'2021-03-24', '2021-03-25', '2021-03-25'};
% db(i).expts         = {[3 4], [4 5 6 7 8], [4 5 6 7 8]};
% db(i).expID         = {[1], [1], [5]};
% db(i).plane         = [5, 3, 3];
% db(i).starterID     = 7;
% db(i).stimList      = {[7:7:84, 85], [7:7:84, 85], [1:13]}; % second day not responding much...perhaps stim 4
% db(i).respWin       = [0 3];
% 
% db_abl(i).animal           = 'FR187';
% db_abl(i).mouse_name    = {'FR187','FR187','FR187'};
% db_abl(i).mouse_name_s2p    = {'FR187','FR187','FR187'};
% db_abl(i).date              = {'2021-04-01'};
% db_abl(i).date_s2p      = {'2021-04-01'};
% db_abl(i).expts         = {[1 2]};
% db_abl(i).expID         = {[1]};
% db_abl(i).plane         = [3];
% db_abl(i).starterID     = 7;
% db_abl(i).stimList      = {[1:13]};
% db_abl(i).ncut_dendrites     = [3  1];
% db_abl(i).respWin       = [0 3];


%% FR187 neuron 8

i = i+1;

db(i).animal           = 'FR187';
db(i).mouse_name    = {'FR187','FR187','FR187','FR187','FR187'};
db(i).mouse_name_s2p    = {'FR187', 'FR187','FR187','FR187','FR187'};
db(i).date          = {'2021-03-24','2021-03-24', '2021-03-25', '2021-03-25','2021-03-25'};
db(i).date_s2p      = {'2021-03-24', '2021-03-24','2021-03-25', '2021-03-25','2021-03-25'};
db(i).expts         = {[3 4], [3 4],[4 5 6 7 8], [4 5 6 7 8],[4 5 6 7 8]};
db(i).expID         = {[2],[2], [1], [1],[4]};
db(i).plane         = [7, 7, 5, 5, 5];
db(i).starterID     = 8;
db(i).stimList      = {[5:7:84, 85], [6:7:84, 85], [5:7:84, 85], [6:7:84, 85], [1:13]}; % can take away stim 5
db(i).respWin       = [0 3];

db_abl(i).animal           = 'FR187';
db_abl(i).mouse_name    = {'FR187','FR187','FR187'};
db_abl(i).mouse_name_s2p    = {'FR187','FR187','FR187'};
db_abl(i).date              = {'2021-03-31',  '2021-04-09', '2021-04-12'};
db_abl(i).date_s2p      = {'2021-03-31', '2021-04-09', '2021-04-09'};
db_abl(i).expts         = {[8 9 10], [6 7 7 8], [6 7 7 8]};
db_abl(i).expID         = {[3], [1], [4]};
db_abl(i).plane         = [5, 5, 5];
db_abl(i).starterID     = 8;
db_abl(i).stimList      = {[1:13], [1:13], [1:13]};
db_abl(i).ncut_dendrites     = [3  1];
db_abl(i).respWin       = [0 3];

%% FR187 neuron 10
i = i+1;

db(i).animal           = 'FR187';
db(i).mouse_name    = {'FR187','FR187', 'FR187'};
db(i).mouse_name_s2p    = {'FR187', 'FR187', 'FR187'};
db(i).date          = {'2021-03-24', '2021-03-25', '2021-03-25'};
db(i).date_s2p      = {'2021-03-24', '2021-03-25', '2021-03-25'};
db(i).expts         = {[3 4], [4 5 6 7 8], [4 5 6 7 8]};
db(i).expID         = {[2], [1], [3]};
db(i).plane         = [9, 7, 7];
db(i).starterID     = 10;
db(i).stimList      = {[1:7:84, 85], [1:7:84, 85], [1:13]};
db(i).respWin       = [0 2];

db_abl(i).animal           = 'FR187';
db_abl(i).mouse_name    = {'FR187','FR187','FR187'};
db_abl(i).mouse_name_s2p    = {'FR187','FR187','FR187'};
db_abl(i).date              = {'2021-03-31', '2021-04-09', '2021-04-12'}; 
db_abl(i).date_s2p      = {'2021-03-31',  '2021-04-09', '2021-04-09'}; % 04-01 was next to optimal ori
db_abl(i).expts         = {[8 9 10],  [6 7 7 8], [6 7 7 8]}; % '2021-04-01' , [1 2],[2],
db_abl(i).expID         = {[2], [2],  [3]};
db_abl(i).plane         = [7, 7 ,  7];
db_abl(i).starterID     = 10;
db_abl(i).stimList      = {[1:13], [1:13], [1:13], [1:13]};
db_abl(i).ncut_dendrites     = [3  2];
db_abl(i).respWin       = [0 2];



%% FR175 nenuron 2
i = i+1;

% db(i).mouse_name    = {'FR175', 'FR175'};
% db(i).mouse_name_s2p    = {'FR175', 'FR175'};
% db(i).date          = {'2020-11-30', '2020-12-07'};
% db(i).date_s2p      = {'2020-11-30', '2020-11-30'};
% db(i).expts         = {[3 5], [3 5]};
% db(i).expID         = {[1],[2]};
% db(i).plane         = [2, 2];
% db(i).starterD     = 2;
% db(i).stimList      = {[4:7:84, 85], [4:7:84, 85]};

db(i).animal           = 'FR175';
db(i).mouse_name    = {'FR175'};
db(i).mouse_name_s2p    = { 'FR175'};
db(i).date          = {'2020-12-07'};
db(i).date_s2p      = {'2020-11-30'};
db(i).expts         = {[3 5]};
db(i).expID         = {[2]};
db(i).plane         = [2];
db(i).starterID     = 2;
db(i).stimList      = {[4:7:84, 85]};
db(i).respWin       = [0 2];

db_abl(i).animal           = 'FR175';
db_abl(i).mouse_name    = {'FR175', 'FR175', 'FR175', 'FR175', 'FR175'};
db_abl(i).mouse_name_s2p    = {'FR175', 'FR175', 'FR175', 'FR175', 'FR175'};
db_abl(i).date              = {'2020-12-11', '2020-12-11', '2020-12-11', '2020-12-11', '2020-12-11'};
db_abl(i).date_s2p      = {'2020-11-30', '2020-11-30', '2020-11-30', '2020-11-30', '2020-11-30'};
db_abl(i).expts         = {[3 5 2 3 4 5 6], [3 5 2 3 4 5 6], [3 5 2 3 4 5 6], [3 5 2 3 4 5 6], [3 5 2 3 4 5 6]};
db_abl(i).expID         = {[4], [5], [5], [6], [6]};
db_abl(i).plane         = [2 2 2 2 2];
db_abl(i).starterID     = 2;
db_abl(i).stimList      = {[1:13], [4:7:84, 85],  [3:7:84, 85],  [4:7:84, 85] , [3:7:84, 85]};
db_abl(i).ncut_dendrites     = [3 1];
db_abl(i).respWin       = [0 2];

%% FR175 nenuron 3

i = i+1;
db(i).animal           = 'FR175';
db(i).mouse_name    = {'FR175', 'FR175', 'FR175'};
db(i).mouse_name_s2p    = {'FR175', 'FR175', 'FR175'};
db(i).date          = {'2020-11-30', '2020-12-07', '2020-12-07'};
db(i).date_s2p      = {'2020-11-30', '2020-11-30', '2020-11-30'};
db(i).expts         = {[3 5], [3 5], [3 5]};
db(i).expID         = {[1],[2],[2]};
db(i).plane         = [3, 3, 3];
db(i).starterID     = 3;
db(i).stimList      = {[6:7:84, 85], [6:7:84, 85], [5:7:84, 85]};
db(i).respWin       = [1 3];

db_abl(i).animal           = 'FR175';
db_abl(i).mouse_name    = {'FR175','FR175','FR175'};
db_abl(i).mouse_name_s2p    = {'FR175','FR175','FR175'};
db_abl(i).date              = {'2020-12-11', '2020-12-11', '2020-12-11'};
db_abl(i).date_s2p      = {'2020-11-30', '2020-11-30', '2020-11-30'};
db_abl(i).expts         = {[3 5 2 3 4 5 6], [3 5 2 3 4 5 6], [3 5 2 3 4 5 6]};
db_abl(i).expID         = {[3], [5], [5]};
db_abl(i).plane         = [3 3 3];
db_abl(i).starterID     = 3;
db_abl(i).stimList      = {[1:13], [5:7:84, 85], [6:7:84, 85]};
db_abl(i).ncut_dendrites     = [4  0];
db_abl(i).respWin       = [1 3];

%% FR175 nenuron 4

i = i+1;
db(i).animal           = 'FR175';
db(i).mouse_name    = {'FR175', 'FR175'};
db(i).mouse_name_s2p    = {'FR175', 'FR175'};
db(i).date          = {'2020-11-30', '2020-12-07'};
db(i).date_s2p      = {'2020-11-30', '2020-11-30'};
db(i).expts         = {[3 5 2 3 4 5 6], [3 5 2 3 4 5 6]};
db(i).expID         = {[1],[2]};
db(i).plane         = [4, 4];
db(i).starterID     = 4;
db(i).stimList      = {[3:7:84, 85], [3:7:84, 85]};
db(i).respWin       = [0 2];

db_abl(i).animal           = 'FR175';
db_abl(i).mouse_name    = {'FR175'};
db_abl(i).mouse_name_s2p    = {'FR175'};
db_abl(i).date              = {'2020-12-11', '2020-12-11', '2020-12-11', '2020-12-11'};
db_abl(i).date_s2p      = {'2020-11-30', '2020-11-30', '2020-11-30', '2020-11-30'};
db_abl(i).expts         = {[3 5 2 3 4 5 6], [3 5 2 3 4 5 6], [3 5 2 3 4 5 6], [3 5 2 3 4 5 6]};
db_abl(i).expID         = {[4], [5], [6], [7]};
db_abl(i).plane         = [4,4,4, 4];
db_abl(i).starterID     = 4;
db_abl(i).stimList      = {[1:13], [3:7:84, 85], [3:7:84, 85], [1:13]};
db_abl(i).ncut_dendrites     = [3 0];
db_abl(i).respWin       = [0 2];

%% FR175 nenuron 5

i = i+1;

db(i).animal           = 'FR175';
db(i).mouse_name    = {'FR175', 'FR175'};
db(i).mouse_name_s2p    = {'FR175', 'FR175'};
db(i).date          = {'2020-11-30', '2020-12-07'};
db(i).date_s2p      = {'2020-11-30', '2020-11-30'};
db(i).expts         = {[6 6 7], [6 6 7]};
db(i).expID         = {[1],[2]};
db(i).plane         = [4, 4];
db(i).starterID     = 5;
db(i).stimList      = {[1:7:84, 85], [1:13]};
db(i).respWin       = [0 3];

db_abl(i).animal           = 'FR175';
db_abl(i).mouse_name    = {'FR175'};
db_abl(i).mouse_name_s2p    = {'FR175'};
db_abl(i).date              = {'2020-12-11'};
db_abl(i).date_s2p      = {'2020-11-30'};
db_abl(i).expts         = {[6 6 7]};
db_abl(i).expID         = {[3]};
db_abl(i).plane         = [4];
db_abl(i).starterID     = 5;
db_abl(i).stimList      = {[1:13]};
db_abl(i).ncut_dendrites     = [3  0];
db_abl(i).respWin       = [0 3];

%% FR175 nenuron 7

i = i+1;
db(i).animal           = 'FR175';
db(i).mouse_name    = {'FR175', 'FR175', 'FR175'};
db(i).mouse_name_s2p    = {'FR175', 'FR175', 'FR175'};
db(i).date          = {'2020-12-08', '2020-12-08','2020-12-09'};
db(i).date_s2p      = {'2020-12-08', '2020-12-08','2020-12-08'};
db(i).expts         = {[3 4 14 8], [3 4 14 8], [3 4 14 8]};
db(i).expID         = {[1],[2],[3]};
db(i).plane         = [2, 2, 2];
db(i).starterID     = 7;
db(i).stimList      = {[1:13], [1:13], [1:13]};
db(i).respWin       = [0 2];

db_abl(i).animal           = 'FR175';
db_abl(i).mouse_name    = {'FR175'};
db_abl(i).mouse_name_s2p    = {'FR175'};
db_abl(i).date              = {'2020-12-10'};
db_abl(i).date_s2p      = {'2020-12-08'};
db_abl(i).expts         = {[3 4 14 8]};
db_abl(i).expID         = {[4]};
db_abl(i).plane         = [2];
db_abl(i).starterID     = 7;
db_abl(i).stimList      = {[1:13]};
db_abl(i).ncut_dendrites     = [3 0];
db_abl(i).respWin       = [0 2];

%% FR175 nenuron 8
i = i+1;
db(i).animal           = 'FR175';
db(i).mouse_name    = {'FR175'};
db(i).mouse_name_s2p    = {'FR175'};
db(i).date          = {'2020-12-08'};
db(i).date_s2p      = {'2020-12-08'};
db(i).expts         = {[1 9]};
db(i).expID         = {[1]};
db(i).plane         = [2];
db(i).starterID     = 8;
db(i).stimList      = {[1:13]};
db(i).respWin       = [0 2];

db_abl(i).animal           = 'FR175';
db_abl(i).mouse_name    = {'FR175'};
db_abl(i).mouse_name_s2p    = {'FR175'};
db_abl(i).date              = {'2020-12-10'};
db_abl(i).date_s2p      = {'2020-12-08'};
db_abl(i).expts         = {[1 9]};
db_abl(i).expID         = {[2]};
db_abl(i).plane         = [2];
db_abl(i).starterID     = 8;
db_abl(i).stimList      = {[1:13]};
db_abl(i).ncut_dendrites     = [3 0];
db_abl(i).respWin       = [0 2];

%% FR171 neuron 3

i = i+1;
db(i).animal           = 'FR171';
db(i).mouse_name    = {'FR171'};
db(i).mouse_name_s2p     = {'FR171'};
db(i).date          = {'2020-09-18'};
db(i).date_s2p      = {'2020-09-18'};
db(i).expts         = {[1 3]};
db(i).expID         = {[2]};
db(i).plane         = 2;
db(i).starterID     = 3;
db(i).stimList      = {[1:13]};
db(i).respWin       = [0 2];

db_abl(i).animal           = [];
db_abl(i).mouse_name    = [];
db_abl(i).mouse_name_s2p    = [];
db_abl(i).date              = [];
db_abl(i).date_s2p      = [];
db_abl(i).expts         = [];
db_abl(i).expID         = [];
db_abl(i).plane         = [];
db_abl(i).starterID     = [];
db_abl(i).stimList      = [];
db_abl(i).ncut_dendrites     = [];
db_abl(i).respWin       = [];


%% FR171 nenuron 11

i = i+1;
db(i).animal           = 'FR171';
db(i).mouse_name    = {'FR171', 'FR171'};
db(i).mouse_name_s2p    = {'FR171', 'FR171'};
db(i).date          = {'2020-09-24', '2020-10-03'};
db(i).date_s2p      = {'2020-09-24', '2020-09-24'};
db(i).expts         = {[6 9 1 2 1 2 3 1], [6 9 1 2 1 2 3 1]};
db(i).expID         = {[2],[4]};
db(i).plane         = [2, 2];
db(i).starterID     = 11;
db(i).stimList      = {[1:7:84, 85], [1:13]};
db(i).respWin       = [0 2];

db_abl(i).animal           = 'FR171';
db_abl(i).mouse_name    = {'FR171', 'FR171'};
db_abl(i).mouse_name_s2p    = {'FR171', 'FR171'};
db_abl(i).date              = {'2020-10-08', '2020-10-14'};
db_abl(i).date_s2p      = {'2020-09-24', '2020-09-24'};
db_abl(i).expts         = {[6 9 1 2 1 2 3 1], [6 9 1 2 1 2 3 1]};
db_abl(i).expID         = {[6],[8]};
db_abl(i).plane         = [2, 2];
db_abl(i).starterID     = 11;
db_abl(i).stimList      = {[1:13], [1:13]};
db_abl(i).ncut_dendrites     = [2 1];
db_abl(i).respWin       = [0 2];

%% %% FR171 nenuron 5

i = i+1;

db(i).animal           = 'FR171';
db(i).mouse_name    = {'FR171', 'FR171'};
db(i).mouse_name_s2p     = {'FR171', 'FR171'};
db(i).date          = {'2020-09-18', '2020-10-10'};
db(i).date_s2p      = {'2020-09-18', '2020-10-10'};
db(i).expts         = {[4 5], [1 2 5]};
db(i).expID         = {[2], [1]};
db(i).plane         = [4, 10];
db(i).starterID     = 5;
db(i).stimList      = {[1:13], [5:7:84, 85]};
db(i).respWin       = [0 2];

db_abl(i).animal           = 'FR171';
db_abl(i).mouse_name   = {'FR171', 'FR172'};
db_abl(i).mouse_name_s2p    = {'FR171', 'FR171'};
db_abl(i).date          = {'2020-10-11', '2020-10-14'};
db_abl(i).date_s2p      = {'2020-10-10', '2020-10-10'};
db_abl(i).expts         = {[1 2 5], [1 2 5]};
db_abl(i).expID         = {[2],[3]};
db_abl(i).plane         = [10, 10];
db_abl(i).starterID     = 5;
db_abl(i).stimList      = {[5:7:84, 85], [5:7:84, 85]};
db_abl(i).ncut_dendrites     = [4 1];
db_abl(i).respWin       = [0 2];



%% FR171 neuron 13

i = i+1;
db(i).animal           = 'FR171';
db(i).mouse_name    = {'FR171', 'FR171'};
db(i).mouse_name_s2p    = {'FR171', 'FR171'};
db(i).date          = {'2020-10-05', '2020-10-10'};
db(i).date_s2p      = {'2020-10-05','2020-10-10'};
db(i).expts         = {[3], [1 2 5]};
db(i).expID         = {[1], [1]};
db(i).plane         = [4, 4];
db(i).starterID     = 13;
db(i).stimList      = {[2:7:84, 85], [2:7:84, 85]};
db(i).respWin       = [0 2];

db_abl(i).animal           = 'FR171';
db_abl(i).mouse_name    = {'FR171', 'FR172'};
db_abl(i).mouse_name_s2p    = {'FR171', 'FR171'};
db_abl(i).date              = {'2020-10-11', '2020-10-14'};
db_abl(i).date_s2p      = {'2020-10-10', '2020-10-10'};
db_abl(i).expts         = {[1 2 5], [1 2 5]};
db_abl(i).expID         = {[2],[3]};
db_abl(i).plane             = [4, 4];
db_abl(i).starterID     = 13;
db_abl(i).stimList      = {[2:7:84, 85], [2:7:84, 85]};
db_abl(i).ncut_dendrites     = [3 1];
db_abl(i).respWin       = [0 2];

%% FR171 neuron 15

i = i+1;
db(i).animal           = 'FR171';
db(i).mouse_name    = {'FR171', 'FR171','FR171', 'FR171'};
db(i).mouse_name_s2p    = {'FR171', 'FR171','FR171', 'FR171'};
db(i).date          = {'2020-10-05', '2020-10-10','2020-10-05', '2020-10-10'};
db(i).date_s2p      = {'2020-10-05','2020-10-10','2020-10-05', '2020-10-10'};
db(i).expts         = {[3], [1 2 5],[3], [1 2 5]};
db(i).expID         = {[1], [1],[1], [1]};
db(i).plane         = [5, 5,5,5];
db(i).starterID     = 15;
db(i).stimList      = {[2:7:84, 85], [2:7:84, 85],[7:7:84, 85], [7:7:84, 85]};
db(i).respWin       = [0 2];

db_abl(i).animal           = 'FR171';
db_abl(i).mouse_name    = {'FR171', 'FR172','FR171', 'FR172'};
db_abl(i).mouse_name_s2p    = {'FR171', 'FR171','FR171', 'FR171'};
db_abl(i).date              = {'2020-10-11', '2020-10-14','2020-10-11', '2020-10-14'};
db_abl(i).date_s2p      = {'2020-10-10', '2020-10-10','2020-10-10', '2020-10-10'};
db_abl(i).expts         = {[1 2 5], [1 2 5],[1 2 5], [1 2 5]};
db_abl(i).expID         = {[2],[3],[2],[3]};
db_abl(i).plane             = [5, 5,5,5];
db_abl(i).starterID     = 15;
db_abl(i).stimList    = {[2:7:84, 85], [2:7:84, 85],[7:7:84, 85], [7:7:84, 85]};
db_abl(i).ncut_dendrites     = [4 1]; 
db_abl(i).respWin       = [0 2];

%% neuron 18

i = i+1;
db(i).animal           = 'FR171';
db(i).mouse_name   = {'FR171', 'FR171','FR171', 'FR171'};
db(i).mouse_name_s2p    = {'FR171', 'FR171','FR171', 'FR171'};
db(i).date          = {'2020-10-05', '2020-10-10','2020-10-05', '2020-10-10'};
db(i).date_s2p      = {'2020-10-05', '2020-10-10','2020-10-05', '2020-10-10'};
db(i).expts         = {[3],  [1 2 5], [3],  [1 2 5],};
db(i).expID         = {[1], [1], [1], [1]};
db(i).plane         = [9, 9, 9, 9 ];
db(i).starterID     = 18;
db(i).stimList      = {[3:7:84, 85], [3:7:84, 85],[6:7:84, 85], [6:7:84, 85]};
db(i).respWin       = [0 2];

db_abl(i).animal           = 'FR171';
db_abl(i).mouse_name   = {'FR171', 'FR172','FR171', 'FR172'};
db_abl(i).mouse_name_s2p    = {'FR171', 'FR171','FR171', 'FR171'};
db_abl(i).date          = {'2020-10-11', '2020-10-14','2020-10-11', '2020-10-14'};
db_abl(i).date_s2p      = {'2020-10-10', '2020-10-10','2020-10-10', '2020-10-10'};
db_abl(i).expts         = { [1 2 5], [1 2 5],[1 2 5], [1 2 5]};
db_abl(i).expID         = {[2], [3],[2], [3]};
db_abl(i).plane             = [9, 9,9 ,9 ];
db_abl(i).starterID     = 18;
db_abl(i).stimList      = {[3:7:84, 85], [3:7:84, 85],[6:7:84, 85], [6:7:84, 85]};
db_abl(i).ncut_dendrites     = [1 1];
db_abl(i).respWin       = [0 2];

%% #6: FR172 neuron 4

i = i+1;
db(i).animal           = 'FR172';
db(i).mouse_name   = {'FR172','FR172'};
db(i).mouse_name_s2p    = {'FR172','FR172'};
db(i).date          = {'2020-10-29','2020-10-29'};
db(i).date_s2p      = {'2020-10-29','2020-10-29'};
db(i).expts         = {[2],[2]};
db(i).expID         = {[1], [1]};
db(i).plane         = [8,8];
db(i).starterID     = 4;
db(i).stimList      = {[2:7:84, 85], [6:7:84, 85]};
db(i).respWin       = [0 2];

db_abl(i).animal           = 'FR172';
db_abl(i).mouse_name   = {'FR166'};
db_abl(i).mouse_name_s2p    = {'FR166'};
db_abl(i).date          = {'2020-11-06'};
db_abl(i).date_s2p      = {'2020-11-06'};
db_abl(i).expts         = {[2 3]};
db_abl(i).expID         = {[1]};
db_abl(i).plane             = [5];
db_abl(i).starterID     = 4;
db_abl(i).stimList      = {[1:13]};
db_abl(i).ncut_dendrites     = [1 1];
db_abl(i).respWin       = [0 2];


%% #7: FR172 neuron 7
i = i+1;

db(i).animal           = 'FR172';
db(i).mouse_name   = {'FR172','FR172','FR172'};
db(i).mouse_name_s2p    = {'FR172','FR172','FR172'};
db(i).date          = {'2020-10-29','2020-10-29','2020-10-29'};
db(i).date_s2p      = {'2020-10-29','2020-10-29','2020-10-29'};
db(i).expts         = {[2],[2],[2]};
db(i).expID         = {[1], [1], [1]};
db(i).plane         = [8,8,8];
db(i).starterID     = 7;
db(i).stimList      = {[2:7:84, 85], [5:7:84, 85], [6:7:84, 85]};
db(i).respWin       = [0 2];

db_abl(i).animal           = 'FR172';
db_abl(i).mouse_name   = {'FR166'};
db_abl(i).mouse_name_s2p    = {'FR166'};
db_abl(i).date          = {'2020-11-06'};
db_abl(i).date_s2p      = {'2020-11-06'};
db_abl(i).expts         = { [2 3]};
db_abl(i).expID         = {[1]};
db_abl(i).plane             = [5];
db_abl(i).starterID     = 7;
db_abl(i).stimList      = {[1:13]};
db_abl(i).ncut_dendrites     = [1 1];
db_abl(i).respWin       = [0 2];

%% #8: FR172 neuron 6
i = i+1;

db(i).animal           = 'FR172';
db(i).mouse_name   = {'FR172'};
db(i).mouse_name_s2p    = {'FR172'};
db(i).date          = {'2020-10-29'};
db(i).date_s2p      = {'2020-10-29'};
db(i).expts         = {[4]};
db(i).expID         = {[1]};
db(i).plane         = [3];
db(i).starterID     = 6;
db(i).stimList      = {[1:13]};
db(i).respWin       = [0 2];

db_abl(i).animal           = 'FR172';
db_abl(i).mouse_name   = {'FR166'};
db_abl(i).mouse_name_s2p    = {'FR166'};
db_abl(i).date          = {'2020-11-06'};
db_abl(i).date_s2p      = {'2020-11-06'};
db_abl(i).expts         = { [2 3]};
db_abl(i).expID         = {[1]};
db_abl(i).plane             = [3];
db_abl(i).starterID     = 6;
db_abl(i).stimList      = {[1:13]};
db_abl(i).ncut_dendrites     = [2 1];
db_abl(i).respWin       = [0 2];


%% FR172 neuron 5 (killed by photoablation)

i = i+1;

db(i).animal           = 'FR172';
db(i).mouse_name   = {'FR172'};
db(i).mouse_name_s2p    = {'FR172'};
db(i).date          = {'2020-10-29'};
db(i).date_s2p      = {'2020-10-29'};
db(i).expts         = {[4]};
db(i).expID         = {[1]};
db(i).plane         = [2];
db(i).starterID     = 5;
db(i).stimList      = {[1:13]};
db(i).respWin       = [0 2];


%% #9: FR156 neuron 1

i = i+1;
db(i).animal           = 'FR156';
db(i).mouse_name    = {'FR156','FR156','FR156','FR156','FR156','FR156'};
db(i).mouse_name_s2p    = {'FR156','FR156','FR156','FR156','FR156','FR156'};
db(i).date          = {'2020-03-11','2020-03-11','2020-03-11','2020-03-11','2020-03-11','2020-03-11'};
db(i).date_s2p          = {'2020-03-11','2020-03-11','2020-03-11','2020-03-11','2020-03-11','2020-03-11'};
db(i).expts         = {[1],[1],[1],[1],[1],[1]};
db(i).expID         = {[1], [1], [1], [1], [1], [1] };
db(i).plane             = [4,4,4,4,4,4,4];
db(i).starterID     = 1;
db(i).stimList      = {[1:7:84, 85],[2:7:84, 85],[3:7:84, 85],[5:7:84, 85],[6:7:84, 85],[7:7:84, 85]};
db(i).respWin       = [0 2];

db_abl(i).animal           ='FR156';
db_abl(i).mouse_name    = {'FR157','FR157','FR157','FR157','FR157','FR157'};
db_abl(i).mouse_name_s2p    = {'FR157','FR157','FR157','FR157','FR157','FR157'};
db_abl(i).date          = {'2020-03-13', '2020-03-13','2020-03-13','2020-03-13', '2020-03-13', '2020-03-13'};
db_abl(i).date_s2p          = {'2020-03-13', '2020-03-13','2020-03-13','2020-03-13', '2020-03-13', '2020-03-13'};
db_abl(i).expts         = {[1],[1],[1],[1],[1],[1]};
db_abl(i).expID         = {[1], [1], [1], [1], [1], [1] };
db_abl(i).plane             = [4,4,4,4,4,4,4];
db_abl(i).starterID     = 1;
db_abl(i).stimList      = {[1:7:84, 85],[2:7:84, 85],[3:7:84, 85],[5:7:84, 85],[6:7:84, 85],[7:7:84, 85]};
db_abl(i).ncut_dendrites     = [1 1]; 
db_abl(i).respWin       = [0 2];

%% #10: FR156 neuron 2
i = i+1;
db(i).animal           = 'FR156';
db(i).mouse_name    = {'FR156','FR156','FR156','FR156','FR156','FR156'};
db(i).mouse_name_s2p    = {'FR156','FR156','FR156','FR156','FR156','FR156'};
db(i).date          = {'2020-03-11','2020-03-11','2020-03-11','2020-03-11','2020-03-11','2020-03-11'};
db(i).date_s2p          = {'2020-03-11','2020-03-11','2020-03-11','2020-03-11','2020-03-11','2020-03-11'};
db(i).expts         = {[1],[1],[1],[1],[1],[1]};
db(i).expID         = {[1], [1], [1], [1], [1], [1] };
db(i).plane             = [2,2,2,2,2,2,2];
db(i).starterID     = 2;
db(i).stimList      = {[1:7:84, 85],[2:7:84, 85],[3:7:84, 85],[5:7:84, 85],[6:7:84, 85],[7:7:84, 85]};
db(i).respWin       = [0 2];

db_abl(i).animal           = 'FR156';
db_abl(i).mouse_name    = {'FR157','FR157','FR157','FR157','FR157','FR157'};
db_abl(i).mouse_name_s2p    = {'FR157','FR157','FR157','FR157','FR157','FR157'};
db_abl(i).date          = {'2020-03-13', '2020-03-13','2020-03-13','2020-03-13', '2020-03-13', '2020-03-13'};
db_abl(i).date_s2p          = {'2020-03-13', '2020-03-13','2020-03-13','2020-03-13', '2020-03-13', '2020-03-13'};
db_abl(i).expts         = {[1],[1],[1],[1],[1],[1]};
db_abl(i).expID         = {[1], [1], [1], [1], [1], [1] };
db_abl(i).plane             = [2,2,2,2,2,2,2];
db_abl(i).starterID     = 2;
db_abl(i).stimList      = {[1:7:84, 85],[2:7:84, 85],[3:7:84, 85],[5:7:84, 85],[6:7:84, 85],[7:7:84, 85]};
db_abl(i).ncut_dendrites     = [2 1];
db_abl(i).respWin       = [0 2];

