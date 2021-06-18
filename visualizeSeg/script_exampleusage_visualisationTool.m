addpath(genpath('GraspDB14_parsingTool'));
addpath(genpath('GraspDB14_visualisationTool'));

filename = ['data' filesep '16_14_ex01-rad-004-grasp-su06'];

%% load a skeleton and a motion including computation of the full 3D joint trajectories
fprintf('<strong>loading skeleton and motion</strong>\n');
skel = readSkeleton ( 'default.xmlskel' ); 
mot = loadDBKSmotion( filename, skel, 'full' ); 


% %% animate skeleton according to loaded motion, play twice (repeat once)
% animate_single( skel, mot, 2 );
% 
% fprintf('<strong>Please press <enter> to continue</strong>\n');
% pause()

%% deactivate a joint for an animation
deactivatedJointIDs = name2index(skel.namemap, 'mf-mcp');
deactivatedSensorIDs = deactivatedJoints( mot, skel, deactivatedJointIDs);
%mot_2 = calcJointTrajectories ( mot, skel, deactivatedSensorIDs );
mot_2 = calcJointTrajectories ( mot, skel );

%% animate skeleton according to loaded motion using the GUI
animateGUI( skel, mot_2 );
