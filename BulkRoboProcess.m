%sets = ["1set", "2set", "3set", "4set", "5set", "6set", "7setlf", "8setsf", "9setb", "10set", "11set", "12set", "skipTest","14set"];
sets = ["3valid","4valid"];


for s = 1:1:length(sets)
    s=length(sets);
    clear lags CG MPU MPUf
    addpath('C:\Users\le40619\Desktop\OR Code\CyberGlove\OR Directory\Code\Intraoperative-CyberGlove')
    curr_dir = pwd;
    cd('\\mcwcorp\Departments\Neurosurgery\Users\le40619\ArduinoData')
    %csvfile = uigetfile('*.csv');
    M = readmatrix(strcat(sets(s),'.csv'));
    accAngle = medfilt1(M(:,1),3);
    TTL = M(:,2);
    cd(curr_dir);
    skipped = 0;
    finger = 5;

    cd('C:\Users\le40619\Desktop\OR Code\CyberGlove\OR Directory\Patients\Leon_TL\Raw Data\Logs')
    [initLag,startClocks,endClocks, delays] = ProcessGoodClockLog('Leon_TL2022_06_16___09_49_32_002949_Log');

    cd(strcat('C:\Users\le40619\Desktop\OR Code\CyberGlove\OR Directory\Patients\Leon_TL\Calibrated Data\',sets(s)))


    CG_files = dir('*.mat');

    last = 1;
    curr = 1;
    start = 0;
    stop = 0;
    moved = 0;
    index = 1;

    lags = zeros(1,length(CG_files));
    lags = lags + 1000;
    lm = zeros(1,length(CG_files));

    i = 1;


    while i < length(TTL) && index < 31
        load(CG_files(index).name);


        curr = i;
        if TTL(last) == 1 && TTL(curr) == 0
            start = curr;
        end

        if start ~= 0 && stop == 0 && moved == 0 && TTL(last) == 0 && TTL(curr) == 1
            moved = curr;
            while(TTL(i) == 1)
                i = i+1;
            end


        elseif start ~= 0 && moved ~= 0 && TTL(last) == 0 && TTL(curr) == 1
            stop = curr;
            while(TTL(i) == 1)
                i = i+1;
            end

        end

        if start ~= 0 && stop ~= 0
            t = 0:(1/90):(length(accAngle(start:stop))/90);

            %offset = mean((-accAngle(start:start+100)))-mean(angles_deg_f(1:101,finger));


            [~,m] = min(angles_deg_f(:,finger));
            [~,CGm] = min(angles_deg_f(:,finger));
            [~,MPUm] = min(-accAngle(start:stop));
            lm(index) = MPUm - CGm;

            CG = -(angles_deg_f(:,finger))./(angles_deg_f(CGm,finger));
            %MPU = -accAngle(start:start+length(angles_deg_f(:,finger))-1)./accAngle(start+MPUm);
            MPU = -accAngle(start:stop)./accAngle(start+MPUm);

            offset = mean(MPU(1:100)-CG(1:100));
            CG = ((CG + offset));
            CG = -CG./CG(CGm);

            [c1, c2]=butter(4,[6/90*2],'low');
            MPUf = filtfilt(c1,c2,MPU);

            if index == 700
                f = figure;
                plot(CG); hold on; plot(MPU); hold on; xline(moved-start); legend('CyberGlove','MPU');
                j = figure;
                plot(diff(MPUf))
                hold on;plot(-TTL(start:stop));
                title(find(diff(MPUf)<=-0.0009783,1,'first')-(moved-start))

                pause()
                close(f)
                close(j)
            end
            [~,MPUm] = min(MPU);



            CGdiff = diff(CG);

            CGdrop = find((CGdiff(15:end) < (-0.005)), 1, 'first');


            [r, lag] = xcorr(CG,MPU,'none');

            [~,tau]=max(r);
            mxLag=lag(tau);


            skip(index) = skipped;
            startTillMove(index) = find(diff(MPUf)<=-0.0009783,1,'first');
            moveDelay(index) = find(diff(MPUf)<=-0.0009783,1,'first')-(moved-start);
            CGmove(index) = find(diff(angles_deg_f(:,5))>=0.01,1,'first');

            start = 0;
            stop = 0;
            moved = 0;


            lags(index) = mxLag;
            time(index) = frameLag(startClocks(index),startClocks(1));
            calcLags(index) = frameLag(startClocks(index),CGtimestamp_wS_2ms(char(data_time(1)),startClocks(index).time));
            lengthLag(index) = length(angles_deg_f)-abs(frameLag(endClocks(index),startClocks(index)));
            %lengthLag(index) = length(angles_deg_f)-((abs(frameLag(endClocks(index),startClocks(index))))/90)*100;
            endLag(index) = frameLag(endClocks(index),CGtimestamp_wS_2ms(char(data_time(end)),startClocks(index).time));
            
            
            index = index+1;
        end

        last = i; 
        i = i+1;

    end

    
    index = 1;
    f = figure; plot(lags); title(s);pause; close(f)
    mn(s) = mean(lags)   
    
end