
function qinv = quatinvert ( quat4xm )
% invert a quaternion

if (size(quat4xm,1)~=4)
    error('Number of rows of input quat must be 4!');
end


% inv(q) = konj(q) / ||q||2
qinv = quatconjugate(quat4xm) ./ ( ones(4,1)*quatnormsquared(quat4xm) );

% norm
% ||q|| = Sqrt(a*a + b*b + c*c + d*d) = Sqrt(q*konj(q))




end % of quatinvert