% function processDriver()
    vocabulary = [];
    prefix1 = 'raw_train/';
    prefix2 = 'raw_test/';
    filelist = dir(prefix1);

    for i=1:size(filelist, 1)
        if ~(strcmp(filelist(i).name, '.') || strcmp(filelist(i).name, '..'))
            
            content = fileread( strcat(prefix1, filelist(i).name));
            % Removing punctuation and special symbols, Lemmetization
            content = process(content);
            content = removestop(content);
            vocabulary = union(vocabulary, strread(content, '%s', 'delimiter', ' '));
            filename = strcat('raw_processed_train/',  filelist(i).name);
            file_ = fopen(filename, 'w');
            fprintf(file_, '%s', content);
            fclose(file_);
        end
    end
    
f = fopen('vocabulary.txt', 'w');
for i=1:size(vocabulary, 1)
    fprintf(f, '%s\n', vocabulary{i});
end
fclose(f);

    filelist = dir(prefix2);
    for i=1:size(filelist, 1)
        if ~(strcmp(filelist(i).name, '.') || strcmp(filelist(i).name, '..'))
            
            content = fileread( strcat(prefix2, filelist(i).name));
            % Removing punctuation and special symbols, Lemmetization
            content = process(content);
            content = removestop(content);
            vocabulary = union(vocabulary, strread(content, '%s', 'delimiter', ' '));
            filename = strcat('raw_processed_test/',  filelist(i).name);
            file_ = fopen(filename, 'w');
            fprintf(file_, '%s', content);
            fclose(file_);
        end
    end
    
% end