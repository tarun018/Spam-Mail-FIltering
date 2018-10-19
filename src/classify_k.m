clear;
clc;
testfilename = 'test_features.txt';
trainfilename = 'train_features.txt';
testfid = fopen(testfilename, 'r');
trainfid = fopen(trainfilename, 'r');


train_data = [];
test_data = [];
 group_test = [];
group_train = [];

line = fgetl(trainfid);
while ischar(line)
    feature = strread(line, '%d', 'delimiter', ',');
     group_train = [ group_train; feature(size(feature, 1)) ];
     train_data = [train_data; (feature(1: size(feature, 1)-1))' ];    
    line = fgetl(trainfid);
end

line = fgetl(testfid);
while ischar(line)
    feature = strread(line, '%d', 'delimiter', ',');
     group_test = [ group_test; feature(size(feature, 1)) ];
     test_data = [test_data; (feature(1: size(feature, 1)-1))' ];
    line = fgetl(testfid);
end

fclose(trainfid);
fclose(testfid);