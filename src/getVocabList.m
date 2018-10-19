function vocabList = getVocabList(filename)

fid = fopen(filename);


i = 1;
line = fgetl(fid);
    while 1
    vocabList{i} = line;
    i = i + 1;
    line = fgetl(fid);
    if ~ischar(line)
        break;
    end
      
end
fclose(fid);

end