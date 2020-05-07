% DEMO OF 2 CLASS CLASSIFICATION USING A NAIVE-BAYES CLASSIFIER A SPAM-HAM DATASET
clc; clear; close all; diary off;
format long;

isOctave = exist('OCTAVE_VERSION', 'builtin') ~= 0;

randn(0);

spamTrainDir = '../../LingspamDataset/spam-train/';
hamTrainDir = '../../LingspamDataset/nonspam-train/';
spamTestDir = '../../LingspamDataset/spam-test/';
hamTestDir = '../../LingspamDataset/nonspam-test/';
featureDictionaryDir = '../feature_dictionary.txt';
%featureDictionaryDir = '../feature_dictionary_100_tokens/feature_dictionary.txt';

fprintf('Reading feature dictionary...\n');
if isOctave
    fflush(stdout);  % only for Octave
end

if ~isOctave
    feature_tokens = strsplit(read_file(featureDictionaryDir));  % for Matlab
elseif isOctave
    feature_tokens = strtok(read_file(featureDictionaryDir));  % for Octave
end

fprintf('\nReading TRAIN files...\n');
if isOctave
    fflush(stdout);  % only for Octave
end

spamTrainFilenames = read_filenames(spamTrainDir);
hamTrainFilenames = read_filenames(hamTrainDir);
spamTrainLabels = ones(length(spamTrainFilenames), 1);
hamTrainLabels = zeros(length(hamTrainFilenames), 1);

spam_class_frequency = length(spamTrainFilenames); % 1 is for SPAM, 0 is for HAM
fprintf("number of SPAM train documents: %d\n", spam_class_frequency)
ham_class_frequency = length(hamTrainFilenames);  % 1 is for SPAM, 0 is for HAM
fprintf("number of HAM train documents: %d\n", ham_class_frequency)

spam_class_probability = spam_class_frequency / (spam_class_frequency + ham_class_frequency);
fprintf("SPAM train document probability: %f\n", spam_class_probability)
ham_class_probability = ham_class_frequency / (spam_class_frequency + ham_class_frequency);
fprintf("HAM train document probability: %f\n", ham_class_probability)


spam_train_documents = get_class_documents(spamTrainDir, spamTrainFilenames);
ham_train_documents = get_class_documents(hamTrainDir, hamTrainFilenames);

fprintf('\nReading TEST files...\n');
if isOctave
    fflush(stdout);  % only for Octave
end

spamTestFilenames = read_filenames(spamTestDir);
hamTestFilenames = read_filenames(hamTestDir);
spamTestLabels = ones(length(spamTestFilenames), 1);
hamTestLabels = zeros(length(hamTestFilenames), 1);
YtestTrue = [spamTestLabels; hamTestLabels];

D = length(feature_tokens);

% fprintf('\nConstructing the classification TRAIN and TEST data...\n');
%if isOctave
%    fflush(stdout);  % only for Octave
%end

% XspamTrain = get_classification_data(spamTrainDir, spamTrainFilenames, feature_tokens, 'train');
% XhamTrain = get_classification_data(hamTrainDir, hamTrainFilenames, feature_tokens, 'train');
XspamTest = get_classification_data(spamTestDir, spamTestFilenames, feature_tokens, 'test');
XhamTest = get_classification_data(hamTestDir, hamTestFilenames, feature_tokens, 'test');

% X = [XspamTrain; XhamTrain];
Xtest = [XspamTest; XhamTest];

% N = size(X, 1); % X: (NxD)
N = length(spamTrainFilenames) + length(hamTrainFilenames);
Ntest = size(Xtest, 1);

fprintf('\nLoading data done!\n');
if isOctave
    fflush(stdout);  % only for Octave
end
