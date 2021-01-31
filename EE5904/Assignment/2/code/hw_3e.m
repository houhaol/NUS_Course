clc; clear;

load('Train_dataset.mat');
load('Val_dataset.mat');

train_data = Train_dataset(1:end-1, :);
train_label = Train_dataset(end, :);
val_data = Val_dataset(1:end-1, :);
val_label = Val_dataset(end, :);
train_num = size(Train_dataset,2);
val_num = size(Val_dataset,2);
train_accuracy = zeros(12);
validation_accuracy = zeros(12);
id = 1;

for n = [1:10, 20, 50]
    disp(n)
    [ net, accu_train, accu_val ] = train_seq(n, train_data, train_label, train_num, 0, 200);;
    
    output_train = sim(net, train_data);
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

    train_accuracy(id) = train_acc/train_num
    validation_accuracy(id) = val_acc/val_num
    id = id + 1;
end