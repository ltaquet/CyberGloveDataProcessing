function [angles,angles_deg,angles_f,angles_deg_f] = calibrateCGdata(rawData,offsets,gains,sample_rate)
%calibrateCGdata : Calibrates raw CyberGlove III data into radian angles,
%degree angles, and filtered versions of both
%   Uses calibration equations derived from the C++ code in the CyberGlove
%   SDK

% If sample_rate is not given for the CG assumes CG default sample-rate of
% 90 Hz
if nargin <= 3
    sample_rate = 90;
end

%Preallocates calibrated data array
calData = zeros(length(rawData),23);

% Calibrates data for all 23 sensors (some of which are not active in CG)
% Abduction sensors are overwritten later in the script
for i = 1:1:23
    calData(:,i) = (double(bitshift(rawData(:,i),-4)) - offsets(i))*-gains(i);
end

% Added calibration steps for the abduction sensors
index_abduct = (bitshift(rawData(:,12),-4) - offsets(12)) * gains(8);
middle_abduct = -(calData(:,16) + double(index_abduct)) * double(gains(12));
calData(:,8) = double(index_abduct) + double(middle_abduct);
calData(:,12) = double(middle_abduct);
calData(:,16) = calData(:,16) + middle_abduct;
calData(:,20) = calData(:,20) + calData(:,16);

%Thumb Roll (TR) sensor should max out at 0.5
for i = 1:1:length(calData(:,1))
    if calData(i,1) > 0.5
        calData(i,1) = 0.5;
    end
end

%calDataL = array2table(calData,'VariableNames',sensors);

%Units in Radians (default for calibration calculation)
angles = calData;

%Converts radians to degrees
angles_deg = rad2deg(angles);

%Filters both the radian and degree sets
[lp1, lp2] = butter(4,(6/sample_rate*2),'low');
angles_f = filtfilt(lp1,lp2,angles);
angles_deg_f = filtfilt(lp1,lp2,angles_deg);
end

