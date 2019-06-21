function [ predicted_labels ] = naive_bayes( X, Y, Xtest )
%NAIVE_BAYES Summary of this function goes here

	%isOctave = exist('OCTAVE_VERSION', 'builtin') ~= 0;

    spam_token_frequencies = sum(X(Y==1, :), 1);
    ham_token_frequencies = sum(X(Y==0, :), 1);
    %token_frequencies = sum(X, 1);

    [Ntest, D] = size(Xtest);
    
    no_of_spam_train_files = length(Y==1);
    no_of_ham_train_files = length(Y==0);
    no_of_train_files = no_of_spam_train_files + no_of_ham_train_files;
    spam_class_probability = no_of_spam_train_files / no_of_train_files;
    ham_class_probability = no_of_ham_train_files / no_of_train_files;
    
    predicted_labels = zeros(Ntest, 1) * (-1);

    spam_document_log_probability = zeros(Ntest, 1);
    ham_document_log_probability = zeros(Ntest, 1);
    for i=1:Ntest,
        feature_vector = Xtest(i, :);
        for j=1:D,
            if feature_vector(j) >= 1,
              spam_class_token_probability = (spam_token_frequencies(j) + 1) / (no_of_spam_train_files + D);
              ham_class_token_probability = (ham_token_frequencies(j) + 1) / (no_of_ham_train_files + D);
              
              spam_document_log_probability(i) = spam_document_log_probability(i) + log(spam_class_token_probability);
              ham_document_log_probability(i) = ham_document_log_probability(i) + log(ham_class_token_probability);
            end
        end
        spam_document_log_probability(i) = spam_document_log_probability(i) + log(spam_class_probability);
        ham_document_log_probability(i) = ham_document_log_probability(i) + log(ham_class_probability);
        
        %fprintf('spam document log probability(%d): %.15f\n', i, spam_document_log_probability(i));
        %fprintf('ham document log probability(%d): %.15f\n', i, ham_document_log_probability(i));
        %if isOctave,
        %    fflush(stdout);    
        %end
        
        % classify the test document as spam or ham
        if (spam_document_log_probability(i) >= ham_document_log_probability(i)),
            predicted_labels(i) = 1;
        elseif (spam_document_log_probability(i) < ham_document_log_probability(i)),
            predicted_labels(i) = 0;
        end
        
    end

end
