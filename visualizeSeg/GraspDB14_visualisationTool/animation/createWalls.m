
function [h, aabb] = createWalls ( aabb, tilesize )
%
% Creates checkerboard coloured planes bordering three sides of the given 
% axis aligned bounding box (aabb). The size of each tile in the
% checkerboard is controlled by tilesize.
%
% [h, aabb] = createWalls ( aabb, tilesize )
%
% input 
%   aabb ....... axis aligned bounding box for the current scene
%   tilesize ... size of one a checkerboar square
% output
%   h .......... handles to the three created plane patches
%   aabb ....... axis aligned bounding box adjusted to the tile size (tile
%                size should devide the aabb)
%


% calculate extensions of the aabb
aabbextension(1) = aabb(2)-aabb(1);
aabbextension(2) = aabb(4)-aabb(3);
aabbextension(3) = aabb(6)-aabb(5);

% make aabb bigger so that it is divided by the tilesize
temp = mod(aabbextension, repmat(tilesize,1,3));
temp = (tilesize-temp)/2;
temp = repmat(temp,2,1);
temp = temp(:)';
temp = temp.*(repmat([-1,1],1,3));
aabb = aabb + temp;

% % control if aabb extension is now ok.
% aabbextension(1) = aabb(2)-aabb(1);
% aabbextension(2) = aabb(4)-aabb(3);
% aabbextension(3) = aabb(6)-aabb(5);

%%%%%
% grid coordinate for all three planes 
[xz_x, xz_z] = meshgrid( aabb(1):tilesize:aabb(2), aabb(5):tilesize:aabb(6) );
[xy_x, xy_y] = meshgrid( aabb(1):tilesize:aabb(2), aabb(3):tilesize:aabb(4) );
[yz_y, yz_z] = meshgrid( aabb(3):tilesize:aabb(4), aabb(5):tilesize:aabb(6) );
% temp = repmat( aabb(1),size(yz_z) );
% hold on;
% surf( temp, yz_y, yz_z );
% % ground plane
% temp = repmat( aabb(5)+10,size(xy_y) );
% surf( xy_x, xy_y, temp );
% hold off;

% Coordinates of a box, relative to lower left corner
href = [0 0 tilesize tilesize 0];
vref = [0 tilesize tilesize 0 0];


%%%%%
% Checkerboard values for xz-plane
% if mod(size(xz_x),1)
%     val = ones(size(xz_x));
%     val(1:2:end) = 2;
% %     % assure correct number of color elemente
% %     val = val(1:end-1,1:end-1);
% else
%     val = ones(size(xz_x,1),size(xz_x,2)+1);
%     val(1:2:end) = 2;
%     val = val(1:end,1:end-1);
% %     % assure correct number of color elemente
% %     val = val(1:end-2,1:end-1);
% end
%%%%%
% Checkerboard values for xz-plane
nh = size(xz_x,1)-1;
nv = size(xz_x,2)-1;
val = repmat([2 1;1 2], ceil(nh/2), ceil(nv/2));
val = val(1:nh, 1:nv);
% assure correct number of patches
xz_x = xz_x(1:end-1, 1:end-1);
xz_z = xz_z(1:end-1, 1:end-1);
% Add to get coordinates of each box
xbox = bsxfun(@plus, xz_x(:), href);
zbox = bsxfun(@plus, xz_z(:), vref);
% Plot using patch with RGB cdata
cmap = [0 0 0; 1 1 1];
col = permute(cmap(val(:), :), [3 1 2]);
% create patch
h(1) = patch(xbox', repmat(aabb(3), size(xbox')), zbox', (col*0.1)+0.9, 'EdgeColor', [ 1 1 1 ]*0.9);

%%%%%
% Checkerboard values xz-plane
% if mod(size(yz_y),2)
%     val = ones(size(yz_y));
%     val(1:2:end) = 2;
%     % assure correct number of color elemente
% %     val = val(1:end-1,1:end-1);
% else
%     val = ones(size(yz_y,1),size(yz_y,2)+1);
%     val(1:2:end) = 2;
%     val = val(1:end,1:end-1);
%     % assure correct number of color elemente
% %     val = val(1:end-2,1:end-1);
% end
%%%%%
% Checkerboard values xz-plane
nh = size(yz_y,1)-1;
nv = size(yz_y,2)-1;
val = repmat([2 1;1 2], ceil(nh/2), ceil(nv/2));
val = val(1:nh, 1:nv);
% assure correct number of patches
yz_y = yz_y(1:end-1, 1:end-1);
yz_z = yz_z(1:end-1, 1:end-1);
% Add to get coordinates of each box
ybox = bsxfun(@plus, yz_y(:), href);
zbox = bsxfun(@plus, yz_z(:), vref);
% Plot using patch with RGB cdata
cmap = [0 0 0; 1 1 1];
col = permute(cmap(val(:), :), [3 1 2]);
% create patch
h(2) = patch(repmat(aabb(1), size(ybox')), ybox', zbox', (col*0.2)+0.8, 'EdgeColor', [ 1 1 1 ]*0.8);


%%%%%
% Checkerboard values xy-plane (ground)
% if mod(size(xy_x),2)
%     val = ones(size(xy_x));
%     val(1:2:end) = 2;
%     % assure correct number of color elemente
% %     val = val(1:end-1,1:end-1);
% else
%     val = ones(size(xy_x,1),size(xy_x,2)+1);
%     val(1:2:end) = 2;
%     % assure correct number of color elemente
%     val = val(1:end,1:end-1);
% %     val = val(1:end-2,1:end-1);
% end
%%%%%
% Checkerboard values xy-plane (ground)
nh = size(xy_x,1)-1;
nv = size(xy_x,2)-1;
val = repmat([2 1;1 2], ceil(nh/2), ceil(nv/2));
val = val(1:nh, 1:nv);
% assure correct number of patches
xy_x = xy_x(1:end-1, 1:end-1);
xy_y = xy_y(1:end-1, 1:end-1);
% Add to get coordinates of each box
xbox = bsxfun(@plus, xy_x(:), href);
ybox = bsxfun(@plus, xy_y(:), vref);
% Plot using patch with RGB cdata
cmap = [0 0 0; 1 1 1];
col = permute(cmap(val(:), :), [3 1 2]);
% create patch
h(3) = patch(xbox', ybox', repmat(aabb(5), size(xbox')), 1-(col*0.15), 'EdgeColor', [ 1 1 1 ]*0.85);

end % of function createBorderPlanes