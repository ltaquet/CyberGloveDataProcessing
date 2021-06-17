function [ pose ] = frame2pose( motion, frame )
%
% Convert a motion frame to a skeleton pose
%
% INPUT
%   motion ... motion struct containing joint trajectories
%   frame .... frame to convert to a pose
%
% OUTPUT
%   pose ......... struct describing the skeleton pose at specified frame f
%     pose.pos ... positions of joints in frame f
%     pose.lcs ... local coordinate systems of joints in frame f
%
% EXAMPLE
%   pose = frame2pose( motion, 3 );
%


P = [motion.jointtrajectories{:}];
Q = reshape(P, motion.numberofframes*3, size(motion.jointtrajectories,1))';
pose.pos = Q(:,frame*3-2:frame*3)'; % equals in shape pose = [skel.joints(:).position]; [3 x #joints]
pose.lcs = motion.localcoordinatesystems(:,frame);



end % of function frame2pose

