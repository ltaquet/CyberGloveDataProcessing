
function [motion_annotation] = readDBKSannotation(motionannotationfilename)

% emptyMotionAnnotation
% 'D:\PhD\native\db-ks\data\ex03\rad\01_27_ex03-rad-064-grasp-su07_annot.txt'
%
% INPUT
%   motionannotationfilename ... string representing the filename (and path)
%                                of the motion annotation to load
% OUTPUT
%   mot_annot ... motion annotation structure
%
% EXAMPLE
% mot_annot = readDBKSannotation( 'D:\PhD\native\db-ks\data\ex03\rad\01_11_ex03-rad-002-grasp-su10_annot.txt' )



%motionannotationfilename = 'D:\PhD\native\db-ks\data\ex03\rad\01_11_ex03-rad-002-grasp-su10_annot.txt';


existsMAT = false;
writeMAT = false;

db_filename_end = strfind(motionannotationfilename, 'su')+3;
filename = motionannotationfilename(1:db_filename_end);
filename_suffix = motionannotationfilename(db_filename_end+1:end);
[~, filename_suffix] = fileparts(filename_suffix);
filenameMAT = [filename '.txt' filename_suffix '.mat'];


% try to load saved mat file
matfilehandle = fopen(filenameMAT);
if (matfilehandle~=-1)
  fclose(matfilehandle);
  load(filenameMAT, 'motion_annotation');
  motion_annotation.cutsm = double(motion_annotation.cutsm); % make sure it's double, not int32 for consistency
  existsMAT = true;
else
  writeMAT = true;
end


% load from original db file 
if (~existsMAT)
  fileID = fopen(motionannotationfilename);
  C = textscan(fileID,'%d %d %q',...
    'Delimiter','\n',...
    ...'TreatAsEmpty',{'NA','na'},...
    'CommentStyle','#');
  fclose(fileID);

  descr = filename2description(filename);
  [~, filename, ~] = fileparts(filename);
  cutsm_start = (C{1}(2:end))';
  cutsm_end = (C{2})';
  cutsm_annot = C{3};
  cutsm_lastframe = (C{2}(end))';

  motion_annotation = emptyMotionAnnotation;
  motion_annotation.ex = descr.experiment;
  %motion_annotation.m
  motion_annotation.filename = filename;
  motion_annotation.cutsm = double(cutsm_end);%start); % make sure they're in double and not int32
  motion_annotation.cutsm_annot = cutsm_annot;
  motion_annotation.num_frames = cutsm_lastframe;
  motion_annotation.nexpected_segments = computeNumberOfExpectedSegments(motion_annotation.cutsm_annot);

  if writeMAT
    save(filenameMAT, 'motion_annotation');
  end % fi  

end % fi



end % of MAIN function
