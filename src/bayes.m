file_features = 'test_features.txt';
line = '';

ftest = fopen(file_features, 'r');
cr = 0;
cw = 0;
while 1
    line = fgetl(ftest);
    if ~ischar(line)
        break;
    end
    feature = strread(line, '%d', 'delimiter', ',');
    
    % 0 for spam and 1 for spam
    class = feature(numel(feature));
    feature = feature(1:numel(feature)-1);
    
    word_indices = find( feature == 1);
    words = {};
    for i=1:numel(word_indices)
        words{i} = vocabList{ word_indices(i) };
    end
    words = sort(words);
    
    spaminess = 1;
    haminess = 1;
    for i=1:numel(words)
        if prob.isKey(words{i})
            spaminess = spaminess * prob(words{i});
            haminess = haminess * (1 - prob(words{i}));
        end
    end
    
    if spaminess > haminess && class == 1
        cr = cr + 1;
    elseif spaminess < haminess && class == 0
        cr = cr + 1;
    else
        cw = cw + 1;
    end
    
end
cr, cw