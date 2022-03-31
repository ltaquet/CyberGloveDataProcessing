function [app] = checkOffTask(taskIndex, app)
%CHECKOFFTASK Summary of this function goes here
%   Detailed explanation goes here
switch taskIndex
    case 1
        app.ThumbCheckBox.Value = false;
    case 2
        app.IndexCheckBox.Value = false; 
    case 3
        app.MiddleCheckBox.Value = false; 
    case 4
        app.RingCheckBox.Value = false; 
    case 5
        app.PinkyCheckBox.Value = false; 
    case 6
        app.HandCheckBox.Value = false;
end

end

