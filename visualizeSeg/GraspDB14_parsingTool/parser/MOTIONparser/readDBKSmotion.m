
function motion = readDBKSmotion( motionfilename )
%READDBKSMOTION Summary of this function goes here
%   Detailed explanation goes here
%
% INPUT
%   motionfilename ... string representing the filename of the motion to
%                      load
%
% OUTPUT
%   motion ... motion structure
%
% EXAMPLE
% motion = readDBKSmotion( 'afilename_with_path' )

existsMAT = false;
writeMAT = false;

filenameMAT = [motionfilename, '.mat'];

% try to load saved mat file
matfilehandle = fopen(filenameMAT);
if (matfilehandle~=-1)
  fclose(matfilehandle);
  load(filenameMAT, 'motion');
  existsMAT = true;
  % set correct filename
  motion.filename = motionfilename;
else
  writeMAT = true;
end

% load from original db file 
if (~existsMAT)
  % generate namemap (for db-ks!)
  namemap = namemapCyberglove(18);

  % initialize motion
  motion = emptyMotion;

  filecontent = dlmread( motionfilename );
  % #frames rows
  % #joints columns
  motion.timestamps = filecontent(:,1:6);
  motion.switchstates = filecontent(:,7);
  motion.angledata = filecontent(:,8:end);
  motion.numberofangles = size(motion.angledata,2);
  motion.numberofframes = size(motion.angledata,1);
  % compute elapsed seconds
  motion.elapsedtime = etime(motion.timestamps, repmat(motion.timestamps(1,:),motion.numberofframes,1));
  %'samplingrate', 60, ...        % sampling rate (inverse of frame time)
  motion.samplingrate = motion.numberofframes/motion.elapsedtime(end);
  motion.filename = motionfilename;
  %'filename', ' ' ...            % name of the source file
  motion.sensornames = namemap(:,1);
  motion.active = find([namemap{:,2}])';
  motion.inactive = find(~[namemap{:,2}])';
  
  if max(max(motion.angledata))>7
    motion.angleunit = 'raw';
  end
  
  if writeMAT
    save(filenameMAT, 'motion');
  end % fi
  
end % fi






end

