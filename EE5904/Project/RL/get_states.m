function get_states(optimal_policy)
    state_pointer = 1;
    qevalstates = [state_pointer];
    iteration = 1;
    while state_pointer~=100 && iteration < 100
        switch optimal_policy(state_pointer)
            case 1
                state_pointer=state_pointer-1;
            case 2
                state_pointer=state_pointer+10;
            case 3
                state_pointer=state_pointer+1;
            case 4
                state_pointer=state_pointer-10;
        end
        iteration = iteration + 1;
        qevalstates= [qevalstates state_pointer];
    end
    save('qevalstates.mat', 'qevalstates')
end