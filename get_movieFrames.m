cam = webcam('USB_Camera');
%cam.Resolution='1920x1080';
cam.Resolution='640x480';

for i = 1:50
    img = snapshot(cam);
    R = img(:,:,1);
    G = img(:,:,2);
    B = img(:,:,3);
    onlyRed = R - G - B;
    onlyRed(find(onlyRed<100))=0; % <- threshold the intensity
   % bg=onlyRed;
    ourImage = onlyRed; % assign ourImage to be threshold image
    %ourImage(find(ourImage<100))=0;
    video_images{i} = image(ourImage); %displays an intensity image
    %cmap = colormap(jet(256)); % Using uint8 movie data, cmap values range between 0-255
    frames{i} = im2frame(ourImage,colormap(jet(256)));
end

% Indexed movie data values must be legal colormap indices:
% 1.0 <= value <= length(colormap) for double-precision movie data, and 0 <= value <= length(colormap)-1 for uint8 movie
% data

writerObj = VideoWriter('myVideo5.avi'); % Create VideoWriter object
writerObj.FrameRate = 10; % Set the frame rate (fps)
open(writerObj);
for k = 1:length(frames)
    writeVideo(writerObj, frames{k});           % frames with desired colormap
end
close(writerObj);