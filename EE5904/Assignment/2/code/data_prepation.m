clc; clear;
cur = pwd
train_path = strcat(pwd, '\group_1\group_1\train\');
val_path = strcat(pwd, '\group_1\group_1\val\');

[train_data, train_label] = dataprepartion(train_path);

[val_data, val_label] = dataprepartion(val_path);
Train_dataset = vertcat(train_data, train_label);
save('Train_dataset_pca.mat', 'Train_dataset');
Val_dataset = vertcat(val_data, val_label);
save('Val_dataset_pca.mat', 'Val_dataset');

function [data, label] = dataprepartion(file_path)
    images = dir(strcat(file_path, '*.jpg'));
    num_images = size(images, 1);

    image_list = cell(1, num_images);
    label = cell(1, num_images);
    data = zeros(65536, 503);

    for i=1:num_images
        image_name = (strcat(file_path, images(i).name));
        img = double(imread(num2str(image_name)));
        image_list{:, i} = img;
        tmp = strsplit(images(i).name, {'_','.'});
        label{i} = str2num(tmp{2});
    end
    image_list_mat = cell2mat(image_list);
    label = cell2mat(label);
    data = reshape(image_list_mat, 65536, num_images);
end





