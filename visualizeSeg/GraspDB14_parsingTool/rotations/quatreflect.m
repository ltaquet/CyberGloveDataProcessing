
function newmat = quatreflect ( mat3xn, quat4x1 )
% reflect each column of a matrix by quaternion
%
% 

if (size(mat3xn,1)~=3)
    error('Input matrix has to have 3 rows!');
end
if (size(quat4x1,1)~=4)
    error('Input quaternion has to have 4 rows!');
end

n = size(mat3xn,2);
m = size(quat4x1,2);
if (m==1 && n>=1)
    quat4x1 = quat4x1(:, ones(1, n));
    m = size(quat4x1,2);
end

% p' = q*p*inv(q) % where * denotes quaternion multiplication
temp = quatmult( quatmult(quat4x1, [zeros(1,n);mat3xn]), quat4x1 );
newmat = temp(2:4,:);


end % of function quatrotate