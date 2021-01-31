function [Q, state] = update(reward, Q, gamma, alpha_k, action, state)
%update - Description
%
% Syntax: Q(state, action) = update(reward)
%
% Long description
switch action
    case 1 % up
        Q(state, action) = Q(state, action) + alpha_k*(reward(state, action) + gamma*max(Q(state-1, :)) - Q(state, action));
        state = state - 1;
    case 2 % Right
        Q(state, action) = Q(state, action) + alpha_k*(reward(state, action) + gamma*max(Q(state + 10, :)) - Q(state, action));
        state = state + 10;
    case 3 % Down
        Q(state, action) = Q(state, action)+ alpha_k*(reward(state, action) + gamma*max(Q(state + 1, :)) - Q(state, action));
        state = state + 1;
    case 4 % Left
        Q(state, action) = Q(state, action)+ alpha_k*(reward(state, action) + gamma*max(Q(state - 10, :)) - Q(state, action));
        state = state - 10;    
end