 %test pull
clc; clear

%Set current directory as location of this script
cd('C:\Users\le40619\Desktop\OR Code\CyberGlove\OR Directory\Code\Intraoperative-CyberGlove')

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

filetype = strcat(PID,'*.mat');
unprocessed_files = dir(filetype);


for index = 1:1:length(unprocessed_files)
    load(unprocessed_files(index).name);
    figure;
    hold on;
    tiledlayout(2,3)
    fing_name = strrep(unprocessed_files(index).name,PID,'');
    fing_name = strrep(fing_name,'_','');
    fing_name = strrep(fing_name,'.mat','');
    fing_name = fing_name(isstrprop(fing_name,'alpha'));
    fing_arr = ["HOC", "thumb", "index", "middle", "ring", "pinky"];
    for i = 1:1:length(fing_arr)
        if strcmp(fing_arr(i), convertCharsToStrings(fing_name))
           fing_ind = i;
        end
    end
    
    if fing_ind == 1
        sgtitle(strcat(strrep(unprocessed_files(index).name,'_',' '),' ','Indiv score: ','N/A'));
    else
        sgtitle(strcat(strrep(unprocessed_files(index).name,'_',' '),' ','Indiv score: ',num2str(indivScore(angles,fing_ind-1))));
    end
    fingers = [2 5 9 13 17];
    finger_axis = [floor(min(min(angles_deg_f)))-5 ceil(max(max(angles_deg_f(:,3:end))))+5];
    thumb_axis = [floor(min(angles_deg_f(:,2)))-5 ceil(max(angles_deg_f(:,2)))+5];
    
    for i = 1:1:length(fingers)
        nexttile;
        plot(angles_deg_f(:,fingers(i)));
        
        if i  == 1
            ylim(thumb_axis);
        else
            ylim(finger_axis);
        end
        
        title(strcat(sensors_full(fingers(i))));
    end
    
    pause();
    close;
end


cd(curr_dir);
