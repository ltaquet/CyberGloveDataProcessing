
function skeleton = setJointAngle ( skeleton, joint, angle, axis )
% set angle at a specific joint
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

if ischar(axis)
  switch axis
    case 'flex' % => local x
      rotaxis = skeleton.joints(idx).localcoordinatesystem(:,1);
    case 'pron'  % => local y
      rotaxis = skeleton.joints(idx).localcoordinatesystem(:,2);
    case 'abd'  % => local z
      rotaxis = skeleton.joints(idx).localcoordinatesystem(:,3);
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


% set this (and only this!) joint
delta3d = skeleton.joints(idx).position;
q = rotquat( angle, rotaxis );
pos = skeleton.joints(idx).position-delta3d;
skeleton.joints(idx).position = (quatrotate(pos, q) + delta3d);
skeleton.joints(idx).localcoordinatesystem = quatrotate(skeleton.joints(idx).localcoordinatesystem, q);

  
end % of function setJointAngle