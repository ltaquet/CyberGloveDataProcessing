clear; clc;

%Save starting directory
curr_dir = pwd;

%Get PID of new patient
PID = input('New patient ID: ','s');

%Navigate to patient directory
cd ../../patients


%If the PID does not already exist, create the PID directory with all the
%subdirectories that the CG function require
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

%Return to starting directory
cd(curr_dir);

%Runs the script for converting the CG DCU Cal file into MATLAB and saving
%it into the new PID directory
importCal2matlab;

