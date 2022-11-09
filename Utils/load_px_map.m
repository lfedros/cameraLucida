function dendrite = load_px_map(neuron)


[~, spine_folder] = build_path(neuron.db);

nDendrites =  numel(neuron.db.spine_seq);

for iD = 1: nDendrites

    try
        load(fullfile(spine_folder, neuron.db.pix_map{iD}));
        pxAmp_ori = abs(px_map.ori);
        pxAng_ori = angle(px_map.ori);
        pxAng_ori = -pxAng_ori;
        px_map.ori = pxAmp_ori.*exp(1i*pxAng_ori);


        pxAmp_dir = abs(px_map.dir);
        pxAng_dir= angle(px_map.dir);
        pxAng_dir = -pxAng_dir;
        px_map.dir = pxAmp_dir.*exp(1i*pxAng_dir);
        
        dendrite(iD).pixelMap = px_map;
        
    end
end



end