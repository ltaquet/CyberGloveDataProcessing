%test pull
clc; clear

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
firstPass = true;
[firstPass] = Copy_2_of_CG_acq_com('Start' ,s, 'Leon_T', player,90, firstPass, timestamps, num_stamps, last_mark);

pause(60);

flush(s);
fprintf(datestr(now,'HH:MM:SS'));
fprintf('\n');
fprintf('\n');
fprintf('--------------------------------------');
fprintf('\n');
fprintf('\n');

%[firstPass] = Copy_2_of_CG_acq_com('Mark' ,s, 'Leon_T', player,90, firstPass, timestamps, num_stamps, last_mark);

pause(1)
datestr(now,'HH:MM:SS:FFF')
write(s,"!!!",'string');
%s.NumBytesAvailable
read(s,s.NumBytesAvailable,'char')


[firstPass] = Copy_2_of_CG_acq_com('End' ,s, 'Leon_T', player,90, firstPass, timestamps, num_stamps, last_mark);



