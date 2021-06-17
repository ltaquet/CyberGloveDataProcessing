
function motskelmap = deactivateJoint( motskelmap, jointidx )
%
% deactivates joints in the motion-skeleton-mapping
% 
% input
%   motskelmap ... mapping of sensors to skeleton joints and rotations
%   jointidx ..... joints to deactivate
% output
%   motskelmap ... updated mapping of sensors to skeleton joints
% 

if ( size(jointidx,1) < size(jointidx,2) )
  jointidx = jointidx';
end
if (size(jointidx, 2) ~= 1)
  error ('wrong dimension in index list, index list should be 1xn or nx1');
end



idx = arrayfun(@(x) find([motskelmap{:,2}]==x), jointidx, 'UniformOutput', false);
idx = [idx{:}];

motskelmap(idx, 3) = {[]};


end % of functin deactivateJoint