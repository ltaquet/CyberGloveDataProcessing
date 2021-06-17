
function aabb = computeAABB ( object, type )
%
% Compute the axis aligned bounding box for a skeleton or 3d points (e.g.
% 3d joint trajectories)
%
% INPUT
%   object ... skeleton structure for aabb of a skeleton
%              <a x 1> cell array of <3 x n> arrays for 3d points
%   type ..... (optional) type
%              'xmlskel' if object is a skeleton struct (default)
%              '3dpositions' if object contains 3d points
% OUTPUT
%   aabb ... tight axis aligned bounding box for the object specified
%
% EXAMPLE
%  aabb = computeAABB(motion.jointtrajectories, '3dpositions');
%  aabb = computeAABB(skeleton);
%
%



if (nargin == 1)
  type = 'xmlskel';
end

switch lower(type)
  case 'xmlskel'
    computeXMLSKELaabb;
  case '3dpositions'
    compute3DPOS;
  otherwise
    error(['type ', type, '. Currently supported ist ''xmlskel'' or ''3dpositions''']);
end

% GLOBAL_VARS_SETTINGS.aabb = computeAABB(mot.jointtrajectories, '3dpositions');
% [h, aabb] = createWalls(GLOBAL_VARS_SETTINGS.aabb(:)'+repmat([-1,1]*25,1,3),25);
% axis(gca, aabb+repmat([-1,1],1,3) );
% set( gca, 'view', [120,40] );
% set( gca, 'Color', 'none' );


  %%
  function computeXMLSKELaabb
    
    temp = [object.joints(:).position];
    positions = reshape(temp,3,object.numberofjoints);
    
    aabb = zeros(2,3);
    
    aabb(:,1) = [min(positions(1,:))  max(positions(1,:))]; % x
    aabb(:,2) = [min(positions(2,:))  max(positions(2,:))]; % y
    aabb(:,3) = [min(positions(3,:))  max(positions(3,:))]; % z
    
  end % of function computeSkelAABB

  function compute3DPOS
    % input object is a #joints x 1 cell array
    
    aabb = repmat([inf;-inf], 1,3);
    
    for k=1:size(object,1)
      positions = object{k};
      aabb(:,1) = [min(aabb(1,1),min(positions(1,:)))  max(aabb(2,1),max(positions(1,:)))]; % x
      aabb(:,2) = [min(aabb(1,2),min(positions(2,:)))  max(aabb(2,2),max(positions(2,:)))]; % y
      aabb(:,3) = [min(aabb(1,3),min(positions(3,:)))  max(aabb(2,3),max(positions(3,:)))]; % z
    end % for

  end % of function compute3DPOS


end % of function computeAABB



% %%
%   function aabb = computeAABB
%     
%     temp = [skeleton.joints(:).position];
%     positions = reshape(temp,3,skeleton.numberofjoints);
%     
%     aabb = zeros(1,6);
%     
%     aabb(1) = min(positions(1,:)); aabb(2) = max(positions(1,:)); % x
%     aabb(3) = min(positions(2,:)); aabb(4) = max(positions(2,:)); % y
%     aabb(5) = min(positions(3,:)); aabb(6) = max(positions(3,:)); % z
%     
%   end % of function computeAABB
% 
