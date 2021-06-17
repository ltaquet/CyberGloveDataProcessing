
function qconj = quatconjugate ( quat4xm )
% conjugate a quaternion

if (size(quat4xm,1)~=4)
    error('Number of rows of input quat must be 4!');
end

% q = a + bi + cj + dk = [a; b; c; d]
% konj(q) = a - bi - cj - dk = [a; -b; -c; -d]
m = size(quat4xm, 2);
qconj = quat4xm .* [ones(1,m);-ones(3,m)];

end % of quatconjugate