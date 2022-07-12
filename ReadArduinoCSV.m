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
% [~,b] = findpeaks(TTL, 0.4);
% length(b)

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
% 
% start = 0;
% stop = 0;
% for i= curr+90:1:length(TTL)
%     curr = i;
%     if TTL(last) == 1 && TTL(curr) == 0
%         start = curr;
%     end
%     
%     if start ~= 0 && TTL(last) == 0 && TTL(curr) == 1
%         stop = curr;
%         
%     end
%     
%     if start ~= 0 && stop ~= 0
%        break 
%     end
%     
%     last = curr; 
% end


t = 0:(1/90):(length(accAngle(start:stop))/90);

offset = abs(mean((-accAngle(start+(90*2):start+(90*3)))-angles_deg_f(0+(90*2):0+(90*3),5)));

figure
plot(t(1:length(angles_deg_f(:,5))), angles_deg_f(:,5))
hold on
plot(t(1:length(accAngle(start:stop))), -accAngle(start:stop)+offset)

% xcorr l

[r, lag] = xcorr(angles_deg_f(:,5),-accAngle(start:start+length(angles_deg_f(:,5))-1)+offset,'coeff');

[mxR,tau]=max(r);
mxLag=lag(tau);