function skeleton = rootToZero ( skeleton )
% move the skeleton joints such that the root joint lies at point (0,0,0) 
%
% INPUT
%   skeleton ... skeleton struct
%
% OUTPUT
%   skeleton ... skeleton struct with root at zero
%
% EXAMPLE
%   skel = rootToZero ( skel );
%

rootidx = name2index(skeleton.namemap, 'root');

translation = skeleton.joints(rootidx).position;

% see if translation is zero and only do somthing if it is not
if any(translation)
  for k=1:skeleton.numberofjoints
    skeleton.joints(k).position = skeleton.joints(k).position - translation;
  end % endfor
end % fi translation is all zeros

end