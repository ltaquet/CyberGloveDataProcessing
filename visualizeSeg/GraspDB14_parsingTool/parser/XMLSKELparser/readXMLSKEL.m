
function skeleton = readXMLSKEL ( skelfile, option )
%
% option 'fix' => fix local coordinate systems
% option 'nofix' => do not fix local coordinate system
%
% skeleton = readXMLSKEL ( filename )
%

if nargin==1
  option = 'fix';
end

global GLOBAL_VARS_SETTINGS;


xmlskel = xmlread( skelfile );

skeleton = emptySkeleton;
skeleton.filename = skelfile;
skeleton.filetype = upper('xmlskel');


% handle only skeleton root node!
allrootnodes = xmlskel.getChildNodes;
for i=0:allrootnodes.getLength-1
  if ( allrootnodes.item(i).getNodeType == allrootnodes.COMMENT_NODE )
    continue;
  end
  if ( strcmp(allrootnodes.item(i).getNodeName.toString,'skeleton') )
    skeleton = processSkeletonNode ( allrootnodes.item(i), skeleton );
  end
end

if (GLOBAL_VARS_SETTINGS.VERBOSE)
  fprintf('\n');
end % fi VERBOSE


skeleton = constructNamemap ( skeleton );
skeleton = constructHierarchy ( skeleton );
skeleton = constructPaths ( skeleton, 'root', 1 ); 

skeleton = rootToZero ( skeleton );

switch option
  case 'fix'
    skeleton = fix_llc ( skeleton );
  otherwise
end


% 
%   function skeleton = toXYplane ( skeleton )
%   % such that y holds the maximum extension
%     temp = [skeleton.joints.position];
%     extent = max(temp,[],2) - min(temp,[],2);
%     [~, idx] = sort(extent);
%     % xz -> xy => rot around x
%     % longest to y
%     % => idx(end) -> 2
%     % second longest to x
%     % => idx(end-1) -> 1
%     % 1 2 3 => 1 3 2
%     rotintoY = rotquat(0, [0 1 0]);
%     rotintoX = rotquat(0, [1 0 0]);
%     if (idx(end) == 1)% x -> y
%       rotintoY = rotquat(pi/2, [0 0 1]);
%     elseif (idx(end) == 2) % y->y
%       rotintoY = rotquat(0, [0 1 0]);
%     elseif (idx(end) == 3) % z -> y
%       rotintoY = rotquat(pi/2, [1 0 0]);
%     end
%     if (idx(end-1) == 1) % x -> x
%       rotintoX = rotquat(0, [1 0 0]);
%     elseif (idx(end-1) == 2) % y -> x
%       rotintoX = rotquat(pi/2, [0 0 1]);
%     elseif (idx(end-1) == 3) % z -> x
%       rotintoX = rotquat(pi/2, [0 1 0]);
%     end
%     %%% construct rotation matrix and rotate
%     rotintoXY = quatmult(rotintoX, rotintoY);
% 
%     reflectY = rotquat(pi, [0 1 0]);
%     for k = 1:skeleton.numberofjoints
%       skeleton.joints(k).position = quatrotate(skeleton.joints(k).position, rotintoXY);
%       skeleton.joints(k).localcoordinatesystem = quatrotate(skeleton.joints(k).localcoordinatesystem,rotintoXY);
%       skeleton.joints(k).position = quatreflect(skeleton.joints(k).position, reflectY);
%       skeleton.joints(k).localcoordinatesystem = quatreflect(skeleton.joints(k).localcoordinatesystem,reflectY);
%     end
%     
%   end

  function skeleton = fix_llc ( skeleton )
  %%% fix local coordinate systems
  % this works only because the default hand resides in x/y-plane
  % and the local coordinate system has to turn around the z plane
  % => third coordinate of the cross product encodes direction (+/-)
  % => sign of third coordinate represents direction for the rotation of
  % the local coordinate system
    for idx=1:skeleton.numberofjoints
      parentid = skeleton.joints(idx).parent;
      if (parentid <= 0 )
        if (GLOBAL_VARS_SETTINGS.VERBOSE)
          fprintf('no parent in node %d, %s\n', skeleton.joints(idx).id, skeleton.joints(idx).jointname);
        end
        continue;
      end % check if no parent
      parentidx = id2index(skeleton.namemap, parentid);
      % calculate direction of the bone
      pos = skeleton.joints(idx).position-skeleton.joints(parentidx).position;
      vec = pos/norm(pos);
      % cross product of two vectors a x b = ||a|| * ||b|| * sin(angle(a,b)) * n 
      q = cross(vec, [0,1,0] );
      angle = sign(q(3))*asin(norm(q));
      %%% construct rotation matrix and rotate
      rotz = rotmat(angle, 'z');
      skeleton.joints(idx).localcoordinatesystem = skeleton.joints(idx).localcoordinatesystem * rotz;
    %   %%% construct quaternion and rotate
    %   q = rotquat(angle, [0;0;1]);
    %   skeleton.joints(idx).localcoordinatesystem = quatrotate ( skeleton.joints(idx).localcoordinatesystem, q );

      clear rotz angle vec q pos parentidx parentid idx  
    end % end for
    idx=find(strcmpi('th-tmc', skeleton.jointnames));
    if ~(isempty(idx))
      parentid = skeleton.joints(idx).parent;
      parentidx = id2index(skeleton.namemap, parentid);
      %rotz = rotmat(pi/16, 'z');
      skeleton.joints(idx).localcoordinatesystem = skeleton.joints(parentidx).localcoordinatesystem;
    end
    % idx=find(strcmpi('th-tmc', skeleton.jointnames));
    % if ~(isempty(idx))
    %   rotz = rotmat(-pi, 'z');
    %   skeleton.joints(idx).localcoordinatesystem = skeleton.joints(idx).localcoordinatesystem*rotz;
    % end
  %%% end fix local coordinate system
  end % of function fix_llc

end % of function readXMLSKEL

%%%%%%
%%% this is how xmlcomments are displayed
% children = xmlskel.getChildNodes;
% for j=0:children.getLength()
%   node = children.item(j)
%   nodetype = node.getNodeType;
%   if (nodetype == node.COMMENT_NODE)
%     disp(children.item(c).getNodeValue);
%   end
% end
%%%%%%