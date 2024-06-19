function set_dendrite_paths()

if ispc
    machine_name = getenv('COMPUTERNAME'); % for windows
    switch machine_name
        case 'FANCIBOT'
    code_repo = 'D:\OneDrive - Fondazione Istituto Italiano Tecnologia\Documents\Code\cameraLucida';
    git_repo = 'D:\OneDrive - Fondazione Istituto Italiano Tecnologia\Documents\Code';
        case 'ZUFOLO'
            code_repo = 'C:\Users\Federico\Documents\GitHub\cameraLucida';
    git_repo = 'C:\Users\Federico\Documents\GitHub';
    end
    % code_repo = 'C:\Users\Federico\Documents\GitHub\cameraLucida';
    addpath(code_repo);
    
    addpath(fullfile(code_repo, 'Plotting'));
    addpath(fullfile(code_repo, 'Pre_proc'));
    addpath(fullfile(code_repo, 'Utils'));
    
    addpath(fullfile(git_repo, 'Dbs\V1_dendrites'));
    %https://github.com/lfedros/Dbs
    addpath(genpath(fullfile(git_repo, 'FedBox')));
    %https://github.com/lfedros/FedBox
    addpath(fullfile(git_repo, 'circstat-matlab'));
    %https://github.com/circstat/circstat-matlab
    addpath(genpath(fullfile(git_repo, 'treestoolbox')));
    %https://github.com/cuntzlab/treestoolbox
    cd(code_repo);
    %https://github.com/cortex-lab/Suite2P
    addpath(fullfile(git_repo, 'Suite2P_Matlab\svd'));
    addpath(fullfile(git_repo, 'Suite2P_Matlab\utils'));
    addpath(fullfile(git_repo, '\Suite2P_Matlab\tiffTools'));
else
    % code_repo = fullfile(home, 'Documents/GitHub/cameraLucida');
    home = '/Users/federico';
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