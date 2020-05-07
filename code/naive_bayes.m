function [ predicted_labels, metrics ] = naive_bayes( spam_class_probability, token_frequencies_in_spam_class, total_words_in_spam_class, ...
                                             ham_class_probability, token_frequencies_in_ham_class, total_words_in_ham_class, ...
                                             Xtest, YtestTrue, feature_tokens, V )

    %NAIVE_BAYES Summary of this function goes here

	%isOctave = exist('OCTAVE_VERSION', 'builtin') ~= 0;

    Ntest = size(Xtest, 1);
    predicted_labels = zeros(Ntest, 1);
    
    wrong_counter = 0;  % the number of wrong classifications made by Logistic Regression

    true_positives = 0;
    false_positives = 0;
    true_negatives = 0;
    false_negatives = 0;
    
    for i = 1 : Ntest
        % print('Reading test file ' + str(i) + '...')

        test_feature_vector = Xtest(i, :);

        % Laplace estimate classification %
        spam_laplace_estimate_probability = calculate_laplace_estimate_probability(test_feature_vector, ...
                                                                                   feature_tokens, ...
                                                                                   spam_class_probability, ...
                                                                                   token_frequencies_in_spam_class, ...
                                                                                   total_words_in_spam_class, V);
        % print("spam_laplace_estimate_probability: " + str(spam_laplace_estimate_probability))

        ham_laplace_estimate_probability = calculate_laplace_estimate_probability(test_feature_vector, ...
                                                                                  feature_tokens, ...
                                                                                  ham_class_probability, ...
                                                                                  token_frequencies_in_ham_class, ...
                                                                                  total_words_in_ham_class, V);
        % print("ham_laplace_estimate_probability: " + str(ham_laplace_estimate_probability))

        if spam_laplace_estimate_probability >= ham_laplace_estimate_probability && YtestTrue(i) == 1
            fprintf("test file %d classified as: SPAM -> correct\n", i);
            true_positives = true_positives + 1;
            predicted_labels(i) = 1;
        elseif spam_laplace_estimate_probability >= ham_laplace_estimate_probability && YtestTrue(i) == 0
            fprintf("test file %d classified as: SPAM -> WRONG!\n", i);
            wrong_counter = wrong_counter + 1;
            false_positives = false_positives + 1;
            predicted_labels(i) = 1;
        elseif spam_laplace_estimate_probability < ham_laplace_estimate_probability && YtestTrue(i) == 0
            fprintf("test file %d classified as: HAM -> correct\n", i);
            true_negatives = true_negatives + 1;
            predicted_labels(i) = 0;
        elseif spam_laplace_estimate_probability < ham_laplace_estimate_probability && YtestTrue(i) == 1
            fprintf("test file %d classified as: HAM -> WRONG!\n", i);
            wrong_counter = wrong_counter + 1;
            false_negatives = false_negatives + 1;
            predicted_labels(i) = 0;
        end
        
    end
    
    metrics = struct('wrong_counter', wrong_counter, ...
                     'true_positives', true_positives, 'false_positives', false_positives, ...
                     'true_negatives', true_negatives, 'false_negatives', false_negatives);
    
end
