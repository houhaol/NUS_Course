clear 
clc
close all
% tic

syms x y;
y = 1.2*sin(pi*x)-cos(2.4*pi*x);

training_x(:) = -1:0.05:1;
training_gt(1,:) = eval(subs(y,x,training_x(1,:)));

test_x(:) = -1:0.01:1;
test_gt(1,:) = eval(subs(y,x,test_x(1,:)));

%
for n = [6]
    [ net, accu_train, accu_val ] = train_seq(n, training_x, training_gt, size(training_x, 2), 0, 100);
    disp(n)
    xtest=[-3,3];
    results = sim(net, xtest)
    ground = eval(subs(y,x,xtest(1,:)))
    % figure
    % plot(training_x,training_gt);
    % hold on;
    % % plot(xtest,test_gt, 'r-', 'LineWidth', 2);
    % % hold on
    % plot(-1:0.01:1,results(1,:), 'b+', 'LineWidth', 2);
    % legend('target function', 'MLP result')
    % title(['epoch ', num2str(100), ', number of neurons:', num2str(n)])
    % xlabel('x')
    % ylabel('y')
    % grid
end

% toc
