%%

function skeleton = emptySkeleton
  
  skeleton = ...
    struct ( ...
      'numberofjoints', 0, ...     % number of joints
      'joints', struct([]), ...    % joints representing nodes in the skeleton (rooted DAG) structure
      'jointnames', cell(1,1), ... % joint names
      'namemap',cell(1,1),...      % cell array mapping struct ids to joint ids to joint names
      'paths', cell(1,1), ...      % contains paths for drawing the skeleton (sequence of joint IDs)
      ...%'active', [], ...            % IDs of active joints (that should be animated)
      ...%'inactive', [], ...          % IDs of inactive joints (that should stay unanimated/fix)
      'angleunit', 'rad', ...      % angle unit (rad or deg)
      'lengthunit', 'mm', ...      % length unit (mm or ...)
      'scale', 1, ...              % scale factor for the skeleton
      'filename', '', ...          % name of the file this skeleton originated from
      'filetype', '' ...           % type of the file this skeleton originated from
    );
    
  % structs have to be initialized a little
  skeleton.joints = emptyJoint;

end % of function emptySkeleton
