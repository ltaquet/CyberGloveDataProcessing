clear; clc;
curr_dir = pwd;
PID = input('New patient ID: ','s');
cd ../../patients

if ~exist(PID, 'dir')
    mkdir(PID);
    cd(PID)
    mkdir('Raw Data');
    mkdir('cal');
    mkdir('Calibrated Data');
    mkdir('Uncalibrated Data');
else
    fprintf('This patient already exists\n');
end
cd(curr_dir);