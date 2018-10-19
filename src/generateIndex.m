
function word_indices = generateIndex(email_contents, vocabList)

    word_indices = [];
    email_contents = strread(email_contents, '%s', 'delimiter', ' ');
    email_contents = sort(email_contents);
    j = 1;
    
 
    for i=1:size(email_contents, 1)

        while j <= size(vocabList, 2)
           if(strcmp( email_contents{i}, vocabList{j}))
             word_indices = [ word_indices ; j];
             break;
           end
           j = j + 1;
        end

    end
    word_indices = word_indices(:);
end