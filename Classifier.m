clc;
clear all;
close all;

%Data Import
fresh_data = xlsread("3_CLASS_TRAIN.xlsx", "Sheet1");
avg_data = xlsread("3_CLASS_TRAIN.xlsx", "Sheet2");
rotten_data = xlsread("3_CLASS_TRAIN.xlsx", "Sheet3");

%% Data Normalization

 MIN=min(vertcat(fresh_data, avg_data, rotten_data));
 MAX=max(vertcat(fresh_data, avg_data, rotten_data));

fresh_data = Data_Normalization(fresh_data,MIN,MAX);
avg_data = Data_Normalization(avg_data,MIN,MAX);
rotten_data = Data_Normalization(rotten_data,MIN,MAX);

%% Feature Extraction

[Fresh_feats,a]=splitter(fresh_data,5,0);
[Avg_feats,b]=splitter(avg_data,5,1);
[Rotten_feats,c]=splitter(rotten_data,5,2);

x=vertcat(Fresh_feats, Avg_feats, Rotten_feats);
y= vertcat(a, b, c);
%y=[0;1;2];


%% Filter


mdl=fscnca(x,y);
ind=find(mdl.FeatureWeights>=0.1);

xnew=x(:,ind);

%% Classification

result2 = fitcknn(xnew,y);


fresh_test = xlsread("3_CLASS_TEST2.xlsx", "Sheet1");
avg_test = xlsread("3_CLASS_TEST2.xlsx", "Sheet2");
rotten_test = xlsread("3_cLASS_TEST2.xlsx", "Sheet3");

fresh_test = Data_Normalization(fresh_test,MIN,MAX);
avg_test = Data_Normalization(avg_test,MIN,MAX);
rotten_test = Data_Normalization(rotten_test,MIN,MAX);


[Fresh_test_feats,d]=splitter(fresh_test,3,0);
[Avg_test_feats,e]=splitter(avg_test,7,1);
[Rotten_test_feats,f]=splitter(rotten_test,8,2);

test_data=vertcat(Fresh_test_feats, Avg_test_feats, Rotten_test_feats);
test_result= vertcat(d, e, f);
test_data_new=test_data(:,ind);




res=predict(result2,test_data_new);

% if res==0
%     disp('Fresh')
% elseif res==1
%     disp('Average')
% else 
%     disp('Rotten')
% end


%% Accuracy Test

accuracy=(sum(test_result==res)/length(test_result))*100


