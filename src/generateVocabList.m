% function word_indices = processEmail(email_contents)
function word_indices = process(content)
% file = fopen(char(filename), 'r');
email_contents = content;
%PROCESSEMAIL preprocesses a the body of an email and
%returns a list of word_indices 
%   word_indices = PROCESSEMAIL(email_contents) preprocesses 
%   the body of an email and returns a list of indices of the 
%   words contained in the email. 
%

%vocabList = getVocabList();

word_indices = [];

email_contents = lower(email_contents);

email_contents = regexprep(email_contents, '[0-9]+', 'number');

email_contents = regexprep(email_contents, ...
                           '(http|https)://[^\s]*', 'httpaddr');

email_contents = regexprep(email_contents, '[^\s]+@[^\s]+', 'emailaddr');

email_contents = regexprep(email_contents, '[$]+', 'dollar');


% ========================== Tokenize Email ===========================

fprintf('\n==== Processed Email ====\n\n');

l = 0;

while ~isempty(email_contents)

    [str, email_contents] = ...
       strtok(email_contents, ...
              [' @$/#.-:&*+=[]?!(){},''">_<;%' char(10) char(13)]);
   
    str = regexprep(str, '[^a-zA-Z0-9]', '');

    fprintf('%s ', str);
    try str = porterStemmer(strtrim(str)); 
    catch str = ''; continue;
    end;

    if length(str) < 1
       continue;
    end

     for i = 1:length(vocabList)
       if(strcmp(str, vocabList{i}))
         word_indices = [ word_indices ; i];
      end
     end

end

fprintf('\n\n=========================\n');

end