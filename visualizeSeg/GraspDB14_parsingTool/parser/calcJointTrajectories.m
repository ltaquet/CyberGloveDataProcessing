
function motion = calcJointTrajectories ( motion, skeleton, varargin )
%
% INPUT
%   motion
%   skeleton
%   varargin{1} ... deactivated sensors
%   varargin{2} ... (true) => re-calculate motion trajectories and ignore saved ones
%                   (false) => don't (default)
%   varargin{3} ... (true) => calculate joints inactive in the recording 
%                             such as the -dip joints for db-ks (default).
%                   (false) => don't
%   varargin{4} ... (true) => write output to disk (this is also influenced
%                             by deactivated, if only root or no joints are 
%                             deactivated this option will be respected (default)
%                   (false) => don't
%
% OUTPUT
%   motion ... motion struct with filled fields .jointtrajectories
%              and .localcoordinatesystems
%
% EXAMPLE
%   mot = calcJointTrajectories ( mot, skel, [] );
%   mot = calcJointTrajectories ( mot, skel, deactivatedJoints( mot, skel, name2index(skel.namemap, 'root')));
% 
%   skelleaps = readSkeleton ( strcat(GLOBAL_VARS_SETTINGS.path_skel,'default-leapks.xmlskel'), 'nofix' );
%   mott = calcJointTrajectories ( mot(1), skelleaps, deactivatedJoints( mot(1), skelleaps, name2index(skelleaps.namemap, 'root')), true, false, false );
% 
%


% only want 5 optional inputs at most
numvarargs = length(varargin);
if numvarargs > 5
    error('calcJointTrajectories:TooManyInputs', ...
        'requires at most 3 optional inputs');
end

temp_name = tempname;
[~, rand_string] = fileparts(temp_name);

optargs = {[], false, true, true, ['_',rand_string,'.mat']};
[optargs{1:numvarargs}] = varargin{:};
% Place optional args in memorable variable names
[deactivated recalc, calc_inactive, write_output, uniquename] = optargs{:};




tryloaddirectly = false;
existsMAT = false;
writeMAT = false;

motionfilename = motion.filename;
filenameMAT = [motionfilename, uniquename];

if isempty(deactivated)
    % matfilename for no deactivated joints
    filenameMAT = [motionfilename, '_w_traj.mat'];
    tryloaddirectly = ~recalc;
end %fi

inactive = [];
if ~calc_inactive
  inactive = deactivatedJoints( motion, skeleton, name2index(skeleton.namemap, {'if-dip','rf-dip','mf-dip','lf-dip'}));
end

% load mapping of sensors to joint names and axes of rotation
motskelmap = constructSensor2JointMap(motion.sensornames, skeleton.jointnames);
motskelmap = deactivateSensor(motskelmap, [deactivated inactive]);

rootidx = name2index(skeleton.namemap, 'root');

if ~tryloaddirectly
  jointidx = [motskelmap{[deactivated], 2}];
  if isempty(find(jointidx-rootidx, 1)) % stopps after finding the first nonempty entry
    if (calc_inactive)
      % matfilename for deactivated root (and only root)
      filenameMAT = [motionfilename, '_w_traj_fixedroot.mat'];
    else
      % matfilename for deactivated root (and inactive joints)
      filenameMAT = [motionfilename, '_w_traj_fixedrootdip.mat'];      
    end
  end
end

% try to load saved mat file
matfilehandle = fopen(filenameMAT);
if (matfilehandle~=-1 & ~recalc)
  fclose(matfilehandle);
  load(filenameMAT, 'motion');
  existsMAT = true;
  % set correct filename
  motion.filename = motionfilename;
else
  if ~(strcmpi(filenameMAT, [motionfilename, 'notexistant.mat']))
    writeMAT = write_output;
  else
    writeMAT = false;
  end
end

% writeMAT = false; %right now nothing is written! TODO, remove this line later


% calcuate trajectories
if (~existsMAT)
  %CS = [skel.joints(:).localcoordinatesystem];
  %ccs = mat2cell(CS, 3, ones(1,25)*3)';

  % initialize empty cell array;
  jointtrajectories = cell(skeleton.numberofjoints,1);
  localccs = cell(skeleton.numberofjoints,1);
  linearcounter=1;
  for k = 1:motion.numberofframes
    % calculate pose for every entry
    skel2 = setPose( skeleton, motskelmap(:,2), -motion.angledata(k,:), motskelmap(:,3) );
    pose = [skel2.joints(:).position];
    cs = [skel2.joints(:).localcoordinatesystem];%coordinate systems
    ccs = mat2cell(cs, 3, ones(1,skel2.numberofjoints)*3)'; % in a cell array
    % set pose for each frame
    for j=1:skeleton.numberofjoints
      jointtrajectories{j,1}(:,linearcounter) = pose(:,j);
      localccs(j,linearcounter) = ccs(j);
    end
    linearcounter = linearcounter+1;
  end

  motion.jointtrajectories = jointtrajectories;
  motion.localcoordinatesystems = localccs;
  
  % save eventually
  if writeMAT
      save(filenameMAT, 'motion');
  end %fi

end %fi

end % of function calcJointTrajectories