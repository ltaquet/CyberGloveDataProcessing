function motion = loadDBKSmotion (filename, skel, type)
%
% Load or read in a motion file. A file is read in if there is no
% appropriata .mat motion file, otherwise it's just loaded.
% 
% Load a pre-saved .mat motion file from the db-ks database. Pre-saved .mat
% motion files exist for no pre-calculated joint trajectories, for
% pre-calculated joint trajectories with fixed root (no motion inferred
% from the root) and a full set of pre-calculated joint trajectories.
%
% INPUT
%   filename ... full database (db-ks) path and filename for file to load
%   skel ....... skeleton struct
%   type ....... 'plain' load motion without precalculated joint
%                  trajectories
%                'full' load motion with all joint trajectories
%                  precalculated
%                'fixed-root' load motion with simulated not moving wrist
%                  joint in the precalculated joint trajectories
%                 
% 
% OUTPUT
%   motion ... motion struct
%
% EXAMPLES
%   loadDBKSmotion([folders{3} files{3}(901).name],skel, 'full');
%   loadDBKSmotion('D:\PhD\native\db-ks\data\ex03\rad\12_00_ex03-1-rad-025-grasp-su04.txt', skel, 'fixed-root');
%
%

% if only a filename is given it is will load a specific .mat file
% this will not be documented!
if nargin==1
  motion = load ( filename, 'motion'); 
  % you'll have to make sure it will carry the correct filename and not the
  % one it was saved with. Also it has to be the correct file extension.
  % You have been warned :) (should you ever again read your documentation)
  return;
end

% determine filenamesupplement for loading the file
switch type
  case 'plain'
    filenamesupplement = '.mat';
  case 'full'
    filenamesupplement = '_w_traj.mat';
  case 'fixed-root'
    filenamesupplement = '_w_traj_fixedroot.mat';
  otherwise
    fprintf ('No such type: ''%s''!\n', type);
end

filenameMAT = [filename, filenamesupplement];

% try to load saved mat file
matfilehandle = fopen(filenameMAT);
if matfilehandle ~= -1
  fclose(matfilehandle);
  load(filenameMAT, 'motion');
  existsMAT = true;
  % set correct filename
  motion.filename = filename;
else
  existsMAT = false;
end

% if there is no mat file, create one!
if ~existsMAT
  mot = readDBKSmotion(filename);
  switch type
    case 'plain'
      %done, actually
      motion = mot;
    case 'full'
      motion = calcJointTrajectories ( mot, skel, [] );
    case 'fixed-root'
      motion = calcJointTrajectories ( mot, skel, deactivatedJoints( mot, skel, name2index(skel.namemap, 'root')) );
  end
end

end
