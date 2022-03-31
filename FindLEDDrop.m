red = zeros(videoObject.NumFrames,1);
thisFrame = read(videoObject, 1);
imshow(thisFrame);
rLED = drawrectangle();
l = 1;
drop = 1;

frameNum = videoObject.NumFrames;

for i = 1:1:frameNum
   
   thisFrame = read(videoObject, i); 
   LED = imcrop(thisFrame,rLED.Position);
   
   red(i) = mean(mean(LED(:, :, 1)));
   
   if red(l) > 40 && red(i) < 40
       drop = i;
       break;
   end
   l = i;
   
end

figure
plot(red)

figure
thisFrame = read(videoObject, drop-1); 
LED = imcrop(thisFrame,rLED.Position);
imshow(LED)

figure
thisFrame = read(videoObject, drop+1); 
LED = imcrop(thisFrame,rLED.Position);
imshow(LED)




if(~isdeployed)
	cd(fileparts(which(mfilename)));
end


plot(red(1:2000)