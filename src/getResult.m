function [out res] = getResult(point, weights_ih, weights_ho, num_op, num_hidden, tgt, p_index)
    
    %tgt has target vectors along rows for each of the data samples
    eps = 1;
    for i=1:num_hidden
        netj(i) = weights_ih(:, i)' * point;
    end

%     netj = normalize(netj);
    f_netj = sigm(netj);

    for i=1:num_op
       netk(i) = f_netj * weights_ho(:, i);
    end
%     fprintf('%f : %f\n', netk(1), netk(2));
%     netk = normalize(netk);

    f_netk = sigm(netk);
    res = f_netk;
    
    if abs(f_netk(1) - tgt(p_index, 1)) < eps && abs(f_netk(2) - tgt(p_index, 2)) < eps 
        out = 1;
    else
        out = 0;
    end
end