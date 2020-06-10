
folder = '.';
movie  = readTiffStack(['..' filesep 'movie.tif']);
mask  = readTiffStack([folder filesep 'bundle_mask.tif'])==0;
[ kymo,kymo_x,kymo_y ] = smartKymoMask( movie,mask );
writeTiffStack(uint16(kymo),[folder filesep 'kymo.tif'])
save([folder filesep 'smartkymo.mat'],'kymo','kymo_x','kymo_y');
