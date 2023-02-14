function set_dendrite_paths()

if ispc
    code_repo = 'C:\Users\Federico\Documents\GitHub\cameraLucida';
    addpath(code_repo);
    
    addpath(fullfile(code_repo, 'Plotting'));
    addpath(fullfile(code_repo, 'Pre_proc'));
    addpath(fullfile(code_repo, 'Utils'));
    
    addpath('C:\Users\Federico\Documents\GitHub\Dbs\V1_dendrites');
    %https://github.com/lfedros/Dbs
    addpath(genpath('C:\Users\Federico\Documents\GitHub\FedBox'));
    %https://github.com/lfedros/FedBox
    addpath('C:\Users\Federico\Documents\GitHub\circstat-matlab');
    %https://github.com/circstat/circstat-matlab
    addpath(genpath('C:\Users\Federico\Documents\GitHub\treestoolbox'));
    %https://github.com/cuntzlab/treestoolbox
    cd(code_repo);
    %https://github.com/cortex-lab/Suite2P
    addpath('C:\Users\Federico\Documents\GitHub\Suite2P_Matlab\svd');
    addpath('C:\Users\Federico\Documents\GitHub\Suite2P_Matlab\utils');
    addpath('C:\Users\Federico\Documents\GitHub\Suite2P_Matlab\tiffTools');

else
    home = '/Users/federico';
    code_repo = fullfile(home, 'Documents/GitHub/cameraLucida');
    addpath(code_repo);
    addpath(fullfile(code_repo, 'Plotting'));
    addpath(fullfile(code_repo, 'Pre_proc'));
    addpath(fullfile(code_repo, 'Utils'));
    addpath(fullfile(home, 'Documents/GitHub/Dbs/V1_dendrites'));
    addpath(genpath('/Users/lfedros/Documents/GitHub/FedBox'));
    addpath(fullfile(home, 'Documents/GitHub/circstat-matlab'));
    addpath('/Users/lfedros/Documents/GitHub/FedBox/Colormaps');
    addpath(genpath(fullfile(home, 'Documents/GitHub/treestoolbox')));
    cd(code_repo);
    addpath(fullfile(home, 'Documents/GitHub/Suite2P_Matlab/svd'));
    addpath(fullfile(home, 'Documents/GitHub/Suite2P_Matlab/utils'));
    addpath(fullfile(home, 'Documents/GitHub/Suite2P_Matlab/tiffTools'));

end

end