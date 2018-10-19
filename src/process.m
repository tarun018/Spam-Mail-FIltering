% function word_indices = processEmail(email_contents)
function out = process(content)
    email_contents = content;

    dummy = '';
    out = '';

    email_contents = lower(email_contents);
    email_contents = regexprep(email_contents, '[0-9]+', 'number');
    email_contents = regexprep(email_contents, ...
                               '(http|https)://[^\s]*', 'httpaddr');
    email_contents = regexprep(email_contents, '[^\s]+@[^\s]+', 'emailaddr');
    email_contents = regexprep(email_contents, '[$]+', 'dollar');


    while ~isempty(email_contents)

        [str, email_contents] = ...
           strtok(email_contents, ...
                  [' @$/#.-:&*+=[]?!(){},''">_<;%' char(10) char(13)]);

        str = regexprep(str, '[^a-zA-Z0-9]', '');

        try str = porterStemmer(strtrim(str)); 
        catch str = ''; continue;
        end;

        if length(str) <= 1
            dummy = strcat(dummy, str);
        else
            out = strcat(out, dummy, {' '}, str, {' '});
            dummy = '';
        end

    end
    out = out{1};
end