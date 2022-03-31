%%

cd(fileparts(which('CK_individuation_running.m')));
curr_dir = pwd;
addpath(curr_dir);
cd ../'Intraoperative-CyberGlove'
addpath(pwd);
addpath('Functions');

cd ../../Patients

% Select PID
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

% Select Trial Folder to be Analyzed
f = msgbox('Select CG III trial folder');
uiwait(f);
[path] = uigetdir('*', "Select Trial Folder to be Analyzed");
%Opens selected folder
cd(path);

%%
numTrials = input('How many trials?: ');
if isempty(numTrials)
    numTrials = 20;
end

indiv_CK_means = zeros(numTrials-2,5);
indiv_CK_median = zeros(numTrials-2,5);
indiv_CK_mode = zeros(numTrials-2,5);
indiv_CK_min = zeros(numTrials-2,5);
indiv_CK_max = zeros(numTrials-2,5);
indiv_CK_sd = zeros(numTrials-2,5);
indiv_CK_se = zeros(numTrials-2,5);
indiv_CK_CIL = zeros(numTrials-2,5);
indiv_CK_CIU = zeros(numTrials-2,5);
indiv_CK_CI = zeros(numTrials-2,5);

for size = 3:1:numTrials
    
    
    % Create Array of Task Files by Task Name
    % Divide Files by Task
    
    task_names = ["HOC", "thumb", "index", "middle", "ring", "pinky"];
    
    
    for i = 1:1:length(task_names)
        task(i).name = task_names(i);
        task(i).files = cell(1,size);
        
        filetype = strcat(PID,'_',task(i).name,'*.mat');
        task_files = dir(filetype);
        task_files = struct2cell(task_files);
        task_files = task_files(1,:);
        task(i).files = task_files;
        
    end
    
    
    
    %%
    %Conway-Krucoff Individuation Equation
    
    
    fingers_ind = zeros(5,2);
    
    fingers_ind(1,1) = 2;
    fingers_ind(1,2) = 3;
    
    fingers_ind(2,1) = 5;
    fingers_ind(2,2) = 6;
    
    fingers_ind(3,1) = 9;
    fingers_ind(3,2) = 10;
    
    fingers_ind(4,1) = 13;
    fingers_ind(4,2) = 14;
    
    fingers_ind(5,1) = 17;
    fingers_ind(5,2) = 18;
    
    normsmax = zeros(size,5);
    normsmaxI = zeros(size,5);
    
    % Finding the maximum norm achieved in a given trial for the digit of
    % interest
    
    for i = 1:1:5
        for j = 1:1:size
            load(task(i+1).files{j})
            norms = sqrt((angles_deg_f(:,fingers_ind(i,1)).^2) + (angles_deg_f(:,fingers_ind(i,2)).^2));
            [normsmax(j,i), normsmaxI(j,i)] = max(norms);
            clear norms
        end
    end
    
    % This is all for the digit of interest
    % Thresholding the speed (thdb), aka finding the moment when the speed exceeds the
    % baseline, a proxy for when the movement begins
    % movI is the index of the moment when the theshold speed is exceeded
    % bsln is the  average euclidean norm achieved from the moment data
    % recording began to the moment the threshold speed is exceeded
    
    
    thdb = zeros(size,5);
    movI = zeros(size,5);
    bsln = zeros(size,5);
    btime = 90;
    
    for i = 1:1:5
        for j = 1:1:size
            load(task(i+1).files{j})
            if i == 1
                norms(:,1) = sqrt((angles_deg_f(:,2).^2) + (angles_deg_f(:,3).^2));
                speed = abs((diff(angles_deg_f)*90));
                thdb(j,1) = mean(speed(1:btime,2)) + 3*(std(speed((1:btime),2)));
                movI(j,1) = find(speed(:,2) > thdb(j,1),1);
                bsln(j,1) = mean(norms((1:movI),:));
                clear norms
            end
            if i == 2
                norms(:,1) = sqrt((angles_deg_f(:,5).^2) + (angles_deg_f(:,6).^2));
                speed = abs((diff(angles_deg_f)*90));
                thdb(j,2) = mean(speed(1:btime,5)) + 3*(std(speed((1:btime),5)));
                movI(j,2) = find(speed(:,6) > thdb(j,2),1);
                bsln(j,2) = mean(norms((1:movI),:));
                clear norms
            end
            if i == 3
                norms(:,1) = sqrt((angles_deg_f(:,9).^2) + (angles_deg_f(:,10).^2));
                speed = abs((diff(angles_deg_f)*90));
                thdb(j,3) = mean(speed(1:btime,9)) + 3*(std(speed((1:btime),9)));
                movI(j,3) = find(speed(:,9) > thdb(j,3),1);
                bsln(j,3) = mean(norms((1:movI),:));
                clear norms
            end
            if i == 4
                norms(:,1) = sqrt((angles_deg_f(:,13).^2) + (angles_deg_f(:,14).^2));
                speed = abs((diff(angles_deg_f)*90));
                thdb(j,4) = mean(speed(1:btime,13)) + 3*(std(speed((1:btime),13)));
                movI(j,4) = find(speed(:,13) > thdb(j,4),1);
                bsln(j,4) = mean(norms((1:movI),:));
                clear norms
            end
            if i == 5
                norms(:,1) = sqrt((angles_deg_f(:,13).^2) + (angles_deg_f(:,14).^2));
                speed = abs((diff(angles_deg_f)*90));
                thdb(j,5) = mean(speed(1:btime,17)) + 3*(std(speed((1:btime),17)));
                movI(j,5) = find(speed(:,17) > thdb(j,5),1);
                bsln(j,5) = mean(norms((1:movI),:));
                clear norms
            end
        end
        
    end
    
    % Finding the displacement achieved in each trial by substracting the baseline of a trial
    % from the maximum euclidean norm achieved in a given trial (again with
    % respect to the digit of interest)
    
    disp = zeros(size,5);
    for i = 1:1:5
        for j = 1:1:size
            disp(j,i) = normsmax(j,i) -  bsln(j,i);
        end
    end
    
    %finding the maximum displacement for each digit among all size trials
    
    max_disp = zeros(1,5);
    for i = 1:1:5
        max_disp(1,i) = max(disp(:,i));
    end
    
    % finding the maximum euclidean norm achieved for each digit and its
    % corresponding index
    maxn = zeros(1,5);
    maxnI = zeros(1,5);
    for i = 1:1:5
        [maxn(1,i), maxnI(1,i)] = max(normsmax(:,i));
    end
    
    % Finding the average maximum norm (but probably do not need this anymore
    % norms_means = zeros(1,5);
    % for i = 1:1:5
    %     norms_means(1,i) = mean(normsmax(:,i));
    % end
    
    
    
    indiv_CK = zeros(size,5);
    thdbt = zeros(size,5);
    movIt = zeros(size,5);
    bslnt = zeros(size,5);
    % thumb has been changed here, still need to do the math by hand to check
    % before applying to the other digits
    for i = 1:1:5
        for j = 1:1:size
            if i == 1
                load(task(i+1).files{j})
                norms(:,1) = sqrt((angles_deg_f(:,2).^2) + (angles_deg_f(:,3).^2));
                norms(:,2) = sqrt((angles_deg_f(:,5).^2) + (angles_deg_f(:,6).^2));
                norms(:,3) = sqrt((angles_deg_f(:,9).^2) + (angles_deg_f(:,10).^2));
                norms(:,4) = sqrt((angles_deg_f(:,13).^2) + (angles_deg_f(:,14).^2));
                norms(:,5) = sqrt((angles_deg_f(:,17).^2) + (angles_deg_f(:,18).^2));
                osum = (abs(norms(normsmaxI(j,1),2)-norms(movI(j,1),2))/(max_disp(1,2)) + abs(norms(normsmaxI(j,1),3)-norms(movI(j,1),3))/(max_disp(1,3))...
                    + abs(norms(normsmaxI(j,1),4)-norms(movI(j,1),4))/max_disp(1,4) + abs(norms(normsmaxI(j,1),5)-norms(movI(j,1),5))/(max_disp(1,5)));
                indiv_CK(j,i) = disp(j,1)/max_disp(1,1) - (osum/4);
                clear norms
            end
            
            if i == 2
                load(task(i+1).files{j})
                norms(:,1) = sqrt((angles_deg_f(:,2).^2) + (angles_deg_f(:,3).^2));
                norms(:,2) = sqrt((angles_deg_f(:,5).^2) + (angles_deg_f(:,6).^2));
                norms(:,3) = sqrt((angles_deg_f(:,9).^2) + (angles_deg_f(:,10).^2));
                norms(:,4) = sqrt((angles_deg_f(:,13).^2) + (angles_deg_f(:,14).^2));
                norms(:,5) = sqrt((angles_deg_f(:,17).^2) + (angles_deg_f(:,18).^2));
                osum = (abs(norms(normsmaxI(j,2),1)-norms(movI(j,2),1))/(max_disp(1,1)) + abs(norms(normsmaxI(j,2),3)-norms(movI(j,2),3))/(max_disp(1,3))...
                    + abs(norms(normsmaxI(j,2),4)-norms(movI(j,2),4))/max_disp(1,4) + abs(norms(normsmaxI(j,2),5)-norms(movI(j,2),5))/(max_disp(1,5)));
                indiv_CK(j,i) = disp(j,2)/max_disp(1,2) - (osum/4);
                clear norms
            end
            
            if i == 3
                load(task(i+1).files{j})
                norms(:,1) = sqrt((angles_deg_f(:,2).^2) + (angles_deg_f(:,3).^2));
                norms(:,2) = sqrt((angles_deg_f(:,5).^2) + (angles_deg_f(:,6).^2));
                norms(:,3) = sqrt((angles_deg_f(:,9).^2) + (angles_deg_f(:,10).^2));
                norms(:,4) = sqrt((angles_deg_f(:,13).^2) + (angles_deg_f(:,14).^2));
                norms(:,5) = sqrt((angles_deg_f(:,17).^2) + (angles_deg_f(:,18).^2));
                osum = (abs(norms(normsmaxI(j,3),1)-norms(movI(j,3),1))/(max_disp(1,1)) + abs(norms(normsmaxI(j,3),2)-norms(movI(j,3),2))/(max_disp(1,2))...
                    + abs(norms(normsmaxI(j,3),4)-norms(movI(j,3),4))/max_disp(1,4) + abs(norms(normsmaxI(j,3),5)-norms(movI(j,3),5))/(max_disp(1,5)));
                indiv_CK(j,i) = disp(j,3)/max_disp(1,3) - (osum/4);
                clear norms
            end
            
            if i == 4
                load(task(i+1).files{j})
                norms(:,1) = sqrt((angles_deg_f(:,2).^2) + (angles_deg_f(:,3).^2));
                norms(:,2) = sqrt((angles_deg_f(:,5).^2) + (angles_deg_f(:,6).^2));
                norms(:,3) = sqrt((angles_deg_f(:,9).^2) + (angles_deg_f(:,10).^2));
                norms(:,4) = sqrt((angles_deg_f(:,13).^2) + (angles_deg_f(:,14).^2));
                norms(:,5) = sqrt((angles_deg_f(:,17).^2) + (angles_deg_f(:,18).^2));
                osum = (abs(norms(normsmaxI(j,4),1)-norms(movI(j,4),1))/(max_disp(1,1)) + abs(norms(normsmaxI(j,4),2)-norms(movI(j,4),2))/(max_disp(1,2))...
                    + abs(norms(normsmaxI(j,4),3)-norms(movI(j,4),3))/max_disp(1,3) + abs(norms(normsmaxI(j,4),5)-norms(movI(j,4),5))/(max_disp(1,5)));
                indiv_CK(j,i) = disp(j,4)/max_disp(1,4) - (osum/4);
                clear norms
            end
            
            if i == 5
                load(task(i+1).files{j})
                norms(:,1) = sqrt((angles_deg_f(:,2).^2) + (angles_deg_f(:,3).^2));
                norms(:,2) = sqrt((angles_deg_f(:,5).^2) + (angles_deg_f(:,6).^2));
                norms(:,3) = sqrt((angles_deg_f(:,9).^2) + (angles_deg_f(:,10).^2));
                norms(:,4) = sqrt((angles_deg_f(:,13).^2) + (angles_deg_f(:,14).^2));
                norms(:,5) = sqrt((angles_deg_f(:,17).^2) + (angles_deg_f(:,18).^2));
                osum = (abs(norms(normsmaxI(j,5),1)-norms(movI(j,5),1))/(max_disp(1,1)) + abs(norms(normsmaxI(j,5),2)-norms(movI(j,5),2))/(max_disp(1,2))...
                    + abs(norms(normsmaxI(j,5),3)-norms(movI(j,5),3))/max_disp(1,3) + abs(norms(normsmaxI(j,5),4)-norms(movI(j,5),4))/(max_disp(1,4)));
                indiv_CK(j,i) = disp(j,5)/max_disp(1,5) - (osum/4);
                clear norms
            end
        end
    end
    
    
    
%     indiv_CK_means = zeros(1,5);
%     indiv_CK_median = zeros(1,5);
%     indiv_CK_mode = zeros(1,5);
%     indiv_CK_min = zeros(1,5);
%     indiv_CK_max = zeros(1,5);
%     indiv_CK_sd = zeros(1,5);
%     indiv_CK_se = zeros(1,5);
%     indiv_CK_CIL = zeros(1,5);
%     indiv_CK_CIU = zeros(1,5);
%     indiv_CK_CI = zeros(1,5);
    
    
    for i = 1:5
        
        indiv_CK_means(size-2,i) = nanmean(indiv_CK(:,i));
        indiv_CK_median(size-2,i) = nanmedian(indiv_CK(:,i));
        indiv_CK_mode(size-2,i) = mode(indiv_CK(:,i));
        indiv_CK_min(size-2,i) = min(indiv_CK(:,i));
        indiv_CK_max(size-2,i) = max(indiv_CK(:,i));
        indiv_CK_sd(size-2,i) = nanstd(indiv_CK(:,i));
        indiv_CK_se(size-2,i) = indiv_CK_sd(1,i)/(sqrt(size));
        indiv_CK_CIL(size-2,i) = indiv_CK_means(1,i) - 0.95*(indiv_CK_sd(1,i)/(sqrt(size)));
        indiv_CK_CIU(size-2,i) = indiv_CK_means(1,i) + 0.95*(indiv_CK_sd(1,i)/(sqrt(size)));
        indiv_CK_CI(size-2,i) = 0.95*(indiv_CK_sd(1,i)/(sqrt(size)));
        
    end
    
end

figure
hold on 
plot(3:1:size,indiv_CK_means(:,1),'Color','red')
plot(3:1:size,indiv_CK_means(:,2),'Color','blue')
plot(3:1:size,indiv_CK_means(:,3),'Color','green')
plot(3:1:size,indiv_CK_means(:,4),'Color','cyan')
plot(3:1:size,indiv_CK_means(:,5),'Color','magenta')
[~,trial_name,~]=fileparts(pwd);
title(strcat(PID,'___',trial_name));
xlabel('Number of Movements');
ylabel('CK Equation Average');
ylim([0.4 1]);
xlim([3 10]);
legend('Thumb','Index','Middle','Ring','Pinky','Location','southeast');