i = 0;


i = i+1;
db(i).mouse_name    = 'FR201'; % worked
db(i).date          = '2021-11-15';
db(i).expts         = [5];
db(i).nchannels     = 2;
db(i).gchannel      = 1;
db(i).nplanes       = 4;
db(i).expred        = db(i).expts;
db(i).nchannels_red = [2];
db(i).diameter      = 15;
db(i).comments      = 'Neuron FOV1';
db(i).sensor        ='GCaMP6s';
db(i).stopSourcery = 0.3;
db(i).getSVDcomps = 0;

%%

for iExp = 1:numel(db)
    for iPlane = 1:db(i).nplanes
        
    [root, refF, refNeu, refSVD, refRaw] = starter.getAnalysisRefs(db(iExp).mouse_name, db(iExp).date, db(iExp).expts, iPlane);
                    
            load(fullfile(root, refRaw), 'ops');
            
            mov2svd(ops);
        
    end
end