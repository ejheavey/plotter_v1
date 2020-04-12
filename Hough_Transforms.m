%% Hough Transform Algorithm

% 1. Initialize H[d, theta]=0
% 2. For each EDGE point in E(x,y) in image
%       for theta = 0:180
%           d = xcos(theta) - ysin(theta);
%           H[d,theta] += 1;

% 3. Find the value(s) of (d,theta) where H[d,theta] is MAX
% 4. The detected line in the image is given by:
%               d = xcos(theta) - ysin(theta)

% Read in sample image
img = imread('rgb.png');
% Convert to grayscale
gray = rgb2gray(img);
% Find the Canny edges
edges = edge(gray,'canny');
% Display the three images
figure, imshow(img), title('Original image');
figure, imshow(gray), title('Grayscale image');
figure, imshow(edges), title('Edged image');

% Apply Hough transform to find canditate lines
% accum = "accumulator array"; theta = angle; rho = radius
[accum theta rho] = hough(edges);

% Pass theta and rho values to properly label each axis
% rho is on y-axis, theta is on x-axis
figure, imagesc(accum, 'XData', theta, 'YData', rho), title('Hough accumulator');
peaks = houghpeaks(accum,100); % 100 is maximum number of peaks of interest

hold on; plot(theta(peaks(:,2)), rho(peaks(:,1)), 'rs'); hold off;

%% Hough Lines
% Find line segments using houghlines functions and plot the segments
lines = houghlines(edges, theta, rho, peaks);

figure, imshow(img), title('Original with Adjusted Lines');
hold on;
for i = 1:length(lines)
    endpoints = [lines(i).point1; lines(i).point2];
    plot(endpoints(:,1), endpoints(:,2), 'LineWidth', 2, 'Color','green');
end
hold off;

% Increase the threshold parameter for Hough peaks and compute LOCAL MAXIMA
% in the accumulator array
peaks = houghpeaks(accum, 100, 'Threshold', ceil(0.6*max(accum(:))), 'NHoodSize',[5 5]);

figure, imagesc(theta, rho, accum), title('Hough accumulator');
hold on; plot(theta(peaks(:,2)), rho(peaks(:,1)), 'rs'); hold off;

% Increas the FillGap parameter (max number of pixels allowed between two
% segments for them to be counted as one if they lie along the same line.
% Look at documentation for houghlines for better understanding of input
% parameters.
lines = houghlines(edges, theta, rho, peaks, 'FillGap', 50, 'MinLength', 100);

%% Extensions using the gradient

% 1. Initialize H[d, theta] = 0
% 2. % 2. For each EDGE point in E(x,y) in image
%       theta = gradient direction at (x,y)
%       d = xcos(theta) - ysin(theta);
%       H[d,theta] += 1;

% 3. Find the value(s) of (d,theta) where H[d,theta] is MAX
% 4. The detected line in the image is given by:
%               d = xcos(theta) - ysin(theta)

% Extension 2: Give more votes for stronger edges
% Extension 3: change the sampling of (d, theta) to give more/less
% resolution
% Extension 4: The same procedure can be used with circles, squares, or any
% other shape

%% Hough Circles Algorithm
%   For every edge pixel (x,y)
%       For each possible radius r
%           for each possible gradient direction theta or estimated grad
%               a = x - rcos(theta);
%               b = y + rsin(theta);
%               H[a,b,r] +=1;
%           end
%       end
%   end

%% Generalized Hough
% Build a Hough table:
% 1. At each boundary point, compute displacement vector r = c - pi
% 2. Measure the gradient angle theta at the boundary point
% 3. Store the displacement in a table indexed by theta










