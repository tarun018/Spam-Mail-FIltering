function [spam_precision, spam_recall, accuracy] = perf(class, group_test)

    total = numel(class);
    corr_class = find(class == group_test);
    num_corr = numel(corr_class);
    num_corr_spam = numel( find( class(corr_class) == 1 ) );
    num_spam = numel( find(class == 1));
    
    spam_precision = num_corr_spam/num_spam
    spam_recall = num_corr_spam/total
    accuracy = num_corr/total

    
end
