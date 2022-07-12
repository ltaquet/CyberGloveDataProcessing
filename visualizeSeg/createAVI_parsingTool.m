clc;    % Clear the command window.
close all;  % Close all figures (except those of imtool.)
imtool close all;  % Close all imtool figures.
clear;  % Erase all existing variables.
workspace;  % Make sure the workspace panel is showing.

addpath(genpath('GraspDB14_parsingTool'));


%filename = ['data' filesep '01_11_ex03-rad-004-grasp-su04.txt'];
filename = ['data' filesep '16_14_ex01-rad-004-grasp-su06'];

%Change to desired movie file name
writerObj = VideoWriter('test.avi');
writerObj.FrameRate = 30;

open(writerObj);

%% load a skeleton and a motion including computation of the full 3D joint trajectories
fprintf('<strong>loading skeleton and motion</strong>\n');
skel = readSkeleton ( 'default.xmlskel' ); 
mot = loadDBKSmotion( filename, skel, 'full' ); 


%% draw default hand skeleton and frame 10 of the loaded motion
% fprintf('<strong>draw loaded hand skeleton</strong>\n');
% figure;
% drawSkeleton( skel );

fprintf('<strong>draw hand configuration of frame 10 of the motion</strong>\n');
figure;
motskelmap = constructSensor2JointMap(mot.sensornames, skel.jointnames);



 for i = 1:3:390
        
        caz = 85.2886;
        cel = 3;
        skel_f10 = setPose( skel, motskelmap(:,2), -mot.angledata( i,:), motskelmap(:,3) );
        drawSkeleton( skel_f10 );
        view(caz,cel);
        %Save figure containing all 3 frames as one frame
        frame = getframe(gcf);
        writeVideo(writerObj, frame);
        cla
        i
        
 end
    
    close(writerObj);

%% cleanup
clear ans motskelmap;
