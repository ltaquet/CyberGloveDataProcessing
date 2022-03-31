clc;    % Clear the command window.
close all;  % Close all figures (except those of imtool.)
imtool close all;  % Close all imtool figures.
clear;  % Erase all existing variables.
workspace;  % Make sure the workspace panel is showing.


% Chose AVI that starts with LED TTL pulse for motion of interest and ends
% after motion
[baseFileName, folderName, ~] = uigetfile('*.avi');
if ~isequal(baseFileName, 0)
    movieFullFileName = fullfile(folderName, baseFileName);
end

%Chose MAT file for motion of interest
[baseFileName, folderName, ~] = uigetfile('*.mat');
if ~isequal(baseFileName, 0)
    motionFullFileName = fullfile(folderName, baseFileName);
end

%Chose TTL Window File for Intraop
[baseFileName, folderName, ~] = uigetfile('*.mat');
if ~isequal(baseFileName, 0)
    eegFullFileName = fullfile(folderName, baseFileName);
end

%Change to desired movie file name
writerObj = VideoWriter('test.avi');
writerObj.FrameRate = 30;


open(writerObj);


videoObject = VideoReader(movieFullFileName);
load(motionFullFileName,'angles_deg_f');
load(eegFullFileName);

%Select crop over hand
thisFrame = read(videoObject, 1);
imshow(thisFrame);
rGlove = drawrectangle();


% Determine how many frames there are.
numberOfFrames = videoObject.NumFrames;
vidHeight = videoObject.Height;
vidWidth = videoObject.Width;
vidFPS = videoObject.FrameRate;

% Use FindLEDDROP.m to find the frame in which the LED drop occurs
LEDdrop = 39;


numberOfFramesWritten = 0;
% Prepare a figure to show the images in the upper half of the screen.
figure;

%set to fit
set(gcf, 'Position',[0 0 640 1080]);
%CG frame to seconds
t = 0:(1/90):(length(angles_deg_f)/90);
%EEG frame to seconds
te = 0:(1/1000):((TTLwindow(10,2)-TTLwindow(10,1))/1000);


    for i = 1:1:videoObject.numFrames-4-LEDdrop
        
        %GoPro Frame
        subplot(3, 1, 1, 'align');
        thisFrame = read(videoObject, LEDdrop-1+i);
        glove = imcrop(thisFrame,rGlove.Position);
        imshow(glove)
        axis off;
        
        %CyberGlove plot frame
        subplot(3, 1, 2, 'align');
        plot(t(1:end-1),angles_deg_f(:,5));
        hold on
        xline((i/30));
        xlim([0 7])
        xlabel('Seconds');
        ylabel('Index MCP Angle');
        hold off
        
        %EEG Plot frame
        subplot(3, 1, 3, 'align');
        plot(te(1:end),chEEG(TTLwindow(10,1):TTLwindow(10,2)));
        hold on
        xline((i/30));
        xlim([0 7])
        xlabel('Seconds');
        ylabel('mV');
        hold off
        
        %Save figure containing all 3 frames as one frame
        frame = getframe(gcf);
        writeVideo(writerObj, frame);
        
    end
    
    close(writerObj);
    
    
