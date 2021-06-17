
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

skeleton = makeRightHand( skeleton );
skeleton = rootToZero ( skeleton );
skeleton = longitudeToYplane ( skeleton );
skeleton = reflectLocalYaxis ( skeleton );

skeleton = straightenFinger ( skeleton, 'lf-cmc' );
skeleton = straightenFinger ( skeleton, 'mf-cmc' );
skeleton = straightenFinger ( skeleton, 'rf-cmc' );
skeleton = straightenFinger ( skeleton, 'if-cmc' );
skeleton = straightenFinger ( skeleton, 'th-mcp' );

skeleton = alignMiddleFingerYaxis ( skeleton );

for kk=1:skeleton.numberofjoints
  for kkk=1:3
    skeleton.joints(kk).localcoordinatesystem(:,kkk) = skeleton.joints(kk).localcoordinatesystem(:,kkk)/norm(skeleton.joints(kk).localcoordinatesystem(:,kkk));
  end
  fprintf('%s\n <position>%s</position>\n<basis>\n%s</basis>\n', ...
    skeleton.joints(kk).jointname, ...
    sprintf('%3.3f ', skeleton.joints(kk).position), ...
    sprintf('<vecx>%s</vecx>\n<vecy>%s</vecy>\n<vecz>%s</vecz>\n', ...
      sprintf('%3.3f ', skeleton.joints(kk).localcoordinatesystem(:,1)), ...
      sprintf('%3.3f ', skeleton.joints(kk).localcoordinatesystem(:,2)), ... 
      sprintf('%3.3f ', skeleton.joints(kk).localcoordinatesystem(:,3))) ...
    );
end


switch option
  case 'fix'
    skeleton = fix_llc ( skeleton );
  otherwise
end

%%
  function skeleton = alignMiddleFingerYaxis ( skeleton )
    baseidx = name2index(skeleton.namemap, 'mf-cmc');
    nextidx = id2index(skeleton.namemap, skeleton.joints(baseidx).children);
    
    target_dir = [0 -1 0];
    axisofrot = [0 0 1];
    current_dir = skeleton.joints(nextidx).position - skeleton.joints(baseidx).position;
    current_dir = current_dir/norm(current_dir);
    
    angle = acos(dot(target_dir, current_dir));
    rot = rotquat(-angle, axisofrot);

    
    for k = 1:skeleton.numberofjoints
      skeleton.joints(k).position = quatrotate(skeleton.joints(k).position, rot);
      skeleton.joints(k).localcoordinatesystem = quatrotate(skeleton.joints(k).localcoordinatesystem,rot);
    end
    
  end

%%
  function skeleton = straightenFinger ( skeleton, stringbasejoint )
    baseidx = name2index(skeleton.namemap, stringbasejoint);
    jointpath = baseidx;
    idx = baseidx;
    counter = 2;
    while ~isempty(skeleton.joints(idx).children)
      idx = id2index(skeleton.namemap,skeleton.joints(idx).children);
      jointpath = [jointpath idx];
      counter = counter+1;
    end
    
    target_dir = skeleton.joints(jointpath(2)).position - skeleton.joints(jointpath(1)).position;    
    target_dir = target_dir/norm(target_dir);
    
    for k=2:length(jointpath)-1
      offset = skeleton.joints(jointpath(k)).position;

      current_dir = skeleton.joints(jointpath(k+1)).position - skeleton.joints(jointpath(k)).position;
      current_dir = current_dir/norm(current_dir);
    
      axisofrot_pt = cross(target_dir, current_dir);
      axisofrot_pt = axisofrot_pt/norm(axisofrot_pt);% just to make sure
      
      angle_pt = acos(dot(target_dir, current_dir));
      rot_pt = rotquat(-angle_pt, axisofrot_pt);
      
      current_ydir = skeleton.joints(jointpath(k+1)).localcoordinatesystem(:,2);
      current_ydir = current_ydir/norm(current_ydir);
      axisofrot_y = cross(-target_dir, current_ydir);% if not negative => coordinate system wrong
      axisofrot_y = axisofrot_y/norm(axisofrot_y);% just to make sure
      angle_y =  acos(dot(-target_dir, current_ydir));
      rot_y = rotquat(-angle_y, axisofrot_y);
      
      skeleton.joints(jointpath(k+1)).position = quatrotate(skeleton.joints(jointpath(k+1)).position-offset,rot_pt)+offset;
      skeleton.joints(jointpath(k+1)).localcoordinatesystem = quatrotate(skeleton.joints(jointpath(k+1)).localcoordinatesystem,rot_y);
    end
    
    
  end
