%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% pre_post_op_trials
% Created on: 5/05/2021
% Created by: Leon Taquet
% Status: PHASED OUT - Used to Brainstom Healthies App
% Uses: Randomly presents 6 sets of CyberGlove Tasks 20 times each with
%       random 5-15 second rests 
% Functionality to add: - 
%                       - 
% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%test pull
clc; clear

%Task Variables
minRest = 1;  %seconds
maxRest = 3; %seconds
numMovements = 5; % per trial

addpath('C:\Users\le40619\Desktop\OR Code\CyberGlove\OR Directory\Code\Intraoperative-CyberGlove\Prompt images');

%Set current directory as location of this script
cd('C:\Users\le40619\Desktop\OR Code\CyberGlove\OR Directory\Code\Intraoperative-CyberGlove')

%Connects to CyberGlove
s = serialport("COM6", 115200);
s.Parity = 'none';
s.FlowControl = 'none';
s.StopBits = 1;
s.DataBits = 8;
s.Timeout = 10;

% Initialize Timestamp Vars
timestamps = strings(100);
num_stamps = 0;
last_mark = 0;

%Initialize sound for start of streaming
[y,Fs]=audioread('buzz.wav');
player=audioplayer(y,Fs);

sensors = ["TR" "IT" "OT" "TA" "II" "MI" "OI" "IM" "MM" "OM" "MA" "IR" "MR" "OR" "RA" "IP" "MP" "OP" "PA" "PR" "TW" "SW"];
sensors_full = ["Thumb Roll" "Thumb metacarpal" "Thumb proximal" "Thumb-index Abduction" "Index metacarpal" "Index proximal" "Index distal (no sensor)" "ABD" "Middle metacarpal" "Middle proximal" "Middle distal (no sensor)" "Index-middle abduction" "Ring metacarpal" "Ring proximal" "Ring distal (no sensor)" "Middle-ring abduction" "Pinky metacarpal" "Pinky proximal" "Pinky distal (no sensor)" "Ring-Pinky abduction" "Palm flex" "Wrist pitch" ];
sensors = [sensors; sensors_full];

isRunning = true;

%Checks directories for patient
curr_dir = pwd;
cd ../../Patients
patients = dir();
patients = patients(3:end);
patients = struct2cell(patients);
patients = patients(1,:);
patients{end+1} = 'New Patient';
PID = listdlg('Name','Patient ID?', 'PromptString','Patient ID?','ListString',patients,...
    'SelectionMode','single',...
    'ListSize',[200 100]);
cd(curr_dir);
if isempty(PID)
    fprintf("Aborted\n");
    return
end
PID = patients{PID};

if PID == "New Patient"
    fprintf("Run newPatient.m to create directory for new patient\n");
    return
end

firstPass = true;

%Initialize Task Struct for loop
task_names = ["thumb"; "index"; "middle"; "ring"; "pinky"; "hand open and close" ];
task_prompts = ["Thumb_prompt.jpg"; "Index_prompt.jpg"; "Middle_prompt.jpg"; "Ring_prompt.jpg"; "Pinky_prompt.jpg"; "HOC_prompt.jpg"];
[tasks] = initializeTaskStruct(task_names,task_prompts);

%Keeps track of task order
order = 1;
imshow('Initial_prompt.jpg');
hold on
pause(2);

[firstPass] = CG_acq_com('Start',s, PID, player,90, firstPass);
while sum([tasks(:).completed]) ~= 6
    [taskIndex] = randomNewTask(tasks);
    [firstPass] = CG_acq_com('Toss',s, PID, player,90, firstPass, timestamps, num_stamps, last_mark);
    
    %Displays task prompt, marks task as completed, and records task order
    [tasks] = performTask(taskIndex,tasks,order,false);
    
    for i = 1:1:numMovements
        %Plays Sound
        tasks(taskIndex).timestamps(i) = datestr(now,'HH:MM:SS');
        play(player);
        restartMsg = questdlg('Restart?', ...
            'Restart?', ...
            'Restart','No','No');
        if strcmp(restartMsg,'Restart')
            %Toss data
            [firstPass] = CG_acq_com('Toss',s, PID, player,90, firstPass, timestamps, num_stamps, last_mark);
            %Resets task to incomplete
            [tasks] = performTask(taskIndex,tasks,0,true);
            i = numMovements;
        end
        randomRest(minRest,maxRest);    
    end
    %Saves Data from Task
    [firstPass] = CG_acq_com('Mark',s, PID, player,90, firstPass, timestamps, num_stamps, last_mark);
    %Increments task order
    order = order + 1;
end

[firstPass] = CG_acq_com('End',s, PID, player,90, firstPass, timestamps, num_stamps, last_mark);
