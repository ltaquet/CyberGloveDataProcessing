%test pull
clc; clear

%Set current directory as location of this script
cd('C:\Users\le40619\Desktop\OR Code\CyberGlove\OR Directory\Code\Intraoperative-CyberGlove')

hand = questdlg('Which hand?', ...
        'Hand?' ,'Left','Right','Right');

if strcmp(hand,'Right')
    comport = "COM6";
else
    comport = "COM8";
end
    
%Connects to CyberGlove
s = serialport(comport, 115200);
s.Parity = 'none';
s.FlowControl = 'none';
s.StopBits = 1;
s.DataBits = 8;
s.Timeout = 10;

% Initialize Timestamp Vars
timestamps = strings(100);
num_stamps = 0;

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
last_mark = 0;

fprintf(datestr(now,'HH:MM:SS:FFF'));
fprintf('\n');
[firstPass] = CG_acq_com('Start' ,s, PID, player,90, firstPass, timestamps, num_stamps, last_mark);
for i = 1:1:10
    fprintf(int2str(i));
    fprintf('\n');
    pause(60);
end
[firstPass] = CG_acq_com('End' ,s, PID, player,90, firstPass, timestamps, num_stamps, last_mark);
fprintf(datestr(now,'HH:MM:SS:FFF'));
fprintf('\n');

flush(s);