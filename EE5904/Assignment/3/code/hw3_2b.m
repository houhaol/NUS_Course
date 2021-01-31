clc;clear;

% Load data
load('MNIST_database.mat')

train_Idx = find(train_classlabel == 9 | train_classlabel == 4);
test_Idx = find(test_classlabel == 9 | test_classlabel == 4);

train_data = train_data(:, train_Idx);
test_data = test_data(:, test_Idx);
TrLabel = train_classlabel(train_Idx);
TeLabel = test_classlabel(test_Idx);

% Convert the label 9 as 1 and 4 as 0
TrLabel = double(TrLabel > 5);
TeLabel = double(TeLabel > 5);

%  Random index
rand_idx = randperm(size(TrLabel, 2), 100);
M = train_data(:, rand_idx);
% lambda = 10;

TrAcc_record = {};
TeAcc_record = {};

for fixed_width = [0.01:1000]
    phi = zeros(size(TrLabel, 2), size(M, 2));
    for i = 1:size(phi, 1)
        for j = 1:size(phi, 2)
            r = norm(train_data(:, i) - M(:, j));
            phi(i,j) = exp(-r^2/(2*(fixed_width^2)));
        end
    end

    % Solution of w
    w = pinv(phi)*TrLabel';
    % w = pinv(transpose(phi)*phi + lambda*eye(size(M, 2)))*transpose(phi)*TrLabel';

    % Prediction
    TrPred = phi*w;

    % For testing data
    phi_test = zeros(size(TeLabel, 2), size(M, 2));
    for i = 1:size(phi_test, 1)
        for j = 1:size(phi_test, 2)
            r = norm(test_data(:, i) - M(:, j));
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
    % figure
    % plot(thr,TrAcc,'.- ',thr,TeAcc,'^-');legend('tr','te');
    % xlabel("Threshold")
    % ylabel("Accuracy")
    % title(["Fixed centers with the width of ", num2str(fixed_width)])
    TrAcc_record = [TrAcc_record ,max(TrAcc)];
    TeAcc_record = [TeAcc_record ,max(TeAcc)];
end

figure
range_width = 0.01:1:1000
TrAcc_record = cell2mat(TrAcc_record)
plot(range_width, TrAcc_record, 'r')
hold on;
TeAcc_record = cell2mat(TeAcc_record)
plot(range_width, TeAcc_record, 'b')
xlabel("Width")
ylabel("Accuracy")
legend("Train accuracy", "Test accuracy")
title("Accuracy of various values of with", num2str(lambda))
hold off;
