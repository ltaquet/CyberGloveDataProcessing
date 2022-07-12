addpath('C:\Users\le40619\Desktop\OR Code\CyberGlove\OR Directory\Code\Intraoperative-CyberGlove');
addpath('C:\Users\le40619\Desktop\OR Code\CyberGlove\OR Directory\Code\Intraoperative-CyberGlove\Functions')

cd('C:\Users\le40619\Desktop\OR Code\CyberGlove\OR Directory\Code\Intraoperative-CyberGlove\sandbox')

%logfile = "2022_05_27___10_35_52_002811_Log";
logfile = "2022_05_31___13_20_23_008122_Log";

Log = readmatrix(logfile);
opts = detectImportOptions(logfile);

Init = readmatrix(logfile,delimitedTextImportOptions('DataLines',[1 Inf]));

GCts = char(Init(1,2));
GoodClock.time = datetime(GCts(1:21),'InputFormat','yyyy_MM_dd___HH_mm_ss');
fractionalSecond = char(Init(1,2));
GoodClock.fs = str2num(fractionalSecond(23:end));


CyberClock = CGtimestamp2ms(char(Init(2,2)),GoodClock.time);

initLag = frameLag(GoodClock,CyberClock);

for i = 3:2:length(Log)-2
    
    GCts = char(Init(i,2))
    GoodClockStart.time = datetime(GCts(1:21),'InputFormat','yyyy_MM_dd___HH_mm_ss');
    fractionalSecond = char(Init(i,2));
    GoodClockStart.fs = str2num(fractionalSecond(23:end));
    
    CyberClockStart = CGtimestamp_wS_2ms(char(char(Init(i+1,1))),GoodClockStart.time)
    char("1"+char(Init(i+1,1)))
    
    time((i-1)/2) = frameLag(GoodClockStart,GoodClock);
    drift((i-1)/2) = frameLag(GoodClockStart,CyberClockStart);
end
