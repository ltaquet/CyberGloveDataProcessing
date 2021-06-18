
function mat = rotmat ( angle, axis )
% construct rotation matrix wrt one  of the standard cartesian axes
%
% mat = rotmat ( angle, axis )
%
%   angle ... rotation angle in [rad]
%   axis .... string representing the axis of rotation, 
%             i.e. 'x' => x-axis
%                  'y' => y-axis
%                  'z' => z-axis
%
% 

ca = cos(angle);
sa = sin(angle);

switch axis
  case 'x'
    mat = [ ... 
      1  0   0; ...
      0 ca -sa; ... 
      0 sa  ca ...
      ];
  case 'y'
    mat = [ ... 
       ca 0 sa; ... 
        0 1  0; ...
      -sa 0 ca ...
      ];
  case 'z'
    mat = [ ... 
      ca -sa 0; ... 
      sa  ca 0; ...
       0   0 1 ...
      ];
  otherwise
    error (['no such standard axis: ', axis, '!'])
end % switch


end % of function rotmat