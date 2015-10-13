This folder contains scripts used to predict the outcome of a hygiene inspecion on resturants according to their reviews.

- **read_data.R** Reads the data and stores it in RData files.
- **language_model.R** Builds an unigram language model for the reviews.
- **reduced_language_model.R** Creates a reduced version of the unigram language model by keeping only those terms that account for 99% of the words in the corpus.
- **topicmodel.R** Computes a topic model from the non-reduced laguage model
- **training_test_dtm_unigram.R** Concatenates the reduced unigram language model to other features in the training and test set.
- **training_test_topic_model_50.R** Concatenates the results of a topic model to other features in the training and test set.
- **training_test_topic_model_label1_100.R** Concatenates the results of a topic model trained only on the positive training samples to other features in the traning and test set.
- **random_forest.R** Trains a classifier using random forest
- **svm.R** Trains a classifier using SVM
- **logistic.R** Trains a classifier using logistic regression.

