 
cd(fileparts(which('Skim_Trial_Data.m')));
curr_dir = pwd;

addpath(curr_dir)
addpath('Functions');

sensors = ["TR" "IT" "OT" "TA" "II" "MI" "OI" "IM" "MM" "OM" "MA" "IR" "MR" "OR" "RA" "IP" "MP" "OP" "PA" "PR" "TW" "SW"];
sensors_full = ["Thumb Roll" "Thumb metacarpal" "Thumb proximal" "Thumb-index Abduction" "Index metacarpal" "Index proximal" "Index distal (no sensor)" "ABD" "Middle metacarpal" "Middle proximal" "Middle distal (no sensor)" "Index-middle abduction" "Ring metacarpal" "Ring proximal" "Ring distal (no sensor)" "Middle-ring abduction" "Pinky metacarpal" "Pinky proximal" "Pinky distal (no sensor)" "Ring-Pinky abduction" "Palm flex" "Wrist pitch" ];
sensors = [sensors; sensors_full];

isRunning = true;

%Checks directories for patient

cd ../../Patients
patients = dir();
patients = patients(3:end);
patients = struct2cell(patients);
patients = patients(1,:);
patients{end+1} = 'New Patient';
PID = listdlg('Name','Patient ID?', 'PromptString','Patient ID?','ListString',patients,...
    'SelectionMode','single',...
    'ListSize',[200 100]);

if isempty(PID)
    fprintf("Aborted\n");
    return
end
PID = patients{PID};

if PID == "New Patient"
    fprintf("Run newPatient.m to create directory for new patient\n");
    return
end

cd(PID);
cd('Calibrated Data');

% Select CG III binary sd card file from directory
f = msgbox('Select CG III trial folder');
uiwait(f);
[path] = uigetdir('*', "Select CG III binary sd card file");
%Opens selected folder
cd(path);
data = uigetfile();
load(data);


cd(curr_dir);

csvfile = uigetfile('*.csv');
M = readmatrix(csvfile,'Range','A36');

CGframe = M(:,2)*90;
[lp1, lp2] = butter(4,(6/200*2),'low');

f1 = filtfilt(lp1,lp2,M(~isnan(M(:,3)),3));
figure
plot(diff(angles_deg_f(:,5)));
hold on
CGframeNANless = CGframe(~isnan(M(:,3)));
plot(CGframeNANless(2:end),diff(f1),'Color','r')

A = CGframe(~isnan(M(:,3)));
plot(CGframe(~isnan(M(:,3))),f1,'Color','r')


hold off

delta = diff(f1);
[~,locs] = findpeaks(delta,'MinPeakHeight',1.7);
plot(CGframeNANless(2:end),diff(f1),'Color','r')
findpeaks(delta,'MinPeakHeight',1.7);
forceSp = floor(CGframeNANless(locs));

figure
deltaCG = diff(angles_deg_f(:,5)).*-1;
[pks,locs] = findpeaks(deltaCG,'MinPeakHeight',0.9);
plot(deltaCG);
findpeaks(deltaCG,'MinPeakHeight',0.8);
fingerDown = locs;

(length(f1) - (length(angles_deg_f(:,5))*(200/90)))/200