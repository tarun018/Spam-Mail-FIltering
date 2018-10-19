%shuffling the points
% clear;
eta = 2;

% [ class0, class7, class_0, class_7, test, tgt] = readData();

eta = 2;

% target = [ repmat([1 0], size(class0, 1), 1); repmat([0 1], size(class7, 1), 1) ];
% target_test = [ repmat([1 0], size(class_0, 1), 1); repmat([0 1], size(class_7, 1), 1) ];

% points = [class0; class7];

%expects data samples along columns

points = train_data';
test = test_data';

target_train = [ group_train (~group_train) ];
target_test = [ group_test (~group_test) ];

num_dim = size(points, 1);

num_ip = num_dim;
num_hidden = 6;
num_op = 2;
init_ih = 0.120;
init_ho = 0.3;

weights_ih = (1/sqrt(num_ip) - ( -1/sqrt(num_ip) ) ).*rand(num_ip, num_hidden) + ( -1/sqrt(num_ip) );
weights_ho = (1/sqrt(num_hidden) - ( -1/sqrt(num_hidden) ) ).*rand(num_hidden, num_op) + ( -1/sqrt(num_hidden) );


%Ip to Hidden Layer
netj = zeros(1, num_hidden);
netk = zeros(1, num_op);

epoch = 1;
for i=1:1
    for p_index=1:size(points, 2)

        %Calculates Output for each Hidden Unit
        for i=1:num_hidden
            netj(i) = weights_ih(:, i)' * points(:, p_index);
        end
    %     netj = normalize(netj);
        %f_netj = sigm(normalize(netj));


        f_netj = sigm(netj);
        szj = size(f_netj, 2);
        deri_netj = sigm(netj) - (sigm(netj) .^ 2);


        %deri_netj = diff(f_netj);
        %deri_netj = [ deri_netj deri_netj(num_hidden - 1) ];
        %netj, f_netj, deri_netj
        % Hidden to Op Layer


        for i=1:num_op
            netk(i) = f_netj * weights_ho(:, i);
        end


        %     netk = normalize(netk);
        %f_netk = sigm(normalize(netk));

        f_netk = sigm(netk);
        szk = size(f_netk, 2);


        %deri_netk = diff(f_netk);

        deri_netk = sigm(netk) - (sigm(netk) .^ 2);


        %deri_netk = [ deri_netk deri_netk(num_op - 1) ];
        % BackPropagation

        % w_kj
        for k=1:num_op
            for j=1:num_hidden
                [out res] = getResult(points(:, p_index), weights_ih, weights_ho, num_op, num_hidden, target_train, p_index);
                delta_k(k) = -( target_train(p_index, k) -  res(k)) * deri_netk(k);
                delta_wkj = eta * delta_k(k)  * f_netj(j);
                weights_ho(j, k) = weights_ho(j, k) + delta_wkj;
            end
        end

        %w_ji

        for j=1:num_hidden
            for i=1:num_ip
                delta_j(j) =  sum( weights_ho(j, :) .* delta_k ) * deri_netj(j);
                delta_wji = eta * delta_j(j) * points(i, p_index);
                weights_ih(i, j) = weights_ih(i, j) + delta_wji;
            end
        end
    end
end

% file = fopen('weightsIH.txt', 'w');
% vec = weights_ih(:);
% i = 1;
% while i <= numel(vec)
%     fprintf(file, '%f & %f & %f & %f & %f & %f \\\\\n', vec(i), vec(i+1), vec(i+2), vec(i+3), vec(i+4), vec(i+5));
%     i = i + 6;
% end
% 
% file = fopen('weightsHO.txt', 'w');
% vec = weights_ho(:);
% i = 1;
% while i <= numel(vec)
%     fprintf(file, '%f & %f \\\\\n', vec(i), vec(i+1));
%     i = i + 2;
% end

cr = 0;
cw = 0;


for i=1:size(test, 2)
    [out res] = getResult(test(:, i), weights_ih, weights_ho, num_op, num_hidden, target_test, i);
    if res == 0
        cw = cw + 1;
    else
        cr = cr + 1;
    end
end

% for i=1:size(points, 2)
%     res = getResult(points(:, i), weights_ih, weights_ho, num_op, num_hidden, target, i);
%     if res == 0
%         cw = cw + 1;
%     else
%         cr = cr + 1;
%     end
% end

cr, cw
 