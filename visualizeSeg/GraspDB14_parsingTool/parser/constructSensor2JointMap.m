
function motskelindexmap = constructSensor2JointMap ( sensornames, jointnames )
% creates an index mapping between a motion file sensor names and a hand
% skeleton files joint names. It is based on KS' standard nomenclature.
% The map will have the following structure:
%   sensoridx | jointidx | axis
%   where
%     sensoridx ... index of sensor motionfile 
%     jointidx .... index of joint in skeleton
%     axis ........ string representing affected axis
%                   'flex' ~ local x axis (flexion (+) and extension (-) )
%                   'pron' ~ local y axis (pronation (+) and supination (-) )
%                   'abd'  ~ local z axis (abduction (+) and adduction (-) )
%
% map = constructSensor2JointMap ( motion.sensornames, skeleton.jointnames )
%

global GLOBAL_VARS_SETTINGS;

printwarning = true;

if (isfield(GLOBAL_VARS_SETTINGS, 'displayDeactivatedSensorWarning'))
  printwarning = GLOBAL_VARS_SETTINGS.displayDeactivatedSensorWarning;
end


k = 1;
jointidx = find(strcmpi( 'th-tmc', jointnames) );
sensoridx = find(strcmpi( 't-tmcj', sensornames) );
% motskelindexmap(k,:) = { sensoridx, jointidx, 'add' };
% motskelindexmap(k,:) = { sensoridx, jointidx, 'flex' };
motskelindexmap(k,:) = { sensoridx, jointidx, 'pron' };

k = k+1;
jointidx = find(strcmpi('th-mcp', jointnames));
sensoridx = find(strcmpi( 't-mcpj', sensornames) );
motskelindexmap(k,:) = { sensoridx, jointidx, 'flex' };

k = k+1;
jointidx = find(strcmpi('th-ip',  jointnames));
%sensoridx = find(strcmpi( 't-ij', sensornames) );
sensoridx = find(strcmpi( 't-ipj', sensornames) );
motskelindexmap(k,:) = { sensoridx, jointidx, 'flex' };

k = k+1;
jointidx = find(strcmp('th-mcp', jointnames));
sensoridx = find(strcmpi( 'ti-aa', sensornames) );
motskelindexmap(k,:) = { sensoridx, jointidx, 'abd' };

k = k+1;
jointidx = find(strcmp('if-mcp', jointnames));
sensoridx = find(strcmpi( 'i-mcpj', sensornames) );
motskelindexmap(k,:) = { sensoridx, jointidx, 'flex' };

k = k+1;
jointidx = find(strcmp('if-pip', jointnames));
%sensoridx = find(strcmpi( 'i-pij', sensornames) );
sensoridx = find(strcmpi( 'i-pipj', sensornames) );
motskelindexmap(k,:) = { sensoridx, jointidx, 'flex' };

k = k+1;
jointidx = find(strcmp('if-dip', jointnames));
%sensoridx = find(strcmpi( 'i-dij', sensornames) );
sensoridx = find(strcmpi( 'i-dipj', sensornames) );
motskelindexmap(k,:) = { sensoridx, jointidx, 'flex' };

k = k+1;
jointidx = 1;
sensoridx = find(strcmpi( 'i-aa', sensornames) );
motskelindexmap(k,:) = { sensoridx, jointidx, '' };

k = k+1;
jointidx = find(strcmp('mf-mcp', jointnames));
sensoridx = find(strcmpi( 'm-mcpj', sensornames) );
motskelindexmap(k,:) = { sensoridx, jointidx, 'flex' };

k = k+1;
jointidx = find(strcmp('mf-pip', jointnames));
%sensoridx = find(strcmpi( 'm-pij', sensornames) );
sensoridx = find(strcmpi( 'm-pipj', sensornames) );
motskelindexmap(k,:) = { sensoridx, jointidx, 'flex' };

k = k+1;
jointidx = find(strcmp('mf-dip', jointnames));
%sensoridx = find(strcmpi( 'm-dij', sensornames) );
sensoridx = find(strcmpi( 'm-dipj', sensornames) );
motskelindexmap(k,:) = { sensoridx, jointidx, 'flex' };

k = k+1;
jointidx = find(strcmp('if-mcp', jointnames));
sensoridx = find(strcmpi( 'mi-aa', sensornames) );
motskelindexmap(k,:) = { sensoridx, jointidx, 'abd' };

k = k+1;
jointidx = find(strcmp('rf-mcp', jointnames));
sensoridx = find(strcmpi( 'r-mcpj', sensornames) );
motskelindexmap(k,:) = { sensoridx, jointidx, 'flex' };

