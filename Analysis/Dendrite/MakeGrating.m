
db.prefOri = - (db.prefDir - 90); % range = [-270 90]
db.prefOri(db.prefOri < -90) = db.prefOri(db.prefOri < -90)+360;
db.prefOri(db.prefOri > 90) = db.prefOri(db.prefOri > 90)-180;

% reduce hsv brightness
hmap(1:256,1) = linspace(0,1,256);
hmap(:,[2 3]) = 0.7; % brightness
huemap = hsv2rgb(hmap);

figure; 
imagesc( db.prefOri );
colormap(huemap);
caxis([-90 90])
axis_cleaner;