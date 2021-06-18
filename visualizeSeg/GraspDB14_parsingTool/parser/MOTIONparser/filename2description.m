
function description = filename2description ( motfilename )
%
% description = filename2description ( motfilename )
%
% INPUT
%   motionfilename ... filename of the file to extract the description of
%                      (best with full path)
% OUTPUT
%   description ... struct containing information on the file, i.e.
%      .experiment   ID of the experiment
%      .objectid     ID of the object interacted with or 'various'
%      .object       object represented by the object ID
%      .subjectid    subject taking the experiment
%      .hand         'left', 'right' or 'both', which hand was leading in the movement
%      .action       'stream' or action the motion contains
%      .feixid       ID of the grasp following to feix (only for exp 3)
%      .angleunit    'rad' or 'raw'
%

description = ... 
  struct ( ...
    'experiment', 0, ...      % number of the experiment
    'objectid', 0, ...        % ID of the object interacted with
    'object', 'various', ...  % object interacted with
    'subjectid', 0, ...       % ID of the subject 
    'hand', '', ...           % main hand for interaction
    'action', '', ...         % action executed 'stream', 'rest', 'interaction', 'open', 'close' 'close fast'
    'feixid', 0, ...          % grasp id after feix
    'angleunit', 'rad' ...    % 
  );

objectlist_de = {
  'Ball';
  'Stift';
  'Flasche';
  'Tasse';
  'Glas';
  'Schale';
  'Wurfel';
  'Visitenkarte';
  'Apfelmusglas';
  'Wasserkasten';
  'Buch/Heft';
  'Zylinder-dunn';
  'Zylinder-dick';
  'Karton-liegend';
  'Karton-stehend';
  'Flaschendeckel';
  };

objectlist_en = {
  'ball';
  'pen';
  'bottle';
  'mug';
  'glass';
  'bowl';
  'cube';
  'business card';
  'oval jar';
  'bottle crate';
  'classic notebook';
  'cylinder small dia.';
  'cylinder larger dia.';
  'carton lying flat';
  'carton standing'
  'bottle-cap';
  };

objectlist = objectlist_en;

slashes = strfind( motfilename, filesep );
if ~(isempty(slashes)) 
  lastslash = slashes(end);
  filename = lower( motfilename( lastslash+1:end ) );
else 
  filename = lower( motfilename );
end
dots = strfind( filename, '.' );
if ~(isempty(dots)) 
  lastdot = dots(end);
  filename = lower( filename( 1:lastdot-1 ) );
end


% type = 1 => stream
% type = 2 => cut
% type = 3 => sorted
% type = 4 => calibration
type = 0;


% fprintf('%s => %s\n', motfilename, filename );

%%% get experiment/calibration
result = strfind(filename, 'ex');
if ~isempty(result)
  % fprintf('Experiment %s\n', filename(result+2:result+3));
  description.experiment = str2num(filename(result+2:result+3));
  if ~(result(1) == 1) type = 3; end
end

result = strfind(filename, 'rad');
if (isempty(result) ) 
  result = strfind(filename, 'raw');
end
description.angleunit = filename(result:result+2);
% fprintf('Angle unit %s\n', filename(result:result+2));

% if  angle unit is at the end of the filename => 
% the data is either the entire recorded stream
% or the stream cut into grasp and rest motions
if (result(1)+2 == length(filename)) 
  type = 1; 
else % it is the stream cut if sorted is not already set true
  if (~type) type = 2; end
end

result = strfind(filename, 'calib');
if (~(isempty(result)) && type>1 )
  % calibration stream file
  type = 4;
  description.object = 'none';
  description.action = 'calibration';
  description.hand = 'right';
end


switch type
  case 1
    handleStreamFile
  case 2
    handleCutFile
  case 3
    handleSortedFile
  case 4
     handleCalibrationFile
  otherwise
end

if description.feixid==14
  description.objectid = 16;
  description.object = objectlist{description.objectid};
end


