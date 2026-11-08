clc;
close all;
clear all;

%% Data Import
fresh_data = xlsread("final_beef_data_test.xlsx", "Sheet3");
avg_data = xlsread("final_beef_data_test.xlsx", "Sheet2");
rotten_data = xlsread("final_beef_data_test.xlsx", "Sheet1");
data=[rotten_data;avg_data;fresh_data];
fd_new=data;

%% noise cancel

fd1=fd_new(:,2);
A=find(fd1<200);
fd_new(A,:)=[];
fd1=fd_new(:,3);
A=find(fd1<400);
fd_new(A,:)=[];
fd1=fd_new(:,4);
A=find(fd1<400);
fd_new(A,:)=[];
fd1=fd_new(:,5);
A=find(fd1<200);
fd_new(A,:)=[];
fd1=fd_new(:,6);
A=find(fd1<20);
if length(A)~=0
  fd_new(A,:)=[];
end
fd1=fd_new(:,7);
A=find(fd1<5);
if length(A)~=0
fd_new(A,:)=[];
end

fd1=fd_new(:,2);
A=find(fd1>9500);
fd_new(A,:)=[];
fd1=fd_new(:,3);
A=find(fd1>9500);
fd_new(A,:)=[];
fd1=fd_new(:,4);
A=find(fd1>9500);
fd_new(A,:)=[];
fd1=fd_new(:,5);
A=find(fd1>9500);
fd_new(A,:)=[];
fd1=fd_new(:,6);
A=find(fd1>900);
if length(A)~=0
  fd_new(A,:)=[];
end
fd1=fd_new(:,7);
A=find(fd1>180);
if length(A)~=0
fd_new(A,:)=[];
end
% 
F_index=find(fd_new==0);
Ave_index=find(fd_new==1);
Ro_index=find(fd_new==2);
Fresh=fd_new(F_index,2:8);
Average=fd_new(Ave_index,2:8);
Rotten=fd_new(Ro_index,2:8);

%% moving average

windowSize=5;
Fresh=movmean(Fresh,windowSize);
Average=movmean(Average,windowSize);
Rotten=movmean(Rotten,windowSize);

%% zscore

%fresh
Zscoref=zscore(Fresh);
[X,Y]=find(abs(Zscoref)>3);
Fresh(X,:)=[];

%Average
Zscorea=zscore(Average);
[X,Y]=find(abs(Zscorea)>3);
Average(X,:)=[];

%Rotten
Zscorer=zscore(Rotten);
[X,Y]=find(abs(Zscorer)>3);
Rotten(X,:)=[];
% 
% Fresh=unique(Fresh);
% Average=unique(Average);
% Rotten=unique(Rotten);

f=length(Fresh);
a=length(Average);
r=length(Rotten);

mincount=min([f,a,r]);

if f==mincount
Average=datasample(Average,mincount,'Replace',false);
Rotten=datasample(Rotten,mincount,'Replace',false);

elseif a==mincount
Fresh=datasample(Fresh,mincount,'Replace',false);
Rotten=datasample(Rotten,mincount,'Replace',false);

else
Average=datasample(Average,mincount,'Replace',false);
Fresh=datasample(Fresh,mincount,'Replace',false);
end

A(1:length(Fresh))=0;
Fresh=[A' Fresh];

A(1:length(Average))=1;
Average=[A' Average];

A(1:length(Rotten))=2;
Rotten=[A' Rotten];

Dataset=[Rotten;Average;Fresh];
dataset1=Dataset;

%% Shuffle dataset
numRows=size(dataset1,1);
randomIndices=randperm(numRows);
shuffledData=dataset1(randomIndices,:);

%% split dataset
cv=cvpartition(size(shuffledData,1),'Holdout',0.2);
trainingIdx=training(cv);
trainingData=shuffledData(trainingIdx,:);
testingIdx=test(cv);
testingData=shuffledData(testingIdx,:);


fresh_data = trainingData(find(trainingData(:,1)==0),2:end);
avg_data = trainingData(find(trainingData(:,1)==1),2:end);
rotten_data = trainingData(find(trainingData(:,1)==2),2:end);


filename= 'Processed Training Data2.xlsx';
writematrix(fresh_data,'Processed Training Data2.xlsx','sheet',1);
writematrix(avg_data,'Processed Training Data2.xlsx','sheet',2);
writematrix(rotten_data,'Processed Training Data2.xlsx','sheet',3);


fresh_test = testingData(find(testingData(:,1)==0),2:end);
avg_test = testingData(find(testingData(:,1)==1),2:end);
rotten_test = testingData(find(testingData(:,1)==2),2:end);

filename= 'Processed Testing Data2.xlsx';
writematrix(fresh_test,'Processed Testing Data2.xlsx','sheet',1);
writematrix(avg_test,'Processed Testing Data2.xlsx','sheet',2);
writematrix(rotten_test,'Processed Testing Data2.xlsx','sheet',3);



