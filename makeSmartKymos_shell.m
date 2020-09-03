found = dir(fullfile(uigetdir(), ['**' filesep 'bundle_mask.tif']));
all_folders = {found.folder};


for i = 1:numel(all_folders)
    folder = all_folders{i};
    mat_file = [folder filesep 'smartkymo.mat'];
    
    if exist(mat_file,'file')==2
        fprintf("* Skipped: %s\n",folder)
        continue
    end
    fprintf("> Making kymo: %s\n", folder)
    fprintf("done\n", folder)
    movie  = readTiffStack([folder filesep '..' filesep 'movie.tif']);
    mask  = readTiffStack([folder filesep 'bundle_mask.tif'])==0;
    [ kymo,kymo_x,kymo_y ] = smartKymoMask( movie,mask );
    writeTiffStack(uint16(kymo),[folder filesep 'kymo.tif'])
    save(mat_file,'kymo','kymo_x','kymo_y');
    
end
close all