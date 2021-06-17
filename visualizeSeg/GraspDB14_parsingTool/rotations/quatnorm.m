
function qnorm = quatnorm ( quat4xm )
% compute norm of  a quaternion

if (size(quat4xm,1)~=4)
    error('Number of rows of input quat must be 4!');
end

% q = a + bi + cj + dk = [a; b; c; d]
% ||q|| = Sqrt(a*a + b*b + c*c + d*d) = Sqrt(q*konj(q))
qnorm = sqrt(sum(quat4xm .* quat4xm));




end % of quatinvert