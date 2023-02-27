function [map, rr] = svd2pxmap(db, targetPlane, stim_type)
%% load a svd compresesed 2P recordinga adn computes stim triggered pixelMaps
%OUTPUTS
% - map: contain tuning pixel maps. Struct with fields:
%       - dir: pixel map of preferred direction
%       - dir_Sf_Tf: pixel map of preferred combo of SfTf for orientation
%       - ori: pixel map of preferred orientation
%       - ori_Sf_Tf: pixel map of preferred combo of SfTf for orientation
%       - mimg: average image
%       - st: nSfTf-dim struct with fields dir, ori, mimg (like above) for each sftf
%       combo
%       - all_st: struct with fields dir, ori, mimg computed by averaging
%       across sftf combos
%       - p: protocol file 


%% load SVD compressed recording

root_folder = db.root_folder;

switch db.s2p_version
    case 'python'

s2p_folder = fullfile(root_folder, db.mouse_name, db.date, ...
    sprintf('%d', db.expts),'suite2P', sprintf('plane%d', targetPlane-1));

svd_file = sprintf('%s/SVD_%s_%s_plane%d.mat', s2p_folder, ...
    db.mouse_name, db.date, targetPlane-1);

svd = load(svd_file);

[nY, nX, nBasis] = size(svd.U);

nFrames = size(svd.Vcell{db.expID},2);

    case 'matlab'

s2p_folder = fullfile(root_folder, db.mouse_name, db.date, ...
    sprintf('%d', db.expts));

svd_file = sprintf('%s/SVD_%s_%s_plane%d.mat', s2p_folder, ...
    db.mouse_name, db.date, targetPlane);



% nFrames = size(svd.Vcell{db.expID},2);

end


svd = load(svd_file);
[nY, nX, nBasis] = size(svd.U);

%     S = imgaussfilt(svd.U, 3*sigma); % smooth spatial basis with gaussian 30 um sigma
S = svd.U;
S = reshape(S, [], nBasis); % nPx * nB
T = svd.Vcell{db.expID} ; % nB * nT



%% load stimulus info and compute STA on temporal components

info = ppbox.infoPopulateTempLFR(db.mouse_name, db.date, db.expts(db.expID));

