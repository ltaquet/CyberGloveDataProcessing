function [indivScore] = indivScore(angleArr, finger)
%indivScore using the Kamper equation Calculates the individuation score
% for a digit using
%   Finger 1 = Thumb
%   Finger 2 = Index
%   Finger 3 = Middle
%   Finger 4 = Ring
%   Finger 5 = Pinky
%%
% Initialize Finger specific sensor indicies

fingers_ind = zeros(5,2);

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

norms = sqrt((angleArr(:,fingers_ind(finger,1)).^2) + (angleArr(:,fingers_ind(finger,2)).^2));
[normsmax, normsmaxI] = max(norms);

%%

% Indiv Score
sij_sum = 0;
for i = 1:1:5
    if i ~= finger
        sij_sum = sij_sum  + (( sqrt( (angleArr(normsmaxI, fingers_ind(i,1))).^2 + (angleArr(normsmaxI, fingers_ind(i,2))).^2 ) )/normsmax);
    end
end
sij_sum = sij_sum + normsmax/normsmax;


indivScore = 1 - ((sij_sum-1)/(4));


end

