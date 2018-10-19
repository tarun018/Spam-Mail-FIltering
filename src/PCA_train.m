
prefix1 = 'raw_train_ind/';
filelist = dir(prefix1);
vocabList = getVocabList('vocabulary.txt');

f = fopen('train_features.txt', 'w');
target = '';
for i=1:size(filelist, 1)
    if mod(i, 500) == 0
        i
    end
     if ~(strcmp(filelist(i).name, '.') || strcmp(filelist(i).name, '..'))
        
        if strcmp(filelist(i).name(1:3), 'spm')
            target = 1;
        else
            target = 0;
        end
        filename = strcat(prefix1, filelist(i).name);
        content = fileread(filename);
        content = strread(content, '%s', 'delimiter', '\n');
        content_ = zeros(size(content));
       for j=1:size(content, 1)
        content_(j) = str2num(content{j});
       end
       
       flag = 0;
       for k=1:size(vocabList, 2)
           flag = 0;
            for j=1:numel(content_)
                if content_(j) == k
                    fprintf(f, '%d,', 1);
                    flag = 1;
                    break;
                end
            end
            if flag == 0
                fprintf(f, '0,');
            end
       end
       fprintf(f, '%d\n', target);
       
     end
end
fclose(f);




prefix1 = 'raw_test_ind/';
filelist = dir(prefix1);

f = fopen('test_features.txt', 'w');
target = '';
for i=1:size(filelist, 1)
    if mod(i, 500) == 0
        i
    end
     if ~(strcmp(filelist(i).name, '.') || strcmp(filelist(i).name, '..'))
        
        if strcmp(filelist(i).name(1:3), 'spm')
            target = 1;
        else
            target = 0;
        end
        filename = strcat(prefix1, filelist(i).name);
        content = fileread(filename);
        content = strread(content, '%s', 'delimiter', '\n');
        content_ = zeros(size(content));
       for j=1:size(content, 1)
        content_(j) = str2num(content{j});
       end
       
       flag = 0;
       for k=1:size(vocabList, 2)
           flag = 0;
            for j=1:numel(content_)
                if content_(j) == k
                    fprintf(f, '%d,', 1);
                    flag = 1;
                    break;
                end
            end
            if flag == 0
                fprintf(f, '0,');
            end
       end
       fprintf(f, '%d\n', target);
       
     end
end
fclose(f);
