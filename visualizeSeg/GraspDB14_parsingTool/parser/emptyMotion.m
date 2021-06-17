
function motion = emptyMotion
% construct an empty motion struct
%
% INPUT
%   none
%
% OUTPUT
%   motion ... motion struct with the following fields:
%     .numberofangles           number of angles (sensors recorded) in the motion
%     .numberofframes           number of frames
%     .samplingrate             sampling rate (inverse of frame time)
%     .timestamps               time stamps
%                               format: <#frames x 6> array 
%     .elapsedtime              relative time stamps (time elapsed since first frame)
%                               format: <#frames x 1> array 
%     .switchstates             state of the switch (ON|OFF)
%                               format: <#frames x 1> array 
%     .angledata                succession of joint angles for the entire time (angle trajectories)
%                               format: <#frames x 23> array 
%     .sensornames              name identifyer for each sensor (representing a joint angle "trajectory")
%                               format: <23 x 1> cell array of strings
%     .active                   indices into angledata marking measured angles (opposed to calculated angles)
%                               format: <18 x 1> array or <22 x 1> array
%     .inactive                 indices into angledata marking calculated angles (opposed to measured angles)
%                               format: <5 x 1> array or <1 x 1> array
%     .angleunit                angle unit (rad or deg)
%     .filename                 name of the source file
%     .jointtrajectories        position of the joints over time (#joints x 1 cell array, each entry contains a 3 x #frames positional joint trajectory)
%                               format: <#joints x 1> cell array of <3 x #frames> arrays
%     .localcoordinatesystems   local coordinate system of the joints over time ( #joints x #frames cell array, each entry contains the local coordinate system of a joint)
%                               format: <#joints x #frames> cell array (each entry is a 3x3 matrix)
%
% EXAMPLE
%  motion = emptyMotion
%



motion = ...
  struct ( ...
    'numberofangles', 0, ...                % number of angles in the motion
    'numberofframes', 0, ...                % number of frames
    'samplingrate', 60, ...                 % sampling rate (inverse of frame time)
    'timestamps', [], ...                   % time stamps
    'elapsedtime', [], ...                  % relative time stamps (time elapsed since first frame)
    'switchstates', [], ...                 % state of the switch (ON|OFF)
    'angledata', [], ...                    % succession of joint angles for the entire time (for positions this would be the trajectory)
    'sensornames', cell(1,1), ...           % name identifyer for each sensor (representing a joint angle "trajectory")
    'active', [], ...                       % indices into the jointangles marking measured angles (opposed to calculated angles)
    'inactive', [], ...                     % indices into the jointangles marking calculated angles (opposed to measured angles)
    'angleunit', 'rad', ...                 % angle unit (rad or deg)
    'filename', ' ', ...                    % name of the source file
    'jointtrajectories', cell(1,1), ...     % position of the joints over time (#joints x 1 cell array, each entry contains a 3 x #frames positional joint trajectory)
    'localcoordinatesystems', cell(1,1) ... % local coordinate system of the joints over time ( #joints x #frames cell array, each entry contains the local coordinate system of a joint)
  );    

end