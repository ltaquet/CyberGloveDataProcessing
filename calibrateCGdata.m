function [angles,angles_deg,angles_f,angles_deg_f] = calibrateCGdata(rawData,offsets,gains,sample_rate)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

if nargin <= 3
    sample_rate = 100;
end

calData = zeros(length(rawData),22);
        for i = 1:1:22
            calData(:,i) = (double(bitshift(rawData(:,i),-4)) - offsets(i))*-gains(i);
        end
        
        index_abduct = (bitshift(rawData(:,12),-4) - offsets(12)) * gains(8);
        middle_abduct = -(calData(:,16) + double(index_abduct)) * double(gains(12));
        
        calData(:,8) = double(index_abduct) + double(middle_abduct);
        calData(:,12) = double(middle_abduct);
        calData(:,16) = calData(:,16) + middle_abduct;
        calData(:,20) = calData(:,20) + calData(:,16);
        
        %TR sensor should max out at 0.5
        for i = 1:1:length(calData(:,1))
            if calData(i,1) > 0.5
                calData(i,1) = 0.5;
            end
        end
        
        %calDataL = array2table(calData,'VariableNames',sensors);
        
        angles = calData;
        
        angles_deg = rad2deg(angles);
        
        
        [lp1, lp2] = butter(4,(6/sample_rate*2),'low');
        angles_f = filtfilt(lp1,lp2,angles);
        angles_deg_f = filtfilt(lp1,lp2,angles_deg);
end

