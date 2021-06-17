addpath(genpath('GraspDB14_parsingTool'));


filename = ['data' filesep '01_11_ex03-rad-004-grasp-su04.txt'];

%% load a skeleton and a motion including computation of the full 3D joint trajectories
fprintf('<strong>loading skeleton and motion</strong>\n');
skel = readSkeleton ( 'default.xmlskel' ); 
mot = loadDBKSmotion( filename, skel, 'full' ); 


%% draw default hand skeleton and frame 10 of the loaded motion
fprintf('<strong>draw loaded hand skeleton</strong>\n');
figure;
drawSkeleton( skel );

fprintf('<strong>draw hand configuration of frame 10 of the motion</strong>\n');
figure;
motskelmap = constructSensor2JointMap(mot.sensornames, skel.jointnames);
skel_f10 = setPose( skel, motskelmap(:,2), -mot.angledata( 10,:), motskelmap(:,3) );
drawSkeleton( skel_f10 );

%% cleanup
clear ans motskelmap;
