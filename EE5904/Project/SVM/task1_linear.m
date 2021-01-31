clear; clc; 

% Load Spam dataset
train = load('train.mat');
test = load('test.mat');
train_data = train.train_data;
train_label = train.train_label;
test_data = test.test_data;
test_label = test.test_label;


% data pre-processing - standardize/scale
train_mean = mean(train_data, 2);
train_std = std(train_data, 1, 2);
train_data = (train_data - train_mean)./train_std;
test_mean = mean(test_data, 2);
test_std = std(test_data, 1, 2);
test_data = (test_data - test_mean)./test_std;


% Gram matrix
gram_mat = train_data' * train_data;
eigen_values = eig(gram_mat);
% Mercer condition
H = zeros(size(train_data,2), size(train_data,2));
min(eigen_values)
if min(eigen_values) > -1e-6
    for i = 1: size(train_data, 2)
        for j = 1: size(train_data, 2)
            k = train_data(:, i)' * train_data(:, j);
            H(i, j) = (train_label(i) * train_label(j)).* k;
        end
    end
    % Quadratic programming
    f = -ones(size(train_data, 2), 1);
    lb = zeros(size(train_data, 2), 1);
    ub = ones(size(train_data, 2), 1);
    Aeq = train_label';
    beq = 0;
    A = [];
    b = [];

    x = quadprog(H,f,A,b,Aeq,beq,lb,ub);

    % % Find support vector candidates
    candidate_index = find(x>1e-6);
    w = zeros(size(train_data, 1), length(candidate_index));
    for i = 1:length(candidate_index)
        % weights calculation
        w(:, i) = x(candidate_index(i)).*train_label(candidate_index(i)).*train_data(:, candidate_index(i));
    end
    w0 = sum(w, 2);
    % calculation for b
    b = zeros(length(candidate_index), 1);
    for i = 1:length(candidate_index)
        b(i) = 1/train_label(candidate_index(i)) - w0' * train_data(:, candidate_index(i));
    end
    b0 = mean(b);
    
    % Discriminate function
    pre_train = sign(w0' * train_data + b0);
    train_accuracy = length(find((pre_train - train_label') ==0))/length(train_label);
    disp(['train_accuracy = ', num2str(train_accuracy)]);

    pre_test = sign(w0' * test_data + b0);
    test_accuracy = length(find((pre_test - test_label') ==0))/length(test_label);
    disp(['test_accuracy = ', num2str(test_accuracy)]);
end





