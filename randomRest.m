function [success] = randomRest(min,max)
%randomRest Pauses a ramdom amount of seconds between min and max
%   Pauses a ramdom amount of seconds between min and max

%Initializes random num generator
rng('shuffle');

%Random num between min and max
r = randi([min max],1,1);

%Pause r seconds
pause(r);

success = true;

end

