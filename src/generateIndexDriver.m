% function generateIndexDriver()
    prefix1 = 'raw_processed_train/';
    prefix2  = 'raw_train_ind/';
    filelist = dir(prefix1);
    vocabList = getVocabList('vocabulary.txt');
    for i=1:size(filelist, 1)
        
        if ~( strcmp(filelist(i).name, '.') ||  strcmp(filelist(i).name, '..')  )
            filename = strcat(prefix1, filelist(i).name);
            contents = fileread( filename );
            word_indices = generateIndex(contents, vocabList);
            word_indices = union([], word_indices);
            file = fopen(strcat(prefix2, filelist(i).name), 'w');

            for j=1:numel(word_indices)
                fprintf(file, '%d\n', word_indices(j));
            end

            fclose(file);
        end
    end

        prefix1 = 'raw_processed_test/';
        prefix2  = 'raw_test_ind/';
        filelist = dir(prefix1);
        for i=1:size(filelist, 1)
        
        if ~( strcmp(filelist(i).name, '.') ||  strcmp(filelist(i).name, '..')  )
            filename = strcat(prefix1, filelist(i).name);
            contents = fileread( filename );
            word_indices = generateIndex(contents, vocabList);
            word_indices = union([], word_indices);
            file = fopen(strcat(prefix2, filelist(i).name), 'w');

            for j=1:numel(word_indices)
                fprintf(file, '%d\n', word_indices(j));
            end

            fclose(file);
        end
    end
% end