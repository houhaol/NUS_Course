clc;clear;
load('Train_dataset.mat');
load('Val_dataset.mat');

% Data prepare
train_data = transpose(Train_dataset(1:end-1, :));
val_data = transpose(Val_dataset(1:end-1, :));

% PCA
[coeff,score,latent,~,explained,mu] = pca(train_data);
% count the number of features needed above 95%, 
sum_explained = 0;
idx = 0;
while sum_explained < 95
    idx = idx + 1;
    sum_explained = sum_explained + explained(idx);
end
% reduce dimension from 65536 to 247

pca_train_data = transpose(score(:, 1:idx));
train_label = Train_dataset(end, :);

% pass the trained model to have pca val
pca_val_data = transpose((val_data - mu)*coeff(:, 1:idx));
val_label = Val_dataset(end, :);


train_num = size(Train_dataset,2);
val_num = size(Val_dataset,2);

net = perceptron('hardlim', 'learnp');
net.trainParam.epochs= 3000;
% net.trainParam.show = 50;
net.divideFcn = 'dividetrain';
net.performParam.regularization = 0.1;

net = train(net, pca_train_data, train_label);

%output_train = sim(net, train_data);
output_train = net(pca_train_data);
output_val = sim(net, pca_val_data);
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