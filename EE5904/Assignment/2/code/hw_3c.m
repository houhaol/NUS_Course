clc; clear;

load('Train_dataset.mat');
load('Val_dataset.mat');

train_data = Train_dataset(1:end-1, :);
train_label = Train_dataset(end, :);
val_data = Val_dataset(1:end-1, :);
val_label = Val_dataset(end, :);
train_num = size(Train_dataset,2);
val_num = size(Val_dataset,2);

n =50;
net = patternnet(n,'trainscg','crossentropy');
net.divideFcn = 'dividetrain';
net.trainParam.epochs= 2000;
net.trainParam.lr=0.01;
net.trainParam.max_fail = 2000;
net.trainParam.goal=0.00000001;
% net.performParam.regularization = 0.1;

net = train(net, train_data, train_label);

output_train = sim(net, train_data);
% output_train = net(train_data);
output_val = sim(net, val_data);

train_acc = 0;
val_acc = 0;

for i=1:train_num
    if abs(output_train(i) - train_label(i)) < 0.5
        train_acc = train_acc+ 1;
    end
end
for i=1:val_num
    if abs(output_val(i) - val_label(i)) < 0.5
        val_acc = val_acc+ 1;
    end
end

train_accuracy = train_acc/train_num
validation_accuracy = val_acc/val_num