%%

function joint = emptyJoint

joint = ...
  struct ( ...
    'jointname', '', ...                 % name of the joint
    'id', 0, ...                         % ID of the joint
    'children', [], ...                  % list of child joint IDs
    'parent',  0, ...                    % parent ID joint
    'offset', [0;0;0],...                % offset in position of this joint to its parent
    'position', [0;0;0], ...             % absolute position of the this joint
    'localcoordinatesystem', eye(3), ... % columns of this matrix represent the local coordinate system
    'dof', [0,0,0], ...                  % degrees of freedom encoded in boolean values (dof(i)=1 => axis i is a dof, dof(i)=0 => axis i is not)
    'limits', zeros(3,2) ...             % limits in [deg] for each degree of freedom
  );    


end % of function emptyJoint
