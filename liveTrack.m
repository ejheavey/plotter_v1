clear
webcamlist
cam = webcam('USB_Camera');
%cam.Resolution='1920x1080';
cam.Resolution='640x480';

clear sampling_time
clear sampling_time_control
clear sampling_time_mass
for kk = 1:1000
    
% Create the snapshot and adjust your image accordingly. Here we are 
% tracking a RED card, so we choose to detect only RED.
    tic
    img = snapshot(cam);
    %bg = snapshot(cam);
    R = img(:,:,1);
    G = img(:,:,2);
    B = img(:,:,3);
    onlyRed = R - G - B;
   % bg=onlyRed;
    ourImage = onlyRed-bg;
    ourImage(find(ourImage<100))=0;
    %imagesc(ourImage);
    %frame_time = toc;
    image5= double(ourImage);
    imagesc(image5)
    
% Initialize overall image 'mass' and pixel weights; sweep the image across
% the X and Y axes and add up the respective weights.
    mass=0;
    sumY=0;
    sumX=0;
    [s1,s2]=size(image5);
    for i = 1:s1
       for j= 1:s2
            mass = mass + image5(i,j);
            sumY = sumY + image5(i,j)*i;
            sumX = sumX + image5(i,j)*j;
       end
    end
    
% Divide each weight by the accumulated mass to find the center of mass coordinates.
    Xc = sumX/mass;
    Yc = sumY/mass;
    
% Initial loop index;
    if (kk==1)
        moveX=0;
        Xold=Xc;
        moveY=0;
        Yold=Yc;
    else
% Move the difference between the new position and previous position.
% If the object has not moved, the new position is the old position.
        moveX = (Xc) - Xold;
        moveY = (Yc) - Yold;
        Xold = Xc;
        Yold = Yc;
    end
    
% Set the direction of rotation for the motor shaft. If moveX is positive,
% the shaft should rotate some direction; if it is negative, the direction
% of motion has changed.
    if (moveX>0)
        dirX = 1;
    else
        dirX = 0;
    end
    if (moveY>0)
        dirY = 1;
    else
        dirY = 0;
    end

% Condition the resulting figures in preparation to transmit to Arduino via
% serial port. 
% Round the values to the nearest integer; convert the numeric values to
% string format and concatenate to send in continuous stream of digits.
% Print the concatenated segment to the serial port for Arduino.
    controlX = ceil(abs(5*moveX));
    controlY = ceil(abs(5*moveY));
    Xd1=floor(abs(controlX)/100); %extracts first x direction digit
    Xd2=floor(mod(abs(controlX),100)/10); 
    Xd3=mod(abs(controlX),10); %extracts last digit
    Yd1=floor(abs(controlY)/100);
    Yd2=floor(mod(abs(controlY),100)/10);
    Yd3=mod(abs(controlY),10);
    controlX_final=strcat(num2str(dirX),num2str(Xd1,1),num2str(Xd2,1),num2str(Xd3,1));
    controlY_final=strcat(num2str(dirY),num2str(Yd1,1),num2str(Yd2,1),num2str(Yd3,1),'>');
    
    fprintf(arduino,strcat(controlX_final,controlY_final));
    run_time = toc;
    %pause(0.001);
end

