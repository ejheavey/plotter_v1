% First, load the database of faces
faceDatabase = imageSet('gt_db','recursive');

% Split data into training and test sets using partition() with an 80/20
% ratio of training data to test data.

[training,test] = partition(faceDatabase,[0.8,0.2]);

% cam = webcam('BisonCam, NB Pro');
% cam.Resolution='1920x1080';
% cam.Resolution='640x480';

%Take a sample image using the webcam and extract the hog features
img = snapshot(cam);
img = rgb2gray(img);
img = imbinarize(img);
cellSize = [16 16];
%[testFeatures, testLabels] = helperExtractHOGFeaturesFromImageSet(testSet, hogFeatureSize, cellSize);
[hog, vis] = extractHOGFeatures(img,'CellSize',cellSize);

% Plot to see features
figure; 
subplot(2,1,1); imshow(img);
subplot(2,1,2);  
plot(vis);

pause(5);

% Begin setup...

hogFeatureSize = length(hog); % establishes how many features to analyze
trainingFeatures = zeros(size(training,2)*training(1).Count,hogFeatureSize); % creates space to store training features
featureCount = 1;
% The nested loop scans the images in the training set
% and extracts the features after binarizing the images.
for i=1:size(training,2)
    for j = 1:training(i).Count
        img = read(training(i),j);
        img = rgb2gray(img);
        img = imbinarize(img);
        trainingFeatures(featureCount,:) = extractHOGFeatures(img,'CellSize',cellSize);
        trainingLabel{featureCount} = training(i).Description;
        featureCount = featureCount + 1;
    end
    personIndex{i} = training(i).Description;
end

% Create classifier using fitcecoc
faceClassifier = fitcecoc(trainingFeatures,trainingLabel);

% Now that the classifier is trained, test it on an individual attempting to run the plotter
FR2;