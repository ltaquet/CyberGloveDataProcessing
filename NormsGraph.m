%Creates a figure containing MCP plots for each finger
    figure;
    hold on;
    tiledlayout(2,3)
    y = 0:(1/90):(length(norms)/90);
    
    fing_arr = ["Thumb", "Index", "Middle", "Ring", "Pinky"];
    find_ind = 2;
    
    norms = zeros(length(angles),5);
    for i = 1:1:5
        norms(:,i) = finger_norms(i,angles_deg_f);
    end
    
    
    finger_axis = [floor(min(min(norms(:,2:5))))-5 ceil(max(max((norms(:,2:5)))))+5];
    thumb_axis = [floor(min(min(norms(:,1))))-5 ceil(max(max(norms(:,1))))+5];
    
    %Sets a uniform x and y limit for the plots in the figure for
    %comparison
    for i = 1:1:5
        nexttile;
        
        plot(x,norms(:,i));
        xlabel('Seconds');
        ylabel('Degrees');
       
        title(fing_arr(i));
        
        
        ylim(finger_axis);
        
        
        
    end
    
    
    
    sgtitle('Index Finger Individuation');
