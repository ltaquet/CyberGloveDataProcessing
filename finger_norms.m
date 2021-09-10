function [norms] = finger_norms(fingerInd,angleArr)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
fingers_ind(1,1) = 2;
fingers_ind(1,2) = 3;

fingers_ind(2,1) = 5;
fingers_ind(2,2) = 6;

fingers_ind(3,1) = 9;
fingers_ind(3,2) = 10;

fingers_ind(4,1) = 13;
fingers_ind(4,2) = 14;

fingers_ind(5,1) = 17;
fingers_ind(5,2) = 18;
%%

% Finger Norm

norms = sqrt((angleArr(:,fingers_ind(fingerInd,1)).^2) + (angleArr(:,fingers_ind(fingerInd,2)).^2));
end

