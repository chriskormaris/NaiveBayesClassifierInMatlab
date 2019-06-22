% DEMO OF 2 CLASS CLASSIFICATION USING A NAIVE-BAYES CLASSIFIER A SPAM-HAM DATASET
clc; clear; close all; diary off;
format long;

isOctave = exist('OCTAVE_VERSION', 'builtin') ~= 0;

rand('state', 0);

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

spamTrainDir = '../LingspamDataset/spam-train/';
hamTrainDir = '../LingspamDataset/nonspam-train/';
spamTestDir = '../LingspamDataset/spam-test/';
hamTestDir = '../LingspamDataset/nonspam-test/';
featureDictionaryDir = '../feature_dictionary.txt';
%featureDictionaryDir = '../feature_dictionary_100_tokens/feature_dictionary.txt';

fprintf('Reading feature dictionary...\n');
if isOctave,
    fflush(stdout);  % only for Octave
end

if ~isOctave,
    feature_tokens = strsplit(read_file(featureDictionaryDir));  % for Matlab
elseif isOctave,  
    feature_tokens = strtok(read_file(featureDictionaryDir));  % for Octave
end

fprintf('\nReading TRAIN files...\n');
if isOctave,
    fflush(stdout);  % only for Octave
end

spamTrainFiles = read_filenames(spamTrainDir);
hamTrainFiles = read_filenames(hamTrainDir);
spamTrainLabels = ones(length(spamTrainFiles), 1);
hamTrainLabels = zeros(length(hamTrainFiles), 1);
Y = [spamTrainLabels; hamTrainLabels];

fprintf('\nReading TEST files...\n');
if isOctave,
    fflush(stdout);  % only for Octave
end

spamTestFiles = read_filenames(spamTestDir);
hamTestFiles = read_filenames(hamTestDir);
spamTestLabels = ones(length(spamTestFiles), 1);
hamTestLabels = zeros(length(hamTestFiles), 1);
YtestTrue = [spamTestLabels; hamTestLabels];

D = length(feature_tokens);

fprintf('\nConstructing the classification TRAIN and TEST data...\n');
if isOctave,
    fflush(stdout);  % only for Octave
end

XspamTrain = get_classification_data(spamTrainDir, spamTrainFiles, spamTrainLabels, feature_tokens, 'train');
XhamTrain = get_classification_data(hamTrainDir, hamTrainFiles, hamTrainLabels, feature_tokens, 'train');
XspamTest = get_classification_data(spamTestDir, spamTestFiles, spamTestLabels, feature_tokens, 'test');
XhamTest = get_classification_data(hamTestDir, hamTestFiles, hamTestLabels, feature_tokens, 'test');

X = [XspamTrain; XhamTrain];
Xtest = [XspamTest; XhamTest];

N = size(X, 1); % X: (NxD)
Ntest = size(Xtest, 1);

fprintf('\nLoading data done!\n');
if isOctave,
    fflush(stdout);  % only for Octave
end

fprintf('\n');

%% run Naive Bayes Classifier
fprintf('\nRunning Naive-Bayes classifier...\n');
if isOctave,
    fflush(stdout);  % only for Octave
end

Ytest = naive_bayes(X, Y, Xtest);

fprintf('\n');

err = length(find(Ytest~=YtestTrue)) / Ntest;
disp(['The error of the method is: ' num2str(err)]);

diary off

rmpath('../code')
savepath
