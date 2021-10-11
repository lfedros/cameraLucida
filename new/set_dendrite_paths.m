function set_dendrite_paths()

if ispc
    
    addpath('C:\Users\Federico\Documents\GitHub\Dbs\V1_dendrites');
    code_repo = 'C:\Users\Federico\Documents\GitHub\cameraLucida\Analysis\Dendrite';

    code_repo = 'C:\Users\Federico\Documents\GitHub\cameraLucida\new';
    addpath(genpath(code_repo));
    addpath(genpath('C:\Users\Federico\Documents\GitHub\treestoolbox'));
    cd(code_repo);
    
else
    
    addpath('/Users/lfedros/Documents/GitHub/Dbs/V1_dendrites');
    addpath('/Users/lfedros/Documents/GitHub/cameraLucida/Analysis/Dendrite')
    addpath('/Users/lfedros/Documents/GitHub/FedBox');
    addpath('/Users/lfedros/Documents/GitHub/circstat-matlab');
    addpath('/Users/lfedros/Documents/GitHub/FedBox/Colormaps');
    code_repo = '/Users/lfedros/Documents/GitHub/cameraLucida/new';
    addpath(genpath(code_repo));
    addpath(genpath('/Users/lfedros/Documents/GitHub/treestoolbox'));
    cd(code_repo);
    
end

end