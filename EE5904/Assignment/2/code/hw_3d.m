clc; clear;

load('Train_dataset.mat');
load('Val_dataset.mat');

train_data = Train_dataset(1:end-1, :);
train_label = Train_dataset(end, :);
val_data = Val_dataset(1:end-1, :);
val_label = Val_dataset(end, :);
all_data = horzcat(train_data, val_data);
all_label = horzcat(train_label, val_label);

train_num = size(Train_dataset,2);
val_num = size(Val_dataset,2);

n =10;
net = patternnet(n,'traingd','crossentropy');
net.divideFcn = 'divideind';
net.divideParam.trainInd = 1:600;
net.divideParam.valInd = 601:670;
    
net.trainParam.epochs= 1000;
net.trainParam.lr=0.05;
net.trainParam.max_fail = 1000;
net.performParam.regularization = 0.5;

[net, tr] = train(net, all_data, all_label);
