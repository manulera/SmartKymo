dirs = dir('interphase_kymo*');

for i = 1:numel(dirs)
    if ~dirs(i).isdir
        continue
    end
    this_dir = dirs(i).name;
    subdirs = dir([this_dir filesep 'bundle*']);
    for j = 1:numel(subdirs)
        folder = [subdirs(j).folder filesep subdirs(j).name];
        movie  = readTiffStack([subdirs(j).folder filesep 'movie.tif']);
        mask  = readTiffStack([folder filesep 'bundle_mask.tif'])==0;
        [ kymo,kymo_x,kymo_y ] = smartKymoMask( movie,mask );
        writeTiffStack(uint16(kymo),[folder filesep 'kymo.tif'])
        save([folder filesep 'smartkymo.mat'],'kymo','kymo_x','kymo_y');
    end
end
close all