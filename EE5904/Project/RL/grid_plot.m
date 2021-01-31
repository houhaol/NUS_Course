function grid_plot(path, max_reward)
    figure()
    title(['MaxFinalReward:', num2str(max_reward)]);
    grid on;
    hold on;
    ax=gca;
    ax.GridColor='k';
    ax.GridAlpha=0.5;
    ax.XAxis.Limits = [10 100];
    ax.YAxis.Limits = [0 10];
    ax.YDir = 'reverse';
    text(12,0.5, 'Start');
    text(92, 9.5, 'Target');
    state_pointer = 1;
    time = 1;
    while state_pointer~=100 && time < 100
        % locate on grid map
        % state_pointer  
        x=ceil(state_pointer/10)*10 + 2;
        y=mod(state_pointer, 10) - 0.5;
        % path(state_pointer)
        switch path(state_pointer)
            case 1
                scatter(x,y,75,'^','r'), hold on;
                state_pointer=state_pointer-1;
            case 2
                scatter(x,y,75,'>','r'), hold on;
                state_pointer=state_pointer+10;
            case 3
                scatter(x,y,75,'v','r'), hold on;
                state_pointer=state_pointer+1;
            case 4
                scatter(x,y,75,'<','r'), hold on;
                state_pointer=state_pointer-10;
        end
        time=time+1;
    end
    
end