%%%%%%%%%%%%%%%%%%%% handle types of files 
  function handleStreamFile
  % recorded in the experiments one stream per experiment
  
    % ex01_20141128084032-rad
    % retrieve subject
    result = strfind(motfilename, 'subject');
    % fprintf('Subject %s\n', filename(result+7:result+8));
    description.subjectid = str2num(motfilename(result+7:result+8));
    description.action = 'stream';
    switch description.experiment
      case 0
        description.hand = 'right';
        result = strfind(filename, 'calib');
        if ~isempty(result)
          description.object = 'calibration';
        end
      case 1
        description.hand = 'right';
      case 2
        description.hand = 'both';
      case 3
        description.hand = 'right';
    end
    
  end % of funtion handleStreamFile



  function handleCutFile
  % experiment files cut according to switch states into 'grasp' and 'rest'
  % periods
  
    % ex01-rad-000-rest-su01
    % ex01-rad-001-grasp-su01
    % retrieve subject
    result = strfind(filename, 'su');
    % fprintf('Subject %s\n', filename(result+2:result+3));
    description.subjectid = str2num(filename(result+2:result+3));
    % retrieve action
    result = strfind(filename, 'rest');
    if (isempty(result))
      result = strfind(filename, 'grasp');
      l=4;
    else l=3;
    end
    % fprintf('Action %s\n', filename(result:result+l));
    description.action = filename(result:result+l);
    switch description.experiment
      case 1
        description.hand = 'right';
      case 2
        description.hand = 'both';
      case 3
        description.hand = 'right';
    end

  end % end handleCutFile



  function handleSortedFile
  % cut experiment files only containing the grasp parts of the motions
  % filenames also include the respective actions.
  
    % check for wronly named file (see db-table errata)
    if (strcmpi(filename, '08_06_ex03-1-raw-030-grasp-su04') || strcmpi(filename, '08_06_ex03-1-rad-030-grasp-su04') )
      warnstring = sprintf('internally changed filename "%s" to', filename);
      filename(1:2) = '12';
      warning('%s "%s" (check dbtable-errata.html)', warnstring, filename);
    end
    if (strcmpi(filename, '12_16_ex03-rad-092-grasp-su08') || strcmpi(filename, '12_16_ex03-rad-092-grasp-su08') )
      warnstring = sprintf('internally changed filename "%s" to', filename);
      filename(4:5) = '08';
      warning('%s "%s" (check dbtable-errata.html)', warnstring, filename);
    end
    if (strcmpi(filename, '01_26_ex03-rad-044-grasp-su02') || strcmpi(filename, '01_26_ex03-rad-044-grasp-su02') )
      warnstring = sprintf('this file ("%s") seems to be empty and no valid file has been found.', filename);
      warning('%s (check dbtable-errata.html)', warnstring);
      % retrieve subject
      result = strfind(filename, 'su');
      % fprintf('Subject %s\n', filename(result+2:result+3));
      description.subjectid = str2num(filename(result+2:result+3));
      % retrieve object
      description.objectid = str2num(filename(1:2));
      description.object = 'nothing';
      description.feixid = 0;
      description.hand = '';
      description.action = '';
      return;
    end
  
  
    % 01_ex01-rad-002-grasp-su01
    % 12_08_ex03-2-raw-047-grasp-su04
    % 03_s_l_ex02-raw-010-grasp-su01
    % 03_o_r_ex02-raw-001-grasp-su01
    % retrieve subject
    result = strfind(filename, 'su');
    % fprintf('Subject %s\n', filename(result+2:result+3));
    description.subjectid = str2num(filename(result+2:result+3));
    % retrieve object
    % fprintf('Object %s %s\n', filename(1:2), objectlist{str2num(filename(1:2))});
    description.objectid = str2num(filename(1:2));
    description.object = objectlist{str2num(filename(1:2))};
    % retrieve experiment dependent information
    switch (description.experiment)
      case 1
        % fprintf('Hand %s\n', 'right' );
        % fprintf('Action %s\n', 'grasp' );
        description.hand = 'right';
        description.action = 'grasp';
      case 2
        % retrieve hand
        hand = 'unclear';
        switch filename(6)
          case 'l'
            hand = 'left';
          case 'r'
            hand = 'right';
        end
        % fprintf('Hand %s\n', hand );
        description.hand = hand;
        % retrieve action
        action = 'unclear';
        switch (filename(4))
          case 'o'
            action = 'open';
          case 'i'
            action = 'interaction';
          case 's'
            action = 'close';
          case 'f'
            action = 'close tightly';
        end
        % fprintf('Action %s\n', action );
        description.action = action;
      case 3
        % fprintf('Feix ID %s\n', filename(4:5) );
        % fprintf('Hand %s\n', 'right' );
        % fprintf('Action %s\n', 'grasp' );
        description.feixid = str2num(filename(4:5));
        description.hand = 'right';
        description.action = 'grasp';
      otherwise
        % fprintf('?\n');
    end
    
  end % of function handleSortedFile



  function handleCalibrationFile
  % Stream calibration file in database path.
  
    % 00_calib-raw-su07.txt
    % 00_calib-ra[d|w]-su##.txt

    result = strfind(filename, 'su');
    % fprintf('Subject %s\n', filename(result+2:result+3));
    description.subjectid = str2num(filename(result+2:result+3));

  end % of handleCalibrationFile


% fprintf('\n');

end % of function filename2description

