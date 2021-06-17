%% usage_animate
% sample usage of the animate functionality
setpaths;

skelfile = 'default.xmlskel';
motfile = fullfile('data','ex01','rad','01_ex01-rad-002-grasp-su01.txt'); 
%motfile = fullfile('data','ex01','rad','04_ex01-rad-021-grasp-su08.txt');
%motfile = fullfile('data','ex01','rad','14_ex01-rad-034-grasp-su03.txt');
%motfile = fullfile('data','ex02','rad','02_i_r_ex02-rad-021-grasp-su08.txt');
%motfile = fullfile('data','ex02','rad','03_f_l_ex02-rad-019-grasp-su06.txt');
%motfile = fullfile('data','ex02','rad','03_f_r_ex02-rad-017-grasp-su06.txt');
%motfile = fullfile('data','ex03','rad','03_01_ex03-rad-050-grasp-su03.txt');
% motfile = fullfile('subject01','calib20141128083134-rad.txt'); % 2mb
% motfile = fullfile('subject01','ex01_20141128084032-rad.txt'); % 15mb
%motfile = fullfile('subject01','ex02_20141128090624-rad.txt'); % 6mb
%motfile = fullfile('subject01','ex03_20141128092037-rad.txt'); %10mb


% read in skeleton file
skel = readSkeleton ( strcat(GLOBAL_VARS_SETTINGS.path_skel,skelfile) ); 
% construct connections for visually separationg the palm from the fingers
skel = constructPalm ( skel );

% read in motion data
mot = readDBKSmotion ( strcat(GLOBAL_VARS_SETTINGS.path_db,motfile) );
% calculate joint trajectories
mot = calcJointTrajectories ( mot, skel, [] );
% mot = calcJointTrajectories (  mot, skel, deactivatedJoints( mot, skel, name2index(skel.namemap, 'root')));

% show 5 repetitions of the motion
animate (skel, mot, 5);

% clear unused data
clear motfile skelfile ans;
