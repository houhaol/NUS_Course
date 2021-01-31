function a = action_selection(q_values, action_candidate, explore_rate)
    % initial zero q
    num_action = length(action_candidate);
    if any(q_values)
        q_values = q_values(action_candidate);
        prob(1:num_action) = inf;
        % select max
        [max_value, max_q_id] = max(q_values);
        all_max_value_idex = find(q_values ==max_value);
        if length(all_max_value_idex) > 1
            % random select 1
            max_q_id = all_max_value_idex(randi(length(all_max_value_idex)));
            prob(max_q_id) = 1 - explore_rate;
        else
            prob(max_q_id) = 1 - explore_rate;
        end
        % select rest
        other_id = find(prob == inf);
        num_other = length(other_id);
        prob(other_id) = explore_rate / num_other;
        %select
        a = randsample(action_candidate,1,true, prob);
    else
        a = action_candidate(randi(length(action_candidate)));
    end
end