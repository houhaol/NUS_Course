close all;
clc;clear;

% Load data
load('MNIST_database.mat')

train_Idx = find(train_classlabel == 8 | train_classlabel == 2);
test_Idx = find(test_classlabel == 8 | test_classlabel == 2);

train_data = train_data(:, train_Idx);
test_data = test_data(:, test_Idx);
TrLabel = train_classlabel(train_Idx);
TeLabel = test_classlabel(test_Idx);

% Convert the label 9 as 1 and 4 as 0
TrLabel = double(TrLabel > 5);
TeLabel = double(TeLabel > 5);

% Exact interpolation method
phi = zeros(size(train_data, 2), size(train_data, 2));
for i = 1:size(phi, 1)
    for j = 1:size(phi, 2)
        r = norm(train_data(:, i) - train_data(:, j));
        phi(i,j) = exp(-r^2/(2*(100^2)));
    end
end

i =0;
% Solution of w
% , 0.1, 1, 10, 100, 1000
% for lambda = [0.001, 0.01, 0.1, 1, 10, 100]

for lambda = [0]
    w = pinv(phi)*TrLabel';
    % w = inv(transpose(phi)*phi + lambda*eye(size(train_data, 2)))*transpose(phi)*TrLabel';

    % Prediction
    TrPred = phi*w;

    % For testing data
    phi_test = zeros(size(test_data, 2), size(train_data, 2));
    for i = 1:size(phi_test, 1)
        for j = 1:size(phi_test, 2)
            r = norm(test_data(:, i) - train_data(:, j));
            phi_test(i,j) = exp(-r^2/(2*(100^2)));
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
    title(["Exact Interpolation with regularization of ", num2str(lambda)])
    max(TrAcc)
    max(TeAcc)
end

