% clear
curr_dir = pwd;
addpath('C:\Users\le40619\Desktop\OR Code\CyberGlove\OR Directory\Code\Intraoperative-CyberGlove')


cd('\\mcwcorp\Departments\Neurosurgery\Users\le40619\ArduinoData')
csvfile = uigetfile('*.csv');
M = readmatrix(csvfile);
accAngle = medfilt1(M(:,1),3);
TTL = M(:,2);
cd(curr_dir);

cd('C:\Users\le40619\Desktop\OR Code\CyberGlove\OR Directory\Patients\Leon_T\Raw Data\Logs')
[initLag,startClocks,endClocks] = ProcessGoodClockLog('Leon_T2022_06_02___15_17_26_002891_Log');


cd('C:\Users\le40619\Desktop\OR Code\CyberGlove\OR Directory\Patients\Leon_T\Calibrated Data\double')


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
        
        
        offset = mean((-accAngle(start+0:start+25))-angles_deg_f(1:26,5));
        
        [~,MPUm] = min(-accAngle(start:start+length(angles_deg_f(:,5))-1));
        [~,CGm] = min(angles_deg_f(:,5));
        
        CG = -(angles_deg_f(:,5)+offset)./(angles_deg_f(CGm,5)+offset);
        MPU = -accAngle(start:start+length(angles_deg_f(:,5))-1)./accAngle(start+MPUm);
        
        [c1, c2]=butter(4,[6/90*2],'low');
        MPUf = filtfilt(c1,c2,MPU);
        MPU = MPUf;
        MPUdiff = diff(MPUf);
        CGdiff = diff(CG);
        MPUdrop = find((MPUdiff < (-0.005)), 1, 'first');
        CGdrop = find((CGdiff(50:end) < (-0.005)), 1, 'first');
        CGdrop = CGdrop + 50;
        
        
        
        
        diffs = zeros(1,MPUm-50);
        diffs = diffs + 1000;
        
        CGdrop = CGdrop-10;
        seg = CG(CGm:CGm+100);
        
        for j=MPUm-50:1:MPUm+150
            if length(seg)+j-1 < length(MPU)
                diffs(j-MPUm+50+1)=abs(sum(MPU(j:length(seg)+j-1)-seg)); diffs_j = i;   
            end
        end
        
     
        [~,mxLag]=min(diffs);
        mxLag = mxLag+MPUm-50;
        
        if mxLag-CGdrop == 3000  
           f = figure;
           plot(MPU); hold on; plot(mxLag:1:mxLag+length(seg)-1,seg); plot(seg,'cyan','LineStyle','--');
           %plot(CG); hold on; plot(MPU);
           title(index);
           %mxLag-CGdrop
           %(stop-start)
           %(stop-start)-length(angles_deg_f(:,5))
           
           pause()
           close(f)
        end
        endgap(index) = length(angles_deg_f)-(stop-start);
        %lags(index) = (stop-start)-length(angles_deg_f(:,5));
        start = 0;
        stop = 0;
        
        lags(index) = mxLag-CGm;
        
        time(index) = frameLag(startClocks(index),startClocks(1));

        calcLags(index) = frameLag(startClocks(index),CGtimestamp_wS_2ms(char(data_time(1)),startClocks(index).time));
        lengthLag(index) = length(angles_deg_f)-abs(frameLag(endClocks(index),startClocks(index)));
        endLag(index) = frameLag(endClocks(index),CGtimestamp_wS_2ms(char(data_time(end)),startClocks(index).time));
        
        
        
        vs(index) = mean(abs(diff(seg)));
        index = index+1;
    end
    
    last = i; 
    i = i+1;
end



SEM = std(lags)/sqrt(length(lags));               % Standard Error
ts = tinv([0.025  0.975],length(lags)-1);      % T-Score
CI = mean(lags) + ts*SEM;    

% boxplot(lags,'Notch','on','Labels')