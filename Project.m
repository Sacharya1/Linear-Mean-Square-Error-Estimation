clear all;clc;


Data=csvread('forestfires.csv',1,4);
m=mean(Data);
std=std(Data(:,1:9));

for i=1:517
Data(i,:)=(Data(i,:) - m);
end

for i=1:9
    Data(:,i)=Data(:,i)/std(i);
end
% Data=normalize((Data));
inputVariables=Data(:,1:8);
output=Data(:,9);

% Train and Test Data declaration
xTrain= inputVariables(1:400,:);
yTrain= output(1:400,:);
xTest= inputVariables(401:517,:);
yTest= output(401:517,:);


% Automated it to find all the 255 different combinations using all 8 inputs.

for k=1:255
n=dec2bin(k,8);

xTrainNew= xTrain(:,logical(n-'0'));
xTestNew= xTest(:, logical(n-'0'));
R= (xTrainNew'*xTrainNew)/400;
R0= (xTrainNew'*yTrain)/400;
a= inv(R)*R0;
calculatedFinalY=xTestNew*a;
mse=immse(calculatedFinalY,yTest);
MSE{k}=mse;
end
Iteration =[1:255];
% Finding the MSE for all the 255 combinations

MSE=cell2mat(MSE);

% Finding the minimum MSE value

[min_val min_index ]=min(MSE);

% Finding the combination where MSE is minimum

Combination= dec2bin(min_index,7);

% Selecting one MSE each from 1,2,3,4,5,6,7,8 variables

numberOfVar=[1 2 3 4 5 6 7,8];
mseLocation= 2.^numberOfVar-1;

% Plotting the bar graph by shifting the origin for better visualization

x=numberOfVar;
y=MSE(mseLocation);
figure('Name','How MSE changes with the change of number of variables used in the combination');
bar(x,y,0.2)
xlim([0 9])
ylim([1.3500 1.5])
