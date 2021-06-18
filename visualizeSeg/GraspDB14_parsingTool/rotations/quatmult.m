
function qmult = quatmult ( q1, q2 )
% multiplication of two quaternions or two arrays of quaternions (one
% quaternion per column)
%
% Q = quatmult ( Q1, Q2 );

if ( (size(q1,1)~=4) || (size(q2,1)~=4) )
    error('Number of rows of input quat must be 4!');
end
if ( size(q1,2) ~= size(q2,2) )
    error('Input dimension mismatch (wrong number of columns)!');
end


% A = a + bi + cj + dk = [a; b; c; d]
% B = e + fi + gj + hk = [e; f; g; h]
% A*B = (a * e - b * f - c * g - d * h)
%     + (a * f + b * e + c * h - d * g)i
%     + (a * g - b * h + c * e + d * f)j
%     + (a * h + b * g - c * f + d * e)k 


r1 = q1(1,:); i1 = q1(2,:); j1 = q1(3,:); k1 = q1(4,:);
r2 = q2(1,:); i2 = q2(2,:); j2 = q2(3,:); k2 = q2(4,:);

qmult = [ ...
  r1.*r2 - i1.*i2 - j1.*j2 - k1.*k2; ...
  r1.*i2 + i1.*r2 + j1.*k2 - k1.*j2; ...
  r1.*j2 - i1.*k2 + j1.*r2 + k1.*i2; ...
  r1.*k2 + i1.*j2 - j1.*i2 + k1.*r2
];


end % of function quatmult