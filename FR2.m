
%% Test the user: Take a picture and predict a matched class

%  cam = webcam('BisonCam, NB Pro');
% %cam.Resolution='1920x1080';
%  cam.Resolution='640x480';
% 
%  pause(1);
 
% Take a picture of yourself. Extract the HOG features and predict a
% classification.

img = snapshot(cam);
img = rgb2gray(img);
img = imbinarize(img);
cellSize = [16, 16];
queryImage = img;
%[hog, vis] = extractHOGFeatures(queryImage,'CellSize',cellSize);
testFeatures = extractHOGFeatures(queryImage,'CellSize',cellSize);
testLabel = predict(faceClassifier,testFeatures);

% Go back to the training set for comparison/find identity
samePerson = strcmp(testLabel,personIndex);
existIndex = find(samePerson);
figure;
subplot(1,2,1);imshow(queryImage);title('Query Face');
subplot(1,2,2);imshow(read(training(existIndex),1));title('Matched Class');
%pause(5);

% Is this person me?
% If yes, run the webcam to control plotter; if not, print "Invalid user."

if existIndex == 10
     track_XandY
    fprintf('Match found.\n');
else
    fprintf('Invalid user.\n');
end

