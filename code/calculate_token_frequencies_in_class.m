function [ token_frequencies_in_class, class_distinct_words, total_words_in_class ] = calculate_token_frequencies_in_class(feature_tokens, class_train_documents)
    
    isOctave = exist('OCTAVE_VERSION', 'builtin') ~= 0;

    token_frequencies_in_class = containers.Map;
    class_distinct_words = [];
    total_words_in_class = 0;
    
    for i=1:length(feature_tokens)
        feature_token = feature_tokens{i};
        token_frequencies_in_class(feature_token) = 0;
    end

    % For each feature token count how many times the documents of the given class contain it.
    for i=1:length(class_train_documents)
        document = class_train_documents{i};
        
        if ~isOctave
            text_tokens = strsplit(document);
        else
            text_tokens = strtok(document);
        end
        
        % remove digits, special characters and convert to lowercase
        for k = 1:length(text_tokens)
            text_tokens(k) = lower(text_tokens(k));
            text_tokens(k) = strrep(text_tokens(k), ' ', '');
            text_tokens(k) = regexprep(text_tokens(k), '[0-9]+', '');
            
            word = text_tokens{k};
            if sum(strcmp(feature_tokens, word)) == 1
                token_frequencies_in_class(word) = token_frequencies_in_class(word) + 1;
            end
        end
        
        document_set = unique(text_tokens);
        class_distinct_words = [class_distinct_words, document_set];
        class_distinct_words = unique(class_distinct_words);

        % number_of_class_words = number_of_class_words + length(tokenized_document);
        total_words_in_class = total_words_in_class + length(text_tokens);
    end
    
    % number_of_class_words = length(class_distinct_words);

end