addpath('C:\Users\le40619\Desktop\OR Code\CyberGlove\OR Directory\Code\Intraoperative-CyberGlove')
cd('C:\Users\le40619\Desktop\OR Code\CyberGlove\OR Directory\Patients\Leon_T\Raw Data')
Log = readmatrix('Leon_T2022_05_26___11_48_10_002854_Log');
opts = detectImportOptions('Leon_T2022_05_26___11_48_10_002854_Log');

Init = readmatrix('Leon_T2022_05_26___11_48_10_002854_Log',delimitedTextImportOptions('DataLines',[1 Inf]));

GCts = char(Init(1,2));
GoodClock.time = datetime(GCts(1:21),'InputFormat','yyyy_MM_dd___HH_mm_ss');
fractionalSecond = char(Init(1,2));
GoodClock.fs = str2num(fractionalSecond(23:end));


CyberClock = CGtimestamp2ms(char(Init(2,2)),GoodClock.time);

initLag = frameLag(GoodClock,CyberClock);



for i = 2:2:length(Log)-2
    GoodClockStart.time = datetime(2022,Log(i,2),Log(i,3),Log(i,6),Log(i,7),Log(i,8));
    GoodClockStart.fs = Log(i,9);
    
    GoodClockStop.time = datetime(2022,Log(i+1,2),Log(i+1,3),Log(i+1,6),Log(i+1,7),Log(i+1,8));
    GoodClockStop.fs = Log(i+1,9);
    
    startClocks(i/2) = GoodClockStart;
end
