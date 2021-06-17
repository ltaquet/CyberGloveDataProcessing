
function [motion_annotation] = emptyMotionAnnotation()
% construct an empty motion annotation struct
%
% INPUT
%   none
%
% OUTPUT
%   motion_annotation ... motion annotation struct with the following fields:
%     .ex                   id of the experiment the motion was part of
%     .m                    number of the file within the loadable
%                           files&folders structure
%     .filename             string containing the filename (only the
%                           filename not the path)
%     .cutsm                segments/cuts in the motion segmenting the
%                           motion into different phases. Start and end
%                           frames in the motion are left out.
%                           format: <#cuts x 1> array 
%     .cutsm_annot          relative time stamps (time elapsed since first frame)
%                           format: <#cuts+1 x 1> cell
%     .num_frames           number of frames in the motion file
%     .nexpected_segments   number of segments/cuts expected
%                           was used to record the number of static phases a motion has
%
% EXAMPLE
%  motion_annotation = emptyMotionAnnotation
%



motion_annotation = ...
  struct ( ...
    'ex', -1, ...                   % id of experiment
    'm', -1, ...                    % number of file in the loadable files&folders structure
    'filename', ' ', ...            % string containing the name of the file (not the path)
    'cutsm', [], ...                % double array of cuts (linear progression)
    'cutsm_annot', cell(1,1), ...   % cell array of annotations for each cut (one more than cuts)
    'num_frames', -1, ...           % number of frames in the motion file
    'nexpected_segments', -1 ...    % number of segments expected
  );

end