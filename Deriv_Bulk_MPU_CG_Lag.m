clear
curr_dir = pwd;
cd('\\mcwcorp\Departments\Neurosurgery\Users\le40619\ArduinoData')
csvfile = uigetfile('*.csv');
M = readmatrix(csvfile);
accAngle = medfilt1(M(:,1),3);
TTL = M(:,2);
cd(curr_dir);

cd('C:\Users\le40619\Desktop\OR Code\CyberGlove\OR Directory\Patients\Leon_T\Calibrated Data\clearr')


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
        
        
        offset = mean((-accAngle(start+100:start+200))-angles_deg_f(100:200,5));
        
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
        CGdrop = find((CGdiff(200:end) < (-0.005)), 1, 'first');
        CGdrop = CGdrop + 200;
        
        
        
        
        diffs = zeros(1,MPUm-50);
        diffs = diffs + 1000;
        
        CGdrop = CGdrop-10;
        seg = CG(CGdrop:CGm-50);
        
        for j=1:1:MPUm-50
            if length(seg)+j-1 < length(MPU)
                diffs(j)=abs(sum(MPU(j:length(seg)+j-1)-seg)); diffs_j = i;   
            end
        end
        
     
        [~,mxLag]=min(diffs);
        
        if mxLag-CGdrop > 3000  
           f = figure;
           plot(MPU); hold on; plot(mxLag:1:mxLag+length(seg)-1,seg); plot(seg,'cyan','LineStyle','--');
           title(index);
           mxLag-CGdrop
           
           pause()
           close(f)
        end
        
        start = 0;
        stop = 0;
        %%
%         [~,aCG]=findpeaks(diff(diff(CG(1:MPUdrop))),'MinPeakHeight',-0.0003652);
%         [~,aMPU]=findpeaks(diff(diff(MPUf(1:MPUdrop))),'MinPeakHeight',-0.0003652);
 [~,aCG]=findpeaks(diff(CG(1:MPUdrop)),'MinPeakHeight',-0.002809);
        [~,aMPU]=findpeaks(diff(MPUf(1:MPUdrop)),'MinPeakHeight',-0.002809);
mxLag = aMPU(end)-aCG(end);
        
        lags(index) = mxLag;
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