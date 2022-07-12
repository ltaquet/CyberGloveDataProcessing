clear
curr_dir = pwd;
cd('\\mcwcorp\Departments\Neurosurgery\Users\le40619\ArduinoData')
csvfile = uigetfile('*.csv');
M = readmatrix(csvfile);
accAngle = medfilt1(M(:,1),3);
TTL = M(:,2);
cd(curr_dir);

finger = 5;


cd('C:\Users\le40619\Desktop\OR Code\CyberGlove\OR Directory\Patients\Leon_T\Calibrated Data\bigRasp')


CG_files = dir('*.mat');

last = 1;
curr = 1;
start = 0;
stop = 0;
index = 1;

lags = zeros(1,length(CG_files));
lags = lags + 1000;
lm = zeros(1,length(CG_files));

i = 1;
while i < length(TTL)
    load(CG_files(index).name);
%     angles_deg_f(:,finger) = (angles_deg_f(:,finger)+angles_deg_f(:,5))./2;
    
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
        t = 0:(1/90):(length(accAngle(start:stop))/90);
        
        offset = mean((-accAngle(start+15:start+30))-angles_deg_f(16:31,finger));
        
        
        [~,m] = min(angles_deg_f(:,finger));
        [~,CGm] = min(angles_deg_f(:,finger));
        [~,MPUm] = min(-accAngle(start:stop));
        lm(index) = MPUm - CGm;

        CG = -(angles_deg_f(:,finger)+offset)./(angles_deg_f(CGm,finger)+offset);
        MPU = -accAngle(start:start+length(angles_deg_f(:,finger))-1)./accAngle(start+MPUm);
        %
        
        [~,MPUm] = min(MPU);

        

%         CGbase = mean(CG(16:31));
%         MPUbase = mean((MPU(15:30)));
%         
%         [c1, c2]=butter(4,[6/90*2],'low');
%         MPUf = filtfilt(c1,c2,MPU);
%         MPUdiff = diff(MPUf);
        CGdiff = diff(CG);
        
%         CGdrop = find((CG(15:end) < (CGbase-0.02)), 1, 'first');
%         CGdrop = CGdrop + 15;
%         MPUdrop = find((MPU < (MPUbase-0.02)), 1, 'first');
        CGdrop = find((CGdiff(15:end) < (-0.005)), 1, 'first');
%         MPUdrop = find((MPUdiff < (-0.005)), 1, 'first');
% %         CG_d = detrend(CG,1,[CGdrop CGm]);
% %         MPU_d = detrend(MPU,1,[MPUdrop MPUm]);
%         CG_d = detrend(CG,1,CGm);
%         MPU_d = detrend(MPU,1,MPUm);
%         CG_d = detrend(CG);
%         MPU_d = detrend(MPU);
            
        [r, lag] = xcorr(CG,MPU,'none');
%         [r, lag] = xcorr(CG(CGdrop:CGm),MPU,'none');
%         [r, lag] = xcorr(CG_d,MPU_d,'coeff');
        
%         [r, lag] = xcorr(angles_deg_f(1:m+45,5)+offset,-accAngle(start:start+m+45-1),'coeff');
%         [r, lag] = xcorr((angles_deg_f(1:m+45,5)+offset)./(angles_deg_f(CGm,5)+offset),-accAngle(start:start+m+45-1)./accAngle(start+MPUm),'coeff');
%         [r, lag] = xcorr(-(angles_deg_f(:,5)+offset)./(angles_deg_f(CGm,5)+offset),(-accAngle(start:start+length(angles_deg_f(:,5))-1))./accAngle(start+MPUm),'coeff');
%         [r, lag] = xcorr(-(angles_deg_f(CGm:end,5)+offset)./(angles_deg_f(CGm,5)+offset),(-accAngle(start+CGm:start+length(angles_deg_f)))./accAngle(start+MPUm),'coeff');
%         [r, lag] = xcorr((-(angles_deg(:,5)+offset)./(angles_deg(CGm,5)+offset)),((-accAngle(start:start+length(angles_deg_f(:,5))-1))./accAngle(start+MPUm)),'coeff');
%         [r, lag] = xcorr(detrend(-(angles_deg(:,5))),detrend((-accAngle(start:start+length(angles_deg_f(:,5))-1))./accAngle(start+MPUm)),'coeff');
            

           [~,tau]=max(r);
        mxLag=lag(tau);
% mxLag = finddelay(CG,MPU);
        
        if mxLag == 100000  
            f = figure;
%             plot(CG_d); hold on; plot(MPU_d);
%             g = figure;
%             plot(CG); hold on; plot(MPU);
            
            plot(-(angles_deg_f(:,finger)+offset)./(angles_deg_f(CGm,finger)+offset))
            hold on
            plot((-accAngle(start:start+length(angles_deg_f(:,finger))-1))./accAngle(start+MPUm))
            hold on
%             plot(t(1:length(angles_deg_f(:,5))), -(angles_deg_f(:,5)+offset)./(angles_deg_f(CGm,5)+offset))
%             hold on
%             plot(t(1:length(-accAngle(start:start+length(angles_deg_f(:,5))-1))), (-accAngle(start:start+length(angles_deg_f(:,5))-1))./accAngle(start+MPUm))
%             hold on
%             plot(t(1-mxLag:length(angles_deg_f(1:m+45,5))-mxLag), angles_deg_f(1:m+45,5)+offset,'LineStyle','--')
             
            pause();
            close(f)
%             close(g)
            
        end
     

        
        start = 0;
        stop = 0;
        
        lags(index) = mxLag;
        index = index+1;
    end
    
    last = i; 
    i = i+1;
end

% 
% figure
% plot(t(1:length(angles_deg_f(:,5))), angles_deg_f(:,5))
% hold on
% plot(t(1:length(accAngle(start:stop))), -accAngle(start:stop)+offset)

% xcorr l
% 
% [r, lag] = xcorr(angles_deg_f(:,5),-accAngle(start:start+length(angles_deg_f(:,5))-1)+offset,'coeff');
% 
% [mxR,tau]=max(r);
% mxLag=lag(tau);

SEM = std(lags)/sqrt(length(lags));               % Standard Error
ts = tinv([0.025  0.975],length(lags)-1);      % T-Score
CI = mean(lags) + ts*SEM;    

% boxplot(lags,'Notch','on','Labels')