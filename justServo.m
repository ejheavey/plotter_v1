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

% Find the reference/initial center of mass of the image...

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


% Create snapshot and filter the image. Here we are 
% tracking a RED card, so we choose to detect only RED.
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

% Initialize overall image 'mass' and pixel weights of new image; sweep the image across
% the X and Y axes and add up the respective weights.
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
    
% Divide each weight by the accumulated mass to find the center of mass coordinates.
Xc = sumX/mass;
Yc = sumY/mass;

% Compare the mass of the live image with the mass of the reference image   
if (mass>1.5*massRef) % If the new mass is 1.5X bigger than reference, drop the pen
         pos_svo = 1;
else
         pos_svo = 0; % Keep the pen raised off drawing surface
end

% Generate the control signal to send to microcontroller    
control_SVO = strcat(num2str(pos_svo),'>');
fprintf(strcat(controlX_final,controlY_final,control_SVO));   
 