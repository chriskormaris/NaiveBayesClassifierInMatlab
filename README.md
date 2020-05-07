# NaiveBayesClassifierInMatlab
A custom Naive Bayes (NB) Classifier for classifying spam and ham text files. Written in Matlab. You should also check my NB classifier in Python.

## How to Run

Unzip the LingspamDataset data from the compressed file "LingspamDataset.zip", in the same directory.
From the Matlab (or Octave or Scilab) console, change directory to the folder "code" and run:
```matlab
demo_spam_ham_NaiveBayes
```

### Naive Bayes Formula
probOfTokenBelongingToClass = (token_frequencies_in_class(token) + 1) / (total_words_in_class + V)

where:

token_frequencies_in_class(token): the frequency of the specified token in all the documents of the specified class
total_words_in_class: the total count of words in the specified class (non-distinct words)
V: the distinct words count from the corpus documents, for all the classes (i.e. the vocabulary size)
