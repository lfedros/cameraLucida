clear;

i = 0;
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
db_abl(i).mouse_name    = {'FR184','FR184','FR184','FR184','FR184','FR184'};
db_abl(i).mouse_name_s2p    = {'FR184','FR184','FR184','FR184','FR184','FR184'};
db_abl(i).date              = {'2021-04-01', '2021-04-06','2021-04-07','2021-04-09','2021-04-12','2021-04-13'};
db_abl(i).date_s2p      = {'2021-04-01','2021-04-06','2021-04-07','2021-04-09', '2021-04-12','2021-04-13'};
db_abl(i).expts         = {[18 19], [14], [2 3 4], [ 4 5 6 7], [14 15 16],  [3 4]};
db_abl(i).expID         = {[1]   ,    [1],          [3],         [2] ,        [1],      [1]};
db_abl(i).plane         = [3, 3, 3, 4, 3, 4];
db_abl(i).starterID     = 23;
db_abl(i).stimList      = {[1:13],  [1:7:84, 85], [1:13], [1:13], [1:13],  [1:13]};
db_abl(i).ncut_dendrites     = [3  1];
db_abl(i).respWin       = [0 3];



%%

for iExp = 1:numel(db.mouse_name)
    
    this_db.mouse_name = db.mouse_name_s2p{iExp};
    this_db.date = db.date_s2p{iExp};
    this_db.expts = db.expts{iExp};
    this_db.expID = db.expID{iExp};
    this_db.starterID = db.starterID;
    this_db.plane = db.plane(iExp);
    

[imgG(iExp), imgR(iExp)] = s2pUtils.loadStarterCrops(this_db);
end

for iExp = 1:numel(db_abl.mouse_name)
    
    this_db.mouse_name = db_abl.mouse_name_s2p{iExp};
    this_db.date = db_abl.date_s2p{iExp};
    this_db.expts = db_abl.expts{iExp};
    this_db.expID = db_abl.expID{iExp};
    this_db.starterID = db_abl.starterID;
    this_db.plane = db_abl.plane(iExp);
    

[imgG_abl(iExp), imgR_abl(iExp)] = s2pUtils.loadStarterCrops(this_db);

end


imgG = cat(2, imgG, imgG_abl);
imgR = cat(2, imgR, imgR_abl);

%%
nPlots  = numel(imgG); 

[fpR, fpG] = prism.mixFP({'dsRed2', 'boundGCaMP6'}, 970);

r= fpR./fpG;

for iP = 1:nPlots
       G = imresize(imgG{iP}, [100,100]);
       R= imresize(imgR{iP}, [100,100]);
       
       M = cat(1, fpR, fpG)\cat(1, R(:)', G(:)');
       dsRed(:,:, iP) = mat2gray(reshape(M(1,:), 100, 100));
        GC(:,:, iP) = mat2gray(reshape(M(2,:), 100, 100));

%        GC(:,:, iP)  = mat2gray(reshape(G(:)-0.2*R(:), 100, 100));
% 
end

rm =  cat(1, [1 1 1], cbrewer('seq', 'Reds',100, 'linear'));
% bm =  cat(1, [1 1 1], cbrewer('seq', 'Blues',100, 'linear'));
gm =  cat(1, [1 1 1], cbrewer('seq', 'Greens',100, 'linear'));
% pm = cat(1, [1 1 1], cbrewer('seq', 'RdPu',100, 'linear'));


figure; 
for iP = 1:nPlots
    axG(iP) = subplot( nPlots, 2, 2*(iP-1)+1);
    imagesc(GC(:,:,iP).^0.7); axis image; formatAxes; set(gca, 'visible', 'off');
%     colormap(axG(iP), gm); caxis([0.1 0.7])
    colormap(axG(iP), Green(100)); caxis([0.1 0.7])

   axR(iP) =  subplot( nPlots, 2,2*(iP-1)+2);
   
    imagesc(dsRed(:,:,iP).^0.7); axis image; formatAxes;set(gca, 'visible', 'off');
    colormap(axR(iP), rm);caxis([0.1 0.7])
end

