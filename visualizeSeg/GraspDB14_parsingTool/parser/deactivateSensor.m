
function motskelmap = deactivateSensor( motskelmap, sensoridx )
%
% deactivates sensors in the motion-skeleton-mapping
% 
% input
%   motskelmap ... mapping of sensors to skeleton joints and rotations
%   sensoridx .... sensors to deactivate
% output
%   motskelmap ... updated mapping of sensors to skeleton joints
% 

motskelmap(sensoridx, 3) = {[]};

end % of function deactivateSensor