switch stim_type
    case 'gratings' % sta across stimuli of same direction, averaged across sf and tf if multiple present


        % load stimulus info
        switch db.s2p_version
    case 'python'
        nFrames = svd.ops.frames_per_folder(db.expID);
            case 'matlab'
                nFrames = svd.ops.Nframes(db.expID);

        end
        planeFrames = targetPlane:info.nPlanes:(nFrames*info.nPlanes); % check if it works for multiplane recs
        %         allFrameTimes = allFrameTimes(planeFrames);

        frameTimes = ppbox.getFrameTimes(info, planeFrames);
        frameRate = (1/mean(diff(frameTimes)));

        stimTimes = ppbox.getStimTimes(info);
        [stimSequence, p] = ppbox.getStimSequence_LFR(info);

        nSfTf = floor(p.nstim/p.nDir);

        dirs = p.dirs; %dirs = -dirs;
        dirs = deg2rad(dirs);
        oris = dirs;
        oris(oris >= pi) = oris(oris >=pi) -pi;
        oris = oris*2 + pi/2;

        %% compute pixel map for each SfTf combo
        if nSfTf >1

            stimMatrix = ppbox.buildStimMatrix(stimSequence, stimTimes, frameTimes);

            for iST = 1:nSfTf
                %select stims
                stimMatrix = ppbox.buildStimMatrix(stimSequence, stimTimes, frameTimes);
                % remove blank from stimMatrix
                stimMatrix(p.blankstim,:) = [];
                % select this SfTf - hardcoded, improve by using protocol info
                stimMatrix = stimMatrix(iST:nSfTf:end, :);
                % sta of temporal components
                nSVD = min(1000, svd.ops.nSVD); % hard coded, perhaps make input
                % filter in time; HARDCODED change for different indicators
                sT = gaussFilt(T(1:nSVD, :)',2);
                [resp, ~, ~, kernelTime] = ppbox.getStimulusSweepsLFR(sT, stimTimes, stimMatrix,frameRate); % responses is (nroi, nStim, nResp, nT)

                % measure response in respWindow
                respWin = [0, 2]; % HARDCODED
                [resPeak, aveResPeak] = ...
                    ppbox.gratingOnResp(resp, kernelTime, respWin);  % resPeak is (nroi, nStim, nResp)
                
                % gentle spatial smoothing of the spatial components
                sS =reshape( S(:, 1:nSVD), nY, nX, nSVD);
                sS = imgaussfilt(sS, 0.5);
                sS = reshape(sS, nY*nX, nSVD);

                % save US and V to reconstruct resp for each px, px =
                % sS*sT;
                nStim = size(resPeak,2); nRep = size(resPeak,3);
                resPeak = reshape(resPeak, nSVD, nStim*nRep);
                rr.st(iST).trial_stim_resp = single(sS*resPeak); % this is nPx*nReps*nStim (more convenient than next lines if nResp*nStim<1000)
                rr.st(iST).stim_resp = single(sS*aveResPeak); % this is nPx*nStim
                rr.st(iST).nStim = nStim;
                rr.st(iST).nRep = nRep;

%                 rr.st(iST).resp_sT = single(resPeak); % this is 1000*nReps*nStim
%                 rr.st(iST).aveResp_sT = aveResPeak; % this is 1000*nStim
%                 rr.st(iST).resp_sS = sS ; % this is nPx*1000

                %pixel maxps for direction
                svdTun_dir = aveResPeak.*exp(1i*dirs);
                svdTun_dir = mean(svdTun_dir, 2);
                pxTun_dir = sS*svdTun_dir(1:nSVD);
                map.st(iST).dir = permute(reshape(pxTun_dir, nY, nX), [2,1]); % for some reason the SVDs are transposed

                %pixel maxps for orientation
                svdTun_ori = aveResPeak.*exp(1i*oris);
                svdTun_ori = mean(svdTun_ori, 2);
                pxTun_ori = sS*svdTun_ori(1:nSVD);
                map.st(iST).ori = permute(reshape(pxTun_ori, nY, nX), [2,1]); % for some reason the SVDs are transposed

                %average image
                map.st(iST).mimg = 1-mat2gray(reshape(sS(:,1), nY, nX))'; % for some reason the SVDs are transposed

                % plot
                plot_px_map(map.st(iST), stim_type, 1, [2 4]);
                print(fullfile(s2p_folder, sprintf('%s_st%d_px_maps', stim_type, iST)), '-dpdf', '-vector', '-bestfit')

            end
            
            % for each pixel, pick the sftf combo gave the strongest resp
            amp = abs(cat(3, map.st(:).ori));
            [~, map.ori_SfTf] = max(amp, [], 3, 'linear');
            amp = reshape(amp(map.ori_SfTf(:)),size(map.ori_SfTf));

            ang = angle(cat(3, map.st(:).ori));
            ang = reshape(ang(map.ori_SfTf(:)),size(map.ori_SfTf));
            map.ori = amp.*exp(1i*ang);

            amp = abs(cat(3, map.st(:).dir));
            [~, map.dir_SfTf] = max(amp, [], 3, 'linear');
            amp = reshape(amp(map.dir_SfTf(:)),size(map.ori_SfTf));

            ang = angle(cat(3, map.st(:).dir));
            ang = reshape(ang(map.dir_SfTf(:)),size(map.ori_SfTf));
            map.dir = amp.*exp(1i*ang);

            map.mimg = mean(cat(3, map.st(:).mimg),3);
            plot_px_map(map, stim_type, 1, [2 4]);
            print(fullfile(s2p_folder, sprintf('%s_px_maps', stim_type)), '-dpdf', '-vector', '-bestfit')

        end

        %% now compute average across SfTf
        stimSequence_dir.seq = ceil(stimSequence.seq/nSfTf); % treat all sftf as the same
        stimSequence_dir.labels = stimSequence.labels(1:nSfTf:end);

        stimMatrix = ppbox.buildStimMatrix(stimSequence_dir, stimTimes, frameTimes);

        % remove blank from stimMatrix
        stimMatrix(p.nDir+1,:) = [];

        % compute stimulus triggered responses
        nSVD = min(1000, svd.ops.nSVD); % hard coded, perhaps make input

        % filter in time; HARDCODED change for different indicators
        sT = gaussFilt(T(1:nSVD, :)',2);
        
        % measure sta response timecourse 
        [resp, aveResp, ~, kernelTime] = ...
            ppbox.getStimulusSweepsLFR(sT, stimTimes, stimMatrix,frameRate); % responses is (nroi, nStim, nResp, nT)
        aveResp = aveResp(:,:,kernelTime>-1 & kernelTime<3);
       
        % measure response in respWindow
        respWin = [0, 2];
        [resPeak, aveResPeak] = ...
            ppbox.gratingOnResp(resp, kernelTime, respWin);  % resPeak is (nroi, nStim, nResp)

         % gentle spatial smoothing of the spatial components
        sS =reshape( S(:, 1:nSVD), nY, nX, nSVD);
        sS = imgaussfilt(sS, 0.5);
        sS = reshape(sS, nY*nX, nSVD);

        % save US and V to reconstruct resp for each px, px =
        % sS*sT;
        nStim = size(resPeak,2); nRep = size(resPeak,3);
        resPeak = reshape(resPeak, nSVD, nStim*nRep);
        rr.trial_stim_resp = single(sS*resPeak);
        rr.stim_resp = single(sS*aveResPeak);
        rr.stimSequence = stimSequence;
        rr.stimSequence_dir = stimSequence_dir;

%         rr.all_st.resp_sT = single(resPeak);
%         rr.all_st.aveResp_sT = aveResPeak;
%         rr.all_st.resp_sS = sS ;

        %pixel maxps for direction
        svdTun_dir = aveResPeak.*exp(1i*dirs);
        svdTun_dir = mean(svdTun_dir, 2);
        pxTun_dir = sS*svdTun_dir(1:nSVD);
        map.all_st.dir = permute(reshape(pxTun_dir, nY, nX), [2,1]); % for some reason the SVDs are transposed

        %pixel maxps for orientation
        svdTun_ori = aveResPeak.*exp(1i*oris);
        svdTun_ori = mean(svdTun_ori, 2);
        pxTun_ori = sS*svdTun_ori(1:nSVD);
        map.all_st.ori = permute(reshape(pxTun_ori, nY, nX), [2,1]); % for some reason the SVDs are transposed

        map.all_st.mimg = 1-mat2gray(reshape(sS(:,1), nY, nX))'; % for some reason the SVDs are transposed

        plot_px_map(map.all_st, stim_type);
        print(fullfile(s2p_folder, sprintf('%s_all_st_px_maps', stim_type)), '-dpdf', '-vector', '-bestfit')

    case 'sparsenoise'

        % need to integrate old code from function 'RF_mapping_mov'
end

map.p = p;
rr.p = p;
rr.nX = nX;
rr.nY = nY;
rr.nRep = nRep;
rr.nStim = nStim;
rr.nSfTf = numel(rr.st);

end




