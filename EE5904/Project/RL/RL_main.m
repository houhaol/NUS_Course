close all; 
clear; clc;

load('qeval.mat'); % 100 * 4 qevalreward matrix
[num_state, num_action] = size(qevalreward);

% Parameters initilization
gamma = 0.75; % 0.5, 0.9
run_times =10; 
maximum_trials = 3000;
threshold = 0.005;
reached_count = 0;
time_record = [];
max_reward = 0;
optimal_policy = zeros(100, 1);

% Q-Learning
for i = 1:run_times
    disp(['Run time:', num2str(i)])
    trail = 0;
    Q_tmp = zeros(num_state, num_action);
    Q = zeros(num_state, num_action);
    converge_flag = false;
    
    tic;
    while trail <= maximum_trials && (~converge_flag)
        k = 1;
        state = 1;
        Q_tmp = Q;
        state_list = [];
        action_list = [];
        while state ~= 100
            explore_rate = 0.7; % !!!0.5 
            if explore_rate > 1 
                explore_rate = 1;
            end
            alpha_k = exp(-0.001*k); % !!!
            if alpha_k < threshold
                break;
            end
            action_candidate = find(qevalreward(state, :) ~= -1);
            
            % greedy exploration
            action = action_selection(Q(state, :), action_candidate, explore_rate);
            action_list = [action_list action];

            [Q, state] = update(qevalreward, Q, gamma, alpha_k, action, state);
            state_list = [state_list state];    
            % for next one
            k = k+1;
        end
        trail = trail +1;
        converge_flag = converge_check(Q_tmp, Q, threshold);
    end
    toc;

    [~, path] = max(Q, [], 2); 
    
    [max_reward, reached_count, time_record, optimal_policy] = final_reward_calculation(path, max_reward, time_record, gamma, qevalreward, reached_count, optimal_policy);
end
get_states(optimal_policy);
disp(['No. of goal-reached runs ', num2str(reached_count)]);
disp(['Average running time ', num2str(mean(time_record))]);
% Plot
grid_plot(optimal_policy, max_reward)
                