function [laplace_estimate_log_probability] = calculate_laplace_estimate_probability(test_feature_vector, feature_tokens, class_probability, ...
                                                                        token_frequencies_in_class, total_words_in_class, V)
    %CALCULATE_LAPLACE_ESTIMATE_PROBABILITY Summary of this function goes here
    %   Detailed explanation goes here

    % laplace_estimate_probability = 1
    laplace_estimate_log_probability = 0;
    
    for i = 1 : length(test_feature_vector)
        test_feature = test_feature_vector(i);
        token = feature_tokens{i};
        if test_feature == 1
            if isKey(token_frequencies_in_class, token)
                probOfTokenBelongingToClass = (token_frequencies_in_class(token) + 1) / (total_words_in_class + V);
            else
                probOfTokenBelongingToClass = (0 + 1) / (total_words_in_class + V);
            end
            
            % traditional way: using multiplications of probabilities
            % laplace_estimate_probability = laplace_estimate_probability * probOfTokenBelongingToClass;

            % numerically stable way to avoid multiplications of probabilities
            laplace_estimate_log_probability = laplace_estimate_log_probability + log(probOfTokenBelongingToClass) / log(2);
        end
        
    end    
    % laplace_estimate_probability *= class_probability
    laplace_estimate_log_probability = laplace_estimate_log_probability + log(class_probability) / log(2);
    
end

