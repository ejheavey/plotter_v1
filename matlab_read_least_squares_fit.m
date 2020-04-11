%%% Sensor Data Acquisition with Matlab:

% command if giving fopen error: delete(instrfindall);
%% STEP 1: Initialize Arduino/MATLAB Communication
clear all
clc
delete(instrfindall);
arduino=serial('COM6','BaudRate',9600,'DataBits',8);    % create serial communication object
%InputBuffe rSize = 25;
%Timeout = 0.1;

%% Step 2: Run lines of this script as needed

fclose(arduino)
clear y i;
clear sampling_time raw_y80

fopen(arduino)
y=zeros(2000,1);
sampling_time=zeros(2000,1);

for i=1:2000
    tic %Start the sampling clock
	y(i)=fscanf(arduino,'%f');
    plot(y);
    %hold on;
   pause(0.02) % delay
   sampling_time(i)=toc; %End sampling clock. Sample time is from tic to toc
end

%% Unfiltered Statistics
% After collecting the sample data from each distance, compute the mean and variance for
% each sample set and create matrices containing the mean and variance at
% each distance
raw_VAR = [0.0016,0.0030,0.0029,0.0033,0.0032,0.0031,0.0029,0.0029,0.0031,0.0029,0.0030,0.0030,0.0029,0.0030,0.0031,0.0031];
    
raw_MEAN = [3.0833,2.4680,1.7296,1.3681,1.1379,0.9882,0.8661,0.7663,0.6876,0.6336,0.5783,0.5467,0.5075,0.4688,0.4493,0.4261];
distance = [5:5:80];
plot(distance,raw_MEAN)
errorbar(distance,raw_MEAN,raw_VAR)
% [5cm, 10cm, 15cm...]
raw_y80 = 'unfiltered_80cm.mat'; % write the serial values to a .mat data file
save(raw_y80,'y'); % save the file


%% Filtered Data
% Repeat the above steps for the filtered data...
filtered_y80 = 'filtered_y80.mat';
filtered_VAR = [2.6677e-05,2.4672e-05,2.2322e-05,2.9181e-05,9.1840e-05,5.7600e-05,6.3863e-05,1.0423e-04,1.0357e-04,1.3759e-04,3.2362e-05,9.2960e-05,4.9318e-05,5.1966e-05,2.4512e-05,8.9220e-05];

filtered_MEAN = [3.0902,2.5760,1.7967,1.4038,1.1451,0.9672,0.8588,0.7561,0.6730,0.6178,0.5644,0.5186,0.4833,0.4430,0.4090,0.3781];
save(filtered_y80,'y')
distance = [5:5:80];
plot(distance,filtered_MEAN,'r')
errorbar(distance,filtered_MEAN,filtered_VAR)


distance1=distance(2:end); % skip the first value, start from the second reading
voltage1=filtered_MEAN(2:end);

A=[ones(numel(distance1),1) (log(distance1)')]; %Horizontally stacking vectors
Y=log(voltage1);
X=inv(A'*A)*A'*Y';
k1=exp(X(1));
k2=X(2);

voltage_fitted=k1*distance1.^k2;
plot(distance1,voltage1);
hold on 
plot(distance1,voltage_fitted,'r');
xlabel('Object distance (cm)');
ylabel('Voltage (V)');
title('Comparison of raw voltage signal against a least squares fitting');

voltage_diff = voltage1-voltage_fitted;
plot(distance1,voltage_diff,'k');

hist(y,1000)

distance=[30]
mean_meas=[184.8623]
var_meas-[40.4453]
