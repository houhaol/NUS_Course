clc;clear;

% Load data
load('MNIST_database.mat')

train_Idx = find(train_classlabel == 9 | train_classlabel == 4);
test_Idx = find(test_classlabel == 9 | test_classlabel == 4);
train_9Idx = find(train_classlabel == 9);
train_4Idx = find(train_classlabel == 4);
train_9data = train_data(:, train_9Idx);
train_4data = train_data(:, train_4Idx);

train_data = train_data(:, train_Idx);
test_data = test_data(:, test_Idx);
TrLabel = train_classlabel(train_Idx);
TeLabel = test_classlabel(test_Idx);

% Convert the label 9 as 1 and 4 as 0
TrLabel = double(TrLabel > 5);
TeLabel = double(TeLabel > 5);

%  Random index
rand_idx = randperm(size(TrLabel, 2), 2);
center = train_data(:, rand_idx);

% Implementation of K-Mean clustering
for i = 1:1000
    % Distance from sample to center
    dist_center1 = dist(transpose(train_data), center(:, 1));
    dist_center2 = dist(transpose(train_data), center(:, 2));

    % Comparrsion and Assignment
    center1_index = find(dist_center1 < dist_center2);
    center2_index = find(dist_center1 > dist_center2);

    c1_cluster = train_data(:, center1_index);
    c2_cluster = train_data(:, center2_index);

    % Update by means
    center(:, 1) = mean(c1_cluster, 2);
    center(:, 2) = mean(c2_cluster ,2);

    % Clear cluster
    c1_cluster = [];
    c2_cluster = [];
end

% Plot results
figure(1)
img1 = reshape(center(:, 1), 28, 28);
subplot(2,2,1)
imshow(img1)
title("Center 1")
img2 = reshape(center(:, 2), 28, 28);
subplot(2,2,2)
imshow(img2)
title("Center 2")

% Mean of training images

img3 = mean(train_9data, 2);
img3 = reshape(img3, 28, 28);
subplot(2,2,3)
imshow(img3)
title("Mean 1")

img4 = mean(train_4data, 2);
img4 = reshape(img4, 28, 28);
subplot(2,2,4)
imshow(img4)
title("Mean 0")

fixed_width = 7;
phi = zeros(size(TrLabel, 2), size(center, 2));
for i = 1:size(phi, 1)
    for j = 1:size(phi, 2)
        r = norm(train_data(:, i) - center(:, j));
        phi(i,j) = exp(-r^2/(2*(fixed_width^2)));
    end
end

% Solution of w
w = pinv(phi)*TrLabel';
% w = pinv(transpose(phi)*phi + lambda*eye(size(M, 2)))*transpose(phi)*TrLabel';

% Prediction
TrPred = phi*w;

% For testing data
phi_test = zeros(size(TeLabel, 2), size(center, 2));
for i = 1:size(phi_test, 1)
    for j = 1:size(phi_test, 2)
        r = norm(test_data(:, i) - center(:, j));
        phi_test(i,j) = exp(-r^2/(2*(fixed_width^2)));
    end
end

% Prediction
TePred = phi_test*w;

% Evaluation
TrAcc = zeros(1,1000);
TeAcc = zeros(1,1000);
thr = zeros(1,1000);
TrN = length(TrLabel);
TeN = length(TeLabel);
for i = 1:1000
    t = (max(TrPred)-min(TrPred)) * (i-1)/1000 + min(TrPred);
    thr(i) = t;
    TrAcc(i) = (sum(TrLabel(TrPred<t)==0) + sum(TrLabel(TrPred>=t)==1)) / TrN;
    TeAcc(i) = (sum(TeLabel(TePred<t)==0) + sum(TeLabel(TePred>=t)==1)) / TeN;
end
figure
plot(thr,TrAcc,'.- ',thr,TeAcc,'^-');legend('tr','te');
xlabel("Threshold")
ylabel("Accuracy")
% title(["Fixed centers with the width of ", num2str(fixed_width)])
