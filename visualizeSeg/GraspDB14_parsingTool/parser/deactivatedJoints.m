
function idx = deactivatedJoints( motion, skeleton, jointidx )
%
% calculate indices for deactivating joints in the motion-skeleton-mapping
% 
% INPUT
%   motion ..... motion structure
%   skeleton ... skeleton structure
%   jointidx ... joints to deactivate
%
% OUTPUT
%   idx ... indices to deactivate
% 

if ( size(jointidx,1) < size(jointidx,2) )
  jointidx = jointidx';
end
if (size(jointidx, 2) ~= 1)
  error ('wrong dimension in index list, index list should be 1xn or nx1');
end

motskelmap = constructSensor2JointMap(motion.sensornames, skeleton.jointnames);


idx = arrayfun(@(x) find([motskelmap{:,2}]==x), jointidx, 'UniformOutput', false);
idx = [idx{:}];



end % of functin deactivateJoint