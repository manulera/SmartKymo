function [ kymo,kymo_x,kymo_y ] = smartKymoMask( movie,mask )


    % Keep the biggest region in the mask.
    mask = bwareafilt(mask,1);

    % Get the center of mass of the mask to center around it

    lis = regionprops(mask,'PixelList','Orientation');
    xx = lis.PixelList(:,1);
    yy = lis.PixelList(:,2);
    xc = mean(xx);
    yc = mean(yy);
    sugg_ang = -deg2rad(lis.Orientation);

    % A fit to an orthogonal parabolla
    polynomium_mask = orthogonalFit(xx,yy,[sugg_ang,xc,yc,0],1,'robust');
    
%     xplot = linspace(-200,200);
%     [x,y] = orthogonalPolyEval(xplot,polynomium_mask);
%     figure
%     imshow(mask)
%     hold on
%     plot(x,y)
    % Project all points in the mask on the polyline
    proj_coord = centerThenRotate(xx,yy,polynomium_mask(2),polynomium_mask(3),polynomium_mask(1));
    
    % Create a pixel coordinate system in which to map all the coordinates
    kymo_coord = floor(min(proj_coord)):floor(max(proj_coord));

    % A logical array to indicate which coordinates belong to which point in
    % the kymograph

    kymo_log = false(numel(kymo_coord),numel(proj_coord));
    kymo_ind = {};
    movie_size = size(movie);
    
    for i = 1:(numel(kymo_coord)-1)
        kymo_log(i,:) = proj_coord>=kymo_coord(i) & proj_coord<kymo_coord(i+1);
        kymo_ind{i} = sub2ind(movie_size([1,2]),yy(kymo_log(i,:)),xx(kymo_log(i,:))); 
    end
    kymo_log(i+1,:) = proj_coord>=kymo_coord(i+1);
    kymo_ind{i+1} = sub2ind(movie_size([1,2]),yy(kymo_log(i+1,:)),xx(kymo_log(i+1,:))); 

    t_kymo = size(movie,3);
    x_kymo = numel(kymo_coord);
    kymo = zeros(t_kymo,numel(kymo_coord));
    kymo_x = zeros(t_kymo,numel(kymo_coord));
    kymo_y = zeros(t_kymo,numel(kymo_coord));

    for i = 1:t_kymo
        ima = movie(:,:,i);
        for j = 1:x_kymo
            ind=kymo_ind{j};
            [kymo(i,j),which]=max(ima(ind));
            [kymo_y(i,j),kymo_x(i,j)]=ind2sub(movie_size([1,2]),ind(which));
        end
        kymo(i,:)=kymo(i,end:-1:1);
        kymo_x(i,:)=kymo_x(i,end:-1:1);
        kymo_y(i,:)=kymo_y(i,end:-1:1);
    end
    figure
    imshow(kymo,[])

end

