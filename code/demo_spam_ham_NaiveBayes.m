clc; diary off;

% add path
addpath('../code')

% save output data to file
filename = 'naive_bayes_1000_feature_tokens';
%filename = 'naive_bayes_100_feature_tokens';
filename_ext = strcat(filename, '.txt');
filepath = strcat('../results/', filename_ext);
if (exist(filepath, 'file'))
  delete(filepath);
end
diary (filepath);

fprintf("Calculating feature token frequencies in SPAM files...\n")
[token_frequencies_in_spam_class, spam_distinct_words, total_words_in_spam_class] = ...
            calculate_token_frequencies_in_class(feature_tokens, spam_train_documents);
fprintf('DONE\n');

fprintf("Calculating feature token frequencies in HAM files...\n")
[token_frequencies_in_ham_class, ham_distinct_words, total_words_in_ham_class] = ...
            calculate_token_frequencies_in_class(feature_tokens, ham_train_documents);
fprintf('DONE\n');

% FOR DEBUGGING
% disp('token frequencies in spam class:');
% token_frequencies_in_spam_class
% disp('token frequencies in ham class:');
% token_frequencies_in_ham_class
% fprintf('\n');

% spam_distinct_words  # 8373
% ham_distinct_words  # 14144
% fprintf('\n');

distinct_words = [spam_distinct_words, ham_distinct_words];
distinct_words = unique(distinct_words);
V = length(distinct_words);  % 19100

%% run Naive Bayes Classifier
fprintf('\nRunning Naive-Bayes classifier...\n');
if isOctave
    fflush(stdout);  % only for Octave
end

[Ytest, metrics] = naive_bayes(spam_class_probability, token_frequencies_in_spam_class, total_words_in_spam_class, ...
                    ham_class_probability, token_frequencies_in_ham_class, total_words_in_ham_class, ...
                    Xtest, YtestTrue, feature_tokens, V);

fprintf('\n');

accuracy = (Ntest - length(find(Ytest~=YtestTrue))) / Ntest;
disp(['accuracy: ' num2str(accuracy * 100) ' %']);

err = length(find(Ytest~=YtestTrue)) / Ntest;
disp(['The error of the method is: ' num2str(err * 100) ' %']);

wrong_counter = metrics.wrong_counter;
true_positives = metrics.true_positives;
false_positives = metrics.false_positives;
true_negatives = metrics.true_negatives;
false_negatives = metrics.false_negatives;

fprintf('number of wrong classifications:  %d out of %d files\n', wrong_counter, Ntest);
fprintf('number of wrong spam classifications (false positives): %d out of %d files\n', false_positives, Ntest);
fprintf('number of wrong ham classifications (false negatives): %d out of %d files\n', false_negatives, Ntest);

fprintf('')
    
spam_precision = true_positives / (true_positives + false_positives) * 100;
fprintf('precision for spam files: %f %%\n', spam_precision);
ham_precision = true_negatives / (true_negatives + false_negatives) * 100;
fprintf('precision for ham files: %f %%\n', ham_precision)

spam_recall = true_positives / (true_positives + false_negatives) * 100;
fprintf('recall for spam files: %f %%\n', spam_recall)
ham_recall = true_negatives / (true_negatives + false_positives) * 100;
fprintf('recall for ham files: %f %%\n', ham_recall)

spam_f1_score = 2 * spam_precision * spam_recall / (spam_precision + spam_recall);
fprintf('f1-score for spam files: %f %%\n', spam_f1_score)
ham_f1_score = 2 * ham_precision * ham_recall / (ham_precision + ham_recall);
fprintf('f1-score for ham files: %f %%\n', ham_f1_score)

diary off

rmpath('../code')
savepath
