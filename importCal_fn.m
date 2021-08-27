function [offsets,gains] = importCal_fn(PID)
%importCal_fn : PHASED OUT
%   PHASED OUT REPLACED BY importCal2matlab 

%Navigates to PID subfolder containing CG Mat cal file
curr_dir = pwd;
cd ../../Patients
cd(PID)
cd cal
file2 = strcat(PID,'.cal');
matCalname = strcat(PID,'_cal');

%Autoloads cal file based on cal file naming convention(PID_cal.mat)
%Opens selected file
calID = fopen(file2);

%Skips header
Header1 = fgetl(calID);
calNums = cell(6,2);
index = 1;

while ~feof(calID)
    fingerLabel = fgetl(calID);
    calNums(index,:) = textscan(calID, '%*f %f %f %*f');
    index = index + 1;
end

% calNums(x,1)(y) = offsets
% calNums(x,2)(y) = gains
% x = finger #
% y = finger x's sensor #y

offsets = cat(1,cell2mat(calNums(1,1)),cell2mat(calNums(2,1)),cell2mat(calNums(3,1)),cell2mat(calNums(4,1)),cell2mat(calNums(5,1)),cell2mat(calNums(6,1)));
gains = cat(1,cell2mat(calNums(1,2)),cell2mat(calNums(2,2)),cell2mat(calNums(3,2)),cell2mat(calNums(4,2)),cell2mat(calNums(5,2)),cell2mat(calNums(6,2)));

save(matCalname, 'offsets','gains');
cd(curr_dir)

end

