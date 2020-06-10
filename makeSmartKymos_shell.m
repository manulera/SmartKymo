[~,out] = system('find . -name "bundle_??"');

all_folders = strsplit(out);
empty_ones = cellfun('isempty',all_folders);
all_folders = all_folders(~empty_ones);


for i = 1:numel(all_folders)
    folder = all_folders{i};
    mat_file = [folder filesep 'smartkymo.mat'];
    if isfile(mat_file)
        continue
    end
    
    movie  = readTiffStack([folder filesep '..' filesep 'movie.tif']);
    mask  = readTiffStack([folder filesep 'bundle_mask.tif'])==0;
    [ kymo,kymo_x,kymo_y ] = smartKymoMask( movie,mask );
    writeTiffStack(uint16(kymo),[folder filesep 'kymo.tif'])
    save(mat_file,'kymo','kymo_x','kymo_y');
    
end
close all