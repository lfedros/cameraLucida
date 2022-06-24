function add_SVDcomps(db)


if ~isfield (db, 'nPlanes')
    info = ppbox.infoPopulateTempLFR(db.mouse_name, db.date, db.expts);
    db.nPlanes = info.nPlanes;
end

switch db.s2p_version
    case 'py'
        for iPlane = 1:db.nplanes

            s2p_folder = fullfile(root_folder, db.mouse_name, db.date, sprintf('%d', db.expts),'suite2P', sprintf('plane%d', iPlane-1));
            s2p_file = fullfile(s2p_folder, 'Fall.mat');
            load(s2p_file, 'ops');

            ops.mouse_name = db.mouse_name ;
            ops.date = db.date   ;
            ops.exps = db.expts;
            ops.save_path = s2p_folder;
            ops.iplane = iPlane-1;

            mov2svd_py(ops);

        end
    case 'matlab' % not sure this section works

        for iPlane = 1:db.nPlanes

            [root, ~, ~, refSVD, refRaw] = starter.getAnalysisRefs(db.mouse_name, db.date, db.expts, iPlane);

            if ~exist(fullfile(root, refSVD), 'file')

                load(fullfile(root, refRaw), 'ops');
                mov2svd(ops);

            end
        end
end


end