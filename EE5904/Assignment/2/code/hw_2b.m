clc
clear all;
%% sampling points in the domain of [-1,1]
train_x = -1:0.05:1;
%% generating training data, and the desired outputs
train_y = 1.2 * sin(pi*train_x) - cos(2.4*pi*train_x);
%% specify the structure and learning algorithm for MLP
for n = [5]
    disp(n);
    net = fitnet(n,'trainbr');
    net.layers{1}.transferFcn = 'tansig';
    net.layers{2}.transferFcn = 'purelin';
    net = configure(net,train_x,train_y);
    net.trainparam.lr=0.01;
    net.trainparam.epochs=10000;
    net.trainparam.goal=1e-8;
    net.divideParam.trainRatio=0.8;
    net.divideParam.valRatio=0.05;
    net.divideParam.testRatio=0.15;
    %% Train the MLP
    [net,tr]=train(net,train_x,train_y);
    %% Test the MLP, net_output is the output of the MLP, ytest is the desired output.
    xtest=-1:0.01:1;
    xtest_1=[-3, 3]
    net_output=sim(net,xtest);
    net_output_1=sim(net,xtest_1)
    % Plot out the test results
    figure
    plot(train_x, train_y)
    hold on;
    plot(xtest,net_output(1, :),'b+', 'LineWidth', 2);
    legend('target function', 'MLP result')
    title(['number of neurons:', num2str(n)])
    xlabel('x')
    ylabel('y')
    hold off
end