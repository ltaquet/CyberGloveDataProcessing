
function mat = chop2zero( mat, delta )
% replaces numbers smaller in absolute magnitude than delta by 0
% default delta is eps (matlab machine epsilon)
%

if (nargin < 2)
  delta = eps;
end

temp = (abs(mat) > delta);
mat = mat .* temp;

end % of function chop2zero