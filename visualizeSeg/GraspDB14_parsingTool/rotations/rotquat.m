
function quat = rotquat ( angle, axis )
% construct rotation quaternion wrt the given angle and axis
%
% quat = rotquat ( angle, axis )
%
%   angle ... rotation angle in [rad]
%   axis .... 3d vector representing the axis of rotation
%             if the vector is not a unit vector it will be normalized
% 

ca = cos(angle/2);
sa = sin(angle/2);

axis = axis/norm(axis);

quat = [ca; axis(1)*sa; axis(2)*sa; axis(3)*sa];


end % of function rotquat