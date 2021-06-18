
function qnormsq = quatnormsquared ( quat4xm )
% compute squared norm of  a quaternion

if (size(quat4xm,1)~=4)
    error('Number of rows of input quat must be 4!');
end

% q = a + bi + cj + dk = [a; b; c; d]
% ||q||^2 = (a*a + b*b + c*c + d*d) = (q*konj(q))
qnormsq = sum(quat4xm .* quat4xm);




end % of quatnormsquared