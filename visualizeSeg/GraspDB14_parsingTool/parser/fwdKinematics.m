function skeleton = fwdKinematics ( skeleton, joint, angle, axis )
% set angle at a specific joint and update all "outgoing" joints
%
% in : skeleton ... skeleton structure 
%      joint ...... string name OR index of the joint to apply the angle to
%      angle ...... angle in [RAD] to be applied to the joint
%      axis ....... column vector representing the axis of rotation OR
%                   a string representing the axis of rotation 
%                     valid strings are
%                       'flex' => local x axis
%                       'pron' => local y axis
%                       'abd'  => local z axis
%                       'x'    => standard x axis
%                       'y'    => standard y axis
%                       'z'    => standard z axis
% out: skeleton ... skeleton structure with updated joint positions
%
% skeleton = setJointAngle ( skeleton, jointname, angle, axis )

if ischar(joint)
  idx = find( strcmpi(joint, skeleton.namemap(:,3)) );
else
  idx = joint;
end


rotaxis = [0;0;1];
anglemultiplier = 1;

if ischar(axis)
  switch axis
    case 'flex' % => local x
      rotaxis = skeleton.joints(idx).localcoordinatesystem(:,1);
    case 'pron'  % => local y
      rotaxis = skeleton.joints(idx).localcoordinatesystem(:,2);
    case 'abd'  % => local z
      rotaxis = skeleton.joints(idx).localcoordinatesystem(:,3);
    case 'add'  % => local z && angleinverse
      rotaxis = skeleton.joints(idx).localcoordinatesystem(:,3);
      anglemultiplier = -1;
    case 'x'
      rotaxis = [1;0;0];
    case 'y'
      rotaxis = [0;1;0];
    case 'z'
      rotaxis = [0;0;1];
    case '-z'
      rotaxis = [0;0;-1];
    otherwise
      info (['no such axis, ', axis, '. Rotating about the standard z-axis']);
  end
  
else
  if ( size(axis,1) ~= 3 )
    msg = ['KS> Wrong vector dimension:\n    Size of vector is [', ...
              num2str(size(axis)),'] but should be [', ...
              num2str(size(ones(3,1))),'].'];
    causeException = MException('MATLAB:KScode:dimensions',msg);
    throw(causeException);
  end
  
  rotaxis = axis/norm(axis);
  
end;

affectedIDs = traverseSubtree ( skeleton, skeleton.joints(idx).id );
delta3d = skeleton.joints(idx).position;
q = rotquat( anglemultiplier*angle, rotaxis );
for k=1:length(affectedIDs)
  currentidx = id2index( skeleton.namemap, affectedIDs(k) );
  pos = skeleton.joints(currentidx).position-delta3d;
  skeleton.joints(currentidx).position = (quatrotate(pos, q) + delta3d);
  skeleton.joints(currentidx).localcoordinatesystem = quatrotate(skeleton.joints(currentidx).localcoordinatesystem, q);
end
  
end % of function fwdKinematics