k = k+1;
jointidx = find(strcmp('rf-pip', jointnames));
%sensoridx = find(strcmpi( 'r-pij', sensornames) );
sensoridx = find(strcmpi( 'r-pipj', sensornames) );
motskelindexmap(k,:) = { sensoridx, jointidx, 'flex' };

k = k+1;
jointidx = find(strcmp('rf-dip', jointnames));
%sensoridx = find(strcmpi( 'r-dij', sensornames) );
sensoridx = find(strcmpi( 'r-dipj', sensornames) );
motskelindexmap(k,:) = { sensoridx, jointidx, 'flex' };

k = k+1;
jointidx = find(strcmp('rf-mcp', jointnames));
sensoridx = find(strcmpi( 'rm-aa', sensornames) );
motskelindexmap(k,:) = { sensoridx, jointidx, 'abd' };

k = k+1;
jointidx = find(strcmp('lf-mcp', jointnames));
sensoridx = find(strcmpi( 'l-mcpj', sensornames) );
motskelindexmap(k,:) = { sensoridx, jointidx, 'flex' };

k = k+1;
jointidx = find(strcmp('lf-pip', jointnames));
%sensoridx = find(strcmpi( 'l-pij', sensornames) );
sensoridx = find(strcmpi( 'l-pipj', sensornames) );
motskelindexmap(k,:) = { sensoridx, jointidx, 'flex' };

k = k+1;
jointidx = find(strcmp('lf-dip', jointnames));
%sensoridx = find(strcmpi( 'l-dij', sensornames) );
sensoridx = find(strcmpi( 'l-dipj', sensornames) );
motskelindexmap(k,:) = { sensoridx, jointidx, 'flex' };

k = k+1;
jointidx = find(strcmp('lf-mcp', jointnames));
sensoridx = find(strcmpi( 'lr-aa', sensornames) );
motskelindexmap(k,:) = { sensoridx, jointidx, 'abd' };

k = k+1;
% modelled as flexion/extension,
% the palm-arch sensor should cause the little finger to rotate across the palm
% according to the "cyberglove reference manual"
jointidx = find(strcmp('lf-cmc', jointnames));
sensoridx = find(strcmpi( 'p-arch', sensornames) );
%motskelindexmap(k,:) = { sensoridx, jointidx, 'flex' };
motskelindexmap(k,:) = { sensoridx, jointidx, '' };
q = dbstack; 
if (printwarning)
  warnstring = 'CyberGlove recorded palm arch sensor (''P-Arch'') is deactivated by default at the moment!';
  %cprintf (GLOBAL_VARS_SETTINGS.textcolour.WARNING, ...
  fprintf (...
    'WARNING:\n>>> %s <<<\n  %s at line %d\n\n', ...
    warnstring, ...
    q(1).file, ...
    q(1).line-1);
end %fi

k = k+1;
jointidx = find(strcmp('root',   jointnames));
sensoridx = find(strcmpi( 'w-fe', sensornames) );
motskelindexmap(k,:) = { sensoridx, jointidx, 'flex' };

k = k+1;
jointidx = find(strcmp('root',   jointnames));
sensoridx = find(strcmpi( 'w-aa', sensornames) );
%motskelindexmap(k,:) = { sensoridx, jointidx, 'flex' };
motskelindexmap(k,:) = { sensoridx, jointidx, 'abd' };

% check for mismatches in length for each (relevant) column of the map
if ( length([motskelindexmap{:,1}]) ~= k )
  msg = ['KS> Dimension mismatch occurred:\n    First column (sensor indices) has ', ...
            num2str(length([motskelindexmap{:,1}])),' rows while it should have ', ...
            num2str(k),' rows.\n    ', ...
            'Check motion file!'];
  causeException = MException('MATLAB:KScode:dimensions',msg);
  throw(causeException);
end
if ( length([motskelindexmap{:,2}]) ~= k )
  msg = ['KS> Dimension mismatch occurred:\n    Second column (joint indices) has ', ...
            num2str(length([motskelindexmap{:,2}])),' rows while it should have ', ...
            num2str(k),' rows.\n    ', ...
            'Check skeleton file!'];
  causeException = MException('MATLAB:KScode:dimensions',msg);
  throw(causeException);
end

% for debug purposes, may be removed later on
motskelindexmap(:,4) = sensornames([motskelindexmap{:,1}]);
motskelindexmap(:,5) = jointnames([motskelindexmap{:,2}]);  

end