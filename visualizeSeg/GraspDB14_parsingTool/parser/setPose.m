
function skeleton = setPose ( skeleton, skelidx, angles, axes )
% 
%


emptyaxis = find(cellfun('isempty', axes));

axes(emptyaxis) = [];
skelidx(emptyaxis) = [];
angles(emptyaxis) = [];

for k = 1:length(angles)
  skeleton = fwdKinematics(skeleton, [skelidx{k}],angles(k), axes{k});
end;

end % of function setPose
