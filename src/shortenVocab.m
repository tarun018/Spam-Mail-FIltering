newf = fopen('final_vocabulary.txt', 'w');
line = fileread('vocabulary.txt');
line = strread(line, '%s', 'delimiter', '\n');
for i = 1:numel(line)
    if numel(line{i}) > 2 && numel(line{i}) <= 13
        fprintf(newf, '%s\n', line{i});
    end
end