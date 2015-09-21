This folder contains scripts used to compute the results used in the Cuisine Clustering and Map Construction step.


- **data_by_cuisine.R** Splits the reviews in restaurant by restaurant category. It removes those categories that are not clearly related to restaurants like Taxi and Automotive.

- **cuisine_subsample.R** Loads the document-term matrix of restaurant reviews and saves a subset dtm of positive useful reviews for a subset of restaurant categories.

- **dtm_by_cuisine_aggregated.R** Aggregates the DTM of positive useful restaurant reviews by cuisine label. For that it concatenates all the documents for each label.

- **cuisine_aggregated_topic_model.R** Computes a topic model with k=20 for the dtm of concatenated positive useful restaurant reviews of a subset of restaurant categories.

- **similarities_aggregted.R** Computes similarities between cuisine categories using concatenated positive useful restaurant reviews. It tries three approaches: 1) cosine similarity of raw Term Frequencies. 2) BM25+ 3) Cosine similarities of probability distribution of each cuisine over the topics of a topic model fitted to the corpus using LDA.

- **topicmodel_by_cuisine.R** Computes a topic model with k=100 for dtm of positive useful restaurant reviews of a subset of restaurant categories.

- **similarities_not_aggregated.R** Computes similarities between cuisine categories using positive useful restaurant reviews. It tries three approaches: 1) Cosine similarities of probability distribution of each cuisine over the topics of a topic model fitted to the corpus using LDA. 2) cosine similarity of raw Term Frequencies. 3) BM25+ This script is computationally intensive and requires to be run on a computer with GPU computing capabilities.

- **cuisine_networks.R** Extracts backbone graphs from similarity matrices to create cuisine maps and applies community detection algorithms to cluster the cuisines.