%%
  function skeleton = reflectLocalYaxis ( skeleton )
    for k = 1:skeleton.numberofjoints
      reflectY = rotquat(pi, skeleton.joints(k).localcoordinatesystem(:,1));
      skeleton.joints(k).localcoordinatesystem = quatreflect(skeleton.joints(k).localcoordinatesystem,reflectY);
    end        
  end


  function skeleton = makeRightHand ( skeleton )
    reflectY = rotquat(pi, [0 1 0]);
    for k = 1:skeleton.numberofjoints
      skeleton.joints(k).position = quatreflect(skeleton.joints(k).position, reflectY);
      skeleton.joints(k).localcoordinatesystem = quatreflect(skeleton.joints(k).localcoordinatesystem,reflectY);
    end
  end

  function skeleton = longitudeToYplane (skeleton)
  % Rotate skeleton such that the length of the hand lies in the y plane
  % This is based on the difference of the root joint and the tip of the
  % middle finger. The maximum absolut value of that difference is assumed 
  % to be the current 'longitudal' axis which is to be rotated into the y
  % plane.
  %
  
  mftipidx = name2index(skeleton.namemap, 'mf-tip');
  rootidx = name2index(skeleton.namemap, 'root');
  
  difference = skeleton.joints(mftipidx).position - skeleton.joints(rootidx).position;
  [~, idx] = sort(abs(difference),'descend');
  
  do_rot = true;
  rotintoY = rotquat(0, [0 1 0]);
  if idx == idx(1) % current longitudal axis is x => rotate 
    if difference(idx(1))>0
      rotintoY = rotquat(pi/2, [0 0 1]);
    else
      rotintoY = rotquat(-pi/2, [0 0 1]);
    end
  elseif idx == idx(2) % current longitudal axis is y => do nothing
    do_rot = false;
  else % current longitudal axis is z => rotate
    if difference(idx(1))>0
      rotintoY = rotquat(pi/2, [1 0 0]);
    else
      rotintoY = rotquat(-pi/2, [1 0 0]);
    end
  end
  
  if do_rot
    for k = 1:skeleton.numberofjoints
      skeleton.joints(k).position = quatrotate(skeleton.joints(k).position, rotintoY);
      skeleton.joints(k).localcoordinatesystem = quatrotate(skeleton.joints(k).localcoordinatesystem,rotintoY);
    end
  end

  
  end % of function longitudeToYplane

  function skeleton = toXYplane ( skeleton )
  % such that y holds the maximum extension
    temp = [skeleton.joints.position];
    extent = max(temp,[],2) - min(temp,[],2);
    [~, idx] = sort(extent);
    % xz -> xy => rot around x
    % longest to y
    % => idx(end) -> 2
    % second longest to x
    % => idx(end-1) -> 1
    % 1 2 3 => 1 3 2
    rotintoY = rotquat(0, [0 1 0]);
    rotintoX = rotquat(0, [1 0 0]);
    if (idx(end) == 1)% x -> y
      rotintoY = rotquat(pi/2, [0 0 1]);
    elseif (idx(end) == 2) % y->y
      rotintoY = rotquat(0, [0 1 0]);
    elseif (idx(end) == 3) % z -> y
      rotintoY = rotquat(pi/2, [1 0 0]);
    end
    if (idx(end-1) == 1) % x -> x
      rotintoX = rotquat(0, [1 0 0]);
    elseif (idx(end-1) == 2) % y -> x
      rotintoX = rotquat(pi/2, [0 0 1]);
    elseif (idx(end-1) == 3) % z -> x
      rotintoX = rotquat(pi/2, [0 1 0]);
    end
    %%% construct rotation matrix and rotate
    rotintoXY = quatmult(rotintoX, rotintoY);

    reflectY = rotquat(pi, [0 1 0]);
    for k = 1:skeleton.numberofjoints
      skeleton.joints(k).position = quatrotate(skeleton.joints(k).position, rotintoXY);
      skeleton.joints(k).localcoordinatesystem = quatrotate(skeleton.joints(k).localcoordinatesystem,rotintoXY);
      skeleton.joints(k).position = quatreflect(skeleton.joints(k).position, reflectY);
      skeleton.joints(k).localcoordinatesystem = quatreflect(skeleton.joints(k).localcoordinatesystem,reflectY);
    end
    
  end

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