clear
curr_dir = pwd;
cd('\\mcwcorp\Departments\Neurosurgery\Users\le40619\ArduinoData')
csvfile = uigetfile('*.csv');
M = readmatrix(csvfile);
cd(curr_dir);

cd('C:\Users\le40619\Desktop\OR Code\CyberGlove\OR Directory\Patients\Leon_T\Calibrated Data\Sync_Test')

mo_file = uigetfile('*.mat');
load(mo_file);


accAngle = medfilt1(M(:,1),3);
TTL = M(:,2);

last = 1;
curr = 1;
start = 0;
stop = 0;
for i= 1:1:length(TTL)
    curr = i;
    if TTL(last) == 1 && TTL(curr) == 0
        start = curr;
    end
    
    if start ~= 0 && TTL(last) == 0 && TTL(curr) == 1
        stop = curr;
        
    end
    
    if start ~= 0 && stop ~= 0
       break 
    end
    
    last = curr; 
end

figure
plot(angles_deg_f(:,5)-14)
hold on
plot(-accAngle(start:stop))


