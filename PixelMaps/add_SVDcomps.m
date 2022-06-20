function add_SVDcomps(db)


if ~isfield (db, 'nPlanes')
    info = ppbox.infoPopulateTempLFR(db.mouse_name, db.date, db.expts);
    db.nPlanes = info.nPlanes;
end

for iPlane = 1:db.nPlanes
    
    [root, ~, ~, refSVD, refRaw] = starter.getAnalysisRefs(db.mouse_name, db.date, db.expts, iPlane);
    
    if ~exist(fullfile(root, refSVD), 'file')
        
        load(fullfile(root, refRaw), 'ops');
        mov2svd(ops);
        
    end
end


end