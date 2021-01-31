function [max_reward, reached_count, time_record, optimal_policy] = final_reward_calculation(path, max_reward, time_record, gamma, reward, reached_count, optimal_policy)
    state_pointer = 1;
    time=1;
    final_reward=0;
    while state_pointer~=100 && time < 100
        % locate on grid map
        % state_pointer  
        x=ceil(state_pointer/10)*10 + 2;
        y=mod(state_pointer, 10) - 0.5;
        % path(state_pointer)
        switch path(state_pointer)
            case 1
                final_reward=final_reward+gamma.^(time-1)*reward(state_pointer,1);
                state_pointer=state_pointer-1;
            case 2
                final_reward=final_reward+gamma.^(time-1)*reward(state_pointer,2);
                state_pointer=state_pointer+10;
            case 3
                final_reward=final_reward+gamma.^(time-1)*reward(state_pointer,3);
                state_pointer=state_pointer+1;
            case 4
                final_reward=final_reward+gamma.^(time-1)*reward(state_pointer,4);
                state_pointer=state_pointer-10;
        end
        time=time+1;
    end
    if state_pointer == 100
        reached_count = reached_count + 1;
        time_record = [time_record toc];
        if final_reward > max_reward
            max_reward = final_reward
            optimal_policy = path;
        end

    end
    
end