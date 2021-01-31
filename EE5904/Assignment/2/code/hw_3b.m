clc; clear;

load('Train_dataset_32.mat');
load('Val_dataset_32.mat');

train_data = Train_dataset(1:end, :);
train_label = Train_dataset(end, :);
val_data = Val_dataset(1:end, :);
val_label = Val_dataset(end, :);
train_num = size(Train_dataset,2);
val_num = size(Val_dataset,2);

net = perceptron('hardlim', 'learnp');
net.trainParam.epochs= 3000;
% net.trainParam.show = 50;
net.divideFcn = 'dividetrain';
net.performParam.regularization = 0.1;

net = train(net, train_data, train_label);

%output_train = sim(net, train_data);
output_train = net(train_data);
output_val = sim(net, val_data);
train_acc = 0;
val_acc = 0;
for i=1:train_num
    if output_train(i) == train_label(i)
        train_acc = train_acc+ 1;
    end
end
for i=1:val_num
    if output_val(i) == val_label(i)
        val_acc = val_acc+ 1;
    end
end
train_accuracy = train_acc/train_num
validation_accuracy = val_acc/val_num