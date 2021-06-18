function [num_exp_segs] = computeNumberOfExpectedSegments ( cutsm_annot )
% compute number of expected segments in an annotated motion based on the
% annotation (every expected segment starts with a '.' in the textual
% annotation)
%
% INPUT
%   cuts_annot ... textual annotation of the motion segments (from a manual
%                  segmentation) <1 x ncuts+1> cell array of strings
% OUTPUT
%   num_exp_segs ... the number of expected segments
%
% EXAMPLE
% mot_annot = readDBKSannotation( 'D:\PhD\native\db-ks\data\ex03\rad\01_11_ex03-rad-002-grasp-su10_annot.txt' )
% nexpsegs = computeNumberOfExpectedSegments(mot_annot.cutsm_annot);
%

% find all annotations starting with '.'
bool_has_leading_dot = cellfun(@(x) x(1)=='.', cutsm_annot);
% number of annotations starting with '.'
sum_all_leading_dot = sum(bool_has_leading_dot);
% find sequences of dots 
seq_leading_token = diff(bool_has_leading_dot);
% get type of sequence of leading token (token = '.' or ~'.')
consecutive_leading_token_type = bool_has_leading_dot(~logical([true; seq_leading_token]));
sum_consecutive_leading_dot = sum(consecutive_leading_token_type);

num_exp_segs = sum_all_leading_dot-sum_consecutive_leading_dot;

end % of MAIN function