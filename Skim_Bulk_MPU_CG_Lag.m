clear
curr_dir = pwd;
cd('\\mcwcorp\Departments\Neurosurgery\Users\le40619\ArduinoData')
csvfile = uigetfile('*.csv');
M = readmatrix(csvfile);
accAngle = medfilt1(M(:,1),3);
TTL = M(:,2);
cd(curr_dir);

cd('C:\Users\le40619\Desktop\OR Code\CyberGlove\OR Directory\Patients\Leon_T\Calibrated Data\clear20')


CG_files = dir('*.mat');

last = 1;
curr = 1;
start = 0;
stop = 0;
index = 1;

lags = zeros(1,length(CG_files));
vs = zeros(1,length(CG_files));
lm = zeros(1,length(CG_files));

i = 1;
while i < length(TTL)
    
    load(CG_files(index).name);
    
    curr = i;
    if TTL(last) == 1 && TTL(curr) == 0
        start = curr;
    end
    
    if start ~= 0 && TTL(last) == 0 && TTL(curr) == 1
        stop = curr;
        while(TTL(i) == 1)
            i = i+1;
        end
    end
    
    if start ~= 0 && stop ~= 0
        
        
        offset = mean((-accAngle(start+15:start+30))-angles_deg_f(16:31,5));
        
        [~,MPUm] = min(-accAngle(start:start+length(angles_deg_f(:,5))-1));
        [~,CGm] = min(angles_deg_f(:,5));
        
        CG = -(angles_deg_f(:,5)+offset)./(angles_deg_f(CGm,5)+offset);
        MPU = -accAngle(start:start+length(angles_deg_f(:,5))-1)./accAngle(start+MPUm);
        
        f = figure;
        plot(-accAngle(start:start+length(angles_deg_f(:,5))-1)); hold on; plot(angles_deg_f(:,5)+offset);
        title(index)
        
        pause()
        close(f)
        
        
        start = 0;
        stop = 0;
        
        
        index = index+1;
    end
    
    last = i; 
    i = i+1;
end




% boxplot(lags,'Notch','on','Labels')