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

% Parameters selection
alpha = 20;
c = 2;

% Gram matrix - sigmoid kernel
gram_mat = tanh(alpha.*(train_data' * train_data) + c);

eigen_values = eig(gram_mat);
% Mercer condition
H = zeros(size(train_data,2), size(train_data,2));
if min(eigen_values) > -1e-6
    for i = 1: size(train_data, 2)
        for j = 1: size(train_data, 2)
            k = tanh(alpha.*(train_data(:, i)' * train_data(:, j)) + c);
            H(i, j) = (train_label(i) * train_label(j)).* k;
        end
    end
    % Quadratic programming
    f = -ones(size(train_data, 2), 1);
    lb = zeros(size(train_data, 2), 1);
    ub = ones(size(train_data, 2), 1)*5;
    Aeq = train_label';
    beq = 0;
    A = [];
    b = [];

    x = quadprog(H,f,A,b,Aeq,beq,lb,ub);

    % % Find support vector candidates
    candidate_index = find(x>1e-6);
    g = zeros(length(candidate_index), 1);
    for i = 1:length(candidate_index)
        % G function
        tmp = zeros(size(train_data, 2), 1);
        % kernel = exp(sum((train_data - train_data(:, candidate_index(i))).^2, 1)./(-2*sigma^2));
        kernel = tanh(alpha.*(train_data'* train_data(:, candidate_index(i))) + c);
        tmp = x.*train_label.*(kernel);
        g(i) = sum(tmp);
    end
    % % calculation for b
    b0 = mean(train_label(candidate_index) - g);
    
    % Discriminate function
    % train
    pre_train = zeros(size(train_data, 2), 1);
    for i = 1:size(train_data, 2)
        tmp_1 = zeros(size(train_data, 2), 1);
        for j = 1:size(train_data, 2)
            tmp_1(j) = x(j).*train_label(j).*(tanh(alpha.*(train_data(:,j)'* train_data(:, i)) + c));
            
        end
        pre_train(i) = sign(sum(tmp_1) + b0);
    end
    train_accuracy = length(find((pre_train - train_label) ==0))/length(train_label);
    disp(['train_accuracy = ', num2str(train_accuracy)]);
    
    % test
    pre_test = zeros(size(test_data, 2), 1);
    for i = 1:size(test_data, 2)
        tmp_2 = zeros(size(train_data, 2), 1);
        for j = 1:size(train_data, 2)
            tmp_2(j) = x(j).*train_label(j).*(tanh(alpha.*(train_data(:,j)'* test_data(:, i)) + c));
        end
        pre_test(i) = sign(sum(tmp_2) + b0);
    end
    test_accuracy = length(find((pre_test - test_label) ==0))/length(test_label);
    disp(['test_accuracy = ', num2str(test_accuracy)]);
else
    disp('mercer condition not met')
end


