function converge_flag = converge_check(Q1, Q2, threshold)
    converge_flag = false;
    difference = abs(Q1 - Q2);

    if max(max(difference)) < threshold
        disp('Converged')
        converge_flag = true;
    end

end