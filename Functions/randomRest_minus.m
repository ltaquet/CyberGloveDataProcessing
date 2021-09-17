function [preR] = randomRest_minus(min,max,minusT)
%randomRest_minus Pauses a random amount between min and max minus minusT
%   The purpose is to pause a toal amount of time between min and max
%   including the runtime of a preceding functio. One should time the
%   preceding function and enter it as minusT in this function call. In the
%   end the run-time of the preceding function plus this function's pause
%   will be between min and max seconds

%Initialize random num gen
rng('shuffle');

%Random num between min and max
r = randi([min max],1,1);

%Generated total pause time
preR = r;

%Only subtracts minusT from total pause time if the preceding function
%already ran for less time than the desired total pause time
if floor(minusT) < r
    r = r - floor(minusT);
    pause(r);
end


end

