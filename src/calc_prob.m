vocabList = getVocabList('vocabulary.txt');
num_tokens = numel(vocabList);

count_tokens = zeros(num_tokens, 2);

prefix = 'raw_processed_train/';
filelist = dir(prefix);

ind = 0;

for i=1:numel(filelist)

    if ~( strcmp(filelist(i).name, '.') || strcmp(filelist(i).name, '..'));
        filename = strcat(prefix, filelist(i).name);
        
        % [ Spam_mail_count Ham_mail_count ]
        if( strcmp(filelist(i).name(1:3), 'spm'))
            ind = 1; 
        else
            ind = 2;
        end
        contents = fileread( filename );
        contents = strread(contents, '%s', 'delimiter', ' ');
        contents = sort( union([], contents) );
        
        i = 1;
        j = 1;
       for i=1:numel(contents)
       
            while j<=num_tokens
                if(strcmp(contents{i}, vocabList{j}))
                    count_tokens(j, ind) = count_tokens(j, ind) + 1;
                    break;
                end
                j = j + 1;
            end
           
       end
       
    end

end

prob = containers.Map();
% write the count_tokens array to file

f = fopen('train_tokens.txt', 'w');
fout = fopen('train_tokens_2.txt', 'w');
spaminess = [];
for i=1:num_tokens
    spamin = count_tokens(i, 1) / (count_tokens(i, 1) + count_tokens(i, 2));
    spaminess = [ spaminess  spamin];
    fprintf(f, '%s %f\n', vocabList{i}, spamin);
    fprintf(fout, '%d %d\n', count_tokens(i, 1), count_tokens(i, 2));
end

fclose(f);
fclose(fout);

prob = containers.Map(vocabList, spaminess);