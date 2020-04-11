clear
webcamlist
cam = webcam('HP Truevision HD');
cam.Resolution='1280x720';

img2 = snapshot(cam);
Rimg2 = img2(:,:,1);
Gimg2 = img2(:,:,2);
Bimg2 = img2(:,:,3);
imgRef = Rimg2 - Bimg2 - Gimg2;
imgRef(find(imgRef<100))=0;
imagesc(imgRef);
ourRef = double(imgRef);
imagesc(ourRef);

massRef=0;
sumYRef=0;
sumXRef=0;
[ref1,ref2]=size(ourRef);
    for i = 1:ref1
        for j = 1:ref2
            massRef = massRef + ourRef(i,j);
            sumYRef = sumYRef + ourRef(i,j)*i;
            sumXRef = sumXRef + ourRef(i,j)*j;
        end
    end
XRef = sumXRef/massRef;
YRef = sumYRef/massRef;


for kk = 1:1000
 %Create the snapshot and adjust your image accordingly. Here we are 
 %tracking a RED card, so we choose to detect only RED.
    img = snapshot(cam);
    R = img(:,:,1);
    G = img(:,:,2);
    B = img(:,:,3);
    onlyRed = R - B - G;
    %onlyGreen = G - B - R;
    onlyRed(find(onlyRed<100))=0;
    ourImg= onlyRed;
    imagesc(ourImg);
    image5= double(ourImg);
    imagesc(image5)
 %Initialize overall image 'mass' and pixel weights; sweep the image across
 %the X and Y axes and add up the respective weights.
    mass=0;
    sumY=0;
    sumX=0;
    [s1,s2]=size(image5);
    for i = 1:s1
        for j = 1:s2
            mass = mass + image5(i,j);
            sumY = sumY + image5(i,j)*i;
            sumX = sumX + image5(i,j)*j;
        end
    end
    
 %Divide each weight by the accumulated mass to find the center of mass coordinates.
    Xc = sumX/mass;
    Yc = sumY/mass;
    %trueX=Xc;
    %trueY=Yc;
 %Initial loop index;
    if (kk==1)
        moveX=0;
        Xold=Xc;
        moveY=0;
        Yold=Yc;
    else
   %Move the difference between the new position and previous position.
   %If the object has not moved, the new position is the old position.
        moveX = (Xc) - Xold;
        Xold = Xc;
        moveY = (Yc) - Yold;
        Yold = Yc;
    end
 %Set the direction of rotation for the motor shaft. If moveX is positive,
 %the shaft should rotate some direction; if it is negative, the direction
 %of motion has changed.
    if (moveX>0)
        dirX = 0;
    else
        dirX = 1;
    end
    if (moveY>0)
        dirY = 0;
    else
        dirY = 1;
    end
    
    if (mass>1.5*massRef)
             pos_svo = 1;
    else
             pos_svo = 0;
    end
    

%Condition the resulting figures in preparation to transmit to Arduino via
%serial port. 
%Round the values to the nearest integer; convert the numeric values to
%string format and concatenate to send in continuous stream of digits.
%Print the concatenated segment to the serial port for Arduino.
    controlX = ceil(abs(3*moveX));
    controlY = ceil(abs(3*moveY));
    Xd1=floor(abs(controlX)/100);
    Xd2=floor(mod(abs(controlX),100)/10);
    Xd3=mod(abs(controlX),10);
    Yd1=floor(abs(controlY)/100);
    Yd2=floor(mod(abs(controlY),100)/10);
    Yd3=mod(abs(controlY),10);
    controlX_final=strcat(num2str(dirX),num2str(Xd1,1),num2str(Xd2,1),num2str(Xd3,1));
    controlY_final=strcat(num2str(dirY),num2str(Yd1,1),num2str(Yd2,1),num2str(Yd3,1));
    control_SVO = strcat(num2str(pos_svo),'>');
    fprintf(strcat(controlX_final,controlY_final,control_SVO));
    pause(0.001);
end

